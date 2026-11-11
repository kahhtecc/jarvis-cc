#!/usr/bin/env bash
# Memória de fatos duráveis (equivalente ao memory/store.py + extractor.py do OpenJarvis).
# Armazenamento: ~/.jarvis/memory/facts.jsonl  — uma linha JSON por fato.
# Uso:
#   jarvis-memory.sh add "fato" [--source origem] [--trust reviewed|auto|untrusted]
#   jarvis-memory.sh search "termos"  [--top N]
#   jarvis-memory.sh list | count | clear | export
#   jarvis-memory.sh forget <index>
set -euo pipefail
. "$(dirname "$0")/jarvis-lib.sh"
jarvis_ensure_home

cmd="${1:-list}"; shift || true

py() { python3 -I - "$@"; }

case "$cmd" in
  add)
    text="${1:-}"; shift || true
    source="claude-code"; trust="reviewed"
    while [ $# -gt 0 ]; do
      case "$1" in --source) source="$2"; shift 2;; --trust) trust="$2"; shift 2;; *) shift;; esac
    done
    [ -n "$text" ] || { echo "uso: add \"fato\"" >&2; exit 1; }
    MEM="$JARVIS_MEMORY_FILE" TEXT="$text" SRC="$source" TRUST="$trust" TS="$(jarvis_now_iso)" py <<'PY'
import json, os, hashlib
path=os.environ["MEM"]; text=os.environ["TEXT"].strip()[:400]
fid=hashlib.sha1(text.lower().encode()).hexdigest()[:10]
existing=[json.loads(l) for l in open(path,encoding="utf-8") if l.strip()]
if any(f.get("id")==fid for f in existing):
    print(f"já existe: {text}"); raise SystemExit
fact={"id":fid,"text":text,"source":os.environ["SRC"],"trust":os.environ["TRUST"],"created":os.environ["TS"]}
with open(path,"a",encoding="utf-8") as fh: fh.write(json.dumps(fact,ensure_ascii=False)+"\n")
print(f"memorizado [{fid}]: {text}")
PY
    ;;
  search)
    q="${1:-}"; shift || true; top=8
    while [ $# -gt 0 ]; do case "$1" in --top) top="$2"; shift 2;; *) shift;; esac; done
    MEM="$JARVIS_MEMORY_FILE" Q="$q" TOP="$top" py <<'PY'
import json, os, re
path=os.environ["MEM"]; q=os.environ["Q"].lower(); top=int(os.environ["TOP"])
terms=[t for t in re.findall(r"\w+", q) if len(t)>2]
facts=[json.loads(l) for l in open(path,encoding="utf-8") if l.strip()]
def score(f):
    t=f["text"].lower(); s=sum(t.count(w) for w in terms)
    if q and q in t: s+=5
    return s
ranked=sorted(((score(f),f) for f in facts), key=lambda x:-x[0])
hits=[f for s,f in ranked if s>0][:top] if terms else facts[-top:]
if not hits: print("(nenhum fato relevante)")
for f in hits: print(f"- [{f['id']}] {f['text']}  (fonte: {f.get('source','?')}, {f.get('created','')[:10]})")
PY
    ;;
  list)
    MEM="$JARVIS_MEMORY_FILE" py <<'PY'
import json, os
facts=[json.loads(l) for l in open(os.environ["MEM"],encoding="utf-8") if l.strip()]
if not facts: print("(memória vazia)")
for i,f in enumerate(facts): print(f"{i:3d} [{f['id']}] {f['text']}  ({f.get('trust','?')}, {f.get('created','')[:10]})")
PY
    ;;
  count) grep -c . "$JARVIS_MEMORY_FILE" || echo 0 ;;
  export) cat "$JARVIS_MEMORY_FILE" ;;
  forget)
    idx="${1:?índice}"
    MEM="$JARVIS_MEMORY_FILE" IDX="$idx" py <<'PY'
import json, os
path=os.environ["MEM"]; idx=os.environ["IDX"]
facts=[json.loads(l) for l in open(path,encoding="utf-8") if l.strip()]
keep=[f for i,f in enumerate(facts) if not (str(i)==idx or f["id"]==idx)]
if len(keep)==len(facts): print("índice não encontrado"); raise SystemExit(1)
open(path,"w",encoding="utf-8").write("".join(json.dumps(f,ensure_ascii=False)+"\n" for f in keep))
print(f"esquecido: {len(facts)-len(keep)} fato(s)")
PY
    ;;
  clear)
    n=$(grep -c . "$JARVIS_MEMORY_FILE" || true); : > "$JARVIS_MEMORY_FILE"; echo "memória limpa ($n fatos removidos)" ;;
  *) echo "comandos: add | search | list | count | export | forget | clear" >&2; exit 1 ;;
esac

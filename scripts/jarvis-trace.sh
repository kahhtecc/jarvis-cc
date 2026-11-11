#!/usr/bin/env bash
# Traces locais (equivalente ao traces/collector.py + server/savings.py).
# Uso: jarvis-trace.sh log <kind> (JSON extra via stdin) | stats [dias]
set -euo pipefail
. "$(dirname "$0")/jarvis-lib.sh"
jarvis_ensure_home
cmd="${1:-stats}"
case "$cmd" in
  log)
    kind="${2:-event}"; day=$(date -u +%Y-%m-%d)
    extra_json=$(cat 2>/dev/null || true)
    KIND="$kind" TS="$(jarvis_now_iso)" OUT="$JARVIS_TRACES_DIR/$day.jsonl" EXTRA="$extra_json" python3 -I - <<'PY'
import json, os
try: extra=json.loads(os.environ.get("EXTRA") or "{}")
except Exception: extra={}
rec={"ts":os.environ["TS"],"kind":os.environ["KIND"]}; rec.update(extra)
with open(os.environ["OUT"],"a",encoding="utf-8") as fh: fh.write(json.dumps(rec,ensure_ascii=False)+"\n")
PY
    ;;
  stats)
    days="${2:-7}"
    DIR="$JARVIS_TRACES_DIR" DAYS="$days" python3 -I - <<'PY'
import json, os, glob, datetime
d=os.environ["DIR"]; days=int(os.environ["DAYS"])
cut=(datetime.date.today()-datetime.timedelta(days=days-1)).isoformat()
files=sorted(f for f in glob.glob(os.path.join(d,"*.jsonl")) if os.path.basename(f)[:10]>=cut)
n=0; chars_in=chars_out=0; sessions=set(); skills={}
for f in files:
    for line in open(f,encoding="utf-8"):
        try: r=json.loads(line)
        except Exception: continue
        n+=1; sessions.add(r.get("session_id","?"))
        if r["kind"]=="prompt": chars_in+=r.get("chars",0)
        if r["kind"]=="response": chars_out+=r.get("chars",0)
        if r["kind"]=="skill": skills[r.get("name","?")]=skills.get(r.get("name","?"),0)+1
tok_in=chars_in//4; tok_out=chars_out//4
# Estimativa do que isso custaria via API paga (referência genérica: $3/M entrada, $15/M saída).
usd=tok_in/1e6*3+tok_out/1e6*15
print(f"Período: últimos {days} dia(s)  |  arquivos: {len(files)}")
print(f"Eventos: {n}  |  sessões: {len(sessions)}")
print(f"Tokens aprox. entrada/saída: {tok_in:,} / {tok_out:,}")
print(f"Equivalente estimado em API paga: ~US$ {usd:.2f} (coberto pela assinatura)")
if skills: print("Skills mais usadas: "+", ".join(f"{k}×{v}" for k,v in sorted(skills.items(),key=lambda x:-x[1])[:8]))
PY
    ;;
  *) echo "comandos: log <kind> | stats [dias]" >&2; exit 1;;
esac

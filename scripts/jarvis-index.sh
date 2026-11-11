#!/usr/bin/env bash
# Índice de conhecimento local (equivalente simplificado ao `jarvis memory index`).
# Registra diretórios e gera um catálogo de documentos para o deep research buscar com grep/rg.
# Uso: jarvis-index.sh add <dir> | list | catalog | search "termos" [--top N] | remove <dir>
set -euo pipefail
. "$(dirname "$0")/jarvis-lib.sh"
jarvis_ensure_home
SRC="$JARVIS_KNOWLEDGE_DIR/sources.txt"; CAT="$JARVIS_KNOWLEDGE_DIR/catalog.tsv"; touch "$SRC"
cmd="${1:-list}"
build_catalog() {
  : > "$CAT"
  while IFS= read -r dir; do
    [ -d "$dir" ] || continue
    find "$dir" -type f \( -iname '*.md' -o -iname '*.txt' -o -iname '*.rst' -o -iname '*.pdf' -o -iname '*.csv' -o -iname '*.json' -o -iname '*.html' -o -iname '*.eml' -o -iname '*.org' \) \
      -not -path '*/.git/*' -not -path '*/node_modules/*' -size -20M 2>/dev/null | while IFS= read -r f; do
      title=$(head -c 4000 "$f" 2>/dev/null | grep -m1 -E '^(# |title:|Subject:)' | sed -E 's/^(# |title:[[:space:]]*|Subject:[[:space:]]*)//' | tr '\t' ' ')
      [ -n "$title" ] || title=$(basename "$f")
      printf '%s\t%s\t%s\t%s\n' "$f" "$title" "$(date -r "$f" +%Y-%m-%d 2>/dev/null || echo ?)" "$(wc -c < "$f")" >> "$CAT"
    done
  done < "$SRC"
  echo "catálogo: $(wc -l < "$CAT") documento(s) em $(grep -c . "$SRC") fonte(s)"
}
case "$cmd" in
  add)    d=$(cd "${2:?dir}" && pwd); grep -qxF "$d" "$SRC" || echo "$d" >> "$SRC"; build_catalog;;
  remove) grep -vxF "${2:?dir}" "$SRC" > "$SRC.tmp" && mv "$SRC.tmp" "$SRC"; build_catalog;;
  list)   echo "Fontes indexadas:"; cat "$SRC"; [ -f "$CAT" ] && echo "Documentos: $(wc -l < "$CAT")";;
  catalog) build_catalog;;
  search)
    q="${2:?termos}"; top="${4:-15}"
    [ -s "$SRC" ] || { echo "(nenhuma fonte indexada; use: jarvis-index.sh add <dir>)"; exit 0; }
    if command -v rg >/dev/null; then
      xargs -a "$SRC" -d '\n' rg -il --max-count 1 -g '!.git' -g '!node_modules' -- "$q" 2>/dev/null | head -n "$top"
    else
      xargs -a "$SRC" -d '\n' grep -rIl -i -- "$q" 2>/dev/null | head -n "$top"
    fi
    ;;
  *) echo "comandos: add | remove | list | catalog | search" >&2; exit 1;;
esac

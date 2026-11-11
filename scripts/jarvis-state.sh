#!/usr/bin/env bash
# Estado persistente por agente (equivalente ao _recall_state/_persist_state do operative).
# Uso: jarvis-state.sh get <agente> | set <agente> (lê stdin) | append <agente> "nota" | list | clear <agente>
set -euo pipefail
. "$(dirname "$0")/jarvis-lib.sh"
jarvis_ensure_home
cmd="${1:-list}"; agent="${2:-}"
f() { printf '%s/%s.md' "$JARVIS_STATE_DIR" "$(printf '%s' "$1" | tr -c 'A-Za-z0-9_-' '_')"; }
case "$cmd" in
  get)    [ -n "$agent" ] || exit 1; [ -f "$(f "$agent")" ] && cat "$(f "$agent")" || echo "(sem estado anterior para $agent)";;
  set)    [ -n "$agent" ] || exit 1; { echo "<!-- atualizado: $(jarvis_now_iso) -->"; cat; } > "$(f "$agent")"; echo "estado de $agent salvo";;
  append) [ -n "$agent" ] || exit 1; printf -- '- %s %s\n' "$(jarvis_now_iso)" "${3:-}" >> "$(f "$agent")"; echo ok;;
  list)   ls -1 "$JARVIS_STATE_DIR" 2>/dev/null | sed 's/\.md$//' || true;;
  clear)  [ -n "$agent" ] || exit 1; rm -f "$(f "$agent")"; echo "estado de $agent removido";;
  *) echo "comandos: get | set | append | list | clear" >&2; exit 1;;
esac

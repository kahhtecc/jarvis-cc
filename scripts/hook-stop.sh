#!/usr/bin/env bash
# Stop: registra o tamanho da resposta no trace (telemetria local). Nunca bloqueia.
. "$(dirname "$0")/jarvis-lib.sh"
jarvis_ensure_home
input=$(cat 2>/dev/null || true)
sid=$(printf '%s' "$input" | jq -r '.session_id // "?"' 2>/dev/null)
chars=$(printf '%s' "$input" | jq -r '.last_assistant_message // "" | length' 2>/dev/null || echo 0)
printf '{"session_id":"%s","chars":%s}' "$sid" "${chars:-0}" | "$JARVIS_PLUGIN_ROOT/scripts/jarvis-trace.sh" log response >/dev/null 2>&1 || true
exit 0

#!/usr/bin/env bash
# UserPromptSubmit: registra o prompt no trace e, a cada N turnos, lembra de persistir fatos (nudge_interval).
. "$(dirname "$0")/jarvis-lib.sh"
jarvis_ensure_home
input=$(cat 2>/dev/null || true)
sid=$(printf '%s' "$input" | jq -r '.session_id // "?"' 2>/dev/null)
chars=$(printf '%s' "$input" | jq -r '.prompt // "" | length' 2>/dev/null || echo 0)
printf '{"session_id":"%s","chars":%s}' "$sid" "${chars:-0}" | "$JARVIS_PLUGIN_ROOT/scripts/jarvis-trace.sh" log prompt >/dev/null 2>&1 || true
counter="$JARVIS_HOME/.turns-$sid"; n=$(( $(cat "$counter" 2>/dev/null || echo 0) + 1 )); echo "$n" > "$counter"
interval=$(jarvis_cfg nudge_interval 10)
if [ "$interval" -gt 0 ] 2>/dev/null && [ $(( n % interval )) -eq 0 ]; then
  echo "Lembrete do Jarvis: já se passaram $n turnos nesta sessão. Se surgiu algum fato durável sobre o usuário (preferência, projeto, objetivo, restrição), registre com: \"$JARVIS_PLUGIN_ROOT/scripts/jarvis-memory.sh\" add \"fato\". Não registre detalhes efêmeros."
fi
exit 0

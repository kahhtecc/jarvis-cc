#!/usr/bin/env bash
# SessionStart: injeta SOUL.md + USER.md + MEMORY.md + fatos recentes como contexto (SystemPromptBuilder).
. "$(dirname "$0")/jarvis-lib.sh"
jarvis_ensure_home
input=$(cat 2>/dev/null || true)
sid=$(jarvis_json_get "$input" session_id '?')
printf '{"session_id":"%s","source":"%s"}' "$sid" "$(jarvis_json_get "$input" source startup)" | "$JARVIS_PLUGIN_ROOT/scripts/jarvis-trace.sh" log session_start >/dev/null 2>&1 || true
[ "$(jarvis_cfg autoload true)" = "false" ] && exit 0
{
  echo "## Jarvis CC — contexto persistente (carregado de $JARVIS_HOME)"
  echo "Data/hora: $(python3 -I -c 'import datetime;d=datetime.datetime.now();ds=["segunda","terça","quarta","quinta","sexta","sábado","domingo"];ms=["janeiro","fevereiro","março","abril","maio","junho","julho","agosto","setembro","outubro","novembro","dezembro"];print(f"{ds[d.weekday()]}-feira, {d.day} de {ms[d.month-1]} de {d.year}, {d:%H:%M}".replace("sábado-feira","sábado").replace("domingo-feira","domingo"))') ($(date +%Z))."
  echo "Scripts do Jarvis: $JARVIS_PLUGIN_ROOT/scripts/ (jarvis-memory.sh, jarvis-state.sh, jarvis-index.sh, jarvis-trace.sh)."
  echo
  echo "### SOUL (persona)"; jarvis_head_tail 4000 < "$JARVIS_HOME/SOUL.md"
  echo; echo "### USER (quem é o usuário)"; jarvis_head_tail 1500 < "$JARVIS_HOME/USER.md"
  echo; echo "### MEMORY (notas curadas)"; jarvis_head_tail 2500 < "$JARVIS_HOME/MEMORY.md"
  n=$(grep -c . "$JARVIS_MEMORY_FILE" 2>/dev/null || echo 0)
  if [ "$n" -gt 0 ]; then
    echo; echo "### Fatos memorizados (últimos 15 de $n; busque mais com jarvis-memory.sh search)"
    tail -n 15 "$JARVIS_MEMORY_FILE" | python3 -I -c 'import sys,json
for l in sys.stdin:
  l=l.strip()
  if l: print("- "+json.loads(l)["text"])'
  fi
  states=$(ls -1 "$JARVIS_STATE_DIR" 2>/dev/null | sed 's/\.md$//' | tr '\n' ' ')
  [ -n "$states" ] && { echo; echo "### Agentes com estado salvo: $states"; }
} 2>/dev/null
exit 0

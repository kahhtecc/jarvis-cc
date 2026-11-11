#!/usr/bin/env bash
# Funções e caminhos compartilhados do Jarvis CC.
# Todo o estado do usuário mora em ~/.jarvis (JARVIS_HOME), nunca dentro do plugin.
JARVIS_HOME="${JARVIS_HOME:-$HOME/.jarvis}"
JARVIS_MEMORY_FILE="$JARVIS_HOME/memory/facts.jsonl"
JARVIS_STATE_DIR="$JARVIS_HOME/state"
JARVIS_TRACES_DIR="$JARVIS_HOME/traces"
JARVIS_KNOWLEDGE_DIR="$JARVIS_HOME/knowledge"
JARVIS_DIGESTS_DIR="$JARVIS_HOME/digests"
JARVIS_REPORTS_DIR="$JARVIS_HOME/reports"
JARVIS_CONFIG="$JARVIS_HOME/config.toml"
JARVIS_PLUGIN_ROOT="${JARVIS_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

jarvis_ensure_home() {
  mkdir -p "$JARVIS_HOME/memory" "$JARVIS_STATE_DIR" "$JARVIS_TRACES_DIR" \
           "$JARVIS_KNOWLEDGE_DIR" "$JARVIS_DIGESTS_DIR" "$JARVIS_REPORTS_DIR"
  local t="$JARVIS_PLUGIN_ROOT/templates"
  for f in SOUL.md USER.md MEMORY.md config.toml; do
    [ -f "$JARVIS_HOME/$f" ] || { [ -f "$t/$f" ] && cp "$t/$f" "$JARVIS_HOME/$f"; }
  done
  if [ ! -d "$JARVIS_HOME/personas" ] && [ -d "$t/personas" ]; then
    cp -r "$t/personas" "$JARVIS_HOME/personas"
  fi
  touch "$JARVIS_MEMORY_FILE"
}

# Lê uma chave simples do config.toml (formato: chave = "valor" ou chave = valor).
jarvis_cfg() {
  local key="$1" default="$2"
  [ -f "$JARVIS_CONFIG" ] || { printf '%s' "$default"; return; }
  local v
  v=$(grep -E "^[[:space:]]*$key[[:space:]]*=" "$JARVIS_CONFIG" | head -1 | sed -E 's/^[^=]*=[[:space:]]*//; s/[[:space:]]*#.*$//; s/^"(.*)"$/\1/; s/^'"'"'(.*)'"'"'$/\1/')
  [ -n "$v" ] && printf '%s' "$v" || printf '%s' "$default"
}

# Trunca texto mantendo cabeça e cauda (head_tail como no SystemPromptBuilder do OpenJarvis).
jarvis_head_tail() {
  local max="$1"
  python3 -I -c '
import sys
m=int(sys.argv[1]); s=sys.stdin.read()
if len(s)<=m: sys.stdout.write(s)
else:
    h=int(m*0.7); t=m-h
    sys.stdout.write(s[:h]+"\n[...truncado...]\n"+s[-t:])
' "$max"
}

jarvis_now_iso() { date -u +%Y-%m-%dT%H:%M:%SZ; }

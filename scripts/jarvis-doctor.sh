#!/usr/bin/env bash
# Diagnóstico (equivalente ao `jarvis doctor`), sem checar Ollama/GPU: o motor é o próprio Claude Code.
. "$(dirname "$0")/jarvis-lib.sh"
jarvis_ensure_home
ok(){ printf '  ✔ %s\n' "$*"; } ; warn(){ printf '  ⚠ %s\n' "$*"; }
echo "Jarvis CC — doctor"
echo "Motor de inferência: Claude Code (sessão atual) — sem API externa, sem Ollama"
echo "Diretório de dados: $JARVIS_HOME"
for f in SOUL.md USER.md MEMORY.md config.toml; do [ -f "$JARVIS_HOME/$f" ] && ok "$f presente" || warn "$f ausente (rode /jarvis-cc:init)"; done
ok "memória: $(grep -c . "$JARVIS_MEMORY_FILE" 2>/dev/null || echo 0) fato(s)"
ok "estados de agentes: $(ls -1 "$JARVIS_STATE_DIR" 2>/dev/null | wc -l)"
ok "fontes de conhecimento: $(grep -c . "$JARVIS_KNOWLEDGE_DIR/sources.txt" 2>/dev/null || echo 0)"
ok "digests salvos: $(ls -1 "$JARVIS_DIGESTS_DIR" 2>/dev/null | wc -l) | relatórios: $(ls -1 "$JARVIS_REPORTS_DIR" 2>/dev/null | wc -l)"
for t in python3 jq rg; do command -v $t >/dev/null && ok "$t disponível" || warn "$t não encontrado (opcional)"; done
echo "Persona: $(jarvis_cfg persona jarvis) | honorífico: $(jarvis_cfg honorific 'chefe') | idioma: $(jarvis_cfg language pt-BR)"
echo "Limites de uso: são os da sua assinatura do Claude. Use /usage no Claude Code para ver sessão e semana."

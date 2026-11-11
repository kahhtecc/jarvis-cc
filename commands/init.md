---
description: Inicializa o Jarvis (~/.jarvis com SOUL/USER/MEMORY/config) e faz a entrevista de primeiro uso
argument-hint: [--reset]
allowed-tools: Bash, Read, Edit, Write
---
Inicialize o Jarvis CC.

1. Rode `${CLAUDE_PLUGIN_ROOT}/scripts/jarvis-doctor.sh` (ele cria ~/.jarvis e copia os templates se faltarem). Se `$ARGUMENTS` contiver `--reset`, pergunte confirmação e depois recopie os templates de `${CLAUDE_PLUGIN_ROOT}/templates/` por cima.
2. Leia `~/.jarvis/USER.md`. Se ainda estiver com os placeholders, faça uma entrevista curta (no máximo 5 perguntas, uma mensagem só): como chamar o usuário, honorífico, cidade/fuso, no que trabalha, preferências de formato. Preencha USER.md e ajuste `honorific`, `timezone` e `language` em `~/.jarvis/config.toml`.
3. Registre os fatos principais com `${CLAUDE_PLUGIN_ROOT}/scripts/jarvis-memory.sh add`.
4. Termine listando os comandos disponíveis: /jarvis-cc:ask, /jarvis-cc:research, /jarvis-cc:digest, /jarvis-cc:monitor, /jarvis-cc:schedule, /jarvis-cc:memory, /jarvis-cc:index, /jarvis-cc:skill, /jarvis-cc:status, /jarvis-cc:doctor.

---
name: jarvis-memory
description: Memória de longo prazo do Jarvis — guardar, buscar, listar e esquecer fatos sobre o usuário (arquivo ~/.jarvis/memory/facts.jsonl) e manter MEMORY.md. Use quando o usuário pedir para lembrar/anotar/esquecer algo, perguntar "o que você sabe sobre mim", ou quando um fato durável aparecer na conversa.
---

# Memória do Jarvis

Comandos (scripts do plugin):

```bash
${CLAUDE_PLUGIN_ROOT}/scripts/jarvis-memory.sh add "fato" [--source origem] [--trust reviewed|auto]
${CLAUDE_PLUGIN_ROOT}/scripts/jarvis-memory.sh search "termos" [--top 8]
${CLAUDE_PLUGIN_ROOT}/scripts/jarvis-memory.sh list
${CLAUDE_PLUGIN_ROOT}/scripts/jarvis-memory.sh forget <índice-ou-id>
${CLAUDE_PLUGIN_ROOT}/scripts/jarvis-memory.sh count | export | clear
```

## Como decidir o que guardar
Guarde fatos **duráveis**: preferências, identidade, objetivos, projetos em andamento, restrições, relações. Cada fato é uma frase curta, autocontida, em terceira pessoa ("Kaique prefere respostas sem emoji"). Não guarde: tarefas pontuais, conteúdo de arquivos, segredos, nada que o assistente disse sobre si.

## Dois níveis
1. **facts.jsonl** — fatos atômicos, busca por palavra-chave. Cresce livremente.
2. **~/.jarvis/MEMORY.md** — resumo curado lido em toda sessão. Quando houver mais de ~40 fatos ou o usuário pedir "organiza a memória", consolide os fatos em MEMORY.md por seções (projetos, preferências, pessoas) e mantenha o arquivo abaixo de 2500 caracteres.

## Pedidos do usuário
- "lembra que..." → add. Confirme em uma linha.
- "o que você sabe sobre mim / sobre X" → search (ou list se for geral) e responda em prosa.
- "esquece isso" → list, identifique o índice, forget. Confirme.
- "limpa tudo" → confirme antes de clear (irreversível).

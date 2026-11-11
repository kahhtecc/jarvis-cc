---
name: topic-research
description: Research a topic using web search, check memory for prior knowledge, and synthesize findings. (Skill importada do OpenJarvis; parâmetros: topic.)
---

# topic-research

Research a topic using web search, check memory for prior knowledge, and synthesize findings.

## Parâmetros
- `topic`: extraia do pedido do usuário; se faltar, pergunte.

## Passos (ordem original do OpenJarvis; adapte com bom senso)
1. busque na memória do Jarvis: `${CLAUDE_PLUGIN_ROOT}/scripts/jarvis-memory.sh search {topic}` → guarde o resultado como `prior_knowledge`.
2. use WebSearch com a consulta {topic} → guarde o resultado como `search_results`.
3. raciocine (sem ferramentas): Synthesize a comprehensive research summary combining prior knowledge and new findings. Prior: {prior_knowledge}. New: {search_results} → guarde o resultado como `synthesis`.
4. guarde na memória do Jarvis (apenas se for durável): `${CLAUDE_PLUGIN_ROOT}/scripts/jarvis-memory.sh add "{synthesis}" --source skill` → guarde o resultado como `stored`.

Entregue o resultado final de forma concisa. Só persista na memória fatos duráveis; nunca segredos.

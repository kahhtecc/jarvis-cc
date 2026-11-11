---
name: search-and-index
description: Search for documents matching a query and index them into memory for future retrieval. (Skill importada do OpenJarvis; parâmetros: directory, query.)
---

# search-and-index

Search for documents matching a query and index them into memory for future retrieval.

## Parâmetros
- `directory`: extraia do pedido do usuário; se faltar, pergunte.
- `query`: extraia do pedido do usuário; se faltar, pergunte.

## Passos (ordem original do OpenJarvis; adapte com bom senso)
1. execute no Bash: `find {directory} -type f \( -name "*.txt" -o -name "*.md" -o -name "*.pdf" \) | head -50` → guarde o resultado como `found_files`.
2. raciocine (sem ferramentas): Filter the found files to those likely relevant to the query: {query}. Files: {found_files} → guarde o resultado como `relevant_files`.
3. use a ferramenta equivalente a `memory_index` com {"path": "{directory}"} → guarde o resultado como `index_result`.
4. busque na memória do Jarvis: `${CLAUDE_PLUGIN_ROOT}/scripts/jarvis-memory.sh search {query}` → guarde o resultado como `search_results`.

Entregue o resultado final de forma concisa. Só persista na memória fatos duráveis; nunca segredos.

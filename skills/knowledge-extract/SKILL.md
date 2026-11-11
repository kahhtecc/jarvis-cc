---
name: knowledge-extract
description: Extract structured knowledge from a document and store in memory. (Skill importada do OpenJarvis; parâmetros: file_path.)
---

# knowledge-extract

Extract structured knowledge from a document and store in memory.

## Parâmetros
- `file_path`: extraia do pedido do usuário; se faltar, pergunte.

## Passos (ordem original do OpenJarvis; adapte com bom senso)
1. leia o arquivo {file_path} com Read → guarde o resultado como `document_content`.
2. raciocine (sem ferramentas): Extract key facts, entities, relationships, and concepts from the document: {document_content} → guarde o resultado como `extracted_knowledge`.
3. guarde na memória do Jarvis (apenas se for durável): `${CLAUDE_PLUGIN_ROOT}/scripts/jarvis-memory.sh add "{extracted_knowledge}" --source skill` → guarde o resultado como `stored`.

Entregue o resultado final de forma concisa. Só persista na memória fatos duráveis; nunca segredos.

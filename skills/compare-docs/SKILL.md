---
name: compare-docs
description: Compare two documents and summarize their differences. (Skill importada do OpenJarvis; parâmetros: file_a, file_b.)
---

# compare-docs

Compare two documents and summarize their differences.

## Parâmetros
- `file_a`: extraia do pedido do usuário; se faltar, pergunte.
- `file_b`: extraia do pedido do usuário; se faltar, pergunte.

## Passos (ordem original do OpenJarvis; adapte com bom senso)
1. leia o arquivo {file_a} com Read → guarde o resultado como `doc_a`.
2. leia o arquivo {file_b} com Read → guarde o resultado como `doc_b`.
3. raciocine (sem ferramentas): Compare the two documents. Identify additions, removals, and modifications. Note structural differences and content changes. Document A: {doc_a}. Document B: {doc_b} → guarde o resultado como `differences`.
4. raciocine (sem ferramentas): Generate a comparison summary with sections: Overview, Key Differences, Added Content, Removed Content, Modified Sections, and Recommendation: {differences} → guarde o resultado como `comparison_report`.

Entregue o resultado final de forma concisa. Só persista na memória fatos duráveis; nunca segredos.

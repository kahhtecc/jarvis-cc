---
name: pdf-summarize
description: Extract text from a PDF document and generate a structured summary. (Skill importada do OpenJarvis; parâmetros: pdf_path.)
---

# pdf-summarize

Extract text from a PDF document and generate a structured summary.

## Parâmetros
- `pdf_path`: extraia do pedido do usuário; se faltar, pergunte.

## Passos (ordem original do OpenJarvis; adapte com bom senso)
1. use a ferramenta equivalente a `pdf_extract` com {"path": "{pdf_path}"} → guarde o resultado como `pdf_text`.
2. raciocine (sem ferramentas): Identify the document structure (title, sections, key arguments) from the extracted text: {pdf_text} → guarde o resultado como `structure`.
3. raciocine (sem ferramentas): Generate a comprehensive summary with sections: Overview, Key Points, Conclusions, and Action Items based on: {structure} → guarde o resultado como `summary`.

Entregue o resultado final de forma concisa. Só persista na memória fatos duráveis; nunca segredos.

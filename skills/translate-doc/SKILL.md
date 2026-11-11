---
name: translate-doc
description: Translate a document from one language to another while preserving formatting. (Skill importada do OpenJarvis; parâmetros: file_path, target_language.)
---

# translate-doc

Translate a document from one language to another while preserving formatting.

## Parâmetros
- `file_path`: extraia do pedido do usuário; se faltar, pergunte.
- `target_language`: extraia do pedido do usuário; se faltar, pergunte.

## Passos (ordem original do OpenJarvis; adapte com bom senso)
1. leia o arquivo {file_path} com Read → guarde o resultado como `original_content`.
2. raciocine (sem ferramentas): Detect the source language and analyze the document structure, formatting, and any specialized terminology: {original_content} → guarde o resultado como `analysis`.
3. use a ferramenta equivalente a `llm_call` com {"prompt": "Translate the following text to {target_language}, preserving all formatting, technical terms, and document structure: {original_content}"} → guarde o resultado como `translation`.
4. raciocine (sem ferramentas): Review the translation for accuracy, natural phrasing, and formatting preservation. Note any terms that may need human review: {translation} → guarde o resultado como `reviewed_translation`.

Entregue o resultado final de forma concisa. Só persista na memória fatos duráveis; nunca segredos.

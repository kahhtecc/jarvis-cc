---
name: email-draft
description: Draft a professional email response based on context and intent. (Skill importada do OpenJarvis; parâmetros: context, intent, recipient.)
---

# email-draft

Draft a professional email response based on context and intent.

## Parâmetros
- `context`: extraia do pedido do usuário; se faltar, pergunte.
- `intent`: extraia do pedido do usuário; se faltar, pergunte.
- `recipient`: extraia do pedido do usuário; se faltar, pergunte.

## Passos (ordem original do OpenJarvis; adapte com bom senso)
1. raciocine (sem ferramentas): Analyze the email context and determine the appropriate tone, key points to address, and desired outcome. Context: {context}. Intent: {intent} → guarde o resultado como `analysis`.
2. raciocine (sem ferramentas): Draft a professional email with proper greeting, body paragraphs addressing each key point, and appropriate closing. Analysis: {analysis}. Recipient: {recipient} → guarde o resultado como `draft`.
3. raciocine (sem ferramentas): Review the draft for clarity, tone, grammar, and completeness. Suggest improvements if needed: {draft} → guarde o resultado como `final_draft`.

Entregue o resultado final de forma concisa. Só persista na memória fatos duráveis; nunca segredos.

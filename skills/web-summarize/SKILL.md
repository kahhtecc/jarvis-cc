---
name: web-summarize
description: Fetch a web page and summarize its content into key points. (Skill importada do OpenJarvis; parâmetros: url.)
---

# web-summarize

Fetch a web page and summarize its content into key points.

## Parâmetros
- `url`: extraia do pedido do usuário; se faltar, pergunte.

## Passos (ordem original do OpenJarvis; adapte com bom senso)
1. use WebFetch na URL {url} → guarde o resultado como `page_content`.
2. raciocine (sem ferramentas): Extract the main content from the web page, ignoring navigation and ads: {page_content} → guarde o resultado como `clean_content`.
3. raciocine (sem ferramentas): Summarize the content into 5-7 key bullet points: {clean_content} → guarde o resultado como `summary`.

Entregue o resultado final de forma concisa. Só persista na memória fatos duráveis; nunca segredos.

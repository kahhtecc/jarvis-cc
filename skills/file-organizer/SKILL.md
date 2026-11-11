---
name: file-organizer
description: Organize files in a directory by type (images, documents, code, etc.). (Skill importada do OpenJarvis; parâmetros: directory.)
---

# file-organizer

Organize files in a directory by type (images, documents, code, etc.).

## Parâmetros
- `directory`: extraia do pedido do usuário; se faltar, pergunte.

## Passos (ordem original do OpenJarvis; adapte com bom senso)
1. execute no Bash: `find {directory} -maxdepth 1 -type f -exec file --mime-type {} \;` → guarde o resultado como `file_listing`.
2. raciocine (sem ferramentas): Analyze the file types and group them into categories (images, documents, code, archives, media, other): {file_listing} → guarde o resultado como `organization_plan`.
3. execute no Bash: `mkdir -p {directory}/images {directory}/documents {directory}/code {directory}/archives {directory}/media {directory}/other` → guarde o resultado como `dirs_created`.
4. raciocine (sem ferramentas): Generate a summary report of the file organization plan: {organization_plan} → guarde o resultado como `report`.

Entregue o resultado final de forma concisa. Só persista na memória fatos duráveis; nunca segredos.

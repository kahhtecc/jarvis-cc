---
name: todo-from-notes
description: Extract actionable todo items from unstructured notes. (Skill importada do OpenJarvis; parâmetros: notes_path.)
---

# todo-from-notes

Extract actionable todo items from unstructured notes.

## Parâmetros
- `notes_path`: extraia do pedido do usuário; se faltar, pergunte.

## Passos (ordem original do OpenJarvis; adapte com bom senso)
1. leia o arquivo {notes_path} com Read → guarde o resultado como `notes_content`.
2. raciocine (sem ferramentas): Identify all actionable items, tasks, commitments, and follow-ups from the notes. Tag each with priority (high/medium/low) and category: {notes_content} → guarde o resultado como `extracted_todos`.
3. raciocine (sem ferramentas): Format as a prioritized todo list with checkboxes, due dates where mentioned, and categories. Sort by priority: {extracted_todos} → guarde o resultado como `todo_list`.

Entregue o resultado final de forma concisa. Só persista na memória fatos duráveis; nunca segredos.

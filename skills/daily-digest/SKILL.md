---
name: daily-digest
description: Create a daily digest summarizing stored information and recent activity. (Skill importada do OpenJarvis; parâmetros: date.)
---

# daily-digest

Create a daily digest summarizing stored information and recent activity.

## Parâmetros
- `date`: extraia do pedido do usuário; se faltar, pergunte.

## Passos (ordem original do OpenJarvis; adapte com bom senso)
1. busque na memória do Jarvis: `${CLAUDE_PLUGIN_ROOT}/scripts/jarvis-memory.sh search recent activity updates {date}` → guarde o resultado como `recent_items`.
2. raciocine (sem ferramentas): Categorize the retrieved items into groups: tasks completed, pending items, important updates, and upcoming deadlines: {recent_items} → guarde o resultado como `categorized`.
3. raciocine (sem ferramentas): Generate a concise daily digest with sections: Highlights, Completed Tasks, Pending Items, Upcoming Deadlines, and Notes: {categorized} → guarde o resultado como `digest`.

Entregue o resultado final de forma concisa. Só persista na memória fatos duráveis; nunca segredos.

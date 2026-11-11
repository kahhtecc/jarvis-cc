---
name: calendar-prep
description: Prepare briefing materials for upcoming calendar events. (Skill importada do OpenJarvis; parâmetros: agenda, attendees, event_title.)
---

# calendar-prep

Prepare briefing materials for upcoming calendar events.

## Parâmetros
- `agenda`: extraia do pedido do usuário; se faltar, pergunte.
- `attendees`: extraia do pedido do usuário; se faltar, pergunte.
- `event_title`: extraia do pedido do usuário; se faltar, pergunte.

## Passos (ordem original do OpenJarvis; adapte com bom senso)
1. raciocine (sem ferramentas): Parse the event details and identify what preparation is needed. Event: {event_title}. Attendees: {attendees}. Agenda: {agenda} → guarde o resultado como `prep_needs`.
2. busque na memória do Jarvis: `${CLAUDE_PLUGIN_ROOT}/scripts/jarvis-memory.sh search {event_title} {attendees}` → guarde o resultado como `related_context`.
3. raciocine (sem ferramentas): Create a briefing document with: event summary, attendee background, talking points, relevant history, and suggested preparation steps. Needs: {prep_needs}. Context: {related_context} → guarde o resultado como `briefing`.

Entregue o resultado final de forma concisa. Só persista na memória fatos duráveis; nunca segredos.

---
name: meeting-notes
description: Generate structured meeting notes from a transcript or raw notes. (Skill importada do OpenJarvis; parâmetros: transcript_path.)
---

# meeting-notes

Generate structured meeting notes from a transcript or raw notes.

## Parâmetros
- `transcript_path`: extraia do pedido do usuário; se faltar, pergunte.

## Passos (ordem original do OpenJarvis; adapte com bom senso)
1. leia o arquivo {transcript_path} com Read → guarde o resultado como `transcript`.
2. raciocine (sem ferramentas): Extract key information from the transcript: attendees, topics discussed, decisions made, action items, deadlines, and open questions: {transcript} → guarde o resultado como `extracted_info`.
3. raciocine (sem ferramentas): Format as structured meeting notes with sections: Date, Attendees, Agenda, Discussion Summary, Decisions, Action Items (with owners and deadlines), Next Steps: {extracted_info} → guarde o resultado como `meeting_notes`.

Entregue o resultado final de forma concisa. Só persista na memória fatos duráveis; nunca segredos.

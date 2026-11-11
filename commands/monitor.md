---
description: Executa um agente monitor com estado (code_reviewer, inbox_triager, research_monitor ou personalizado)
argument-hint: <nome> [instrução]  ex.: research_monitor "papers sobre RAG local"
---
Use a skill `jarvis-cc:monitor`. O primeiro token de `$ARGUMENTS` é o nome do monitor (slug); o resto é a instrução. Se o nome for um dos templates (code_reviewer, inbox_triager, research_monitor), delegue ao subagente correspondente `jarvis-cc:<nome-com-hífen>` passando a instrução e o estado anterior; caso contrário execute inline. Sempre restaure e depois persista o estado.

$ARGUMENTS

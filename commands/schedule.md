---
description: Agenda uma tarefa recorrente do Jarvis (digest diário, monitor, etc.) com o agendador disponível
argument-hint: "<expressão cron ou linguagem natural>" <comando do jarvis>  ex.: "0 8 * * 1-5" /jarvis-cc:digest
---
Agende a tarefa do Jarvis descrita em: $ARGUMENTS

Regras:
1. Converta o horário para cron de 5 campos, no fuso de `~/.jarvis/config.toml` (timezone).
2. Escolha o agendador que existir nesta sessão, nesta ordem: ferramenta `CronCreate` (Claude Code local, dispara nesta sessão) → `mcp__claude-code-remote__create_trigger` (sessão na nuvem; use create_new_session_on_fire=true e escreva o prompt como instrução completa e autossuficiente, começando por "Use a skill jarvis-cc:<skill> ...") → se nenhum existir, explique como usar `/loop` ou o cron do sistema com `claude -p`.
3. O prompt agendado deve sempre começar restaurando contexto (SessionStart já injeta SOUL/USER/MEMORY) e terminar persistindo estado/memória.
4. Confirme ao usuário: o que roda, quando, em que fuso, e como cancelar.

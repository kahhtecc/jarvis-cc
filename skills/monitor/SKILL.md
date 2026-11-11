---
name: monitor
description: Agente operativo com estado (monitor_operative) — executa tarefas de longo horizonte e recorrentes (vigiar repositório, inbox, tema de pesquisa), restaurando o estado da execução anterior e salvando o novo em ~/.jarvis/state. Use para "monitore", "acompanhe", "toda vez que rodar verifique", "agente agendado".
---

# Monitor Operative

Cada monitor tem um **nome** (slug) e um **estado** persistente em `~/.jarvis/state/<nome>.md`.

## Protocolo de uma execução
1. **Restaurar**: `${CLAUDE_PLUGIN_ROOT}/scripts/jarvis-state.sh get <nome>` e `${CLAUDE_PLUGIN_ROOT}/scripts/jarvis-memory.sh search "<tema>"`.
2. **Planejar em fases** (task_decomposition = phased): o que checar, com que ferramenta, o que conta como novidade em relação ao estado anterior.
3. **Coletar** com ferramentas substantivas (WebSearch/WebFetch, gh, Grep/Read, conectores MCP). Nunca conclua sobre algo recente sem consultar uma fonte. Limite de turnos: `monitor_max_turns` (padrão 20).
4. **Comprimir observações** (observation_compression = summarize): resuma saídas longas antes de raciocinar sobre elas.
5. **Decidir e reportar**: liste o que mudou desde a última execução, prioridade (urgente / importante / informativo), e ações sugeridas. Seja escaneável em 30 segundos.
6. **Persistir**: escreva o novo estado (substitui o anterior) com `${CLAUDE_PLUGIN_ROOT}/scripts/jarvis-state.sh set <nome> <<'EOF'` contendo: objetivo, última execução, itens já vistos (ids/urls/hashes), pendências, próximos passos. Fatos duráveis vão para a memória (`jarvis-memory.sh add`), não para o estado.

## Modelos prontos (templates do OpenJarvis)
- **code_reviewer** — vigia um repositório: `git fetch` + `git log --since`, revisa diffs novos, aponta bugs. Padrão a cada 1 h.
- **inbox_triager** — triagem de mensagens dos conectores por prioridade. Padrão a cada 30 min.
- **research_monitor** — papers/notícias/blogs sobre um tema; novidades vão para memória. Padrão diário 09:00.
Os agentes correspondentes existem como subagentes `jarvis-cc:code-reviewer`, `jarvis-cc:inbox-triager`, `jarvis-cc:research-monitor`; use-os quando a execução for longa, para não inflar o contexto principal.

## Agendamento
Use `/jarvis-cc:schedule` (cron local do Claude Code ou tarefa agendada na nuvem). Cada disparo deve começar com o passo 1.

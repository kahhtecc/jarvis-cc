---
description: Gerencia a memória do Jarvis (add | search | list | forget | consolidate | clear)
argument-hint: add "fato" | search termos | list | forget <n> | consolidate | clear
allowed-tools: Bash, Read, Edit
---
Use a skill `jarvis-cc:jarvis-memory` para executar: $ARGUMENTS
Se o subcomando for `consolidate`, resuma os fatos de `jarvis-memory.sh list` em `~/.jarvis/MEMORY.md` (por seções, < 2500 caracteres) sem apagar o facts.jsonl. Sem argumentos: mostre `count` e os 10 últimos fatos.

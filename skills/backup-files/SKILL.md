---
name: backup-files
description: Create a timestamped backup archive of specified files or directory. (Skill importada do OpenJarvis; parâmetros: destination, source.)
---

# backup-files

Create a timestamped backup archive of specified files or directory.

## Parâmetros
- `destination`: extraia do pedido do usuário; se faltar, pergunte.
- `source`: extraia do pedido do usuário; se faltar, pergunte.

## Passos (ordem original do OpenJarvis; adapte com bom senso)
1. execute no Bash: `date +%Y%m%d_%H%M%S` → guarde o resultado como `timestamp`.
2. execute no Bash: `tar czf {destination}/backup_{timestamp}.tar.gz -C {source} .` → guarde o resultado como `archive_result`.
3. raciocine (sem ferramentas): Verify the backup was created successfully and summarize: {archive_result} → guarde o resultado como `report`.

Entregue o resultado final de forma concisa. Só persista na memória fatos duráveis; nunca segredos.

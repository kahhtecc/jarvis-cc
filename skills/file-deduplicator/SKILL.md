---
name: file-deduplicator
description: Find and report duplicate files in a directory by comparing checksums. (Skill importada do OpenJarvis; parâmetros: directory.)
---

# file-deduplicator

Find and report duplicate files in a directory by comparing checksums.

## Parâmetros
- `directory`: extraia do pedido do usuário; se faltar, pergunte.

## Passos (ordem original do OpenJarvis; adapte com bom senso)
1. execute no Bash: `find {directory} -type f -exec md5sum {} \; | sort` → guarde o resultado como `checksums`.
2. raciocine (sem ferramentas): Identify duplicate files from the checksums. Group files with identical hashes: {checksums} → guarde o resultado como `duplicates`.
3. raciocine (sem ferramentas): Generate a report listing all duplicate file groups and total space that could be reclaimed: {duplicates} → guarde o resultado como `report`.

Entregue o resultado final de forma concisa. Só persista na memória fatos duráveis; nunca segredos.

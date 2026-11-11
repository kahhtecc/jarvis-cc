---
name: code-lint
description: Read a source file, analyze it for code quality issues, and report findings. (Skill importada do OpenJarvis; parâmetros: file_path.)
---

# code-lint

Read a source file, analyze it for code quality issues, and report findings.

## Parâmetros
- `file_path`: extraia do pedido do usuário; se faltar, pergunte.

## Passos (ordem original do OpenJarvis; adapte com bom senso)
1. leia o arquivo {file_path} com Read → guarde o resultado como `source_code`.
2. raciocine (sem ferramentas): Analyze the code for quality issues: style violations, potential bugs, unused variables, missing error handling, code smells, and complexity problems: {source_code} → guarde o resultado como `issues`.
3. raciocine (sem ferramentas): Format the findings as a structured lint report with severity levels (error, warning, info) and line references: {issues} → guarde o resultado como `report`.

Entregue o resultado final de forma concisa. Só persista na memória fatos duráveis; nunca segredos.

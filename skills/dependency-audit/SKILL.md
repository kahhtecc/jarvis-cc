---
name: dependency-audit
description: Check project dependencies for known vulnerabilities and outdated packages. (Skill importada do OpenJarvis; parâmetros: project_path.)
---

# dependency-audit

Check project dependencies for known vulnerabilities and outdated packages.

## Parâmetros
- `project_path`: extraia do pedido do usuário; se faltar, pergunte.

## Passos (ordem original do OpenJarvis; adapte com bom senso)
1. leia o arquivo {project_path}/pyproject.toml com Read → guarde o resultado como `project_config`.
2. raciocine (sem ferramentas): Extract all dependencies and their version constraints from the project config: {project_config} → guarde o resultado como `dependencies`.
3. use WebSearch com a consulta python package vulnerability advisory {dependencies} → guarde o resultado como `advisories`.
4. raciocine (sem ferramentas): Cross-reference dependencies with advisories and generate an audit report with risk levels and upgrade recommendations: {advisories} → guarde o resultado como `report`.

Entregue o resultado final de forma concisa. Só persista na memória fatos duráveis; nunca segredos.

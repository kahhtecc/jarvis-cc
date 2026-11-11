---
name: security-scan
description: Scan source code for common security vulnerabilities and report findings. (Skill importada do OpenJarvis; parâmetros: file_path.)
---

# security-scan

Scan source code for common security vulnerabilities and report findings.

## Parâmetros
- `file_path`: extraia do pedido do usuário; se faltar, pergunte.

## Passos (ordem original do OpenJarvis; adapte com bom senso)
1. leia o arquivo {file_path} com Read → guarde o resultado como `source_code`.
2. raciocine (sem ferramentas): Scan for security vulnerabilities: SQL injection, XSS, command injection, hardcoded secrets, insecure crypto, path traversal, SSRF, deserialization issues: {source_code} → guarde o resultado como `vulnerabilities`.
3. raciocine (sem ferramentas): Generate a security report with severity ratings (critical, high, medium, low), affected lines, and remediation advice: {vulnerabilities} → guarde o resultado como `report`.

Entregue o resultado final de forma concisa. Só persista na memória fatos duráveis; nunca segredos.

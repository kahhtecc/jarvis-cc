---
name: code-test-gen
description: Read a source file and generate unit tests for its functions and classes. (Skill importada do OpenJarvis; parâmetros: file_path.)
---

# code-test-gen

Read a source file and generate unit tests for its functions and classes.

## Parâmetros
- `file_path`: extraia do pedido do usuário; se faltar, pergunte.

## Passos (ordem original do OpenJarvis; adapte com bom senso)
1. leia o arquivo {file_path} com Read → guarde o resultado como `source_code`.
2. raciocine (sem ferramentas): Identify all functions, classes, and methods in the source code. Determine their inputs, outputs, and edge cases: {source_code} → guarde o resultado como `analysis`.
3. execute este código com Bash (python3 -c ou arquivo temporário): # Generate pytest-style unit tests based on the analysis:\n# {analysis}\nprint("Tests generated successfully") → guarde o resultado como `generated_tests`.
4. raciocine (sem ferramentas): Review the generated tests for completeness and correctness. Suggest additional test cases if needed: {generated_tests} → guarde o resultado como `review`.

Entregue o resultado final de forma concisa. Só persista na memória fatos duráveis; nunca segredos.

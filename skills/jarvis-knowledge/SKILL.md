---
name: jarvis-knowledge
description: Base de conhecimento local do Jarvis — indexar pastas de documentos/notas/e-mails exportados e buscar neles (equivalente a jarvis memory index + knowledge_search/scan_chunks). Use para "indexe essa pasta", "procure nos meus documentos", "o que meus arquivos dizem sobre X".
---

# Knowledge (documentos locais)

```bash
${CLAUDE_PLUGIN_ROOT}/scripts/jarvis-index.sh add <pasta>        # registra a fonte e gera o catálogo
${CLAUDE_PLUGIN_ROOT}/scripts/jarvis-index.sh list               # fontes e contagem
${CLAUDE_PLUGIN_ROOT}/scripts/jarvis-index.sh search "termos"    # arquivos que contêm os termos (rg/grep, case-insensitive)
${CLAUDE_PLUGIN_ROOT}/scripts/jarvis-index.sh catalog            # reconstrói o catálogo (~/.jarvis/knowledge/catalog.tsv)
```

## Estratégia de busca (knowledge_search → scan_chunks)
1. **Palavra-chave** primeiro: `search` com 2 a 4 variações de termos (sinônimos, nomes, siglas).
2. **Leitura dirigida**: abra os arquivos candidatos com Read/Grep com contexto (-C 3) em vez de ler tudo.
3. **Varredura semântica** (scan_chunks): se a pergunta for abstrata ("compromissos que assumi", "itens de ação"), leia os arquivos mais recentes do catálogo (`sort -t$'\t' -k3 -r catalog.tsv | head`) e extraia o que corresponde ao significado.
4. **Contagens/rankings** (knowledge_sql): use o catálogo TSV com awk/cut/sort/uniq.
5. Cite caminho + título nas respostas de pesquisa.

PDFs: extraia texto com a skill de PDF do ambiente ou `pdftotext` se existir.

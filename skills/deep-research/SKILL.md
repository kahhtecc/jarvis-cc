---
name: deep-research
description: Pesquisa profunda multi-hop com citações — combina web, documentos locais indexados e memória do Jarvis, e produz relatório citado salvo em ~/.jarvis/reports. Use para "pesquise a fundo", "faça um relatório sobre", comparações, levantamento de literatura, ou perguntas que exigem cruzar várias fontes.
---

# Deep Research (agente deep_research do OpenJarvis, versão Claude Code)

Objetivo: resposta correta, citada e proporcional à pergunta. Não pesquise demais para perguntas simples.

## Protocolo
1. **Planeje** (1 parágrafo mental): tipo de resposta, fontes prováveis, 3 a 6 consultas iniciais. Expanda termos abstratos em palavras-chave concretas, sinônimos e nomes.
2. **Conhecimento prévio**: `${CLAUDE_PLUGIN_ROOT}/scripts/jarvis-memory.sh search "<tema>"` e, se houver fontes indexadas, `${CLAUDE_PLUGIN_ROOT}/scripts/jarvis-index.sh search "<termos>"` (depois leia os arquivos encontrados com Read/Grep).
3. **Web**: WebSearch (modo standard; extended só se vier raso ou o tema for recente/nicho). Abra as páginas que importam com WebFetch. Máximo de hops: `research_max_hops` do config (padrão 8).
4. **Cruzamento**: compare fontes, marque divergências, registre datas. Nunca afirme sem fonte.
5. **Relatório**: estrutura abaixo. Cite inline como [n] e liste as fontes no fim com URL ou caminho.
6. **Salve** em `~/.jarvis/reports/AAAA-MM-DD-<slug>.md` e registre um fato de memória só se o tema for um interesse durável do usuário.

## Quando usar subagente
Se a pesquisa tiver mais de ~3 frentes independentes, delegue cada frente ao agente `jarvis-cc:researcher` (em paralelo) e sintetize. Caso contrário, faça inline: subagentes custam tokens da assinatura.

## Formato do relatório
```
# <título>
Resumo executivo (3 a 5 frases)
## Achados
- achado [1]
## Divergências e incertezas
## Conclusão / recomendação
## Fontes
[1] título — URL/caminho (data)
```
Se nada for encontrado, diga honestamente e sugira alternativas.

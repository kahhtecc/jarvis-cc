---
name: morning-digest
description: Briefing diário estilo Jarvis (morning digest) — coleta mensagens, agenda, saúde e notícias a partir dos conectores disponíveis e da web, e produz um briefing falado curto, salvo em ~/.jarvis/digests. Use para "meu briefing", "resumo do dia", "bom dia Jarvis", "digest".
---

# Morning Digest

## 1. Configuração
Leia `~/.jarvis/config.toml` (digest_sections, digest_max_words, digest_style, honorific, timezone, persona) e a persona em `~/.jarvis/personas/<persona>.md`.

## 2. Coleta (equivalente ao digest_collect)
Para cada seção configurada, use **apenas** fontes realmente disponíveis nesta sessão:
| Seção | Fontes |
|---|---|
| messages | ferramentas MCP de e-mail/Slack/GitHub conectadas (ex.: Gmail, Slack, notificações do gh); `gh api notifications` se o gh estiver autenticado |
| calendar | ferramenta MCP de calendário conectada (Google Calendar etc.) |
| health | ferramenta MCP de saúde, se existir |
| world | WebSearch: previsão do tempo da cidade do USER.md, 3 a 5 manchetes relevantes aos interesses do usuário (memória) |
| music | ferramenta MCP de música, se existir |

Janela: últimas 24 h. Se uma fonte não existe ou falha, **pule em silêncio** (regra do OpenJarvis). Use `ListConnectors`/ToolSearch para descobrir conectores antes de assumir que não há.

## 3. Síntese
Escreva o briefing em ordem decrescente de importância, só com fatos coletados, sem inventar contexto pessoal nem oferecer ações. Estilo `spoken`: sem markdown, sem emoji, sem bullets, sem títulos; honorífico no máximo 3 vezes; limite `digest_max_words` (padrão 200). Estilo `markdown`: seções curtas são permitidas.

## 4. Autoavaliação (DigestEvaluator)
Antes de entregar, cheque: (a) nenhuma afirmação fora dos dados; (b) nenhuma menção a fonte indisponível; (c) dentro do limite de palavras; (d) toda fonte que retornou dados foi reconhecida. Corrija e reescreva se falhar.

## 5. Entrega e persistência
Mostre o briefing e salve em `~/.jarvis/digests/AAAA-MM-DD.md` (com uma linha de cabeçalho listando as fontes usadas). Para agendar diariamente, oriente `/jarvis-cc:schedule`.

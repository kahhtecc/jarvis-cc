# Jarvis CC — OpenJarvis rodando 100% dentro do Claude Code

> Reimplementação do [OpenJarvis](https://github.com/open-jarvis/OpenJarvis) como **plugin do Claude Code**.
> O "motor de inferência" é a sua própria sessão do Claude Code (assinatura, limites de sessão e semanais).
> **Sem chave de API, sem Ollama, sem servidor local, sem Node/Python extra.**

## Por que isso existe

O OpenJarvis original é um stack Python + Rust + Ollama/vLLM + FastAPI + frontend. Ele precisa ser instalado na máquina, baixar modelos e, para usar Claude, exige `ANTHROPIC_API_KEY` (agente `claude_code` via Agent SDK).

O Jarvis CC pega os **conceitos** do OpenJarvis (persona, memória de fatos, SOUL/USER/MEMORY, agentes com estado, deep research, morning digest, skills, scheduler, traces) e os reimplementa com as primitivas nativas do Claude Code: skills, comandos slash, subagentes, hooks e o agendador do Claude Code. Tudo que precisa de "modelo" vira instrução para a sessão atual; tudo que precisa de persistência vira arquivo em `~/.jarvis/`.

## Mapa OpenJarvis → Jarvis CC

| OpenJarvis | Jarvis CC | Como |
|---|---|---|
| `[engine]` (ollama, vllm, …) + `[intelligence]` | — | A sessão do Claude Code é o motor. Não há configuração de modelo. |
| `prompt/builder.py` (SOUL.md, USER.md, MEMORY.md, frozen prefix) | hook `SessionStart` | `scripts/hook-session-start.sh` injeta SOUL + USER + MEMORY + últimos fatos no início de cada sessão (truncamento head_tail igual ao original). |
| `memory/store.py` + `memory/extractor.py` (FactExtractor) | `scripts/jarvis-memory.sh` + skill `jarvis-memory` | Fatos em `~/.jarvis/memory/facts.jsonl`, dedupe por hash, busca por palavra-chave. A "extração" é feita pela própria sessão seguindo a regra do FactExtractor; o hook `UserPromptSubmit` dá o nudge a cada N turnos (`nudge_interval`). |
| agente `orchestrator` | skill `jarvis` + `/jarvis-cc:ask` | Tabela de roteamento para a skill mais barata que resolve. |
| agente `deep_research` | skill `deep-research` + subagente `researcher` + `/jarvis-cc:research` | Multi-hop com WebSearch/WebFetch + documentos locais + memória, relatório citado em `~/.jarvis/reports/`. |
| agente `morning_digest` + `DigestEvaluator` | skill `morning-digest` + subagente `digest-writer` + `/jarvis-cc:digest` | Coleta via conectores MCP disponíveis (Gmail, Calendar, Slack, gh) e web; briefing falado ≤ 200 palavras com autoavaliação; salvo em `~/.jarvis/digests/`. |
| `operative` / `monitor_operative` + templates (`code_reviewer`, `inbox_triager`, `research_monitor`) | skill `monitor` + subagentes homônimos + `scripts/jarvis-state.sh` + `/jarvis-cc:monitor` | Estado por agente em `~/.jarvis/state/<nome>.md`, restaurado e persistido a cada execução. |
| `scheduler` (`jarvis scheduler create`) | `/jarvis-cc:schedule` | Usa `CronCreate` (local) ou tarefas agendadas da nuvem (`create_trigger`). |
| `jarvis memory index` + `knowledge_search` / `knowledge_sql` / `scan_chunks` | `scripts/jarvis-index.sh` + skill `jarvis-knowledge` + `/jarvis-cc:index` | Catálogo TSV + busca com ripgrep; varredura semântica feita pela sessão. |
| 20 skills TOML (`skills/data/*.toml`) | `skills/<nome>/SKILL.md` | Convertidas por `tools/convert_skills.py` (mapeia cada `tool_name` do OpenJarvis para ferramenta nativa ou script do Jarvis). |
| `jarvis skill install hermes:… / openclaw` | `/jarvis-cc:skill import <git-url>` | Importa SKILL.md (padrão agentskills.io) ou TOML, com revisão de segurança antes de copiar. |
| `traces/` + `server/savings.py` | `scripts/jarvis-trace.sh` + `/jarvis-cc:status` | Hooks registram prompts/respostas em `~/.jarvis/traces/*.jsonl`; `stats` estima tokens e o equivalente em API paga. |
| `jarvis doctor` | `/jarvis-cc:doctor` | Sem checagem de GPU/Ollama: só o que importa aqui. |
| `jarvis init --preset …` | `/jarvis-cc:init` | Cria `~/.jarvis`, entrevista de primeiro uso, preenche USER.md/config. |
| `configs/openjarvis/prompts/personas/jarvis.md` | `templates/personas/jarvis.md` (pt-BR) | Persona com honorífico configurável. |

**Deixado de fora de propósito** (precisa de servidor, API externa ou hardware): GUI/desktop Tauri, servidor FastAPI, canais (Telegram/Slack bot), A2A, telemetria de energia/FLOPs, benchmarks de modelos locais, learning loop (DSPy/otimização de rotas), TTS (o digest entrega texto; se houver ferramenta de áudio na sessão, a skill a usa).

## Instalação

Requisitos: Claude Code ≥ 2.1 com assinatura ativa, `bash`, `python3`, `jq` (opcional: `rg`).

**Opção A — testar direto da pasta**
```bash
claude --plugin-dir /caminho/para/jarvis-cc
```

**Opção B — instalar como plugin (persistente)**
```bash
# dentro do Claude Code
/plugin marketplace add /caminho/para/jarvis-cc
/plugin install jarvis-cc@jarvis-cc-marketplace
```
Se você publicar esta pasta num repositório GitHub, troque o caminho por `usuario/repo`.

Depois:
```
/jarvis-cc:init
```

## Uso

| Comando | O que faz |
|---|---|
| `/jarvis-cc:ask <pedido>` | Fala com o Jarvis (persona + memória + roteamento). Em sessões normais basta chamar "Jarvis" — a skill é ativada por contexto. |
| `/jarvis-cc:research <tema>` | Deep research com citações. |
| `/jarvis-cc:digest` | Briefing do dia. `--sections messages,world` ou `--text-only`. |
| `/jarvis-cc:monitor research_monitor "RAG local"` | Roda um agente com estado. Templates: `code_reviewer`, `inbox_triager`, `research_monitor`, ou um nome seu. |
| `/jarvis-cc:schedule "0 8 * * 1-5" /jarvis-cc:digest` | Agenda. |
| `/jarvis-cc:memory add "…"` / `search` / `list` / `forget n` / `consolidate` | Memória. |
| `/jarvis-cc:index ~/Documentos/notas` | Indexa documentos locais. |
| `/jarvis-cc:skill list` / `import <url>` | Skills. |
| `/jarvis-cc:status`, `/jarvis-cc:doctor` | Painel e diagnóstico. |

Skills importadas do OpenJarvis disponíveis por contexto: backup-files, calendar-prep, code-lint, code-test-gen, compare-docs, daily-digest, data-analyze, dependency-audit, email-draft, file-deduplicator, file-organizer, knowledge-extract, meeting-notes, pdf-summarize, search-and-index, security-scan, todo-from-notes, topic-research, translate-doc, web-summarize.

## Onde ficam seus dados

```
~/.jarvis/
├── SOUL.md            persona (editável)
├── USER.md            quem você é
├── MEMORY.md          resumo curado, lido toda sessão
├── config.toml        honorífico, fuso, seções do digest, nudge_interval…
├── memory/facts.jsonl fatos atômicos
├── state/<agente>.md  estado dos monitores
├── knowledge/         fontes e catálogo indexados
├── digests/ reports/  saídas
└── traces/            telemetria local (jsonl por dia)
```
Nada sai da sua máquina/sessão além do que a própria sessão do Claude Code já faz. Nenhum script chama rede.

## Limites de uso

Tudo consome a cota da sua assinatura (`/usage` mostra sessão e semana). O plugin é desenhado para gastar pouco: contexto injetado é truncado (SOUL 4000 / MEMORY 2500 / USER 1500 chars, como no OpenJarvis), subagentes só para trabalho longo, hooks são scripts shell sem chamadas de modelo. `/jarvis-cc:status` mostra uma estimativa do que o uso equivaleria em API paga.

## Desenvolvimento

```bash
claude plugin validate .                              # valida manifesto e layout
JARVIS_HOME=/tmp/jh scripts/jarvis-memory.sh add "x"  # testar scripts isolados
python3 -I tools/convert_skills.py pasta/com/toml skills/   # reconverter skills
```

Licença: Apache-2.0 (mesma do OpenJarvis; prompts e nomes dos templates derivam do projeto original).

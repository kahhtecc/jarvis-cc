#!/usr/bin/env python3
"""Converte skills TOML do OpenJarvis ([skill] + [[skill.steps]]) em skills do Claude Code (SKILL.md).

Uso: python3 -I convert_skills.py <arquivo.toml|pasta> <dir-de-saida>
Cada passo (tool_name + arguments_template) vira uma instrução em linguagem natural que mapeia a
ferramenta do OpenJarvis para a ferramenta nativa do Claude Code ou para os scripts do Jarvis.
"""
import json, re, sys, tomllib
from pathlib import Path

TOOL_MAP = {
    "memory_search":  "busque na memória do Jarvis: `${CLAUDE_PLUGIN_ROOT}/scripts/jarvis-memory.sh search {q}`",
    "memory_store":   "guarde na memória do Jarvis (apenas se for durável): `${CLAUDE_PLUGIN_ROOT}/scripts/jarvis-memory.sh add \"{content}\" --source skill`",
    "memory_retrieve":"busque na memória do Jarvis: `${CLAUDE_PLUGIN_ROOT}/scripts/jarvis-memory.sh search {q}`",
    "web_search":     "use WebSearch com a consulta {q}",
    "http_request":   "use WebFetch na URL {url}",
    "file_read":      "leia o arquivo {path} com Read",
    "file_write":     "escreva {path} com Write",
    "shell_exec":     "execute no Bash: `{command}`",
    "code_interpreter":"execute este código com Bash (python3 -c ou arquivo temporário): {code}",
    "think":          "raciocine (sem ferramentas): {thought}",
    "calculator":     "calcule: {expression}",
    "pdf_tool":       "extraia o texto do PDF {path} (skill de PDF do ambiente ou pdftotext)",
    "knowledge_search":"busque nos documentos indexados: `${CLAUDE_PLUGIN_ROOT}/scripts/jarvis-index.sh search {q}` e leia os resultados com Read/Grep",
    "scan_chunks":    "faça uma varredura semântica dos documentos indexados mais recentes procurando: {question}",
    "text_to_speech": "se houver ferramenta de TTS disponível, gere áudio; caso contrário entregue o texto",
    "git_tool":       "use git no Bash: {command}",
    "llm_tool":       "produza o texto pedido você mesmo: {prompt}",
}

def arg(template: str, *keys):
    try:
        d = json.loads(template)
    except Exception:
        return template
    for k in keys:
        if k in d:
            return str(d[k])
    return ", ".join(f"{k}={v}" for k, v in d.items())

def describe(step):
    tool = step.get("tool_name", "?")
    t = step.get("arguments_template", "")
    fmt = TOOL_MAP.get(tool)
    if not fmt:
        return f"use a ferramenta equivalente a `{tool}` com {t}"
    fields = {
        "q": arg(t, "query"), "content": arg(t, "content"), "url": arg(t, "url"),
        "path": arg(t, "path", "file_path"), "command": arg(t, "command"), "code": arg(t, "code"),
        "thought": arg(t, "thought"), "expression": arg(t, "expression"),
        "question": arg(t, "question", "query"), "prompt": arg(t, "prompt"),
    }
    out = fmt
    for k, v in fields.items():
        out = out.replace("{" + k + "}", v)
    return out

def convert(path: Path, out_dir: Path):
    data = tomllib.loads(path.read_text(encoding="utf-8"))
    sk = data.get("skill", data)
    name = re.sub(r"[^a-z0-9-]", "-", sk["name"].lower())
    desc = sk.get("description", "").strip().rstrip(".")
    steps = sk.get("steps", [])
    params = sorted({p for s in steps for p in re.findall(r"\{(\w+)\}", s.get("arguments_template", ""))
                     if p not in {s2.get("output_key") for s2 in steps}})
    lines = ["---", f"name: {name}",
             f"description: {desc}. (Skill importada do OpenJarvis; parâmetros: {', '.join(params) or 'nenhum'}.)",
             "---", "", f"# {sk['name']}", "", desc + ".", ""]
    if params:
        lines += ["## Parâmetros", *[f"- `{p}`: extraia do pedido do usuário; se faltar, pergunte." for p in params], ""]
    lines += ["## Passos (ordem original do OpenJarvis; adapte com bom senso)"]
    for i, s in enumerate(steps, 1):
        ok = s.get("output_key")
        lines.append(f"{i}. {describe(s)}" + (f" → guarde o resultado como `{ok}`." if ok else ""))
    lines += ["", "Entregue o resultado final de forma concisa. Só persista na memória fatos duráveis; nunca segredos."]
    dest = out_dir / name / "SKILL.md"
    dest.parent.mkdir(parents=True, exist_ok=True)
    dest.write_text("\n".join(lines) + "\n", encoding="utf-8")
    return dest

def main():
    if len(sys.argv) != 3:
        print(__doc__); sys.exit(1)
    src, out = Path(sys.argv[1]), Path(sys.argv[2])
    files = [src] if src.is_file() else sorted(src.rglob("*.toml"))
    n = 0
    for f in files:
        try:
            print("ok ", convert(f, out)); n += 1
        except Exception as e:  # noqa: BLE001
            print("falhou", f, e)
    print(f"{n} skill(s) convertida(s) em {out}")

if __name__ == "__main__":
    main()

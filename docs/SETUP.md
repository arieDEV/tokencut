# Setup

## Install

```bash
git clone https://github.com/arieDEV/tokencut.git
cd tokencut
./scripts/install
```

## What gets wired

| Target | Default location |
| --- | --- |
| Cursor | `~/.cursor/skills/tokencut` → `skills/` |
| Agent workflows (hosted box) | `$HOME/agent-data/workflows/tokencut-*` when that directory exists |

Overrides:

```bash
CURSOR_SKILLS_DIR=/custom/path ./scripts/install
AGENT_WORKFLOWS_DIR=/custom/workflows ./scripts/install
```

Local-only files (not published): `config/settings.json`, `config/brain.md`, `memory/lessons.md`. Defaults live in `config/settings.defaults.json` and `memory/lessons.md.example`.

## Verify

```bash
./scripts/toggle status
ls ~/.cursor/skills/tokencut   # when using Cursor
```

Ask a normal coding question on an existing project. A ✂️ badge indicates tokencut handled the job.

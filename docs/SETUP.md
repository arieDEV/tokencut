# Setup one-click

```bash
git clone https://github.com/arieDEV/tokencut.git
cd tokencut
./scripts/install
```

## Yang di-wire

| Target | Path default |
| --- | --- |
| Cursor | `~/.cursor/skills/tokencut` → symlink ke `skills/` |
| Grok Bot / box | `~/agent-data/workflows/tokencut-*` |

Override:

```bash
CURSOR_SKILLS_DIR=/custom/path ./scripts/install
GROK_WORKFLOWS_DIR=/custom/workflows ./scripts/install
```

## Verifikasi

```bash
./scripts/toggle status          # ON
ls ~/.cursor/skills/tokencut    # ada (Cursor)
```

Lalu di Cursor/Grok Bot: tanya coding biasa pada project yang sudah ada → cari badge ✂️.

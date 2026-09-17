# tokencut

**Token-saving local workers for coding agents** — inspired by Spotify’s *shunt*, **without Portal / AiKA**.

Install it like a local dependency (npm/pip-style scripts + skills). When toggled **on**, agents should auto-use it for suitable coding work — **not** a chat/thread “mode” you enter with magic words.

> Bahasa singkat: mesin hemat token di mesin agent. Pasang → `toggle on` → agent pakai sendiri untuk baca file besar / boilerplate / review. Bukan chatbot.

---

## Mental model

| Think of it as | Not |
| --- | --- |
| A **local package** of bash/python CLIs + agent skills | A product chat mode or Second Brain (Slack/Docs/Jira) |
| **Always-on when `toggle on`** (like an installed lib) | Something you must say “pakai tokencut” to activate |
| Workers for bulk I/O → short answers + ✂️ badge | A replacement for the main agent on meta/greenfield |

---

## Requirements

- `bash`, `jq`, `python3`
- A coding agent that can run shell scripts and spawn cheaper workers (`Task` / equivalent)

---

## Install

```bash
git clone <your-fork-or-upstream-url> tokencut
cd tokencut

export TOKENCUT_ROOT="$PWD"
export TOKENCUT_JOBS="${TOKENCUT_JOBS:-$HOME/.tokencut/jobs}"   # or e.g. /workspace/.tokencut/jobs
mkdir -p "$TOKENCUT_JOBS"

cp config/brain.md.template config/brain.md   # optional profile inject
"$TOKENCUT_ROOT/scripts/toggle" on
"$TOKENCUT_ROOT/scripts/toggle" status
```

Wire skills into your agent (copy or symlink):

```bash
# example — adjust to your agent’s skills directory
ln -s "$TOKENCUT_ROOT/skills" /path/to/agent/skills/tokencut
```

Add `TOKENCUT_ROOT` / `TOKENCUT_JOBS` to the agent environment so scripts resolve without hard-coded paths.

---

## Quick start (no magic words)

With tokencut **ON**, give a normal coding ask on an existing project (“explain auth”, “review this draft”, “scaffold tests from this reference”). The agent should:

1. `should-use-tokencut` — gate meta/greenfield
2. `detect-project` → `use-for-project` (or `cmd` / `role-run` / `resolve-prompt`)
3. Run workers with `model_hint` → `drive-next` until done
4. Reply with a **✂️** badge + job id

Manual smoke:

```bash
"$TOKENCUT_ROOT/scripts/should-use-tokencut" --prompt "Explain the auth flow"
"$TOKENCUT_ROOT/scripts/detect-project" --json
"$TOKENCUT_ROOT/scripts/cmd" --list
"$TOKENCUT_ROOT/scripts/cmd" explain-area \
  --question "What does this export?" \
  --paths src/foo.ts
```

---

## When it runs vs answers directly

| Situation | Path |
| --- | --- |
| Read / summarize / review / boilerplate on an **existing user project** | ✂️ tokencut |
| Changing **tokencut itself**, **new project** scaffold, or “how do I use tokencut?” | Answer directly + `badge --none` |
| `toggle off` | Answer directly |

One-pager for agents: [`docs/PUBLIC.md`](docs/PUBLIC.md) · details: [`docs/when-to-use.md`](docs/when-to-use.md)

---

## Badge ✂️

Final replies that used tokencut **must** show a scissors badge and job id, e.g.:

```text
✂️ tokencut chain 📖reader💚→🧵synthesizer❤️ · job=20260918-...
```

No ✂️ + job id → **do not** claim token savings. Direct answers use `badge --none` (🧠).

```bash
"$TOKENCUT_ROOT/scripts/badge" --from-job "$TOKENCUT_JOBS/<id>/manifest.json"
"$TOKENCUT_ROOT/scripts/badge" --none
```

---

## Toggle

```bash
"$TOKENCUT_ROOT/scripts/toggle" status
"$TOKENCUT_ROOT/scripts/toggle" on
"$TOKENCUT_ROOT/scripts/toggle" off                 # disable all tokencut packing
"$TOKENCUT_ROOT/scripts/toggle" auto-continue on|off
"$TOKENCUT_ROOT/scripts/toggle" badge on|off
"$TOKENCUT_ROOT/scripts/toggle" smart-route on|off
```

State lives in `config/settings.json`.

---

## Main CLIs

| Command | Purpose |
| --- | --- |
| `should-use-tokencut` | Gate: pack vs answer directly |
| `detect-project` / `use-for-project` | Find project + pack without user paths |
| `cmd` | SOPs: `explain-area`, `review-change`, `design-choice` |
| `role-run` | Roles: reader / writer / reviewer / debugger / architect / synthesizer |
| `resolve-prompt` + `apply-classify` | Ambiguous prompt → classifier → role |
| `smart-route` | Heuristic role + optional `--pack` |
| `drive-next` / `last` / `e2e` | Advance pipeline / inspect jobs |
| `learn` | Append lessons for later inject |

Roles at a glance: **reader/writer** → low 💚 · **reviewer/debugger** → medium 💛 · **architect/synthesizer** → high ❤️

---

## Docs

- [`docs/PUBLIC.md`](docs/PUBLIC.md) — agent auto-route one-pager  
- [`docs/when-to-use.md`](docs/when-to-use.md) · [`docs/any-project.md`](docs/any-project.md) · [`docs/auto-continue.md`](docs/auto-continue.md)  
- [`docs/v2-plan.md`](docs/v2-plan.md) — design notes  
- [`README.upstream.md`](README.upstream.md) — upstream Spotify *shunt* notes (Portal/AiKA; **not** used here)

---

## Layout

```text
tokencut/
  config/     roles, settings, brain.md.template, commands/, router-rules.json
  scripts/    CLIs (+ lib/)
  skills/     agent skill markdown (link/copy into your agent)
  memory/     lessons.md
  docs/       public + design docs
  tests/      golden tests
```

Runtime jobs: `$TOKENCUT_JOBS/<id>/` (gitignored). Personal `config/brain.md` is gitignored — copy from the template.

---

## Not for

- Slack / Docs / Calendar / Jira / meeting recorders  
- Claiming Spotify’s published % savings as your numbers (host pricing differs)  
- Pure architecture decisions with no brief (keep those short on the main agent or `architect`)

---

## License

MIT — see [`LICENSE`](LICENSE). Contributions welcome: [`CONTRIBUTING.md`](CONTRIBUTING.md).

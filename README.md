# tokencut

Local **token-saving workers** for coding agents. Inspired by Spotify’s *shunt*, with **no Portal / AiKA**.

Treat tokencut as an installable dependency (similar to a local CLI package): install once, leave it enabled, and let the agent route suitable coding work to cheaper workers. It is **not** a chat product, thread mode, or browser extension.

## Compatibility

| Environment | Supported | Notes |
| --- | :---: | --- |
| [Cursor](https://cursor.com) | Yes | `./scripts/install` links skills under `~/.cursor/skills/tokencut` |
| Hosted coding agents with a shell (VM / box) | Yes | Install wires agent workflow/skill directories when present |
| Any agent that can run shell scripts and spawn workers | Yes | Set `TOKENCUT_ROOT` and load the skills under `skills/` |
| Browser-only chat (no machine shell) | No | Requires a machine where the agent can execute scripts |

## One-click install

```bash
git clone https://github.com/arieDEV/tokencut.git
cd tokencut
./scripts/install
```

The installer:

1. Enables tokencut (`toggle on`)
2. Sets `TOKENCUT_ROOT` and `TOKENCUT_JOBS`
3. Links skills for Cursor and compatible agent workflow directories when found

Verify:

```bash
./scripts/toggle status
```

More detail: [docs/SETUP.md](docs/SETUP.md).

## Usage

With tokencut **on**, ask normal coding questions about an **existing** project (explain an area, review a draft, generate boilerplate from a reference). The agent should invoke tokencut without special wake words.

Successful tokencut runs end with a **✂️** badge and job id. Direct answers (meta work on tokencut itself, greenfield scaffolds, or `toggle off`) do not claim savings and use a non-scissors badge.

```bash
./scripts/toggle off    # disable globally
./scripts/toggle on
```

## When tokencut runs

| Situation | Expected path |
| --- | --- |
| Read / summarize / review / boilerplate on an existing user project | tokencut workers + ✂️ |
| Changing this repository, scaffolding a new project, or product Q&A about tokencut | Direct agent answer |
| `toggle off` | Direct agent answer |

Agent routing notes: [docs/PUBLIC.md](docs/PUBLIC.md) · [docs/when-to-use.md](docs/when-to-use.md)

## Requirements

- `bash`, `jq`, `python3`
- A coding agent that can run shell commands on the same machine as the project

## License

MIT — see [LICENSE](LICENSE).

Release: [v1.0.0](https://github.com/arieDEV/tokencut/releases/tag/v1.0.0)

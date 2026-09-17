# tokencut

Fork of Spotify's [shunt](https://github.com/spotify/portal-ai-plugins/tree/main/plugins/shunt) for **this coding-agent computer**, with **no Portal and no AiKA**.

Upstream shunt saves ~82–94% tokens by sending large file reads and boilerplate to cheap AiKA worker modes through Portal CLI. This fork keeps the same *workflow shape* but replaces AiKA with a **low-cost executor** on this machine.

## How it works

1. You (or the agent) run `scripts/bulk-read` or `scripts/code-write`.
2. The script validates inputs and writes a job under `/workspace/.tokencut/jobs/<id>/` including `PROMPT.md`.
3. stdout is a JSON manifest (`kind: tokencut-job`) telling the agent to dispatch **one executor with `model=low`** using that prompt.
4. Large file bodies stay out of the main chat; only the worker's short answer comes back.

There are **no Claude Code hooks** here (those are host-specific). Enforcement is via Grok Bot skills that tell the agent when to call these scripts.

## Install / paths

```text
/workspace/tokencut/          ← this fork
/workspace/.tokencut/jobs/    ← job prompts + manifests
```

Skills on this bot: `Bulk file read`, `Boilerplate code write` (point at these scripts).

## Commands

```bash
/workspace/tokencut/scripts/bulk-read \
  --question "What does this service do?" \
  --paths src/Service.ts src/Handler.ts

/workspace/tokencut/scripts/code-write \
  --spec "Write tests for UserService" \
  --reference tests/OrderTest.ts \
  --target tests/UserTest.ts
```

## Env

| Variable | Default | Purpose |
| --- | --- | --- |
| `TOKENCUT_JOBS` | `/workspace/.tokencut/jobs` | Job directory |
| `TOKENCUT_MAX_BYTES` | `2000000` | Max combined size for one bulk-read batch |
| `TOKENCUT_MIN_LINES` | `350` | Hint threshold (skills); scripts do not hard-block |

## What this is not

- Not a drop-in Claude Code plugin (no PreToolUse hooks).
- Not Portal/AiKA — savings depend on this host's low-effort executor pricing, not Spotify's benchmark numbers.
- Not for debugging, surgical edits, or architecture decisions (keep those on the main agent).

## Upstream

See `README.upstream.md` for the original shunt design and benchmarks.

## Multi-role

Roles live in `config/roles.json`. Pack with `scripts/role-run`; optional pipelines via `scripts/pipeline`.

| Role | Effort / model | Job |
| --- | --- | --- |
| `reader` | low | Bulk-read / summarize files |
| `writer` | low | Boilerplate from a reference |
| `reviewer` | medium | Critique a draft or diff |
| `architect` | high | Tradeoffs on a short brief (not huge corpora) |
| `debugger` | medium | Hypotheses from logs + source |

```bash
/workspace/tokencut/scripts/role-run --list

/workspace/tokencut/scripts/role-run --role reviewer \
  --question "Any bugs?" --paths src/foo.ts --draft /tmp/draft.ts

/workspace/tokencut/scripts/pipeline --pack draft-then-review \
  --spec "Add tests" --reference tests/a_test.ts --target tests/b_test.ts
```

The JSON manifest includes `role`, `effort`, and `model_hint` so the agent dispatches the matching executor tier.

## Smart-route

Heuristic detector (no LLM) that scores a natural-language prompt and optional paths, then suggests `role` + `model_hint`.

```bash
/workspace/tokencut/scripts/smart-route \
  --prompt "Review this draft for bugs" \
  --paths src/a.ts --draft /tmp/draft.ts

# Pack when confidence is high enough:
/workspace/tokencut/scripts/smart-route \
  --prompt "Summarize these services" \
  --paths a.ts b.ts c.ts \
  --pack
```

Rules: `config/router-rules.json`. This is **not** Portal AiKA auto-routing — it is local keyword/corpus scoring. Ambiguous prompts return low confidence and should be confirmed before packing.

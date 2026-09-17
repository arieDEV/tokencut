# shunt-local

Fork of Spotify's [shunt](https://github.com/spotify/portal-ai-plugins/tree/main/plugins/shunt) for **this coding-agent computer**, with **no Portal and no AiKA**.

Upstream shunt saves ~82–94% tokens by sending large file reads and boilerplate to cheap AiKA worker modes through Portal CLI. This fork keeps the same *workflow shape* but replaces AiKA with a **low-cost executor** on this machine.

## How it works

1. You (or the agent) run `scripts/bulk-read` or `scripts/code-write`.
2. The script validates inputs and writes a job under `/workspace/.shunt-local/jobs/<id>/` including `PROMPT.md`.
3. stdout is a JSON manifest (`kind: shunt-local-job`) telling the agent to dispatch **one executor with `model=low`** using that prompt.
4. Large file bodies stay out of the main chat; only the worker's short answer comes back.

There are **no Claude Code hooks** here (those are host-specific). Enforcement is via Grok Bot skills that tell the agent when to call these scripts.

## Install / paths

```text
/workspace/shunt-local/          ← this fork
/workspace/.shunt-local/jobs/    ← job prompts + manifests
```

Skills on this bot: `Bulk file read`, `Boilerplate code write` (point at these scripts).

## Commands

```bash
/workspace/shunt-local/scripts/bulk-read \
  --question "What does this service do?" \
  --paths src/Service.ts src/Handler.ts

/workspace/shunt-local/scripts/code-write \
  --spec "Write tests for UserService" \
  --reference tests/OrderTest.ts \
  --target tests/UserTest.ts
```

## Env

| Variable | Default | Purpose |
| --- | --- | --- |
| `SHUNT_LOCAL_JOBS` | `/workspace/.shunt-local/jobs` | Job directory |
| `SHUNT_LOCAL_MAX_BYTES` | `2000000` | Max combined size for one bulk-read batch |
| `SHUNT_LOCAL_MIN_LINES` | `350` | Hint threshold (skills); scripts do not hard-block |

## What this is not

- Not a drop-in Claude Code plugin (no PreToolUse hooks).
- Not Portal/AiKA — savings depend on this host's low-effort executor pricing, not Spotify's benchmark numbers.
- Not for debugging, surgical edits, or architecture decisions (keep those on the main agent).

## Upstream

See `README.upstream.md` for the original shunt design and benchmarks.

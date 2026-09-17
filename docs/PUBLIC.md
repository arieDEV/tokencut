# Public one-pager: how agents should auto-route

tokencut is an **installed dependency** for coding agents (like a local npm/pip package of scripts + skills). When toggled **ON**, the agent should use it for suitable coding work **without** waiting for magic words from the user.

## Auto-route chain

```text
user coding ask
  → should-use-tokencut --prompt "..."
       use=false  → answer directly (meta / greenfield / tokencut OFF) + badge --none
       use=true   → detect-project → use-for-project (or resolve-prompt / cmd / role-run)
                 → Task worker(s) with model_hint
                 → drive-next until done
                 → reply + ✂️ badge (with job id)
```

## Scripts (order)

```bash
export TOKENCUT_ROOT=/path/to/tokencut          # e.g. /workspace/tokencut
export TOKENCUT_JOBS=/path/to/.tokencut/jobs

"$TOKENCUT_ROOT/scripts/should-use-tokencut" --prompt "<user ask>" [--paths ...]
# if use=true:
"$TOKENCUT_ROOT/scripts/detect-project" --json
"$TOKENCUT_ROOT/scripts/use-for-project" --prompt "<user ask>"
# then Task workers → drive-next → badge
```

## When `use=false` (answer directly)

- User is changing **tokencut itself**
- **Greenfield** / new project scaffold from scratch
- Product questions (how to install/toggle/status)
- `toggle` is **OFF**

## Badge meaning

- `✂️` + job id → work went through tokencut workers (safe to claim token-saving path)
- `🧠` / `badge --none` → answered directly; **do not** claim tokencut savings

## Skills

Copy or symlink `skills/` into your agent’s skill/plugin directory so the agent discovers the same SOP. Prefer `$TOKENCUT_ROOT/scripts/...` in skill bodies after install.

See also: [`when-to-use.md`](when-to-use.md), [`any-project.md`](any-project.md), [`auto-continue.md`](auto-continue.md).

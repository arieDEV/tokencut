# When tokencut is active (like an installed dependency)

**tokencut ON = installed.** The user does **not** need to say “pakai tokencut”.
Like `npm` / `pip`: if the coding task fits, the agent **should** use tokencut on its own.

Turn it off only with `toggle off` (global) or the exceptions below.

## Auto-on (✂️) — default

Every coding ask on an **existing user project** (not the tokencut repo itself):

- Read / summarize / explain a code area
- Generate boilerplate from a reference
- Review a draft/diff
- Debug with logs + code snippets
- Ambiguous prompt → low classifier, then the chosen role

Agent flow (no magic words):

```bash
"$TOKENCUT_ROOT/scripts/should-use-tokencut" --prompt "<user ask>"
# if use=true:
"$TOKENCUT_ROOT/scripts/detect-project"   # or use-for-project --prompt "..."
# then Task worker + drive-next (auto-continue) + badge ✂️
```

## Answer directly (🧠) — exceptions

1. **Editing tokencut itself** (`$TOKENCUT_ROOT`, “fix/change tokencut”)
2. **New project / greenfield** (scaffold from scratch)
3. **Product questions** (how to use, toggle status, README)
4. **tokencut toggled OFF**
5. Surgical debug that truly needs full context in the main reply

## Gate

```bash
"$TOKENCUT_ROOT/scripts/should-use-tokencut" --prompt "<user ask>" [--paths ...]
```

`use=false` → answer directly + `badge --none`  
`use=true` → auto pack (user need not mention tokencut)

See also: [`PUBLIC.md`](PUBLIC.md).

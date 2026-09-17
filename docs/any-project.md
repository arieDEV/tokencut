# Any project — always on when toggled ON

The user does not care about paths and **does not** need to say “pakai tokencut”.

When `toggle` = ON and the ask is coding work on an existing project:

1. `should-use-tokencut` (except meta/greenfield → answer directly)
2. `detect-project` — pick a repo under the workspace root (default `/workspace`, or `WORKSPACE_ROOT`), excluding tokencut
3. `use-for-project` — pack + auto-continue
4. ✂️ badge on the reply

Analogy: dependency already `npm install` / `pip install` — just use it.

```bash
export TOKENCUT_ROOT=/path/to/tokencut
"$TOKENCUT_ROOT/scripts/detect-project" --json
"$TOKENCUT_ROOT/scripts/use-for-project" --prompt "Explain the auth flow briefly"
```

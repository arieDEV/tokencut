---
name: tokencut-auto-continue
description: After any tokencut pack/pipeline/classifier step, keep running remaining steps until the work is finished unless the user stops you or approval is required.
---

# Auto-continue

Do **not** ask the user to type “lanjut” between tokencut steps.

1. Pack → Task worker at `model_hint` → save answer.
2. If `PIPELINE.md` / chain has more steps, pack the next role immediately and Task it.
3. After the last step, send the final answer + ✂️ badge chain.
4. Only pause for: user stop, destructive approval, or blocking ambiguity.

See `docs/auto-continue.md`.

## Gate (wajib)

Before routing to tokencut, run:

```bash
/workspace/tokencut/scripts/should-use-tokencut --prompt "<user ask>" [--paths ...]
```

If `use=false` (modifying tokencut, new project, product docs) → **do not** pack jobs; work on main chat with `badge --none`.

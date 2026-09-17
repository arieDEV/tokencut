---
name: tokencut-v2
description: Use tokencut v2 brain, learn, commands, synthesizer pipelines, and badge chains for coding token savings.
---

1. Check `scripts/toggle status` (must be ON to pack jobs).
2. Prefer `scripts/cmd` SOPs: `explain-area`, `review-change`, `design-choice`.
3. Or `smart-route --prompt ...` then `role-run` / `pipeline --pack`.
4. Heavy pipelines end with `synthesizer` (high).
5. Always end user-visible replies with `scripts/badge` (single or `--chain`).
6. Capture user corrections via `scripts/learn add`.

## Gate (wajib)

Before routing to tokencut, run:

```bash
/workspace/tokencut/scripts/should-use-tokencut --prompt "<user ask>" [--paths ...]
```

If `use=false` (modifying tokencut, new project, product docs) → **do not** pack jobs; work on main chat with `badge --none`.

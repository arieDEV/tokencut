---
name: tokencut-smart-route
description: Detect tokencut role and model_hint from a user prompt, optionally pack the job.
---

```bash
/workspace/tokencut/scripts/smart-route --prompt "<user text>" [--paths ...] [--draft d] [--brief b] [--log l] [--reference r] [--pack]
```

1. Read `suggested_role`, `model_hint`, `confidence`, `ambiguous`.
2. If `ambiguous` or `missing_inputs`, ask the user or supply the missing path.
3. Otherwise `--pack` (or call `role-run` yourself) and Task an executor with `model=model_hint` using `prompt_file`.

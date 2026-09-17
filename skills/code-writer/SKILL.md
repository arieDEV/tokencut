---
name: code-writer
description: Delegate boilerplate generation via tokencut (no Portal). Use when >80% is predictable from a reference file.
---

```bash
/workspace/tokencut/scripts/code-write --spec "<spec>" --reference <ref> [--target <out>]
```

1. Run the script.
2. Task one executor with `model: "low"` and `prompt_file` contents.
3. Review output; surgical-edit the 5–20% that needs judgment.

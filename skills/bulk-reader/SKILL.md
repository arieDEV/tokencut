---
name: bulk-reader
description: Delegate bulk file reading via tokencut (no Portal). Use for files >350 lines, 3+ files, or large diffs.
---

```bash
/workspace/tokencut/scripts/bulk-read --question "<question>" --paths <file1> [<file2> ...]
```

1. Run the script.
2. Read `prompt_file` from the JSON on stdout.
3. Task one executor with `model: "low"` and that prompt as the full task.
4. Do not Read the listed source files in the main chat.
5. Verify critical line numbers before editing.

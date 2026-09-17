---
name: tokencut-multi-role
description: Route tokencut work across reader/writer/reviewer/architect/debugger roles with matching model effort.
---

# tokencut multi-role

## List roles

```bash
$TOKENCUT_ROOT/scripts/role-run --list
```

## Pack one role

```bash
$TOKENCUT_ROOT/scripts/role-run --role reader --question "..." --paths f1 f2
$TOKENCUT_ROOT/scripts/role-run --role writer --spec "..." --reference ref [--target out]
$TOKENCUT_ROOT/scripts/role-run --role reviewer --question "..." --paths f1 [--draft d]
$TOKENCUT_ROOT/scripts/role-run --role architect --question "..." [--brief b] [--paths small…]
$TOKENCUT_ROOT/scripts/role-run --role debugger --question "..." --paths f1 [--log log]
```

## After packing

1. Read `model_hint` / `effort` from the JSON manifest.
2. Task **one** executor with that `model` and the full `prompt_file` contents.
3. Do not dump large sources into the main chat for reader/writer.

## Pipelines

```bash
$TOKENCUT_ROOT/scripts/pipeline --list
$TOKENCUT_ROOT/scripts/pipeline --pack draft-then-review --spec "..." --reference r --target t
$TOKENCUT_ROOT/scripts/pipeline --pack read-then-architect --question "..." --paths f1 f2
```

Follow `PIPELINE.md` inside the job dir for step 2.

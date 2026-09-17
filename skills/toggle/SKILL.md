---
name: tokencut-toggle
description: Turn tokencut on or off for this computer.
---

```bash
$TOKENCUT_ROOT/scripts/toggle status
$TOKENCUT_ROOT/scripts/toggle on
$TOKENCUT_ROOT/scripts/toggle off
$TOKENCUT_ROOT/scripts/toggle badge on|off
$TOKENCUT_ROOT/scripts/toggle smart-route on|off
```

When `enabled=false`, do not call role-run / bulk-read / code-write / smart-route; answer on main chat and use `badge --none`.

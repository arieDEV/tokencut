---
name: tokencut-toggle
description: Turn tokencut on or off for this computer.
---

```bash
/workspace/tokencut/scripts/toggle status
/workspace/tokencut/scripts/toggle on
/workspace/tokencut/scripts/toggle off
/workspace/tokencut/scripts/toggle badge on|off
/workspace/tokencut/scripts/toggle smart-route on|off
```

When `enabled=false`, do not call role-run / bulk-read / code-write / smart-route; answer on main chat and use `badge --none`.

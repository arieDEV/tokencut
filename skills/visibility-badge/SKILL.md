---
name: tokencut-visibility-badge
description: Always label chat replies that used tokencut with a role/model badge so humans can see low vs medium vs high.
---

After any tokencut job (role-run, smart-route --pack, bulk-read, code-write), end the user-visible reply with:

```bash
$TOKENCUT_ROOT/scripts/badge --from-job <manifest.json>
```

Emoji legend: 💚 low · 💛 medium · ❤️ high · 🧠 main without tokencut.

If you answered without tokencut, either omit savings claims or append `badge --none`.

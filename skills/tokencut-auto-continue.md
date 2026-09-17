# tokencut auto-continue (agent rule)

When tokencut work is in flight, finish the whole chain yourself.
Never ask the user to say “lanjut” / “next” between reader→synthesizer, writer→reviewer→synthesizer, or classifier→chosen role.
Pause only for stop, approval of destructive actions, or blocking ambiguity.

## Gate (wajib)

Before routing to tokencut, run:

```bash
/workspace/tokencut/scripts/should-use-tokencut --prompt "<user ask>" [--paths ...]
```

If `use=false` (modifying tokencut, new project, product docs) → **do not** pack jobs; work on main chat with `badge --none`.

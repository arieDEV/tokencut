# tokencut auto-continue (agent rule)

When tokencut work is in flight, finish the whole chain yourself.
Never ask the user to say “lanjut” / “next” between reader→synthesizer, writer→reviewer→synthesizer, or classifier→chosen role.
Pause only for stop, approval of destructive actions, or blocking ambiguity.

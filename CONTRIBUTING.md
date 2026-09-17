# Contributing

Thanks for helping with tokencut.

## Basics

- Keep the mental model: **installable dependency for coding agents**, not a chat-mode product.
- No Portal / AiKA integrations. Local scripts + skills only.
- Prefer small, focused PRs with a short “why”.

## Before you open a PR

1. Copy `config/brain.md.template` → `config/brain.md` if you need local profile inject (do not commit secrets).
2. Run a quick smoke:

```bash
export TOKENCUT_ROOT="$PWD"
export TOKENCUT_JOBS="${TOKENCUT_JOBS:-$PWD/.tokencut/jobs}"
mkdir -p "$TOKENCUT_JOBS"
./scripts/toggle status
./scripts/should-use-tokencut --prompt "explain auth in this repo"
./scripts/detect-project --json
```

3. If you touch routing: `./tests/smart-route-golden.sh`

## Docs

- Public install/usage: `README.md`
- Agent auto-route one-pager: `docs/PUBLIC.md`
- Deeper design notes live under `docs/`

## License

By contributing you agree your changes are dual-licensed under the MIT License in `LICENSE`.

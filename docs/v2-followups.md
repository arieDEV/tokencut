# tokencut v2 follow-ups (post-MVP)

Done in this pass:
- `scripts/last` — job terakhir + badge
- `toggle inject-brain|inject-lessons on|off`
- `tests/smart-route-golden.sh` — regresi heuristik

Still optional later:
- Low-model classifier for ambiguous prompts only
- External connectors (out of tokencut scope)

## Added next

- `scripts/classify-ambiguous` — pack low classifier job (JSON role/model)
- `smart-route --classify` — when ambiguous, attach `classifier_job`
- `scripts/e2e` — pack explain-area chain + print agent next steps + badge preview

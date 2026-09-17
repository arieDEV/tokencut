# tokencut

Fork of Spotify's [shunt](https://github.com/spotify/portal-ai-plugins/tree/main/plugins/shunt) for **this coding-agent computer**, with **no Portal and no AiKA**.

Upstream shunt saves ~82–94% tokens by sending large file reads and boilerplate to cheap AiKA worker modes through Portal CLI. This fork keeps the same *workflow shape* but replaces AiKA with a **low-cost executor** on this machine.

## How it works

1. You (or the agent) run `scripts/bulk-read` or `scripts/code-write`.
2. The script validates inputs and writes a job under `/workspace/.tokencut/jobs/<id>/` including `PROMPT.md`.
3. stdout is a JSON manifest (`kind: tokencut-job`) telling the agent to dispatch **one executor with `model=low`** using that prompt.
4. Large file bodies stay out of the main chat; only the worker's short answer comes back.

There are **no Claude Code hooks** here (those are host-specific). Enforcement is via Grok Bot skills that tell the agent when to call these scripts.

## Install / paths

```text
/workspace/tokencut/          ← this fork
/workspace/.tokencut/jobs/    ← job prompts + manifests
```

Skills on this bot: `Bulk file read`, `Boilerplate code write` (point at these scripts).

## Commands

```bash
/workspace/tokencut/scripts/bulk-read \
  --question "What does this service do?" \
  --paths src/Service.ts src/Handler.ts

/workspace/tokencut/scripts/code-write \
  --spec "Write tests for UserService" \
  --reference tests/OrderTest.ts \
  --target tests/UserTest.ts
```

## Env

| Variable | Default | Purpose |
| --- | --- | --- |
| `TOKENCUT_JOBS` | `/workspace/.tokencut/jobs` | Job directory |
| `TOKENCUT_MAX_BYTES` | `2000000` | Max combined size for one bulk-read batch |
| `TOKENCUT_MIN_LINES` | `350` | Hint threshold (skills); scripts do not hard-block |

## What this is not

- Not a drop-in Claude Code plugin (no PreToolUse hooks).
- Not Portal/AiKA — savings depend on this host's low-effort executor pricing, not Spotify's benchmark numbers.
- Not for debugging, surgical edits, or architecture decisions (keep those on the main agent).

## Upstream

See `README.upstream.md` for the original shunt design and benchmarks.

## Multi-role

Roles live in `config/roles.json`. Pack with `scripts/role-run`; optional pipelines via `scripts/pipeline`.

| Role | Effort / model | Job |
| --- | --- | --- |
| `reader` | low | Bulk-read / summarize files |
| `writer` | low | Boilerplate from a reference |
| `reviewer` | medium | Critique a draft or diff |
| `architect` | high | Tradeoffs on a short brief (not huge corpora) |
| `debugger` | medium | Hypotheses from logs + source |

```bash
/workspace/tokencut/scripts/role-run --list

/workspace/tokencut/scripts/role-run --role reviewer \
  --question "Any bugs?" --paths src/foo.ts --draft /tmp/draft.ts

/workspace/tokencut/scripts/pipeline --pack draft-then-review \
  --spec "Add tests" --reference tests/a_test.ts --target tests/b_test.ts
```

The JSON manifest includes `role`, `effort`, and `model_hint` so the agent dispatches the matching executor tier.

## Smart-route

Heuristic detector (no LLM) that scores a natural-language prompt and optional paths, then suggests `role` + `model_hint`.

```bash
/workspace/tokencut/scripts/smart-route \
  --prompt "Review this draft for bugs" \
  --paths src/a.ts --draft /tmp/draft.ts

# Pack when confidence is high enough:
/workspace/tokencut/scripts/smart-route \
  --prompt "Summarize these services" \
  --paths a.ts b.ts c.ts \
  --pack
```

Rules: `config/router-rules.json`. This is **not** Portal AiKA auto-routing — it is local keyword/corpus scoring. Ambiguous prompts return low confidence and should be confirmed before packing.

## Visibility badge

Every user-facing answer that used tokencut **must** end with a badge line so humans can see the tier:

| Badge | Meaning |
| --- | --- |
| ✂️ … 💚 `model=low` | Cheap worker (reader/writer) |
| ✂️ … 💛 `model=medium` | Mid worker (reviewer/debugger) |
| ✂️ … ❤️ `model=high` | Strong worker (architect) |
| 🧠 `main · tanpa tokencut` | Answered only on the main chat (no savings claim) |

```bash
/workspace/tokencut/scripts/badge --from-job /workspace/.tokencut/jobs/<id>/manifest.json
/workspace/tokencut/scripts/badge --none
```

Put the badge as the **last line** of the chat reply. Never claim token savings without a ✂️ badge and job id.

## On / off

```bash
/workspace/tokencut/scripts/toggle status   # lihat status
/workspace/tokencut/scripts/toggle on       # hidupkan tokencut
/workspace/tokencut/scripts/toggle off      # matikan (agent jawab di main chat)
/workspace/tokencut/scripts/toggle badge on|off
/workspace/tokencut/scripts/toggle smart-route on|off
```

State file: `config/settings.json` (`enabled`, `badge`, `smart_route`).
When `enabled=false`, `role-run` / `bulk-read` / `code-write` / `smart-route` refuse to pack jobs.

## tokencut v2

Upgrade pola Second Brain (tanpa Slack/Docs/ops):

| Fitur | Perintah / path |
| --- | --- |
| Brain (profil) | `config/brain.md` (+ template) — di-inject ke prompt worker |
| Learn | `scripts/learn add\|list\|clear` → `memory/lessons.md` |
| Commands/SOP | `scripts/cmd --list` · `explain-area` · `review-change` · `design-choice` |
| Synthesizer | role `synthesizer` (high); wajib di akhir pipeline berat |
| Badge chain | `scripts/badge --chain reader:low,synthesizer:high --job-id …` |
| Smart-route v2 | `scripts/smart-route` (+ sinyal ringan dari brain/lessons) |
| On/off | `scripts/toggle on\|off` |

Rencana lengkap: [`docs/v2-plan.md`](docs/v2-plan.md).

### Post-MVP utilities

```bash
/workspace/tokencut/scripts/last 3
/workspace/tokencut/scripts/toggle inject-brain on|off
/workspace/tokencut/scripts/toggle inject-lessons on|off
/workspace/tokencut/tests/smart-route-golden.sh
```

### Ambiguous prompts & e2e

```bash
/workspace/tokencut/scripts/smart-route --prompt "tolong bantu" --classify
/workspace/tokencut/scripts/classify-ambiguous --prompt "..." [--paths ...]
/workspace/tokencut/scripts/e2e --question "..." --paths file.ts
```

## Auto-continue

Setelah job/pipeline tokencut dimulai, agent **melanjutkan semua step sampai selesai** tanpa menunggu user mengetik “lanjut”. Berhenti hanya jika user minta stop, butuh approval destruktif, atau ambigu yang memblokir. Lihat `docs/auto-continue.md`.

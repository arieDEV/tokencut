# tokencut bench results

Neutral measurement of main-chat token load for a fixed eval question over a documented corpus. Tokens are **approximate** (`ceil(bytes/4)`), not a billing meter.

## Eval

- **Question:** In 8–12 bullets: what tokencut is, how install/toggle works, when it runs vs direct answer, and cite path:line for each claim.
- **Corpus:** 11 files under the tokencut tree (README, docs, install/gate scripts, `scripts/lib/*.sh`, `config/roles.json`)
- **Job:** `20260918-063153-66408-bulk-reader` (bulk-reader, model/effort `low`)
- **Generated:** 2026-09-18T06:32:23+07:00 (Asia/Jakarta)

## Main-chat tokens

| | Bytes | Approx tokens |
| --- | ---: | ---: |
| **Before** (dump all corpus into main) | 29,949 | **7,488** |
| **After** (pack prompt + worker answer) | 3,094 | **774** |
| **Saved on main** | 26,855 | **6,714 (89.7%)** |

After breakdown: packed prompt 1,478 B (~370 tok) + answer 1,616 B (~404 tok).

## Worker (cheap tier, separate)

| | Approx tokens |
| --- | ---: |
| Corpus bodies read by worker | 7,488 |
| Worker input ≈ corpus + pack prompt | 7,857 |

Savings claimed above are **main-chat context** only. The worker still spends cheap-tier tokens on the corpus.

## Quality (rubric /10)

| Criterion | Score |
| --- | --- |
| Purpose | 2/2 |
| Install / toggle | 2/2 |
| When-to-use gate | 2/2 |
| Citations present | 2/2 |
| Citation spot-check (3 lines) | 2/2 |
| **Total** | **10/10** |

Citation spot-check hit rate: **100%** (3/3).

### Spot-check evidence

- **README.md:3** [HIT] — local token-saving workers, no Portal/AiKA
  - Quote: `Local **token-saving workers** for coding agents. Inspired by Spotify’s *shunt*, with **no Portal / AiKA**.`
- **scripts/install:13** [HIT] — installer calls toggle on
  - Quote: `"$ROOT/scripts/toggle" on >/dev/null`
- **scripts/should-use-tokencut:26-30** [HIT] — use=false when toggled OFF
  - Quote: `  jq -n '{use:false,reason:"tokencut toggled OFF"}'`

## Artifacts

- `bench/PROMPT.md` — fixed eval question
- `bench/artifacts/after-answer.md` — worker answer
- `bench/artifacts/comparison.json` — before/after numbers
- `bench/artifacts/quality.json` — rubric + evidence
- `bench/before-after.html` — visual summary

## Caveats

- Token counts are approximate (ceil(bytes/4)), not a provider billing meter.
- Worker still processes the full corpus on the cheap/low tier; reported savings are on expensive main-chat context.
- This is not Spotify's published AiKA savings figure — that needs Portal + AiKA pricing.
- Quality depends on the worker answer; spot-check cited line numbers before editing.

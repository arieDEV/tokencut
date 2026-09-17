# tokencut auto-continue policy

Once the user starts (or accepts) a tokencut job/pipeline, the agent MUST drive every remaining step to completion without asking “lanjut?” / “next?”.

## Continue automatically when
- A pipeline packs step 1 and `PIPELINE.md` / `next[]` lists further steps
- Classifier returns a role → pack + run that role
- Reader finishes → synthesizer (if pipeline requires it)
- Writer finishes → reviewer → synthesizer (if pipeline requires it)

## Stop and ask only when
- User says stop / cancel / pause / tunggu
- A step needs explicit approval (destructive write outside the job target, send message, delete, spend money)
- Irreducible ambiguity that changes the outcome (wrong file set, missing secret, conflicting goals)
- tokencut is toggled OFF

## Visibility
Still append the final ✂️ badge (or chain badge). Mid-pipeline, brief status updates are OK; do not wait for a reply to proceed.

## Exception: meta & greenfield

Auto-continue **does not apply** when `should-use-tokencut` returns `use=false`
(modifying tokencut itself, new project scaffold, product/docs questions).
Those stay on the main agent (🧠).

#!/usr/bin/env bash
# Shared plumbing for tokencut: pack a job for a low-cost executor.
# No Portal, no AiKA — the coding agent runs an executor with model=low
# using the prompt file this library writes.

set -euo pipefail

TOKENCUT_ROOT="${TOKENCUT_ROOT:-/workspace/tokencut}"
TOKENCUT_JOBS="${TOKENCUT_JOBS:-/workspace/.tokencut/jobs}"
TOKENCUT_MAX_BYTES="${TOKENCUT_MAX_BYTES:-2000000}"
TOKENCUT_MIN_LINES="${TOKENCUT_MIN_LINES:-350}"

tokencut_preflight() {
  command -v jq >/dev/null 2>&1 || {
    echo "Error: jq is required (apt install jq / brew install jq)" >&2
    return 1
  }
  mkdir -p "$TOKENCUT_JOBS"
}

# Create a unique job directory. Sets JOB_DIR, JOB_ID, PROMPT_FILE, MANIFEST_FILE.
tokencut_new_job() {
  local mode="$1"
  JOB_ID="$(date +%Y%m%d-%H%M%S)-$$-${mode}"
  JOB_DIR="${TOKENCUT_JOBS}/${JOB_ID}"
  mkdir -p "$JOB_DIR"
  PROMPT_FILE="${JOB_DIR}/PROMPT.md"
  MANIFEST_FILE="${JOB_DIR}/manifest.json"
}

tokencut_check_readable() {
  local path
  for path in "$@"; do
    if [[ ! -f "$path" || ! -r "$path" ]]; then
      echo "Error: file not found or unreadable: $path" >&2
      return 1
    fi
  done
}

# Emit machine-readable job JSON to stdout (for the agent).
# Human notes go to stderr.
tokencut_emit_job() {
  local mode="$1"
  local summary="$2"

  jq -n \
    --arg kind "tokencut-job" \
    --arg mode "$mode" \
    --arg effort "low" \
    --arg job_id "$JOB_ID" \
    --arg job_dir "$JOB_DIR" \
    --arg prompt_file "$PROMPT_FILE" \
    --arg summary "$summary" \
    '{
      kind: $kind,
      mode: $mode,
      effort: $effort,
      model_hint: "low",
      job_id: $job_id,
      job_dir: $job_dir,
      prompt_file: $prompt_file,
      agent_instruction: "Dispatch one executor with model=low. Pass the full contents of prompt_file as the task. Do not load the listed source files into the main chat. Return only the worker answer to the user.",
      summary: $summary
    }' | tee "$MANIFEST_FILE"

  echo "[tokencut: job $JOB_ID | mode=$mode | effort=low]" >&2
  echo "[tokencut: prompt → $PROMPT_FILE]" >&2
  echo "[tokencut: next → Task executor model=low with that prompt]" >&2
}

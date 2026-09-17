#!/usr/bin/env bash
# Shared plumbing for tokencut: pack a job for a role-scoped executor.
# No Portal, no AiKA — the coding agent dispatches an executor using model_hint.

set -euo pipefail

TOKENCUT_ROOT="${TOKENCUT_ROOT:-/workspace/tokencut}"
TOKENCUT_JOBS="${TOKENCUT_JOBS:-/workspace/.tokencut/jobs}"
TOKENCUT_MAX_BYTES="${TOKENCUT_MAX_BYTES:-2000000}"
TOKENCUT_MIN_LINES="${TOKENCUT_MIN_LINES:-350}"
TOKENCUT_ROLES_FILE="${TOKENCUT_ROLES_FILE:-$TOKENCUT_ROOT/config/roles.json}"

tokencut_preflight() {
  command -v jq >/dev/null 2>&1 || {
    echo "Error: jq is required (apt install jq / brew install jq)" >&2
    return 1
  }
  mkdir -p "$TOKENCUT_JOBS"
  tokencut_require_enabled || return 1
}

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

# Load role fields into ROLE_TITLE ROLE_EFFORT ROLE_MODEL ROLE_SYSTEM
tokencut_load_role() {
  local role="$1"
  if [[ ! -f "$TOKENCUT_ROLES_FILE" ]]; then
    echo "Error: roles file missing: $TOKENCUT_ROLES_FILE" >&2
    return 1
  fi
  if ! jq -e --arg r "$role" '.roles[$r]' "$TOKENCUT_ROLES_FILE" >/dev/null; then
    echo "Error: unknown role '$role'. Known:" >&2
    jq -r '.roles | keys[]' "$TOKENCUT_ROLES_FILE" | sed 's/^/  - /' >&2
    return 1
  fi
  ROLE_TITLE=$(jq -r --arg r "$role" '.roles[$r].title' "$TOKENCUT_ROLES_FILE")
  ROLE_EFFORT=$(jq -r --arg r "$role" '.roles[$r].effort' "$TOKENCUT_ROLES_FILE")
  ROLE_MODEL=$(jq -r --arg r "$role" '.roles[$r].model_hint' "$TOKENCUT_ROLES_FILE")
  ROLE_SYSTEM=$(jq -r --arg r "$role" '.roles[$r].system' "$TOKENCUT_ROLES_FILE")
  ROLE_PURPOSE=$(jq -r --arg r "$role" '.roles[$r].purpose' "$TOKENCUT_ROLES_FILE")
}

# tokencut_emit_job <mode> <summary> [effort] [model_hint] [role]
tokencut_emit_job() {
  local mode="$1"
  local summary="$2"
  local effort="${3:-low}"
  local model_hint="${4:-low}"
  local role="${5:-}"

  local instruction
  instruction="Dispatch one executor with model=${model_hint} (effort=${effort}). Pass the full contents of prompt_file as the task. Do not load bulky source files into the main chat unless this role explicitly requires tiny key files. Return only the worker answer to the user."

  jq -n \
    --arg kind "tokencut-job" \
    --arg mode "$mode" \
    --arg effort "$effort" \
    --arg model_hint "$model_hint" \
    --arg role "$role" \
    --arg job_id "$JOB_ID" \
    --arg job_dir "$JOB_DIR" \
    --arg prompt_file "$PROMPT_FILE" \
    --arg summary "$summary" \
    --arg agent_instruction "$instruction" \
    '{
      kind: $kind,
      mode: $mode,
      role: (if $role == "" then null else $role end),
      effort: $effort,
      model_hint: $model_hint,
      job_id: $job_id,
      job_dir: $job_dir,
      prompt_file: $prompt_file,
      agent_instruction: $agent_instruction,
      summary: $summary
    }' | tee "$MANIFEST_FILE"

  echo "[tokencut: job $JOB_ID | role=${role:-$mode} | effort=$effort | model=$model_hint]" >&2
  echo "[tokencut: prompt → $PROMPT_FILE]" >&2
  echo "[tokencut: next → Task executor model=$model_hint with that prompt]" >&2
}

tokencut_list_roles() {
  jq -r '
    .roles | to_entries[] |
    "\(.key)\t\(.value.effort)/\(.value.model_hint)\t\(.value.title)\t\(.value.purpose)"
  ' "$TOKENCUT_ROLES_FILE"
}

TOKENCUT_SETTINGS_FILE="${TOKENCUT_SETTINGS_FILE:-$TOKENCUT_ROOT/config/settings.json}"

tokencut_settings_get() {
  local key="$1"
  if [[ ! -f "$TOKENCUT_SETTINGS_FILE" ]]; then
    echo "true"
    return 0
  fi
  # Do NOT use // — in jq, false is falsy so (false // true) => true
  jq -r --arg k "$key" 'if has($k) then .[$k] else true end' "$TOKENCUT_SETTINGS_FILE"
}

tokencut_require_enabled() {
  local enabled
  enabled=$(tokencut_settings_get enabled)
  if [[ "$enabled" != "true" ]]; then
    echo "Error: tokencut is OFF. Turn on with: $TOKENCUT_ROOT/scripts/toggle on" >&2
    return 1
  fi
}

# shellcheck source=context.sh
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/context.sh"

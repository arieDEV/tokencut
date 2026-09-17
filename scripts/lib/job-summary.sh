#!/usr/bin/env bash
# Print a concise summary from a tokencut job manifest.

set -euo pipefail

tokencut_job_summary() {
  local manifest_path="$1"

  if [[ ! -f "$manifest_path" || ! -r "$manifest_path" ]]; then
    echo "Error: file not found or unreadable: $manifest_path" >&2
    return 1
  fi

  jq -r '"job_id=\(.job_id)\nmode=\(.mode)\nprompt_file=\(.prompt_file)"' "$manifest_path"
}

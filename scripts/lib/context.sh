#!/usr/bin/env bash
# Brain + lessons injection helpers for tokencut v2.

TOKENCUT_BRAIN_FILE="${TOKENCUT_BRAIN_FILE:-$TOKENCUT_ROOT/config/brain.md}"
TOKENCUT_BRAIN_LOCAL="${TOKENCUT_BRAIN_LOCAL:-$TOKENCUT_ROOT/config/brain.local.md}"
TOKENCUT_LESSONS_FILE="${TOKENCUT_LESSONS_FILE:-$TOKENCUT_ROOT/memory/lessons.md}"
TOKENCUT_BRAIN_MAX_CHARS="${TOKENCUT_BRAIN_MAX_CHARS:-2500}"
TOKENCUT_LESSONS_MAX_CHARS="${TOKENCUT_LESSONS_MAX_CHARS:-2000}"
TOKENCUT_LESSONS_MAX_ITEMS="${TOKENCUT_LESSONS_MAX_ITEMS:-8}"

tokencut_truncate() {
  local file="$1" max="$2"
  [[ -f "$file" ]] || return 0
  # Prefer head -c for byte cap; keep readable text
  head -c "$max" "$file"
  local size
  size=$(wc -c < "$file" | tr -d ' ')
  if [[ "$size" -gt "$max" ]]; then
    printf '\n\n…[truncated %s chars of %s]\n' "$((size - max))" "$(basename "$file")"
  fi
}

# Print markdown section for brain (stdout). Empty if no brain file.
tokencut_brain_section() {
  local inject
  inject=$(tokencut_settings_get inject_brain 2>/dev/null || echo true)
  [[ "$inject" == "true" ]] || return 0
  local src=""
  if [[ -f "$TOKENCUT_BRAIN_LOCAL" ]]; then src="$TOKENCUT_BRAIN_LOCAL"
  elif [[ -f "$TOKENCUT_BRAIN_FILE" ]]; then src="$TOKENCUT_BRAIN_FILE"
  else return 0
  fi
  echo "## Brain (user)"
  echo
  tokencut_truncate "$src" "$TOKENCUT_BRAIN_MAX_CHARS"
  echo
}

# Print lessons section filtered loosely by role tag (stdout).
tokencut_lessons_section() {
  local role="${1:-}"
  local inject
  inject=$(tokencut_settings_get inject_lessons 2>/dev/null || echo true)
  [[ "$inject" == "true" ]] || return 0
  [[ -f "$TOKENCUT_LESSONS_FILE" ]] || return 0
  local tmp
  tmp=$(mktemp)
  # Keep entries that are untagged or match role / general
  if [[ -n "$role" ]]; then
    awk -v role="$role" '
      BEGIN{RS=""; FS="\n"}
      {
        tag=""
        for (i=1;i<=NF;i++) if ($i ~ /^tags:/) tag=$i
        if (tag ~ role || tag ~ /general/ || tag == "" || tag ~ /tags: *$/ )
          print $0 "\n"
      }
    ' "$TOKENCUT_LESSONS_FILE" | tail -n 80 > "$tmp" || true
  else
    tail -n 80 "$TOKENCUT_LESSONS_FILE" > "$tmp" || true
  fi
  if [[ ! -s "$tmp" ]]; then rm -f "$tmp"; return 0; fi
  echo "## Lessons (from prior corrections)"
  echo
  tokencut_truncate "$tmp" "$TOKENCUT_LESSONS_MAX_CHARS"
  echo
  rm -f "$tmp"
}

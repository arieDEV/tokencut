#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SR="$ROOT/scripts/smart-route"
pass=0; fail=0
TMP=$(mktemp -d)
echo 'export const n=1' > "$TMP/a.ts"
echo 'draft' > "$TMP/draft.ts"
echo 'Error: boom at x.ts:1' > "$TMP/app.log"
echo 'brief notes' > "$TMP/brief.md"

check() {
  local name="$1" expect="$2"; shift 2
  local got
  got=$("$SR" "$@" 2>/dev/null | jq -r .suggested_role)
  if [[ "$got" == "$expect" ]]; then
    echo "PASS $name → $got"; pass=$((pass+1))
  else
    echo "FAIL $name → got=$got want=$expect"; fail=$((fail+1))
  fi
}

check review reviewer --prompt "Please review this draft for security risks" --paths "$TMP/a.ts" --draft "$TMP/draft.ts"
check debug debugger --prompt "Why does this stack trace fail?" --paths "$TMP/a.ts" --log "$TMP/app.log"
check arch architect --prompt "Bagaimana tradeoff arsitektur untuk migrasi API?" --brief "$TMP/brief.md"
check write writer --prompt "Generate test boilerplate from this reference" --reference "$TMP/a.ts" --paths "$TMP/a.ts"
check read reader --prompt "Ringkas apa isi file-file ini" --paths "$TMP/a.ts" "$TMP/a.ts" "$TMP/a.ts"

echo "RESULT pass=$pass fail=$fail"
exit "$fail"

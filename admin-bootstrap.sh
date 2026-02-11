#!/usr/bin/env bash
set -euo pipefail

BASE="${BASE:-https://aop.fastcallvoip.com}"
PASS="${1:-}"

if [ -z "$PASS" ] || [ ${#PASS} -lt 12 ]; then
  echo "Usage: $0 <newPassword(min12)>"
  exit 1
fi

curl -sS -X POST "$BASE/api/admin/bootstrap" \
  -H 'Content-Type: application/json' \
  -d "{\"newPassword\":\"$PASS\"}" | cat

echo
echo "[done] admin bootstrap attempted"

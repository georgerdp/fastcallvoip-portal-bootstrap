#!/usr/bin/env bash
set -euo pipefail

BASE="${BASE:-https://aop.fastcallvoip.com}"
CJ="${CJ:-/tmp/fcv_cookiejar.txt}"

FROM="${1:-}"
TO="${2:-}"

if [ -z "$FROM" ] || [ -z "$TO" ]; then
  echo "Usage: $0 <fromExt> <toExt>"
  echo "Example: $0 201 220"
  exit 1
fi

curl -sS -b "$CJ" -X POST "$BASE/api/admin/extensions/sync" \
  -H 'Content-Type: application/json' \
  -d "{\"from\":$FROM,\"to\":$TO}" | cat
echo

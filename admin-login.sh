#!/usr/bin/env bash
set -euo pipefail

BASE="${BASE:-https://aop.fastcallvoip.com}"
CJ="${CJ:-/tmp/fcv_cookiejar.txt}"

USER="${1:-admin}"
PASS="${2:-}"

if [ -z "$PASS" ]; then
  echo "Usage: $0 <username> <password>"
  exit 1
fi

curl -sS -c "$CJ" -X POST "$BASE/api/auth/login" \
  -H 'Content-Type: application/json' \
  -d "{\"username\":\"$USER\",\"password\":\"$PASS\"}" >/dev/null

echo "[ok] cookie saved: $CJ"

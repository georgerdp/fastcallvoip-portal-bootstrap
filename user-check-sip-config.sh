#!/usr/bin/env bash
set -euo pipefail

BASE="${BASE:-https://aop.fastcallvoip.com}"
CJ="${CJ:-/tmp/fcv_user_cookiejar.txt}"

USER="${1:-}"
PASS="${2:-}"

if [ -z "$USER" ] || [ -z "$PASS" ]; then
  echo "Usage: $0 <username(ext)> <portalPassword>"
  exit 1
fi

curl -sS -c "$CJ" -X POST "$BASE/api/auth/login" \
  -H 'Content-Type: application/json' \
  -d "{\"username\":\"$USER\",\"password\":\"$PASS\"}" >/dev/null

curl -sS -b "$CJ" "$BASE/api/sip/config" | cat
echo

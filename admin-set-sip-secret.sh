#!/usr/bin/env bash
set -euo pipefail

BASE="${BASE:-https://aop.fastcallvoip.com}"
CJ="${CJ:-/tmp/fcv_cookiejar.txt}"

USER="${1:-}"
SECRET="${2:-}"

if [ -z "$USER" ] || [ -z "$SECRET" ]; then
  echo "Usage: $0 <username(ext)> <sipSecret>"
  echo "Example: $0 201 'SIP_SECRET_201'"
  exit 1
fi

curl -sS -b "$CJ" -X POST "$BASE/api/admin/users/$USER/sip-secret" \
  -H 'Content-Type: application/json' \
  -d "{\"sipSecret\":\"$SECRET\"}" | cat
echo

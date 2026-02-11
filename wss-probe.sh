#!/usr/bin/env bash
set -euo pipefail

HOST="${1:-wss.fastcallvoip.com}"
PORT="${2:-443}"
PATH_="${3:-/ws}"

echo "[probe] host=$HOST port=$PORT path=$PATH_"
echo

echo "=== TLS certificate (SNI) ==="
echo | openssl s_client -connect "${HOST}:${PORT}" -servername "${HOST}" -showcerts 2>/dev/null \
  | egrep -i "subject=|issuer=|Verify return code|CN=|DNS:" || true
echo

echo "=== WebSocket Upgrade (HTTP/1.1) ==="
curl -skI --http1.1 \
  -H "Host: ${HOST}" \
  -H "Connection: Upgrade" \
  -H "Upgrade: websocket" \
  -H "Sec-WebSocket-Version: 13" \
  -H "Sec-WebSocket-Key: SGVsbG9XU1M=" \
  "https://${HOST}${PATH_}" || true

echo
echo "[hint] If you DON'T see '101 Switching Protocols', path/route is wrong or blocked."

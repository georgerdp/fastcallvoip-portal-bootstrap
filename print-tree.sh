#!/usr/bin/env bash
set -euo pipefail
ROOT="/volume1/docker/fastcallvoip-portal"
OUT="$ROOT/docs/structure.txt"

( cd "$ROOT" && find . -maxdepth 4 -print ) | sed 's#^\./##' > "$OUT"
echo "[tree] written: $OUT"

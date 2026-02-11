#!/usr/bin/env bash
set -euo pipefail

# FastCallVoIP Portal deploy helper for Synology DSM (Docker)
# Copies this bundle into /volume1/docker/fastcallvoip-portal and sets sane ownership/perms,
# then (optionally) runs bootstrap and brings up docker compose.
#
# Usage on Synology:
#   1) Upload and unzip bundle somewhere (e.g. /tmp/fastcallvoip-portal)
#   2) cd into the extracted folder that contains 'bash-scripts/'
#   3) sudo -i
#   4) ./deploy-to-synology.sh --copy-only
#   5) cp -n /volume1/docker/fastcallvoip-portal/.env.example /volume1/docker/fastcallvoip-portal/.env
#      nano /volume1/docker/fastcallvoip-portal/.env
#   6) ./deploy-to-synology.sh --up
#
# Flags:
#   --copy-only  : copy files only (no docker)
#   --bootstrap  : run bootstrap only
#   --up         : bootstrap + (optional) frontend build + docker compose up -d --build
#   --root PATH  : override destination root (default: /volume1/docker/fastcallvoip-portal)

DEST_ROOT="/volume1/docker/fastcallvoip-portal"
MODE="copy-only"

while [ $# -gt 0 ]; do
  case "$1" in
    --copy-only) MODE="copy-only" ;;
    --bootstrap) MODE="bootstrap" ;;
    --up) MODE="up" ;;
    --root) DEST_ROOT="${2:-}"; shift ;;
    -h|--help)
      sed -n '1,120p' "$0"
      exit 0
      ;;
    *) echo "Unknown arg: $1"; exit 1 ;;
  esac
  shift
done

SRC_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "[deploy] src=$SRC_DIR"
echo "[deploy] dest=$DEST_ROOT"
echo "[deploy] mode=$MODE"

if [ "$(id -u)" -ne 0 ]; then
  echo "[deploy] ERROR: run as root (sudo -i)"
  exit 1
fi

mkdir -p "$DEST_ROOT"

# Copy everything except frontend/dist build artifacts placeholders if desired
rsync -a --delete   --exclude 'frontend/dist/.keep'   --exclude 'frontend/dist/*'   "$SRC_DIR/" "$DEST_ROOT/"

# Ensure bootstrap exists & is executable
if [ ! -x "$DEST_ROOT/bash-scripts/00-bootstrap/00-bootstrap.sh" ]; then
  chmod +x "$DEST_ROOT/bash-scripts/00-bootstrap/00-bootstrap.sh" || true
fi

# Run bootstrap to set ownership/perms and sort incoming scripts
bash -lc "$DEST_ROOT/bash-scripts/00-bootstrap/00-bootstrap.sh"

if [ "$MODE" = "copy-only" ]; then
  echo "[deploy] copy-only done."
  echo "[next] Edit env:"
  echo "  cp -n $DEST_ROOT/.env.example $DEST_ROOT/.env"
  echo "  nano $DEST_ROOT/.env"
  exit 0
fi

if [ "$MODE" = "bootstrap" ]; then
  echo "[deploy] bootstrap done."
  exit 0
fi

# MODE=up
cd "$DEST_ROOT"

# Build frontend dist if node project exists
if [ -f "$DEST_ROOT/frontend/package.json" ]; then
  echo "[deploy] build frontend dist"
  docker run --rm -t -v "$DEST_ROOT/frontend:/app" -w /app node:22-alpine     sh -lc "npm install --no-audit --no-fund && npm run build"
fi

echo "[deploy] docker compose up"
docker compose up -d --build
docker compose ps

echo "[deploy] done."

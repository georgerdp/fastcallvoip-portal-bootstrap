#!/usr/bin/env bash
set -euo pipefail
ROOT="/volume1/docker/fastcallvoip-portal"

sudo -i bash -lc "$ROOT/bash-scripts/00-bootstrap/00-bootstrap.sh"
cd "$ROOT"

# Frontend build (Vite dist) if a Node project exists
if [ -f "$ROOT/frontend/package.json" ]; then
  echo "[build] frontend"
  docker run --rm -t -v "$ROOT/frontend:/app" -w /app node:22-alpine \
    sh -lc "npm install --no-audit --no-fund && npm run build"
fi

docker compose up -d --build
docker compose ps

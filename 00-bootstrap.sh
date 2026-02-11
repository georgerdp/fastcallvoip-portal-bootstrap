#!/usr/bin/env bash
set -euo pipefail

ROOT="/volume1/docker/fastcallvoip-portal"
INCOMING="$ROOT/_incoming"
SCRIPTS="$ROOT/bash-scripts"

echo "[bootstrap] root=$ROOT"

# 1) ensure dirs
mkdir -p \
  "$ROOT"/{backend,frontend,db,docs,runtime/{logs,cache,export,tmp}} \
  "$SCRIPTS"/{00-bootstrap,10-admin,20-docker,30-security,40-maintenance,90-dev} \
  "$INCOMING"

# 2) ownership (Synology-friendly)
chown -R admin:users "$ROOT"

# 3) perms: dirs setgid for group inheritance
find "$ROOT" -type d -exec chmod 2775 {} \;

# 4) files default
find "$ROOT" -type f -exec chmod 0664 {} \; || true

# 5) scripts exec
find "$SCRIPTS" -type f -name "*.sh" -exec chmod 0755 {} \; || true

# 6) protect .env
if [ -f "$ROOT/.env" ]; then
  chmod 0640 "$ROOT/.env" || true
fi

# 7) auto-sort incoming scripts by prefix tag in filename:
#   ex: admin-create-invites.sh -> 10-admin
#       docker-up.sh -> 20-docker
#       sec-perms-fix.sh -> 30-security
sort_one() {
  local f="$1"
  local b
  b="$(basename "$f")"
  local dst="$SCRIPTS/90-dev"

  case "$b" in
    admin-*|user-*|invite-* ) dst="$SCRIPTS/10-admin" ;;
    docker-*|compose-* )     dst="$SCRIPTS/20-docker" ;;
    sec-*|perm-*|acl-* )     dst="$SCRIPTS/30-security" ;;
    maint-*|clean-*|rotate-* ) dst="$SCRIPTS/40-maintenance" ;;
    bootstrap-* )            dst="$SCRIPTS/00-bootstrap" ;;
  esac

  echo "[bootstrap] move $b -> $dst/"
  mv -f "$f" "$dst/$b"
}

if [ -d "$INCOMING" ]; then
  shopt -s nullglob
  for f in "$INCOMING"/*.sh; do
    sort_one "$f"
  done
  shopt -u nullglob
fi

# 8) print tree snapshot
echo "[bootstrap] tree:"
( cd "$ROOT" && find . -maxdepth 3 -type d -print | sed 's#^\./##' ) | sort

echo "[bootstrap] done"

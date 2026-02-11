#!/usr/bin/env bash
set -euo pipefail

DEST="${1:-/volume1/docker/fastcallvoip-portal}"

menu() {
  cat <<'EOF'
FastCallVoIP Portal Wizard
1) Bootstrap perms (bash-scripts/00-bootstrap/00-bootstrap.sh)
2) Compose UP (build + up -d)
3) Compose DOWN
4) Logs (tail)
5) Status (ps)
6) Exit
EOF
}

while true; do
  menu
  read -r -p "Select> " c
  case "$c" in
    1) bash -lc "$DEST/bash-scripts/00-bootstrap/00-bootstrap.sh" ;;
    2) cd "$DEST"; docker compose up -d --build ; docker compose ps ;;
    3) cd "$DEST"; docker compose down ;;
    4) cd "$DEST"; docker compose logs -f --tail=200 ;;
    5) cd "$DEST"; docker compose ps ;;
    6) exit 0 ;;
    *) echo "Unknown option" ;;
  esac
done

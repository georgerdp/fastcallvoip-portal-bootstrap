# FastCallVoIP Portal — scripts + docs + GUI preview

**What you get**
- `bash-scripts/` — Synology-friendly scripts (bootstrap, deploy helpers, wizards)
- `docker-compose.yml` — reference compose (Postgres + Redis + backend + frontend)
- `docs/` — environment + outbound prefix plan
- `assets/gui/` — PDF preview (Operator Panel style SPA)

## Quick Start (Synology DSM via SSH)

```bash
sudo -i
# copy repo to Synology (example: /tmp/fastcallvoip-portal)
cd /tmp/fastcallvoip-portal || exit 1

# deploy to /volume1/docker/fastcallvoip-portal (copy + perms + optional secret generation)
./deploy-to-synology.sh --copy-only

# create env
cp -n /volume1/docker/fastcallvoip-portal/.env.example /volume1/docker/fastcallvoip-portal/.env
nano /volume1/docker/fastcallvoip-portal/.env

# start
cd /volume1/docker/fastcallvoip-portal
docker compose up -d --build
docker compose ps
```

## Wizard
```bash
/volume1/docker/fastcallvoip-portal/bash-scripts/10-wizard/wizard.sh /volume1/docker/fastcallvoip-portal
```

## GUI Preview
Open: `assets/gui/FastCallVoIP_OperatorPanel_UI_Mockups.pdf`

## Webphone popup preview (interactive)
Open a local preview and click through the keypad/buttons:

```bash
python3 -m http.server 4173
# then open http://localhost:4173/docs/webphone-preview.html
```

## License
Apache-2.0 (see `LICENSE` and `NOTICE`).


## Brand / UI assets
See `assets/BRAND_ASSETS.md`.

## Russian deployment presentation
- `docs/DEPLOYMENT_PRESENTATION_RU.md` — launch roadmap, market comparison, and visual architecture/tree diagrams for `pbx.fastcallvoip.com`.

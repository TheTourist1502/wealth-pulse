#!/usr/bin/env bash
# Clone every WealthPulse app repo next to this workspace config. Safe to re-run.
#   ./setup.sh        clone missing repos
#   ./setup.sh pull   also fast-forward the ones already cloned
set -euo pipefail
cd "$(dirname "$0")"
mode="${1:-clone}"
for repo in wp_shared wp_layout wp_dashboard wp_portfolio wp_watchlist wp_alerts; do
  if [ -d "$repo/.git" ]; then
    if [ "$mode" = pull ]; then
      echo "pull $repo"
      git -C "$repo" pull --ff-only
    else
      echo "skip $repo (exists)"
    fi
  else
    git clone "https://github.com/TheTourist1502/$repo.git"
  fi
  [ -f "$repo/.env" ] || cp "$repo/.env.example" "$repo/.env"
done

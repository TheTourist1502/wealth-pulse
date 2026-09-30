#!/usr/bin/env bash
# Clone every WealthPulse app repo next to this workspace config. Safe to re-run.
set -euo pipefail
cd "$(dirname "$0")"
for repo in wp_shared wp_layout wp_dashboard wp_portfolio wp_watchlist wp_alerts; do
  if [ -d "$repo/.git" ]; then
    echo "skip $repo (exists)"
  else
    git clone "https://github.com/TheTourist1502/$repo.git"
  fi
done

#!/usr/bin/env bash
# Run `pnpm dev` in every app (or only the ones named), output prefixed per repo.
# Ctrl+C stops them all.
#   ./dev.sh                        all apps
#   ./dev.sh wp_layout wp_portfolio only these
set -euo pipefail
cd "$(dirname "$0")"
repos=("$@")
[ ${#repos[@]} -gt 0 ] || repos=(wp_shared wp_layout wp_dashboard wp_portfolio wp_watchlist wp_alerts)

trap 'trap - EXIT; kill 0' INT TERM EXIT
for repo in "${repos[@]}"; do
  [ -d "$repo/node_modules" ] || (cd "$repo" && pnpm install)
  (cd "$repo" && pnpm dev 2>&1 | sed -u "s/^/[$repo] /") &
done
wait

#!/usr/bin/env bash
# Generate Module Federation types for every app (or only the ones named)
# without a dev server: build each app's exposed types, then copy them from
# disk into each consumer's @mf-types/ instead of fetching them over HTTP.
#   ./types.sh                        all apps
#   ./types.sh wp_shared wp_layout    only these
set -euo pipefail
cd "$(dirname "$0")"
all=(wp_shared wp_dashboard wp_portfolio wp_watchlist wp_alerts wp_layout)
repos=("$@")
[ ${#repos[@]} -gt 0 ] || repos=("${all[@]}")

# 1. Emit <app>/dist/@mf-types (exposed modules) + dist/@mf-types.d.ts (api).
for repo in "${repos[@]}"; do
  [ -d "$repo/node_modules" ] || (cd "$repo" && pnpm install)
  echo "[$repo] building types"
  (cd "$repo" && pnpm exec vite build --logLevel error)
done

# 2. Copy each remote's types into every consumer that lists it in `remotes`.
for host in "${all[@]}"; do
  [ -f "$host/vite.config.ts" ] || continue
  mapfile -t remotes < <(grep -oE '^\s+wp_[a-z]+: \{ type' "$host/vite.config.ts" | grep -oE 'wp_[a-z]+')
  [ ${#remotes[@]} -gt 0 ] || continue

  # Only refresh hosts that were asked for, or that consume a rebuilt remote.
  touched=false
  for r in "$host" "${remotes[@]}"; do [[ " ${repos[*]} " == *" $r "* ]] && touched=true; done
  $touched || continue

  out="$host/@mf-types"
  rm -rf "$out" && mkdir -p "$out"
  imports=() ; modules=""
  for r in "${remotes[@]}"; do
    i=${#imports[@]}
    if [ ! -f "$r/dist/@mf-types.d.ts" ]; then
      echo "[$host] skip $r: no types, run ./types.sh $r" >&2
      continue
    fi
    cp -r "$r/dist/@mf-types" "$out/$r"
    sed "s/REMOTE_ALIAS_IDENTIFIER/$r/g" "$r/dist/@mf-types.d.ts" > "$out/$r/apis.d.ts"
    imports+=("PackageType as PackageType_$i,RemoteKeys as RemoteKeys_$i } from './$r/apis.d.ts';")
  done
  [ ${#imports[@]} -gt 0 ] || continue

  # Same index.d.ts the dts-plugin writes: loadRemote() typed for every remote.
  keys=$(seq -s ' | ' -f 'RemoteKeys_%g' 0 $((${#imports[@]} - 1)))
  pkgs=""
  for i in $(seq 0 $((${#imports[@]} - 1))); do pkgs+="T extends RemoteKeys_$i ? PackageType_$i<T> : "; done
  for m in @module-federation/runtime @module-federation/enhanced/runtime @module-federation/runtime-tools; do
    modules+="declare module \"$m\" {
  type RemoteKeys = $keys;
  type PackageType<T, Y = any> = ${pkgs}Y;
  export function loadRemote<T extends RemoteKeys, Y>(packageName: T): Promise<PackageType<T, Y>>;
  export function loadRemote<T extends string, Y>(packageName: T): Promise<PackageType<T, Y>>;
}
"
  done
  { printf 'import type { %s\n' "${imports[@]}"; printf '%s' "$modules"; } > "$out/index.d.ts"
  echo "[$host] @mf-types <- ${remotes[*]}"
done

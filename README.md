# WealthPulse

A real-time financial dashboard built as a set of micro-frontends: React 18,
TypeScript, Vite and Module Federation. Each app lives in its own Git
repository.

This repository is the **workspace**. It holds no app code. It holds:

- `.claude/`: shared project rules, the design system (`DESIGN.md`), and the
  agents and skills used by Claude Code
- `setup.sh`: clones (and updates) every app repo into this folder
- `dev.sh`: runs every app's dev server from here with a single command
- `types.sh`: generates every app's Module Federation types without a server

## Apps

| Repo | Port | Role |
| --- | --- | --- |
| [wp_layout](https://github.com/TheTourist1502/wp_layout) | 3000 | Host shell: layouts, auth pages, router, settings. Open this one in the browser. |
| [wp_shared](https://github.com/TheTourist1502/wp_shared) | 3001 | Shared types, API client, hooks, components, stores, EventBus |
| [wp_dashboard](https://github.com/TheTourist1502/wp_dashboard) | 3002 | Portfolio summary, top performers, market overview |
| [wp_portfolio](https://github.com/TheTourist1502/wp_portfolio) | 3003 | Holdings, allocation, performance |
| [wp_watchlist](https://github.com/TheTourist1502/wp_watchlist) | 3004 | Watchlist, live prices, stock detail |
| [wp_alerts](https://github.com/TheTourist1502/wp_alerts) | 3005 | Alert CRUD, notification center, history |

`wp_layout` loads the other apps in the browser at runtime from their
`remoteEntry.js`. The apps never import each other's code at build time.

## Prerequisites

- **Node.js 22** (tested on 22.22)
- **pnpm 10**: `npm install -g pnpm` or `corepack enable`
- **Git**, with access to the `TheTourist1502` repositories on GitHub
- **bash** (Linux or macOS; on Windows use WSL or Git Bash)

## Installation

### 1. Clone the workspace and the apps

```bash
git clone https://github.com/TheTourist1502/wealth-pulse.git
cd wealth-pulse
./setup.sh
```

`setup.sh` clones the six app repos into this folder. The folder then looks
like this:

```text
wealth-pulse/
├── .claude/
├── setup.sh
├── dev.sh
├── types.sh
├── wp_layout/      ← each wp_* is its own Git repo
├── wp_shared/
├── wp_dashboard/
├── wp_portfolio/
├── wp_watchlist/
└── wp_alerts/
```

The `wp_*` folders are listed in this repo's `.gitignore`, so changes inside
them never show up here.

### 2. Configure environment variables

`setup.sh` creates each app's `.env` from its `.env.example` (it never
overwrites an existing `.env`). The ports are already filled in. The remote
URLs are empty, so fill them in for local development:

**`wp_layout/.env`**

```env
PORT=3000
VITE_WP_SHARED_URL=http://localhost:3001/remoteEntry.js
VITE_WP_DASHBOARD_URL=http://localhost:3002/remoteEntry.js
VITE_WP_PORTFOLIO_URL=http://localhost:3003/remoteEntry.js
VITE_WP_WATCHLIST_URL=http://localhost:3004/remoteEntry.js
VITE_WP_ALERTS_URL=http://localhost:3005/remoteEntry.js
```

**`wp_dashboard`, `wp_portfolio`, `wp_watchlist`, `wp_alerts`**: each one
needs only the shared URL:

```env
VITE_WP_SHARED_URL=http://localhost:3001/remoteEntry.js
```

**`wp_shared/.env`**: needs nothing beyond `PORT=3001`.

Never commit a `.env` file. Only `.env.example` is tracked.

### 3. Install dependencies and start

```bash
./dev.sh
```

The first run installs dependencies (`pnpm install`) in any app that has no
`node_modules`, then starts every dev server. Open <http://localhost:3000>.

## Daily use

| Task | Command |
| --- | --- |
| Start every app | `./dev.sh` |
| Start only some apps | `./dev.sh wp_layout wp_shared wp_portfolio` |
| Stop everything | `Ctrl+C` in the `dev.sh` terminal |
| Get the latest code for every app | `./setup.sh pull` |
| Clone an app that was added later | `./setup.sh` |
| Regenerate federated types (no server) | `./types.sh` or `./types.sh wp_shared` |

`dev.sh` prefixes each line of output with the app's name (`[wp_portfolio] …`),
so you can tell the logs apart.

When you only work on one feature app, start the host, `wp_shared`, and that
app:

```bash
./dev.sh wp_layout wp_shared wp_portfolio
```

Routes that belong to apps you didn't start won't load. The app you are
working on runs normally.

### Working inside one app

Each app is an ordinary Vite project:

```bash
cd wp_portfolio
pnpm dev          # dev server on its port
pnpm type-check   # tsc --noEmit
pnpm build        # type-check + production build into dist/
pnpm preview      # serve the production build
```

### Committing

Commit and push from **inside** the app's folder. Each app has its own
remote, branches and pull requests:

```bash
cd wp_portfolio
git checkout -b feature/holdings-table
git commit -s -m "feat: holdings table"
git push -u origin feature/holdings-table
```

Commit in this workspace repo only when you change `.claude/`, the scripts or
this README.

## Troubleshooting

**`Port 3000 is already in use`**: every app uses `strictPort`, so it refuses
to switch to another port. Stop the old process (`lsof -i :3000`, then kill
it) and run `./dev.sh` again.

**A section of the app shows the error page, or the console says a remote
failed to load**: that app's dev server isn't running, or the matching
`VITE_WP_*_URL` in `wp_layout/.env` is empty or wrong. Check that
`http://localhost:<port>/remoteEntry.js` loads in the browser.

**The port shows as `NaN`, or the server won't start**: the app's `.env` is
missing. Run `./setup.sh` to create it from `.env.example`.

**`./setup.sh pull` stops with `Not possible to fast-forward`**: that app has
local commits that differ from its remote. `cd` into the app and resolve it
with `git pull --rebase` or a merge. The script never merges for you.

**`permission denied: ./setup.sh`**: run `chmod +x setup.sh dev.sh types.sh`.

## Project rules

Before you change code, read `.claude/CLAUDE.md` and `.claude/rules/`. The
visual system in `.claude/DESIGN.md` is the source of truth for colors, type,
spacing and components.

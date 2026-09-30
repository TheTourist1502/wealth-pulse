# WealthPulse

Real-time financial dashboard. Users track portfolios and holdings, watch
stocks with live prices, and set price/portfolio alerts.

Built as a micro-frontend: a shell host plus four feature apps (dashboard,
portfolio, watchlist, alerts) and a shared singleton package, stitched
together with Module Federation.

- Visual system: `DESIGN.md` (repo root)
- Full spec: `.claude/docs/wealth-pulse-config.json`

## Environments

| Env | URL | Notes |
|---|---|---|
| development | localhost:3000 | Hot reload, source maps |
| staging | staging.wealth-pulse.io | Production-like, full monitoring |
| production | app.wealth-pulse.io | CDN, full monitoring |

## Local setup

1. `pnpm install`
2. Copy `.env.example` to `.env`, fill in values
3. `docker-compose up` for backend services
4. `pnpm dev`, open <http://localhost:3000>

## CI

- PR: type-check → lint → unit tests → coverage → build → bundle-size check
- Merge to main: full suite → prod build → E2E on staging → perf report →
  auto-deploy

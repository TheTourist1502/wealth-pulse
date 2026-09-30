# Module Federation map

Six independent repos, each its own git repo and Vite + `@module-federation/vite` build. Each one
documents its full contract in `<repo>/docs/module-federation.md`; this file is the overview.

## Who exposes what, who consumes it

| Repo | Port | Role | Exposes | Consumes |
|---|---|---|---|---|
| `wp_shared` | 3001 | shared library | `./Card` | — |
| `wp_layout` | 3000 | host / shell | — | `wp_shared/Card`, `wp_dashboard/routes`, `wp_portfolio/routes`, `wp_watchlist/routes`, `wp_alerts/routes` |
| `wp_dashboard` | 3002 | feature remote | `./routes` | `wp_shared/Card` |
| `wp_portfolio` | 3003 | feature remote | `./routes` | `wp_shared/Card` |
| `wp_watchlist` | 3004 | feature remote | `./routes` | `wp_shared/Card` |
| `wp_alerts` | 3005 | feature remote | `./routes` | `wp_shared/Card` |

```
                   wp_shared (:3001)
                   ./Card
          ┌──────────┬───┴──────┬───────────┬──────────┐
          ▼          ▼          ▼           ▼          ▼
     wp_layout  wp_dashboard wp_portfolio wp_watchlist wp_alerts
      (:3000)        │          │           │          │
          ▲          └──────────┴─── ./routes ──────────┘
          └──────────────────────────────────┘
```

Feature remotes never import each other. They talk through the EventBus (to live in `wp_shared`).

## Route ownership

| URL | Owner | Layout |
|---|---|---|
| `/` → `/dashboard` | `wp_layout` | — |
| `/auth/login` | `wp_layout` | BlankLayout |
| `/settings` | `wp_layout` | RootLayout |
| `/dashboard` | `wp_dashboard` | RootLayout |
| `/portfolio?tab=overview\|holdings\|performance` | `wp_portfolio` | RootLayout |
| `/portfolio/$id` | `wp_portfolio` | RootLayout |
| `/watchlist` | `wp_watchlist` | RootLayout |
| `/watchlist/$symbol` | `wp_watchlist` | RootLayout |
| `/alerts` | `wp_alerts` | RootLayout |
| anything else | `wp_layout` (`notFoundComponent`) | — |

## The `./routes` contract

Every feature remote exposes the same shape:

```ts
// <remote>/src/routing/routeConfig.tsx
export function createRoutes<TParent extends AnyRoute>(parent: TParent): readonly AnyRoute[];
```

- The host calls it with its pathless `app` layout route; the remote's standalone router calls it
  with a bare root route. Same route code runs in both.
- Route segments come from the remote's `src/constants/routes.ts` (`APP_ROUTES`).
- Pages get params/search as props from `routeConfig.tsx`. Route ids differ between host
  (`/app/...`) and standalone (`/...`), so pages never use `getRouteApi()`.
- If a remote is down, the host mounts `<basePath>/$` → `ModuleErrorPage` (Retry). The rest of
  the app keeps working.

## Shared singletons

`react`, `react-dom`, `@tanstack/react-query` in every repo; `@tanstack/react-router` in every
repo that routes (all except `wp_shared`).

## Start order

`wp_shared` first, then the feature remotes, then `wp_layout`. A single feature remote can run on
its own with only `wp_shared` up (`pnpm dev` in that repo).

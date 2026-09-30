# Routing Rules

Source: `routing` in `.claude/docs/wealth-pulse-config.json` — the route table
there is canonical.

## Adding a route

1. Add it to `apps/shell/src/router.ts` (all routes are defined there).
2. Feature-module routes load via `React.lazy()`; the module exports them
   from `./routes`.
3. Type every param (`/portfolio/$id` → `id: string`). Query params go
   through `useSearch` with a validated schema.
4. Add the route to the config's `routing.routes` block and, if it belongs in
   the sidebar or header, to `routing.navigation`.

## Access

- `permissions: "authenticated"` → protected by `authMiddleware`
  (`packages/shared/src/middleware/authMiddleware.ts`) via `beforeLoad`.
  Invalid/expired JWT → redirect to `/auth/login?redirect=<path>`.
- `permissions: "unauthenticated"` → auth pages; a signed-in user is sent to
  `/dashboard`.
- No auth checks inside pages or components. The route decides.

## Layouts

- `RootLayout` — header + sidebar + outlet, for every protected route.
- `BlankLayout` — auth and error pages.

## Behaviour

- Unknown path → `/404` catch-all. Module load failure → error boundary with
  retry, not a blank screen.
- Every route is deep-linkable; tabs live in the URL (`/portfolio?tab=holdings`).
- Prefetch with the route `loader` + React Query when data is known up front.
- `analyticsMiddleware` tracks every route change; don't add per-page tracking.
- Set `meta.title` per route.

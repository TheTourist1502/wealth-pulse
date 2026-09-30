# Architecture

Enforceable rules: `.claude/rules/architecture.md`. This file is the picture.

```text
                 ┌──────────── shell :3000 ────────────┐
                 │ router · layouts · auth pages ·      │
                 │ settings · module loaders            │
                 └──┬───────┬────────┬────────┬─────────┘
          React.lazy│       │        │        │
          dashboard :3001  portfolio :3002  watchlist :3003  alerts :3004
                 │       │        │        │
                 └───────┴────┬───┴────────┘
                     shared :3008 (singleton)
        types · api · hooks · components · stores · eventBus
```

Feature apps never import each other. They talk through the EventBus and read
shared stores.

## Data flows

**Login** — LoginPage → `useMutation(login)` → `/api/auth/login` → JWT set as
httpOnly cookie → emit `user:login` → `authStore` updates → redirect to
`/dashboard`.

**Live prices** — module mounts → `useWebSocket` connects and subscribes →
server pushes a price → emit `stock:price:updated` → React Query invalidates →
components re-render.

**Cross-module** — Watchlist row click → emit `stock:selected` → stock detail
listens → `useStocks` fetches → live detail view.

## State layers

| Layer | Tool | Example |
|---|---|---|
| Server data | React Query | holdings, quotes, alerts |
| Cross-module client state | Zustand + EventBus | auth user, sidebar open, theme |
| Local UI | `useState` | an open dropdown |

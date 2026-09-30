---
name: new-feature
description: Scaffold WealthPulse code following the MFE architecture — either a new remote app (`/new-feature app <name> <port>`) or a feature inside an existing app (`/new-feature <app> <FeatureName>`, e.g. /new-feature portfolio HoldingsTable). Uses DESIGN.md tokens for any UI it creates.
---

Read `.claude/rules/architecture.md` and `.claude/rules/styling.md` first.
UI stubs use DESIGN.md token classes only (see
`.claude/docs/styling-and-theming.md`).

## Mode A — feature inside an app

Args: `<app> <FeatureName>` (app ∈ dashboard, portfolio, watchlist, alerts,
shell).

Location: `apps/<app>/src/features/<FeatureName>/` (dashboard uses
`src/components/`, per the config).

Create:

- `<FeatureName>.tsx` — the component. Data via a hook, no direct fetch.
  Loading, empty and error states rendered. Root surface picked from DESIGN.md
  (`feature-card` → `rounded-lg bg-surface-card p-8`, dense data →
  `product-mockup-card-dark`).
- `use<FeatureName>.ts` — only if it composes more than one shared query or
  adds local logic; otherwise call the shared hook directly and skip this file.
- `<FeatureName>.test.tsx` — RTL test: loading, success, error.
- `index.ts` — barrel.

If it needs new data: add the query to `packages/shared/src/api/queries.ts`
(or `mutations.ts`) and its types to `packages/shared/src/types`. If other
modules must react: add a typed event to `eventBus.ts` and the config's
`eventBus` block.

If it is a page: add the route in `apps/shell/src/router.ts` and the app's
`routes.ts`, plus the config `routing` entry.

## Mode B — new remote app

Args: `app <name> <port>`.

Create `apps/<name>/`:

- `package.json` — `@wealth-pulse/<name>`; React, TanStack, zustand as
  `peerDependencies`; build tools in `devDependencies`.
- `tsconfig.json` — extends `../../tsconfig.base.json`.
- `webpack.config.js` — `ModuleFederationPlugin` from
  `@module-federation/enhanced`, `name: '<name>'`, `filename: 'remoteEntry.js'`,
  exposes `./<Name>` → `./src/<Name>.tsx` and `./routes` → `./src/routes.ts`,
  `shared` identical to the shell's (singletons). Dev server on `<port>`.
- `src/<Name>.tsx` — default export, page title in
  `font-display text-display-md text-ink` (weight 400).
- `src/routes.ts` — exported routes.
- `src/{components,hooks,types,utils}/` only when first needed — do not create
  empty folders.
- `README.md` — port, exposes, routes, events.

Then wire it:

1. Shell `webpack.config.js` remotes: `<name>: 'http://localhost:<port>/remoteEntry.js'`.
2. Shell router: lazy route with `React.lazy(() => import('<name>/<Name>'))`
   inside `<Suspense>` and the error boundary.
3. Config JSON: `architecture.apps.<name>`, `shell.remotes`, `routing`.
4. `.claude/docs/folder-structure.md`.

## Finish

Run `pnpm type-check && pnpm lint` for the touched packages and report the
result. List every file created.

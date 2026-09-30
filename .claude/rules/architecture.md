# Architecture Rules

Source: `architecture` + `rules.architecture` in `.claude/docs/wealth-pulse-config.json`.

## Module Federation

- Each feature app exposes its root component and routes via Module Federation
  (`./<Name>` → `src/<Name>.tsx`, `./routes` → `src/routes.ts`). Entry points
  export a default component **and** routes.
- `packages/shared` is a singleton, loaded once and shared by every app.
- `react`, `react-dom` are `singleton` + `eager` in the shell; TanStack
  packages and `zustand` are `singleton`. Never bundle a second copy.
- Feature apps load only via `React.lazy()` + `<Suspense>` in the shell, wrapped
  in the shell's error boundary (fallback: error page with retry).
- **No direct imports between feature apps.** `apps/portfolio` never imports
  `apps/watchlist`. Cross-module communication goes through the EventBus.
- Every app has its own `tsconfig.json` extending the shared base.

## Where code lives

| What | Where |
|---|---|
| API calls | `packages/shared/src/api` — `queries.ts` (reads), `mutations.ts` (writes). Feature apps never call `axios`/`fetch` directly. |
| Types | `packages/shared/src/types` — the canonical `Stock`, `Portfolio`, `Holding`, `Alert`, `User`, API types |
| Reusable hooks | `packages/shared/src/hooks` (`useAuth`, `usePortfolio`, `useStocks`, `useWebSocket`, `useLocalStorage`) |
| Reusable UI | `packages/shared/src/components` (`Button`, `Input`, `Card`, `Badge`, `Alert`, `Loading`, `ErrorBoundary`) |
| Stores | `packages/shared/src/stores` (`authStore`, `portfolioStore`, `watchlistStore`, `uiStore`) |
| EventBus | `packages/shared/src/eventBus.ts` |
| Layouts | `apps/shell/src/layouts` (`RootLayout`, `BlankLayout`, `ModuleLayout`) |
| Module loading | `apps/shell/src/loaders` (`loadModule`, `preloadModule`, `handleModuleError`) |

Build a component in a feature app first. Promote it to `shared/components`
when a second app needs it, not before.

## Naming

- Apps in `apps/`, shared code in `packages/shared`, referenced as
  `@wealth-pulse/<package>`.
- Inside each app: `src/{components,hooks,pages,types,utils}` (+ `features/`
  where the config lists one).
- Components `PascalCase.tsx`; hooks `useCamelCase.ts`; stores
  `<feature>Store.ts`; barrels `index.ts`.

## State

- Server data → React Query only. Stale times: 5 min portfolio, 1 min prices.
  Invalidate on mutation.
- Cross-module client state → Zustand store in `shared/stores` + EventBus.
- Local UI state → `useState`. Never put server data in Zustand.

## EventBus

The event names and payloads in the config's `eventBus.events` are the
contract. Add an event there **and** to the typed map in `eventBus.ts` together;
never emit an untyped string.

- `user:logout` → every module clears its state and the React Query cache.
- `stock:price:updated` (from the WebSocket) → invalidate affected queries,
  do not hand-patch caches in three modules.
- Unsubscribe in the effect cleanup. A leaked listener survives remounts.

## Dependencies

- In feature apps, React and peers are `peerDependencies`.
- `devDependencies` hold build tools only.
- No circular dependencies (ESLint `import/no-cycle`).
- External libraries: approved list only (recharts, axios, clsx, …). Adding one
  needs a reason stated in the PR.
- Version ranges `^X.Y.Z`. Security updates within 48 h.

# Code Quality & Performance Rules

Source: `rules.codeQuality` + `rules.performance` in the config.

## TypeScript

`strict`, `noImplicitAny`, `noUnusedLocals`, `noUnusedParameters`,
`esModuleInterop`, `resolveJsonModule`, `skipLibCheck`, target ES2020.
No `any`; use `unknown` and narrow. No `@ts-ignore` without a one-line reason.

## Lint & format

- ESLint on all TS; Prettier, 2-space indent, max line 100.
- `react-hooks` and `jsx-a11y` enforced. Sorted imports, no unused imports.
- No `console.*` or `debugger` in shipped code.

## Testing

- 80% coverage minimum. Utils → unit tests. Custom hooks → hook tests
  (`renderHook`). Components → integration tests with RTL. Critical flows
  (login, portfolio view, add to watchlist, create alert) → Playwright E2E.
- Test behaviour through the DOM (roles, labels), not implementation details.
- Mock the network at the boundary (MSW) with responses shaped like the real
  API types from `shared/types`. No hand-rolled mocks that drift from them.
- Snapshot tests only for visual-regression guards, never as the sole test.
- Tests run in the pre-commit hook.

## Bundles

- Code-split by route; feature apps load async via Module Federation.
- Budgets (gzipped): total alert > 500 KB, entry ≤ 200 KB, async chunk ≤ 150 KB.
- Source maps in development only.

## Runtime

- `useMemo`/`useCallback` where a profiler or referential equality needs it,
  not by default.
- Lists over 100 items → virtualize. Pagination defaults to 20.
- Debounce search 300 ms; throttle resize listeners 200 ms.

## Network

- Timeout 30 s. Retry 3× with exponential backoff (React Query `retry`).
- Batch parallel calls where the API supports it. Respect 60 req/min/endpoint.
- WebSocket: reconnect up to 5× with backoff, then surface a stale-data state.

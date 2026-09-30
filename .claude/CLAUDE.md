# WealthPulse

Real-time financial dashboard. React 18 + TypeScript micro-frontend monorepo
(Module Federation, pnpm workspaces).

## Sources of truth

1. **`DESIGN.md`** (repo root) — the visual system. **Always follow it.** Every
   color, font, radius, spacing value, surface and component style comes from
   there. When anything else disagrees with it, `DESIGN.md` wins.
2. **`.claude/docs/wealth-pulse-config.json`** — architecture, routes, rules,
   EventBus contract, security, performance budgets. Everything *not* visual.
3. `.claude/rules/*` — the enforceable summary of both. Read the relevant rule
   before touching that area.

Where the config's `styling` / `theming` sections conflict with `DESIGN.md`
(blue primary, Inter-only type, shadow scale, hover styles, rounded scale),
`DESIGN.md` wins. The resolved mapping lives in
`.claude/docs/styling-and-theming.md`.

## Stack

| Concern | Choice |
|---|---|
| UI | React 18.3, TypeScript 5.3 (strict) |
| Routing | `@tanstack/react-router` |
| Server state | `@tanstack/react-query` v5 |
| Client state | `zustand` v4 + EventBus |
| Tables | `@tanstack/react-table` v8 |
| Build | webpack 5 + `@module-federation/enhanced` |
| Styling | Tailwind 3.4 + CSS variables from `DESIGN.md` |
| Tests | Jest + React Testing Library, Playwright for E2E |
| Errors | Sentry |

## Apps

| App | Port | Role |
|---|---|---|
| `apps/shell` | 3000 | Host: layouts, auth pages, router, settings |
| `apps/dashboard` | 3001 | Portfolio summary, top performers, market overview |
| `apps/portfolio` | 3002 | Holdings, allocation, performance |
| `apps/watchlist` | 3003 | Watchlist, live prices, stock detail |
| `apps/alerts` | 3004 | Alert CRUD, notification center, history |
| `packages/shared` | 3008 | Types, api, hooks, components, stores, eventBus |

## Commands

```bash
pnpm install
pnpm dev                                    # all apps on their ports
pnpm type-check && pnpm lint && pnpm test   # required before every commit
```

## Every chat

Invoke `/caveman` and `/promt-master` at the start of every chat — see
`rules/chat-mode.md`.

## Rules index

- `rules/chat-mode.md` — `/caveman` + `/promt-master` always on
- `rules/architecture.md` — MFE boundaries, naming, dependencies, state, EventBus
- `rules/styling.md` — DESIGN.md enforcement, Tailwind usage, dark mode, motion
- `rules/routing.md` — TanStack Router, route protection, navigation
- `rules/code-quality.md` — TypeScript, lint, testing, performance budgets
- `rules/security.md` — auth, sanitization, data protection, monitoring
- `rules/commit.md` — commit gate

## Agents & skills

- `mfe-architect` — plan a feature or turn a Figma design into a component tree
- `test-writer` — Jest/RTL/Playwright tests to the 80% bar
- `code-reviewer` — review a diff against every rule above, DESIGN.md included
- `docs-writer` — module READMEs, API docs, setup guides
- `security-auditor` — on demand only
- `/new-feature` — scaffold a remote app or a feature inside one
- `/design-check` — audit files or a diff against DESIGN.md

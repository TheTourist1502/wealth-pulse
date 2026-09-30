# Folder Structure

Update this file whenever a folder or top-level module file is added.

```text
wealth-pulse/
├── DESIGN.md                      # Visual system — always follow
├── pnpm-workspace.yaml
├── tsconfig.base.json             # Strict base, extended by every app
├── docker-compose.yml
├── .env.example
├── apps/
│   ├── shell/                     # :3000 host
│   │   ├── webpack.config.js      # remotes: dashboard, portfolio, watchlist, alerts, shared
│   │   └── src/
│   │       ├── router.ts          # every route
│   │       ├── layouts/           # RootLayout, BlankLayout, ModuleLayout
│   │       ├── loaders/           # loadModule, preloadModule, handleModuleError
│   │       ├── middleware/        # analytics.ts, errorBoundary.ts
│   │       ├── components/        # Header.tsx, Sidebar.tsx
│   │       └── pages/
│   │           ├── auth/          # LoginPage, SignupPage, ForgotPasswordPage
│   │           ├── Settings.tsx, ProfileSettings.tsx,
│   │           │   SecuritySettings.tsx, NotificationSettings.tsx
│   │           └── NotFoundPage.tsx, ErrorPage.tsx
│   ├── dashboard/                 # :3001
│   │   └── src/
│   │       ├── Dashboard.tsx      # exposed ./Dashboard
│   │       ├── routes.ts          # exposed ./routes
│   │       └── components/        # PortfolioSummary, TopPerformers, MarketOverview
│   ├── portfolio/                 # :3002
│   │   └── src/
│   │       ├── Portfolio.tsx, routes.ts
│   │       ├── pages/PortfolioDetail.tsx
│   │       └── features/          # HoldingsTable, AllocationChart, PerformanceMetrics
│   ├── watchlist/                 # :3003
│   │   └── src/
│   │       ├── Watchlist.tsx, routes.ts
│   │       ├── pages/StockDetail.tsx
│   │       └── features/          # WatchlistTable, PriceCard, AddStockForm
│   └── alerts/                    # :3004
│       └── src/
│           ├── Alerts.tsx, routes.ts
│           └── features/          # AlertForm, NotificationCenter, AlertHistory
└── packages/
    └── shared/                    # :3008 singleton, @wealth-pulse/shared
        └── src/
            ├── types/index.ts
            ├── api/               # client.ts, queries.ts, mutations.ts
            ├── hooks/             # useAuth, usePortfolio, useStocks, useWebSocket, useLocalStorage
            ├── components/        # Button, Input, Card, Badge, Alert, Loading, ErrorBoundary
            ├── stores/            # authStore, portfolioStore, watchlistStore, uiStore
            ├── middleware/authMiddleware.ts
            ├── styles/            # variables.css (DESIGN.md tokens), tailwind preset
            ├── utils/
            └── eventBus.ts
```

Each app also has `src/{hooks,types,utils}` as needed, its own
`tsconfig.json`, `webpack.config.js`, and tests beside the code
(`Foo.test.tsx`). E2E specs live in `e2e/` at the root.

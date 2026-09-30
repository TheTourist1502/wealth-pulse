# Styling Rules — follow DESIGN.md

`DESIGN.md` at the repo root is the design system. Read it before building any
UI. Token → Tailwind mapping and dark-mode values live in
`.claude/docs/styling-and-theming.md`.

## Tokens only

- Never write a hex, `rgb()`, or arbitrary Tailwind color (`bg-[#cc785c]`).
  Use the Tailwind classes backed by the DESIGN.md CSS variables
  (`bg-canvas`, `text-ink`, `bg-primary`, `border-hairline`, …).
- Radius: `rounded-md` (8px) buttons/inputs/tabs, `rounded-lg` (12px) cards,
  `rounded-xl` (16px) hero containers, `rounded-full` pills/avatars/icon buttons.
- Spacing on the 4px grid. Card padding `p-8` (32px), dense cards `p-6`,
  section gaps 96px on marketing-style pages, max content width 1200px.
- Tailwind classes only; `clsx` for conditionals. CSS modules only when
  Tailwind cannot express it. No inline `style`.
- Brand colors change only in `packages/shared/src/styles/variables.css`.

## Type

- Display (page titles, section heads, hero figures such as total portfolio
  value): serif `font-display`, **weight 400**, negative tracking. Never bold a
  serif. Emphasis = bigger serif, not heavier.
- Everything else: `font-sans` (Inter) 400 body, 500 labels/buttons.
- Code, tickers in terminal-style panels: `font-mono` (JetBrains Mono).
- Money and percentages: `tabular-nums` so columns do not jitter on live updates.

## Surfaces

- Page floor is cream `bg-canvas`, never white or cool gray.
- Three surface modes: canvas, cream card (`bg-surface-card`), dark
  (`bg-surface-dark`). Dark cards carry dense data (charts, tables, terminal
  views, the featured metric). Don't stack two identical surface modes back to
  back.
- Depth comes from surface color, not shadow. `shadow-sm` on hover-elevated
  elements is the only shadow. No `shadow-md`/`lg`/`xl`.
- No fourth surface tone (no blue, purple or green panels).

## Color use

- Coral `primary` is scarce: primary CTA, active nav marker, inline links,
  full-bleed callouts. Not for decoration, not for gains.
- Gains/losses: `success` / `error`. Warnings: `warning`. Chart series:
  `primary`, `accent-teal`, `accent-amber`, then `muted`.
- Body text `text-body`, headings `text-ink`, secondary `text-muted`, fine
  print `text-muted-soft`.

## Components

Match the DESIGN.md `components:` entry for anything with a name there:
`button-primary`, `button-secondary`, `button-secondary-on-dark`,
`button-text-link`, `button-icon-circular`, `text-input(-focused)`,
`feature-card`, `product-mockup-card-dark`, `badge-pill`, `badge-coral`,
`category-tab(-active)`, `top-nav`. Build them once in `shared/components`.

- Buttons: one height (40px), `rounded-md`, `px-5 py-3`. Danger variant =
  `bg-error text-on-primary`, same shape.
- Badges: `badge-pill` for neutral tags; semantic badges use the semantic color
  at low alpha behind the full-strength text.

## States

- Primary button: default → `primary-active` on press **and** hover. That is
  the only hover treatment. No color shifts, lifts or underlines elsewhere.
- Focus is mandatory for a11y: every interactive element gets a visible
  `focus-visible` ring — `ring-[3px] ring-primary/15` plus `border-primary` on
  inputs.
- Disabled: `bg-primary-disabled text-muted`.
- Inputs also need an error state: `border-error` + message in `text-error`.

## Dark mode

- `dark:` classes work through the semantic variables, so most components need
  none. Mode is `light | dark | system`, detected on first load, persisted in
  `localStorage`.
- Dark mode moves the floor to `surface-dark` and text to `on-dark`. Coral
  stays coral. Contrast must pass WCAG AA in both modes.

## Motion

- Theme switch: 0.3s color transition.
- Honour `prefers-reduced-motion` (`motion-safe:` / `motion-reduce:`).
- Numbers never bounce: no overshoot or spring easing on prices, balances or
  chart values.

## Responsive

Mobile-first. Tailwind `md` (768) and `lg` (1024) match the DESIGN.md
breakpoints. Grids drop columns rather than shrinking cards. Tables and code
panels scroll horizontally inside their card on mobile. Touch targets ≥ 40px.

## Icons

`lucide-react` (names in the config's sidebar: `LayoutDashboard`, `Briefcase`,
`Star`, `Bell`, `Settings`, `User`), `currentColor`, 16/20px.

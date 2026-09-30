# Styling & Theming — DESIGN.md → code

`DESIGN.md` owns the values. This file shows how they reach Tailwind. If the
two ever disagree, fix this file to match `DESIGN.md`.

## Config conflicts, resolved

| Config says | DESIGN.md says | Use |
|---|---|---|
| Primary `210 100% 50%` (blue) | Coral `#cc785c` | Coral |
| Background white `0 0% 100%` | Cream canvas `#faf9f5` | Cream |
| Font `Inter` only | Serif display + Inter body | Both (serif for display) |
| Mono `Fira Code` | JetBrains Mono | JetBrains Mono |
| Shadows xs–xl | Color-block depth, one faint shadow | `shadow-sm` only |
| Radius sm 2px … 2xl 16px | 4/6/8/12/16/pill | DESIGN.md scale |
| Hover states everywhere | Primary darkens on press, nothing else | Primary hover = active; focus rings kept for a11y |
| Card `bg-white shadow-md` | `surface-card`, no shadow | DESIGN.md |

Everything else in the config (breakpoints, 4px spacing, dark mode, CSS vars,
0.3s theme transition) stands.

## `packages/shared/src/styles/variables.css`

HSL triplets for Tailwind's `<alpha-value>`. Hex in the comment is the source.

```css
:root {
  /* Brand */
  --primary: 15 52% 58%;             /* #cc785c */
  --primary-active: 15 46% 45%;      /* #a9583e */
  --primary-disabled: 30 22% 87%;    /* #e6dfd8 */
  --on-primary: 0 0% 100%;           /* #ffffff */
  --accent-teal: 168 39% 54%;        /* #5db8a6 */
  --accent-amber: 32 76% 63%;        /* #e8a55a */

  /* Semantic */
  --success: 134 39% 54%;            /* #5db872 */
  --warning: 43 80% 46%;             /* #d4a017 */
  --error: 0 53% 52%;                /* #c64545 */

  /* Fixed dark surfaces (product/data cards, footer) */
  --surface-dark: 40 7% 9%;          /* #181715 */
  --surface-dark-elevated: 36 7% 14%;/* #252320 */
  --surface-dark-soft: 45 7% 11%;    /* #1f1e1b */
  --on-dark: 48 33% 97%;             /* #faf9f5 */
  --on-dark-soft: 42 5% 61%;         /* #a09d96 */

  /* Adaptive — swap in dark mode */
  --canvas: 48 33% 97%;              /* #faf9f5 */
  --surface-soft: 37 39% 94%;        /* #f5f0e8 */
  --surface-card: 39 35% 90%;        /* #efe9de */
  --surface-strong: 38 32% 87%;      /* #e8e0d2 */
  --hairline: 30 22% 87%;            /* #e6dfd8 */
  --hairline-soft: 35 23% 90%;       /* #ebe6df */
  --ink: 60 3% 8%;                   /* #141413 */
  --body-strong: 60 3% 14%;          /* #252523 */
  --body: 60 3% 23%;                 /* #3d3d3a */
  --muted: 45 4% 41%;                /* #6c6a64 */
  --muted-soft: 45 5% 53%;           /* #8e8b82 */
}

.dark {
  --canvas: 40 7% 9%;                /* surface-dark */
  --surface-soft: 45 7% 11%;         /* surface-dark-soft */
  --surface-card: 36 7% 14%;         /* surface-dark-elevated */
  --surface-strong: 36 7% 18%;
  --hairline: 36 7% 20%;
  --hairline-soft: 36 7% 16%;
  --ink: 48 33% 97%;                 /* on-dark */
  --body-strong: 48 20% 90%;
  --body: 48 10% 82%;
  --muted: 42 5% 61%;                /* on-dark-soft */
  --muted-soft: 42 4% 50%;
  /* Dark data cards sit one step below the floor so they still read as a band */
  --surface-dark: 45 7% 6%;
}

html { transition: background-color .3s, color .3s; }
@media (prefers-reduced-motion: reduce) { html { transition: none; } }
```

The `.dark` values not listed in DESIGN.md (`surface-strong`, `hairline`,
`body*`, `muted-soft`) are derived from its dark ramp; check AA contrast when
changing them.

## `tailwind.config.ts` (shared preset)

```ts
const v = (name: string) => `hsl(var(--${name}) / <alpha-value>)`;

export default {
  darkMode: 'class',
  theme: {
    screens: { xs: '320px', sm: '640px', md: '768px', lg: '1024px', xl: '1280px', '2xl': '1536px' },
    colors: {
      transparent: 'transparent',
      current: 'currentColor',
      primary: { DEFAULT: v('primary'), active: v('primary-active'), disabled: v('primary-disabled') },
      'on-primary': v('on-primary'),
      'accent-teal': v('accent-teal'),
      'accent-amber': v('accent-amber'),
      success: v('success'),
      warning: v('warning'),
      error: v('error'),
      canvas: v('canvas'),
      'surface-soft': v('surface-soft'),
      'surface-card': v('surface-card'),
      'surface-strong': v('surface-strong'),
      'surface-dark': { DEFAULT: v('surface-dark'), elevated: v('surface-dark-elevated'), soft: v('surface-dark-soft') },
      'on-dark': { DEFAULT: v('on-dark'), soft: v('on-dark-soft') },
      hairline: { DEFAULT: v('hairline'), soft: v('hairline-soft') },
      ink: v('ink'),
      'body-strong': v('body-strong'),
      body: v('body'),
      muted: { DEFAULT: v('muted'), soft: v('muted-soft') },
    },
    fontFamily: {
      display: ['"Cormorant Garamond"', '"EB Garamond"', 'Garamond', '"Times New Roman"', 'serif'],
      sans: ['Inter', '-apple-system', 'BlinkMacSystemFont', '"Segoe UI"', 'Roboto', 'sans-serif'],
      mono: ['"JetBrains Mono"', 'ui-monospace', 'monospace'],
    },
    fontSize: {
      // [size, { lineHeight, letterSpacing }] — DESIGN.md typography
      'display-xl': ['64px', { lineHeight: '1.05', letterSpacing: '-1.5px' }],
      'display-lg': ['48px', { lineHeight: '1.1', letterSpacing: '-1px' }],
      'display-md': ['36px', { lineHeight: '1.15', letterSpacing: '-0.5px' }],
      'display-sm': ['28px', { lineHeight: '1.2', letterSpacing: '-0.3px' }],
      'title-lg': ['22px', { lineHeight: '1.3' }],
      'title-md': ['18px', { lineHeight: '1.4' }],
      'title-sm': ['16px', { lineHeight: '1.4' }],
      'body-md': ['16px', { lineHeight: '1.55' }],
      'body-sm': ['14px', { lineHeight: '1.55' }],
      caption: ['13px', { lineHeight: '1.4' }],
      'caption-upper': ['12px', { lineHeight: '1.4', letterSpacing: '1.5px' }],
      code: ['14px', { lineHeight: '1.6' }],
      button: ['14px', { lineHeight: '1' }],
    },
    borderRadius: { none: '0', xs: '4px', sm: '6px', md: '8px', lg: '12px', xl: '16px', full: '9999px' },
    boxShadow: { none: 'none', sm: '0 1px 3px rgba(20,20,19,0.08)' },
    extend: {
      maxWidth: { content: '1200px' },
      spacing: { section: '96px' },
    },
  },
};
```

Cormorant Garamond reads small next to Inter: use weight 500 with
`tracking-[-0.02em]` per DESIGN.md's substitute note, and size it up one step
if a heading looks light.

## Component recipes

| DESIGN.md component | Classes |
|---|---|
| `button-primary` | `h-10 px-5 rounded-md bg-primary text-on-primary text-button font-medium hover:bg-primary-active active:bg-primary-active disabled:bg-primary-disabled disabled:text-muted focus-visible:ring-[3px] focus-visible:ring-primary/15` |
| `button-secondary` | `h-10 px-5 rounded-md bg-canvas text-ink border border-hairline text-button font-medium` |
| `button-secondary-on-dark` | `h-10 px-5 rounded-md bg-surface-dark-elevated text-on-dark` |
| `button-icon-circular` | `size-9 rounded-full bg-canvas border border-hairline text-ink` |
| `text-link` | `text-primary active:underline` |
| `text-input` | `h-10 px-3.5 rounded-md bg-canvas text-ink text-body-md border border-hairline focus:border-primary focus:ring-[3px] focus:ring-primary/15` |
| `feature-card` | `rounded-lg bg-surface-card p-8` |
| `product-mockup-card-dark` | `rounded-lg bg-surface-dark text-on-dark p-8` |
| `badge-pill` | `rounded-full bg-surface-card text-ink text-caption font-medium px-3 py-1` |
| `badge-coral` | `rounded-full bg-primary text-on-primary text-caption-upper uppercase font-medium px-3 py-1` |
| `category-tab` / active | `px-3.5 py-2 rounded-md text-muted` / `bg-surface-card text-ink` |
| `top-nav` (app header) | `h-16 bg-canvas text-ink text-body-sm font-medium` |

## App-surface mapping

DESIGN.md is written for a marketing site. In the dashboard:

- Header → `top-nav`. Sidebar → canvas with `category-tab` items; active item
  gets `category-tab-active`.
- KPI and summary cards → `feature-card`. The single headline figure (total
  portfolio value) → `font-display text-display-md` in a
  `product-mockup-card-dark`.
- Holdings/watchlist tables → canvas with `border-hairline` rows,
  `text-body-sm`, `tabular-nums`, sticky header on `surface-soft`.
- Charts → dark card; series `primary`, `accent-teal`, `accent-amber`, gridlines
  `on-dark-soft/20`.
- Toasts → `cookie-consent-card` styling (dark, `rounded-lg`, `p-6`).
- Alerts (the component) → `rounded-lg border p-4`, semantic color at 10%
  alpha background, full-strength text.

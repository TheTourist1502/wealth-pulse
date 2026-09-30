---
name: design-check
description: Audit UI code against DESIGN.md — hardcoded colors, wrong fonts or weights, off-scale radius, extra shadows, hover styling, coral overuse, white canvas, missing focus rings. Invoke with a path (/design-check apps/portfolio) or no argument for the current diff. Use before committing any UI change, or when asked "does this follow the design", "check the design", "design audit".
---

Checks `.tsx`, `.ts`, `.css` against `DESIGN.md` (repo root) and the mapping in
`.claude/docs/styling-and-theming.md`. Report only; fix when asked.

## Target

A path argument, or with none:
`git diff --name-only HEAD -- '*.tsx' '*.ts' '*.css'` plus untracked files.

## 1. Mechanical scan

Run each over the target; every hit is a finding unless it is in
`packages/shared/src/styles/variables.css` or the Tailwind preset.

```bash
T="<target paths>"
grep -rnE "#[0-9a-fA-F]{3,8}\b|rgba?\(|hsla?\(" $T --include=*.tsx --include=*.ts --include=*.css   # raw colors
grep -rnE "(bg|text|border|ring|fill|stroke)-\[(#|rgb|hsl|var)" $T      # arbitrary colors (ring-[3px] is fine)
grep -rnE "\b(bg-white|bg-black|text-black|(bg|text|border)-(gray|slate|zinc|neutral|blue|sky|indigo|purple|red|green)-[0-9])" $T   # Tailwind palette, not tokens
grep -rnE "shadow-(md|lg|xl|2xl|inner)" $T                              # shadows beyond shadow-sm
grep -rnE "rounded-(2xl|3xl)" $T                                        # off-scale radius
grep -rnE "font-display[^\"']*font-(semibold|bold|extrabold|black)|font-(semibold|bold)[^\"']*font-display" $T   # bold serif
grep -rnE "hover:" $T                                                   # review each: only primary→primary-active allowed
grep -rnE "style=\{\{" $T                                               # inline styles
grep -rnE "Fira Code|font-\['" $T                                        # wrong/arbitrary fonts
```

## 2. Read-through (judgement)

Read each file in the target and check:

- **Canvas** — page floors are `bg-canvas`, not white.
- **Coral scarcity** — `bg-primary`/`text-primary` only on the primary CTA,
  active nav, inline links, full-bleed callouts. Not on gains, icons, borders
  for decoration.
- **Type** — display headings and the headline figure use `font-display`
  at 400; body/labels `font-sans`; figures `tabular-nums`.
- **Surfaces** — cards are `surface-card` or `surface-dark`; no two identical
  surface bands in a row; no fourth tone.
- **Radius hierarchy** — md buttons/inputs, lg cards, xl hero, full pills.
- **Named components** — anything that is a DESIGN.md component uses the
  shared component or the recipe classes.
- **States** — visible `focus-visible` ring on every interactive element;
  disabled uses `primary-disabled`; inputs have an error state.
- **Dark mode** — colors come through variables, so it works without
  per-element `dark:` overrides; nothing hardcodes a light-only value.
- **Motion** — no overshoot/spring/bounce on numbers; reduced motion honoured.
- **Contrast** — text on coral is `on-primary`; `muted-soft` never carries
  essential info.

## Output

One line per finding, most severe first:
`path:line — rule broken — DESIGN.md-compliant fix`

Then: `N findings (X mechanical, Y judgement)`. If clean, list the checks run.

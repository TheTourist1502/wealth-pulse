# Commit Behavior

Before committing, always:

1. Run `pnpm type-check && pnpm lint && pnpm test` and report the result.
2. Show the full diff.
3. List any issues or suggestions, including DESIGN.md violations (run
   `/design-check` on UI changes).
4. If there is any issue, wait for explicit approval before running `git commit`.
5. If any issues are found (linting, formatting, logic, design, etc.), present
   them and wait for explicit approval before fixing them — never auto-correct
   and commit without confirmation.

Branches: `feature/<description>` off `develop`. Commit messages are clear and
signed off (`git commit -s`).

# Naming Rules

Files and folders are kebab-case. Identifiers inside them follow the language
convention.

| Thing | Convention | Example |
|---|---|---|
| Folders | kebab-case | `user-profile/` |
| `.tsx` files | kebab-case | `user-profile.tsx` |
| `.ts` files | kebab-case | `use-auth.ts` |
| Components | PascalCase | `UserProfile` |
| Functions | camelCase | `getUserProfile()` |
| Hooks | `use` + camelCase | `useAuth()` |
| Types / interfaces | PascalCase | `UserProfile` |
| Constants | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT` |
| Tests | same filename + `.test` | `user-profile.test.tsx` |
| Barrel | `index.ts` | `index.ts` |

- File name matches its main export in kebab-case: `UserProfile` lives in
  `user-profile.tsx`, `useAuth` in `use-auth.ts`, `authStore` in
  `auth-store.ts`.
- Tests sit next to the file they test.

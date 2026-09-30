# Security & Observability Rules

Source: `rules.security` + `monitoring` in the config.

## Auth

- JWT lives in an **httpOnly cookie** only. Never in `localStorage`,
  `sessionStorage`, Zustand persistence or a JS-readable cookie.
- Refresh the token 5 min before expiry.
- Logout clears cookies, every Zustand store, the React Query cache, and emits
  `user:logout`.
- Mutations send `x-csrf-token`. All requests use `withCredentials: true`.

## Untrusted input

- Render user input as text (React escaping). `dangerouslySetInnerHTML` only
  with DOMPurify and a reviewer sign-off.
- CSP is on; no inline scripts, no `eval`.

## Data protection

- Never log passwords, tokens, or full account numbers. Mask emails and phone
  numbers in logs and Sentry breadcrumbs.
- API keys and DSNs from environment variables only. `.env` is never committed
  or read by the agent; `.env.example` holds the keys with empty values.
- HTTPS everywhere outside localhost.

## Monitoring

- Errors → Sentry via the shared `ErrorBoundary` and the api client
  interceptor. Report 5xx and unknown errors; don't report 401/403/404 or
  validation errors (those are user flows).
- Analytics (`routeChange`, `componentInteraction`, `apiCall`) go through the
  shell's analytics middleware only.
- Structured logs with `error | warn | info | debug` levels.

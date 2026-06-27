# TypeScript Frontend Security and Performance Audit

Use this skill to audit TypeScript frontend projects with strong focus on user safety, browser security, token handling, runtime data validation, accessibility, performance, privacy, production readiness, and maintainable UI architecture.

Skill metadata:

- Version: 1.0.0
- License: MIT

Prioritize:

1. User safety and sensitive data protection
2. XSS, token handling, route protection, and browser security
3. Runtime validation of API/user data
4. Robust UI states, accessibility, and privacy
5. Performance based on evidence
6. Simple, explicit, maintainable TypeScript frontend code

## Core Prompt

Start from this baseline:

> Perform a strict audit of this TypeScript frontend project.
> Prioritize security, XSS resistance, token safety, runtime validation, accessibility, privacy, performance, production safety, and code quality.
> Look for issues that could cause account compromise, token leakage, data exposure, broken authorization UX, privacy violations, inaccessible flows, broken async states, bundle bloat, poor Core Web Vitals, or long-term code risk.
> Review the code like a production dashboard, SaaS frontend, or financial/crypto app, even if it is still an MVP.
> For every confirmed problem, provide the most robust practical solution, plus validation steps.

The audit is complete only after every applicable standard has been checked and every finding includes a robust solution and validation path.

## Scope Selection

First identify the project shape:

- App type: SPA, SSR/SSG app, dashboard, landing page, embedded widget, mobile web app, PWA, admin panel, wallet/crypto UI, checkout, or mixed frontend.
- Framework/build: React, Next.js, Vue, Nuxt, Angular, Svelte/SvelteKit, Vite, CRA, Remix, Astro, TanStack Router, or custom build.
- Data flows: auth, API clients, forms, uploads, payments, analytics, cookies, local/session storage, URL params, user-generated content, markdown/HTML rendering, websocket/SSE, or third-party scripts.
- Risk profile: financial, DeFi, wallet, tenant data, sensitive data, public production surface, dashboard/admin, healthcare, minors, or high-traffic app.

Mark items as not applicable only with a clear reason.

## Evidence and Traceability Protocol

Use a traceable audit flow for non-trivial repositories:

- Inspect code incrementally by route, page, component, hook, store, API client, form, auth flow, layout, middleware, build config, or browser integration.
- Do not mark an area as safe without citing concrete evidence: file, component, route, config, test, command output, schema, browser behavior, or observed invariant.
- If repository size or context limits prevent full coverage, state what was reviewed, what was not reviewed, and which high-risk areas remain.
- Track each meaningful area with one of these statuses:
  - **Verified:** evidence supports the control or invariant.
  - **Issue:** evidence shows a concrete problem.
  - **Partial:** evidence is incomplete or the control exists but has gaps.
  - **Not applicable:** the area does not apply, with reason.
- Add a confidence level to important findings when certainty is not absolute: High, Medium, or Low.
- Use lower confidence when SSR/CSR behavior, framework config, dynamic imports, generated clients, environment variables, CDN/proxy headers, third-party scripts, or deployment context make behavior harder to prove.

## Non-Negotiable Standards

Apply these rules aggressively:

1. **Browser-exposed secrets must not exist.**
   - Never ship private keys, server secrets, admin tokens, internal API keys, or privileged credentials to frontend code.
   - Public env vars such as `NEXT_PUBLIC_*` or `VITE_*` are user-visible and must be treated as public.
   - Source maps, build artifacts, and error reports must not expose secrets or sensitive implementation details.

2. **Token handling must resist XSS.**
   - Avoid storing sensitive JWTs, refresh tokens, private keys, seed phrases, or session secrets in `localStorage`.
   - Prefer secure `HttpOnly`, `Secure`, `SameSite` cookies controlled by the backend when possible.
   - If memory/session storage is used, explain the tradeoff and harden XSS, logout, refresh, and tab/session behavior.
   - Logout must clear client state, caches, in-memory auth, storage, and sensitive query data.

3. **Frontend authorization is UX only.**
   - Route guards, hidden buttons, RBAC UI, and feature flags improve UX but do not secure backend resources.
   - Every sensitive operation must rely on backend authorization.
   - Flag UI code that implies frontend-only permission checks are sufficient.

4. **Untrusted content must not reach the DOM unsanitized.**
   - Avoid `dangerouslySetInnerHTML`, `v-html`, `innerHTML`, template injection, markdown rendering, or HTML from users/API without sanitization.
   - Use DOMPurify/isomorphic-dompurify or framework-safe rendering for user content.
   - Avoid `eval`, `new Function`, string `setTimeout`, dynamic script injection, and unsafe template execution.

5. **Runtime data must be validated.**
   - TypeScript types do not validate API responses, URL params, storage, postMessage, or form input at runtime.
   - Use Zod, Yup, Valibot, io-ts, generated clients, or explicit validators at trust boundaries.
   - Reject unknown or unsafe fields when contract strictness matters.

6. **Fix root causes, not symptoms.**
   - Do not recommend one-off guards, scattered `if`s, or silent fallback when the real problem is a missing invariant, weak boundary, broken auth model, unsafe rendering path, or scattered state.
   - Prefer fixing the schema, domain model, route boundary, auth flow, component contract, state model, or canonical helper.

7. **Optimize only with evidence.**
   - Require Lighthouse, WebPageTest, bundle analyzer, Web Vitals/RUM, React Profiler, performance traces, or clear hot-path evidence before complex performance changes.
   - Simple, accessible UI wins over speculative micro-optimization.

## Frontend Safety Standards

Audit frontend-specific risk as part of production safety:

- TypeScript config should enable `strict`, `noImplicitAny`, `strictNullChecks`, `noImplicitReturns`, and `useUnknownInCatchVariables` when practical.
- Avoid `any`; prefer `unknown` plus type guards, schemas, generated types, or branded/domain types.
- Avoid non-null assertions (`!`), broad `as`, unsafe optional fallbacks, and unchecked API assumptions in critical flows.
- Validate URLs before navigation; use allowlists for redirects, return URLs, links, iframe/embed URLs, and external origins.
- Use CSRF protections when cookie/session-authenticated state-changing requests are possible.
- Use CSP, HSTS, `X-Content-Type-Options`, frame protection, `Referrer-Policy`, `Permissions-Policy`, COOP/CORP/COEP, and SRI where applicable.
- Treat analytics, tag managers, chat widgets, session replay, ads, and third-party scripts as supply-chain and privacy risks.
- Respect cookie consent and do not load non-essential tracking before valid consent when required.
- Avoid leaking sensitive data through URLs, query params, browser history, referrers, analytics events, logs, screenshots, or error monitoring.

## Structural Quality Standards

Audit maintainability as part of safety. A secure patch that leaves tangled UI code is not robust when a clearer path is visible.

- Look for structural simplification: delete branches, flags, wrappers, helper layers, or special cases when a better model makes them unnecessary.
- Fight spaghetti growth in pages, components, hooks, stores, contexts, API clients, route guards, and form logic.
- Keep logic in the canonical layer:
  - pages/routes compose views and data boundaries;
  - components render UI and local interactions;
  - hooks own reusable UI/data behavior;
  - API clients own transport and response parsing;
  - stores own shared client state;
  - domain helpers own business formatting, validation, and state rules.
- Treat files above 1000 lines, giant components, generic `utils` dumping grounds, and unrelated responsibilities as strong maintainability smells.
- Reject weak abstractions: pass-through components, hooks, wrappers, providers, stores, or helpers that do not make code safer or simpler.
- Reuse canonical helpers before creating new ones; consolidate repeated validation, auth state, error handling, formatting, API parsing, feature flags, and loading/error-state logic.
- Do not accept refactors that only move complexity across files.

## Production Safety Standards

Check these cross-cutting production risks:

- **Deny-by-default UX:** protected views should default to unauthenticated/unauthorized until auth state is verified.
- **Business logic validation:** validate client-side state transitions, form limits, balances, quotas, expiration, ownership hints, tenant context, and replay/idempotency hints, while requiring backend enforcement.
- **Anti-enumeration:** login, signup, email verification, password reset, magic link, invite, API key, and recovery flows should not reveal account existence when that matters.
- **Fallback safety:** fallbacks must be explicit, safe, observable, and must not hide auth, payment, quota, signing, tenant isolation, or financial integrity failures.
- **API contract consistency:** API response and error shapes should be consistent; breaking changes should update generated clients, schemas, docs, examples, or tests.
- **Shared canonical formats:** payloads, digests, signatures, HMACs, protobufs, binary layouts, challenge formats, and cross-language encodings need fixtures or tests when frontend must match another service/language.
- **No unfinished production paths:** flag `TODO`, `FIXME`, stubs, mocks, fake implementations, empty branches, disabled checks, placeholder logic, mock signers, fake payments, skipped auth, or temporary secrets in critical paths.

## Security Checklist

### Auth, Tokens, and Protected Routes

Check:

- Auth state initializes safely and avoids flashing protected content before verification.
- Route guards and protected layouts redirect or block only as UX; backend auth remains authoritative.
- JWT/session handling validates expiry and refresh behavior without infinite refresh loops.
- Refresh flow is race-safe and does not duplicate requests or overwrite newer auth state.
- Logout clears storage, query caches, auth context/store, websocket state, and sensitive client memory where practical.
- MFA/2FA UX exists for admin or highly sensitive operations when required.
- Login, recovery, invite, magic link, and sensitive flows handle loading/error states without enumeration.
- Cookies use `HttpOnly`, `Secure`, `SameSite`, and correct domain/path scope when cookie auth applies.

### XSS, Injection, and Browser Surface

Check:

- No unsafe HTML rendering without sanitization.
- Markdown, rich text, user-generated content, CMS content, translated strings, and API-provided HTML are sanitized.
- URL params, hash fragments, local/session storage, postMessage, clipboard, files, and API responses are treated as untrusted.
- Open redirects and unsafe external navigation are prevented.
- `target="_blank"` external links use `rel="noopener noreferrer"` when applicable.
- CSP and security headers are configured through framework, hosting, proxy, or meta tags when feasible.
- Third-party scripts have clear purpose, consent behavior, and SRI where useful.
- Forms validate on submit and at appropriate interaction points.

### Privacy, Observability, and Supply Chain

Check:

- Analytics, RUM, session replay, crash reports, and logs do not capture tokens, PII, secrets, financial data, private material, or sensitive form fields.
- Cookie/consent model matches trackers actually loaded.
- Privacy Policy and cookie settings are discoverable when trackers or personal data collection exist.
- Lockfile is committed and installs are deterministic.
- New packages are necessary and reviewed for maintenance, license, security, transitive dependencies, bundle impact, and native/simple alternatives.
- Use `npm audit`, Snyk, Dependabot, Renovate, `npm outdated`, bundle scanners, and dependency update review according to risk.
- Run or recommend secrets scanning with `gitleaks`, `trufflehog`, or equivalent according to risk.

## Robustness Checklist

### UI State, Errors, and Async Flows

Check:

- Error boundaries exist for React or equivalent framework-level error handling.
- `unhandledrejection` and global error events are observed where appropriate.
- Every async user flow has loading, success, empty, error, retry, and disabled/deduped-submit states when relevant.
- Requests use cancellation/abort handling to avoid stale state writes after unmount or route change.
- Forms prevent duplicate submissions for mutating actions.
- Optimistic updates have rollback or reconciliation.
- Websocket/SSE subscriptions, event listeners, intervals, observers, and timers clean up correctly.
- Offline, slow network, expired session, and backend error states are handled for critical flows.

### Data Integrity and API Contracts

Check:

- API clients parse/validate responses before critical UI decisions.
- Generated types, OpenAPI, GraphQL, tRPC, or schemas stay aligned with backend contracts.
- Client-side amount, date, locale, timezone, unit, and decimal formatting does not corrupt financial or security decisions.
- Idempotency keys or duplicate-submit protections exist for sensitive mutations when frontend participates.
- Cache invalidation, query keys, tenant scoping, and user scoping are correct.
- Sensitive data is removed from caches on logout or account switch.

### Tests and Accessibility

Check:

- Unit/component tests cover important UI business rules and security-sensitive rendering.
- Integration/E2E tests cover critical auth, checkout, dashboard, form, upload, and error flows.
- Accessibility tests use axe, jest-axe, Playwright, Cypress, or manual review where risk justifies it.
- Keyboard navigation, focus management, labels, alt text, contrast, reduced motion, and screen-reader semantics are checked.
- Contract tests or schema tests exist for important API integrations.
- Visual regression tests exist for high-risk UI workflows when useful.

## Performance Checklist

Check:

- Hot paths and user-critical flows are identified before optimization.
- Profiling uses Lighthouse, WebPageTest, Web Vitals/RUM, React Profiler, browser performance traces, bundle analyzer, or framework tooling.
- Bundle size, duplicate dependencies, unused dependencies, dynamic imports, route splitting, and tree shaking are reviewed.
- Heavy components use lazy loading, code splitting, virtualization, pagination, or progressive rendering when justified.
- Images use responsive sizing, modern formats, lazy loading, dimensions/aspect ratios, and framework image optimization where available.
- Avoid unnecessary re-renders, unstable props, broad context updates, and expensive derived state in render paths.
- `useMemo`, `useCallback`, and memoization are used only when they solve measured or obvious render problems.
- Debounce/throttle search, resize, scroll, and high-frequency inputs when needed.
- Large payloads use pagination, streaming, partial loading, or background loading.
- Service workers, HTTP caching, CDN, prefetch, preload, and compression are used only when they fit product needs and invalidation risk.
- Memory leaks are checked: listeners, intervals, subscriptions, observers, caches, object URLs, and long-lived stores.

## Build, Deploy, and Maintainability

Check:

- TypeScript compiles in CI with `tsc --noEmit` or framework-native typecheck.
- ESLint, `@typescript-eslint`, security rules, React hooks rules, Prettier, and project-native checks run according to risk.
- Production builds remove debug code, `console.log`, `debugger`, test mocks, mock APIs, and dev-only paths.
- Source maps are disabled or protected in production when they expose sensitive code.
- Env vars are correctly scoped: frontend public prefixes are public, not secret.
- Assets are hashed for cache busting.
- Framework/hosting security config is reviewed: Next.js headers, Vite config, CSP/meta, CDN headers, Netlify/Vercel/Cloudflare settings.
- Code is organized by domain, feature, route, component type, or layer without artificial architecture.
- Critical user-flow rules are not hidden in presentational components or scattered effects.
- Components and hooks are small, cohesive, and low-coupling.
- Constants, enums, branded types, or domain types replace magic strings/numbers in important rules.
- CI runs typecheck, lint, test, build, audit, and scans appropriate to service risk.
- Dead code is identified and recommended for safe removal:
  - unused components, hooks, stores, contexts, types, routes, pages, assets, styles, config, flags, dependencies, and API clients;
  - obsolete branches, impossible states, stale compatibility paths, old scripts no longer referenced, and commented-out code;
  - tests that validate removed behavior or keep obsolete UI alive.

## Recommended Commands

Prefer project-native commands first: `package.json` scripts, `Makefile`, `Taskfile`, `justfile`, CI config, or docs.

Useful TypeScript frontend audit commands:

```bash
npm ci
npm run typecheck
npm run lint
npm test
npm run test:e2e
npm run build
npm audit
npm outdated
npx tsc --noEmit
npx eslint .
npx lighthouse <url>
npx gitleaks detect --source .
npx trivy fs .
```

Adapt package manager commands for pnpm, yarn, bun, or deno. Run mutation commands such as formatting, dependency updates, audit fixes, or snapshot updates only when editing code or when the user asked for fixes.

## What to Flag Aggressively

Escalate:

- Secrets, private keys, admin/internal API keys, or privileged credentials shipped to frontend code.
- Sensitive tokens stored in `localStorage` without strong justification and XSS hardening.
- Unsafe HTML rendering, markdown rendering, `innerHTML`, `dangerouslySetInnerHTML`, `v-html`, or third-party content without sanitization.
- `eval`, `new Function`, string timers, unsafe dynamic scripts, or dynamic import from user input.
- Open redirect, unsafe external URL handling, postMessage trust bugs, or target blank without `noopener`.
- Frontend-only authorization presented as security.
- Protected content flash before auth verification.
- API/user data used without runtime validation in critical flows.
- Financial math or amount formatting that can corrupt decisions.
- Sensitive data leaked to URLs, analytics, RUM, session replay, logs, error reports, screenshots, local/session storage, or browser history.
- Cookie/analytics trackers loading before consent when consent is required.
- Missing loading/error/disabled/deduped-submit states in sensitive mutations.
- Duplicate submissions, stale async writes, bad cache keys, tenant leakage, or cache not cleared on logout/account switch.
- Missing CSRF protection for cookie-authenticated mutations.
- Missing CSP/security headers where the app has browser attack surface.
- Known vulnerable, unnecessary, abandoned, or bundle-bloating dependencies.
- Production source maps, `console.log`, `debugger`, mocks, stubs, fake payments/signers, or dev-only code exposed.
- Accessibility blockers in critical flows.
- Performance rewrites without evidence.
- Bundle bloat, unbounded list rendering, image misuse, memory leaks, or expensive re-renders in proven hot paths.
- Dead code that increases attack surface, hides obsolete behavior, or makes changes riskier.
- Public API contract drift without schema/client/docs/test updates.
- Spaghetti growth, files above 1000 lines, giant components/hooks/stores, weak wrappers, duplicate helpers, or refactors that only move complexity.

## Preferred Remedies

For every confirmed problem, provide the most robust practical solution, not only a warning.

Prefer remedies that remove the class of bug:

- Move secrets and privileged actions to backend/server-only boundaries.
- Use `HttpOnly`, `Secure`, `SameSite` cookies where possible; otherwise minimize token lifetime and storage exposure.
- Centralize auth state, route guards, logout cleanup, and query/cache clearing.
- Add strict runtime schemas for API responses, forms, URL params, storage, and postMessage.
- Sanitize user/CMS/markdown HTML with a vetted sanitizer and narrow allowed tags/attributes.
- Add CSP/security headers through framework/hosting/proxy configuration.
- Use allowlists for redirects, external links, embeds, postMessage origins, and third-party scripts.
- Add consent gating before analytics/marketing/session replay initialization.
- Move critical business rules into domain helpers/hooks with tests and backend enforcement.
- Add robust loading, error, retry, disabled, empty, stale-request, and duplicate-submit handling.
- Use AbortController/cancellation and cleanup effects for async flows.
- Add idempotency or duplicate-submit protection for sensitive mutations.
- Fix cache keys, tenant scoping, and logout/account-switch cache clearing.
- Add accessibility fixes: labels, focus management, keyboard support, contrast, alt text, reduced motion, and semantic roles.
- Split oversized components into data boundary, state hook, presentational component, and domain helper.
- Delete weak wrappers/components/hooks when direct use is clearer and equally testable.
- Add code splitting, lazy loading, virtualization, image optimization, or memoization only where justified.
- Prefer platform/framework APIs or existing helpers before new dependencies.
- Remove proven dead code and obsolete UI paths.
- Add unit, component, E2E, accessibility, contract, visual regression, performance, or security tests where they prove the invariant.

When multiple remedies exist, distinguish:

- **Robust solution:** preferred production-grade fix.
- **Fast mitigation:** acceptable temporary risk reduction, only when useful.
- **Validation:** tests, scans, Lighthouse/Web Vitals, screenshots, accessibility checks, or manual browser checks required to prove the fix.

## Review Tone

Be formal, direct, and practical.
Do not soften token leakage, XSS, privacy, accessibility, financial, or production-build risk.
Avoid cosmetic comments when larger risks exist.
Separate confirmed issues from assumptions.
If evidence is missing, say exactly what should be checked.

Good phrases:

- `This secret is bundled into client code. Move it behind a server-side boundary.`
- `This token storage choice is exposed to XSS. Prefer HttpOnly cookies or reduce the blast radius.`
- `This HTML reaches the DOM without sanitization. Add a sanitizer and restrict allowed markup.`
- `This route guard only protects the UI. The backend must enforce authorization.`
- `This API response is trusted without runtime validation. Add a schema at the boundary.`
- `This mutation can be submitted twice. Add disabled state and idempotency where needed.`
- `This accessibility gap blocks a critical user flow. Fix it before release.`
- `This performance change needs Lighthouse/Web Vitals or profiling evidence before adding complexity.`

## Output Expectations

Start with an **Executive Snapshot**:

- Overall risk: Critical, High, Medium, or Low
- Release stance: Block release, release after fixes, or no major blocker found
- Scope reviewed: routes/components/flows/configs actually inspected
- Top risks: 3-5 highest-impact issues or residual concerns
- Validation run or still needed

Prioritize findings:

1. Token leakage, XSS, frontend secret exposure, account compromise, or privacy risks
2. Authentication UX, route protection, backend authorization assumptions, and tenant/user data leakage
3. Runtime validation, injection, open redirect, unsafe URL, postMessage, CSRF, and browser security risks
4. Financial, payment, wallet, signing, checkout, duplicate mutation, and business-flow risks
5. Async state, cache, stale request, logout cleanup, error boundary, and robustness risks
6. Accessibility, privacy consent, analytics, and compliance-adjacent risks
7. Production build, source maps, dependency, supply-chain, and configuration risks
8. Performance issues supported by evidence
9. Structural quality, dead code, weak abstraction, and maintainability risks

For each finding include:

- Severity: Critical, High, Medium, or Low
- Status: Issue, Partial, or Not applicable when relevant
- Confidence: High, Medium, or Low
- File and line reference when available
- Evidence
- What can go wrong
- Why it matters
- Robust solution
- Fast mitigation when appropriate
- Validation commands, tests, or browser checks

After findings, include a **Recommended Fix Plan** ordered by risk and dependency. The plan must be concrete enough for an agent to implement without guessing, naming visible files, components, routes, hooks, tests, and commands when available.

If no serious findings are found, say that clearly and list residual risks or tests not run.

## Approval Bar

Do not approve a TypeScript frontend for production while any of these remain unresolved:

- Secrets or privileged credentials bundled into client code.
- Sensitive tokens stored unsafely without justified tradeoff and XSS hardening.
- Unsafe HTML/user content rendering without sanitizer.
- Frontend-only authorization relied on for real security.
- Protected sensitive content visible before auth verification.
- Critical API/user data used without runtime validation.
- Sensitive data leaked through URLs, analytics, storage, logs, error monitoring, or source maps.
- Cookie/session mutation flow missing required CSRF protection.
- Non-essential trackers load before required consent.
- Critical payment, wallet, signing, or account mutation can be duplicated or submitted stale.
- Critical async flow lacks loading/error/cancellation/cleanup handling.
- Accessibility blocker prevents completion of critical flows.
- Production build exposes source maps, mocks, fake payments/signers, debug code, or dev-only paths.
- Known reachable vulnerable dependency.
- Shared canonical format changes without compatibility tests or fixtures.
- Large tangled components/hooks/stores or weak abstractions that make critical code hard to audit.
- Missing tests around critical auth, token, XSS, payment, validation, accessibility, or async-state logic.

If approval is blocked, give the shortest robust path to make the project safe enough for the next review.

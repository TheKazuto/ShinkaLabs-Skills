# TypeScript Backend Security and Performance Audit

Use this skill to audit TypeScript/Node.js backend projects with strong focus on financial safety, API security, runtime robustness, event-loop safety, production readiness, performance, and maintainable backend design.

Skill metadata:

- Version: 1.0.0
- License: MIT

Prioritize:

1. Financial and user safety
2. Authentication, authorization, tenant isolation, and input validation
3. Type safety, runtime validation, and event-loop safety
4. Robustness under failure and production traffic
5. Performance based on evidence
6. Simple, explicit, maintainable TypeScript backend code

## Core Prompt

Start from this baseline:

> Perform a strict audit of this TypeScript backend project.
> Prioritize security, robustness, event-loop safety, runtime validation, performance, production safety, and code quality.
> Look for issues that could cause unauthorized access, financial loss, data exposure, process crashes, unhandled rejections, event-loop blocking, race conditions, resource exhaustion, poor scalability, or long-term code risk.
> Review the code like a production backend or financial service, even if it is still an MVP.
> For every confirmed problem, provide the most robust practical solution, plus validation steps.

The audit is complete only after every applicable standard has been checked and every finding includes a robust solution and validation path.

## Scope Selection

First identify the project shape:

- Public API, internal API, worker/background job, CLI, daemon, library, serverless function, or mixed service.
- Framework/runtime: Express, NestJS, Fastify, Hono, Koa, Next.js route handlers, tRPC, GraphQL, BullMQ worker, Node.js, Bun, or Deno.
- Auth model: JWT, session, API key, internal key, mTLS, OAuth2/OIDC, webhook signature, or none.
- Dependencies: database, ORM/ODM, cache, queue, external HTTP/RPC, file upload, webhooks, crypto/signing, billing, quota, or payment flow.
- Risk profile: SaaS, DeFi, custody-free signing, wallet, exchange, accounting, billing, tenant data, sensitive data, public production surface, or high-throughput service.

Mark items as not applicable only with a clear reason.

## Evidence and Traceability Protocol

Use a traceable audit flow for non-trivial repositories:

- Inspect code incrementally by package, module, route, controller, middleware, guard, service, repository, worker, job, integration, or business flow.
- Do not mark an area as safe without citing concrete evidence: file, function, route, config, test, command output, schema, middleware, or observed invariant.
- If repository size or context limits prevent full coverage, state what was reviewed, what was not reviewed, and which high-risk areas remain.
- Track each meaningful area with one of these statuses:
  - **Verified:** evidence supports the control or invariant.
  - **Issue:** evidence shows a concrete problem.
  - **Partial:** evidence is incomplete or the control exists but has gaps.
  - **Not applicable:** the area does not apply, with reason.
- Add a confidence level to important findings when certainty is not absolute: High, Medium, or Low.
- Use lower confidence when dynamic typing, `any`, runtime config, generated clients, decorators, DI containers, build steps, external services, migrations, or deployment context make behavior harder to prove.

## Non-Negotiable Standards

Apply these rules aggressively:

1. **Auth and ownership must fail closed.**
   - Sensitive endpoints require authentication.
   - Authorization must validate resource ownership, tenant isolation, role/scope, and object-level access.
   - Missing, malformed, expired, or unverifiable auth context must deny access.
   - Admin, internal, debug, metrics, billing, signing, recovery, and financial flows require explicit privilege.

2. **Financial and state-changing operations must be safe.**
   - Never use floating point for money, token balances, fees, shares, billing, or quotas.
   - Prefer integer base units, decimal libraries, branded/domain amount types, and explicit rounding rules.
   - Mutating financial, billing, quota, token, consumption, or single-use operations need transactions, conditional updates, idempotency, locks, or another clear consistency control.
   - Retry only idempotent operations or operations protected by idempotency keys.

3. **Runtime input must be validated before business logic.**
   - TypeScript types do not validate runtime data.
   - Validate request bodies, query/path params, headers, webhooks, callbacks, URLs, file names, uploads, base64, hex, addresses, enums, amounts, dates, and limits.
   - Use strict schemas with Zod, Joi, class-validator, express-validator, Ajv, or equivalent.
   - Reject unknown fields when contract strictness matters; use allowlists for sorting, filtering, includes, redirects, callbacks, and dynamic query fields.

4. **Secrets and sensitive data must not leak.**
   - Logs, metrics, traces, errors, responses, source maps, and crash reports must not expose passwords, tokens, API keys, cookies, Authorization headers, private keys, seed phrases, magic links, signatures, raw secrets, or sensitive PII.
   - Public errors must be stable and sanitized, preferably with `requestId` or `traceId`.

5. **The event loop must not be blocked.**
   - Do not run heavy CPU loops, sync filesystem, sync crypto, compression, parsing, or blocking calls in request paths.
   - Use streams, worker threads, queues, background jobs, or async APIs for heavy work.
   - Monitor event-loop lag and memory leaks in production-grade services.

6. **Failure handling must be explicit.**
   - External calls and database operations require timeouts, cancellation/abort signals, or client-level deadlines.
   - Handle `uncaughtException` and `unhandledRejection` with logging, alerting, and graceful shutdown strategy.
   - EventEmitters, streams, queues, and background jobs need error handlers.

7. **Fix root causes, not symptoms.**
   - Do not recommend one-off guards, scattered `if`s, or silent fallback when the real problem is a missing invariant, weak boundary, broken state model, type hole, or scattered policy.
   - Prefer fixing the schema, domain model, validation boundary, auth policy, transaction boundary, idempotency design, or canonical helper.

8. **Optimize only with evidence.**
   - Require profiling, load tests, APM, `clinic`, `0x`, heap snapshots, metrics, or clear hot-path evidence before complex performance changes.
   - Simple, readable TypeScript wins over speculative micro-optimization.

## TypeScript and Node Safety Standards

Audit TypeScript and Node-specific risk as part of production safety:

- `tsconfig.json` should enable strictness, especially `strict`, `noImplicitAny`, `strictNullChecks`, `noImplicitReturns`, and `useUnknownInCatchVariables` when practical.
- Avoid `any`; prefer `unknown` plus type guards, schemas, or branded/domain types.
- Use branded types or domain wrappers for sensitive IDs, tenant IDs, wallet/account IDs, money, states, permissions, roles, and units.
- Avoid non-null assertions (`!`), unchecked casts, broad `as`, and optional chains that hide missing invariants in critical paths.
- Disable production source maps or ensure they are not publicly exposed.
- Avoid `eval`, `new Function`, dynamic `require/import` from user input, unsafe template execution, and shell execution with unsanitized input.
- Use `execFile`/spawn with fixed command and argument arrays instead of `exec` when shelling out is required.
- Avoid ReDoS-prone regexes; validate with safe-regex tools or simpler parsing.
- Validate `Content-Type`, body size, file size, file type, and upload storage rules.

## Structural Quality Standards

Audit maintainability as part of safety. A secure patch that leaves tangled code is not robust when a clearer path is visible.

- Look for structural simplification: delete branches, flags, wrappers, helper layers, or special cases when a better model makes them unnecessary.
- Fight spaghetti growth in controllers, handlers, services, repositories, workers, queues, guards, pipes, and middleware.
- Keep logic in the canonical layer:
  - controllers/handlers parse protocol input and shape responses;
  - middleware/guards handle authentication and coarse access control;
  - domain/use-case code owns business rules, authorization policy, idempotency, and transaction boundaries;
  - repositories/adapters own persistence and external integration details.
- Treat files above 1000 lines, giant services/controllers, generic `utils` dumping grounds, and unrelated responsibilities as strong maintainability smells.
- Reject weak abstractions: pass-through services, repositories, wrappers, managers, helpers, decorators, or internal frameworks that do not make code safer or simpler.
- Reuse canonical helpers before creating new ones; consolidate repeated validation, auth, logging redaction, retry, timeout, transaction, amount conversion, and error response logic.
- Do not accept refactors that only move complexity across files.

## Production Safety Standards

Check these cross-cutting production risks:

- **Deny-by-default and least privilege:** scopes, roles, API keys, service credentials, database grants, npm tokens, CI permissions, and internal endpoints should be narrow and explicit.
- **Business logic validation:** validate state transitions, balances, quotas, limits, expiration, ownership, tenant, replay status, token consumption, webhook state, and permission context.
- **Anti-enumeration:** login, signup, email verification, password reset, magic link, invite, API key lookup, and recovery flows should not reveal whether a user, tenant, key, or account exists when that matters.
- **Fallback safety:** fallbacks must be explicit, safe, observable, documented, and must never bypass auth, billing, quota, signing, tenant isolation, idempotency, recovery, or financial integrity.
- **API contract consistency:** public endpoints should be versioned when consumers depend on them; JSON responses and errors should follow a consistent documented shape; breaking changes should update docs, OpenAPI, examples, clients, or Postman collections when present.
- **Shared canonical formats:** payloads, digests, signatures, HMACs, protobufs, binary layouts, challenge formats, and cross-language encodings need fixtures or tests when TypeScript must match another service or language.
- **No unfinished production paths:** flag `TODO`, `FIXME`, stubs, mocks, fake implementations, empty branches, disabled checks, placeholder logic, mock signers, fake billing, skipped auth, or temporary secrets in critical paths.

## Security Checklist

### Auth, Sessions, and API Access

Check:

- Auth model matches risk: JWT, session, API key, internal key, mTLS, OAuth2/OIDC, webhook signature, or another secure pattern.
- Auth middleware, guards, pipes, and decorators are centralized and reused.
- JWT validation is strict when used: `iss`, `aud`, `exp`, `nbf`, `sub`, `jti`, and expected algorithm. Do not accept unexpected algorithms.
- Tokens expire appropriately; refresh tokens rotate and can be revoked when used.
- Logout invalidates sessions or revocable tokens where the model supports it.
- Passwords use Argon2id, bcrypt, scrypt, or PBKDF2. Never accept plaintext, MD5, SHA-1, or plain SHA-256 for passwords.
- MFA/2FA exists for admin accounts or highly sensitive operations.
- Login, recovery, refresh token, admin, and sensitive operations have rate limits per IP and user/account where appropriate.
- Secrets or tokens are compared with timing-safe equality where relevant.
- Cookie sessions use `HttpOnly`, `Secure`, `SameSite`, and correct domain/path scope.
- Production session stores use Redis/Memcached/database, not memory stores.

### Input, Injection, and Browser Surface

Check:

- Runtime schemas protect all external boundaries.
- Business rules are validated after input shape.
- SQL uses ORM/query builder/prepared statements; NoSQL input is sanitized; filesystem paths prevent traversal; command execution avoids unsanitized input.
- HTTP parameter pollution is mitigated where frameworks expose ambiguous arrays/duplicates.
- Uploads and large bodies have size, type, extension, scanning, and storage controls.
- CSRF protection exists for cookie/session/browser form/OAuth redirect flows.
- XSS risk is reviewed when rendering HTML, templates, emails, markdown, or browser-visible content.
- Helmet or equivalent security headers are configured: HSTS, `nosniff`, frame protection or CSP `frame-ancestors`, CSP, `Referrer-Policy`, and related headers.
- `X-Powered-By` and unnecessary framework/version banners are removed.
- CORS uses strict allowlists and never uses `*` for authenticated production endpoints.
- HTTPS/TLS is mandatory in production through the service, proxy, load balancer, or edge.

### Secrets, Logs, and Attack Resistance

Check:

- Secrets live in env vars, secret manager, Vault, KMS, Doppler, cloud secret stores, or equivalent. Real `.env` files are not committed.
- `.env.example` documents required variables without real secrets.
- Logs use Pino, Winston, OpenTelemetry, or equivalent, are structured/redacted, and have enough context for investigation.
- Critical actions have audit logs: actor, action, time, resource, tenant, and request/trace id where applicable.
- SSRF is mitigated for user-controlled URLs; redirects and callbacks use allowlists.
- Replay attacks are blocked with nonce, single-use token, signature, timestamp window, or idempotency key where needed.
- Large payloads are limited before expensive work.
- ReDoS, prototype pollution, mass assignment, and insecure deserialization risks are reviewed.

### Supply Chain and Dependencies

Check:

- Lockfile is committed: `package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, or equivalent.
- CI uses deterministic install: `npm ci`, `pnpm install --frozen-lockfile`, or equivalent.
- Production builds install only production dependencies where applicable.
- New packages are necessary and reviewed for maintenance, license, security, transitive dependencies, and native/simple alternatives.
- Use `npm audit`, Snyk, Dependabot, Renovate, `npm outdated`, and dependency update review according to risk.
- npm publishing or CI credentials use 2FA/OIDC/trusted publishing and minimal permissions when relevant.
- Run or recommend secrets scanning with `gitleaks`, `trufflehog`, or equivalent according to risk.
- Docker images are scanned when present.

## Robustness Checklist

### Errors, Config, and Deployment

Check:

- Global error handler sanitizes public errors and preserves internal context.
- Operational errors and programmer errors are separated where useful.
- `uncaughtException` and `unhandledRejection` behavior is explicit and leads to safe shutdown when appropriate.
- EventEmitters, streams, queues, schedulers, and workers have error listeners.
- Circuit breakers protect critical unstable dependencies where appropriate.
- Partial failure behavior is explicit: fail closed, safe fallback, or observable degradation.
- Config comes from env vars, safe config, or secret manager; critical config is validated at boot with Zod/envalid/joi or equivalent.
- Unsafe production defaults are rejected.
- Liveness and readiness checks exist when appropriate.
- Graceful shutdown drains HTTP servers, workers, queues, database pools, cache clients, and external clients.
- Feature flags, canary, or rollback strategy exists for risky auth, billing, signing, recovery, or production behavior changes.

### Concurrency and Data Integrity

Check:

- Request-created async work is bounded, cancellable, and has backpressure.
- Queues, workers, schedulers, and long-running tasks have ownership, retry policy, idempotency, and dead-letter behavior.
- Race conditions, duplicate processing, queue replay, and concurrent mutations are considered.
- Connection pools fit the database and replica count.
- Critical queries and external calls have timeouts or abort signals.
- Transactions protect atomic operations.
- Migrations are versioned, reproducible, and safe for multi-replica deploys.
- Indexes exist for frequent queries, filters, joins, and foreign keys.
- List endpoints use pagination.
- Critical queries are reviewed with `EXPLAIN`/`ANALYZE` or equivalent.
- Backup, restore, and point-in-time recovery exist for critical data.

### Tests and Observability

Check:

- Unit tests cover important business rules and security invariants.
- Integration/E2E tests cover critical database, cache, webhook, queue, and external-service flows.
- Contract tests exist for public APIs or important external integrations.
- Load tests exist for public APIs, hot paths, or spike-prone endpoints.
- Security tests use OWASP ZAP, Burp, dependency scans, or equivalent when risk justifies it.
- Property-based tests exist for parsers, codecs, serialization, and strong invariants.
- Metrics cover latency, throughput, error rate, saturation, event-loop lag, CPU, memory, heap, database/cache usage, queue depth, and external connections where useful.
- Metrics cardinality is controlled.
- Logs include request, trace, tenant, user, resource, or API key id where applicable.
- Alerts exist for error rate, latency, dependency failure, queue backlog, stalled workers, event-loop lag, memory leaks, and resource exhaustion.

## Performance Checklist

Check:

- Hot paths are identified before optimization.
- Profiling uses `clinic`, `0x`, `node --inspect`, heap snapshots, APM, flamegraphs, or equivalent.
- Benchmarks/load tests exist for critical functions/endpoints where performance matters.
- Event-loop lag, memory leaks, large object retention, excessive JSON serialization, copy-heavy paths, and unnecessary awaits are investigated in proven hot paths.
- Blocking CPU or sync I/O is not run directly inside request paths.
- Heavy work uses workers, worker threads, queues, streams, batching, or background jobs.
- Database queries avoid N+1, `SELECT *`, full scans, unbounded list responses, and long transactions.
- Connection pools, HTTP agents, clients, and transports are reused and configured.
- Cache is used only when it reduces real cost without breaking security or consistency.
- Sensitive, auth, token, and tenant-specific data is not cached without explicit controls.
- Cache has TTL, invalidation, or clear consistency rules.
- Batching/streaming is used when it reduces cost without breaking atomicity or loading huge responses into memory.
- Read replicas and sharding are considered only after evidence of need.
- HTTP clients and server timeouts are configured; compression is placed in proxy/app where measurable and safe.
- Services are stateless where possible; shared state lives in database, cache, queue, or storage.
- Clustering, PM2, containers, or horizontal scaling are considered only when operationally appropriate.

## Maintainability and Dead Code

Check:

- TypeScript compiles in CI with `tsc --noEmit`.
- ESLint, `@typescript-eslint`, security rules, Prettier, and project-native checks run according to risk.
- Code is organized by domain, feature, bounded context, or layer without artificial architecture.
- Critical business rules are not hidden in controllers, middleware, adapters, decorators, logging, or persistence plumbing.
- Functions are small, cohesive, and low-coupling.
- Constants, enums, branded types, or domain types replace magic strings/numbers in important rules.
- CI runs typecheck, lint, test, build, audit, and scans appropriate to service risk.
- Dockerfiles use multi-stage builds, minimal images, and non-root user when applicable.
- Technical documentation covers architecture, endpoints, env vars, security decisions, and important behavior when they affect operation or API consumers.
- Dependency licenses are compatible with the project.
- Dead code is identified and recommended for safe removal:
  - unused functions, methods, classes, interfaces, types, enums, constants, variables, modules, files, routes, handlers, workers, jobs, commands, configs, flags, and dependencies;
  - obsolete branches, impossible states, stale compatibility paths, old scripts/migrations no longer referenced, and commented-out code;
  - tests that validate removed behavior or keep obsolete code alive.

## Recommended Commands

Prefer project-native commands first: `package.json` scripts, `Makefile`, `Taskfile`, `justfile`, CI config, or docs.

Useful TypeScript backend audit commands:

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
npx gitleaks detect --source .
npx trivy fs .
```

Adapt package manager commands for pnpm, yarn, bun, or deno. Run mutation commands such as formatting, dependency updates, or audit fixes only when editing code or when the user asked for fixes.

## What to Flag Aggressively

Escalate:

- Unauthenticated or weakly protected sensitive endpoints.
- Missing object-level authorization, ownership checks, tenant isolation, deny-by-default, or least privilege.
- Financial math using floats without decimal/base-unit safeguards.
- Non-atomic or non-idempotent financial, billing, quota, token, consumption, or single-use operations.
- SQL/NoSQL injection, SSRF, path traversal, open redirect, command injection, unsafe deserialization, weak JWT validation, or unexpected JWT algorithms.
- Token, key, password, PII, signature, cookie, Authorization header, private material, source map, or secret leakage.
- Missing rate limits on public auth or sensitive flows.
- Missing timeouts, abort signals, circuit breakers, error listeners, or graceful shutdown in critical paths.
- `uncaughtException`, `unhandledRejection`, stream errors, queue errors, or EventEmitter errors without safe handling.
- Blocking event-loop work in request paths.
- Async work, queues, jobs, or retries that can duplicate mutating operations.
- Business logic that validates request shape but not current domain state.
- Silent fallback hiding auth, billing, quota, signing, recovery, tenant isolation, idempotency, or financial integrity failure.
- User/account/key enumeration through status, body, timing, or error detail.
- Public admin, debug, metrics, profiling, or framework/version endpoints without protection.
- CORS wildcard on authenticated production endpoints.
- Secrets committed to the repo or embedded in code.
- Known vulnerable, unnecessary, abandoned, or bloated dependencies.
- Docker containers running as root without reason.
- Sensitive or tenant-specific cache without safe keying, TTL, and invalidation.
- Performance rewrites without evidence.
- ReDoS-prone regex, `eval`, `new Function`, dynamic import/require from user input, or shell execution from unsanitized input.
- Overuse of `any`, broad casts, non-null assertions, or optional fallbacks that hide missing invariants in critical paths.
- Dead code that increases attack surface, keeps old unsafe paths alive, hides obsolete behavior, or makes changes riskier.
- TODO, FIXME, stubs, mocks, fake implementations, disabled checks, or placeholder logic in critical paths.
- Public API contract drift without versioning, docs, examples, or schema updates.
- Shared canonical payload/digest/signature/webhook/protobuf/binary changes without fixture/test updates.
- Spaghetti growth, files above 1000 lines, giant controllers/services, weak wrappers, duplicate helpers, or refactors that only move complexity.

## Preferred Remedies

For every confirmed problem, provide the most robust practical solution, not only a warning.

Prefer remedies that remove the class of bug:

- Centralize auth middleware/guards, authorization policy, ownership checks, and deny-by-default behavior.
- Move critical business rules into domain/use-case code with tests.
- Use integer base units, decimal libraries, explicit rounding, or domain amount types for financial values.
- Use strict runtime schemas, typed request models, explicit validators, and clear error responses.
- Use allowlists for dynamic fields, redirects, callbacks, sorting, filtering, and includes.
- Replace `any` and broad casts with `unknown`, schemas, branded types, type guards, or domain types.
- Wrap critical state changes in transactions, conditional updates, locks, or idempotency guarantees.
- Add timeouts/abort signals at client, repository, database, queue, and upstream boundaries.
- Move heavy work to queues, workers, streams, or worker threads instead of blocking the event loop.
- Add centralized error handling for HTTP, workers, queues, EventEmitters, streams, and process-level failures.
- Add redaction helpers used by all logging paths.
- Fix root causes by strengthening invariants, state models, schemas, policies, transaction boundaries, type models, or canonical helpers.
- Make fallbacks explicit, safe, observable, and documented.
- Add anti-enumeration responses for identity, key, invite, and recovery flows.
- Keep API response/error envelopes consistent and version public endpoints.
- Add fixtures and cross-language tests for shared canonical formats.
- Prefer standard library, platform APIs, or existing helpers before new dependencies.
- Remove proven dead code and obsolete paths.
- Split oversized controllers/services into parsing, authorization, domain operation, persistence, async orchestration, and response mapping.
- Delete weak wrappers when direct calls are clearer and equally testable.
- Add unit, integration, E2E, contract, security, benchmark, property, or load tests where they prove the invariant.

When multiple remedies exist, distinguish:

- **Robust solution:** preferred production-grade fix.
- **Fast mitigation:** acceptable temporary risk reduction, only when useful.
- **Validation:** tests, scans, benchmarks, DAST, profiling, or manual checks required to prove the fix.

## Review Tone

Be formal, direct, and practical.
Do not soften security, financial, runtime validation, or production crash risk.
Avoid cosmetic comments when larger risks exist.
Separate confirmed issues from assumptions.
If evidence is missing, say exactly what should be checked.

Good phrases:

- `This endpoint changes sensitive state but I do not see authentication or authorization. This should block release.`
- `This reads a tenant-scoped resource without validating ownership. This creates an IDOR risk.`
- `TypeScript types do not validate this request at runtime. Add a strict schema before business logic.`
- `This uses floating point for financial values. Use integer base units or a decimal type.`
- `This code can block the event loop in a request path. Move it to async I/O, a worker, or a queue.`
- `This retry can duplicate a mutating operation. Add idempotency or make the operation transactional.`
- `This fallback hides a critical failure. Make the failure explicit, observable, and fail closed.`
- `This performance change needs profiling evidence before adding complexity.`

## Output Expectations

Start with an **Executive Snapshot**:

- Overall risk: Critical, High, Medium, or Low
- Release stance: Block release, release after fixes, or no major blocker found
- Scope reviewed: packages/modules/flows/configs actually inspected
- Top risks: 3-5 highest-impact issues or residual concerns
- Validation run or still needed

Prioritize findings:

1. Financial loss, payment, billing, quota, token, or balance risks
2. Authentication, authorization, tenant isolation, and ownership failures
3. Runtime validation, type safety, injection, SSRF, path traversal, secret exposure, and browser/API security risks
4. Data integrity, transactionality, idempotency, replay, and business-logic risks
5. Event-loop blocking, async job, queue, timeout, process crash, and fallback risks
6. Production reliability, observability, deploy, and API contract risks
7. Performance issues supported by evidence
8. Dependency, supply-chain, Docker, npm/CI, and configuration risks
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
- Validation commands or tests

After findings, include a **Recommended Fix Plan** ordered by risk and dependency. The plan must be concrete enough for an agent to implement without guessing, naming visible files, functions, tests, and commands when available.

If no serious findings are found, say that clearly and list residual risks or tests not run.

## Approval Bar

Do not approve a TypeScript backend for production while any of these remain unresolved:

- Sensitive public endpoint without auth.
- Missing ownership, tenant isolation, deny-by-default, or least-privilege boundary.
- Financial values represented with floats without safe amount handling.
- Mutating financial/quota/token operation without atomicity or idempotency.
- Secrets, tokens, keys, signatures, auth headers, source maps, or sensitive PII leaking to logs or responses.
- SQL/NoSQL injection, SSRF, path traversal, open redirect, command injection, unsafe deserialization, or weak JWT path.
- External input reaches business logic without runtime schema validation.
- Critical external calls or database operations without timeout/abort handling.
- Blocking event-loop work in request paths.
- Unhandled process, stream, queue, worker, or EventEmitter errors in critical paths.
- Public admin, debug, metrics, or profiling endpoints without protection.
- Known reachable vulnerable dependency.
- Critical business logic validated only by request shape, not domain state.
- Silent fallback hiding auth, billing, quota, tenant isolation, signing, recovery, or financial integrity failure.
- Stub, mock, TODO, disabled check, or placeholder logic in production-critical paths.
- Shared canonical format changes without compatibility tests or fixtures.
- Security, auth, transaction, timeout, validation, or redaction logic scattered across many paths where a canonical boundary is needed.
- Large tangled controllers/services or weak abstractions that make critical code hard to audit.
- Missing tests around critical money, auth, permission, idempotency, runtime validation, async jobs, or concurrency logic.

If approval is blocked, give the shortest robust path to make the project safe enough for the next review.

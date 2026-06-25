---
name: go-audit-optimizer
description: Audit and optimize Go codebases for security, robustness, performance, dead code, and structural quality. Use for Go/Golang backend, API, worker, DeFi, financial, multi-tenant, database, queue, external-call, or production-readiness reviews.
---

# Go Security and Performance Audit

Use this skill to audit Go projects with strong focus on financial safety, backend security, robustness, production readiness, performance, and maintainable Go design.

Skill metadata:

- Version: 1.0.0
- License: MIT

Prioritize:

1. Financial and user safety
2. Authentication, authorization, tenant isolation, and input validation
3. Robustness under failure, concurrency, and production traffic
4. Performance based on evidence
5. Simple, explicit, maintainable Go code

## Core Prompt

Start from this baseline:

> Perform a strict audit of this Go project.
> Prioritize security, robustness, performance, production safety, and code quality.
> Look for issues that could cause unauthorized access, financial loss, data exposure, service instability, race conditions, resource exhaustion, poor scalability, or long-term code risk.
> Review the code like a production backend or financial service, even if it is still an MVP.
> For every confirmed problem, provide the most robust practical solution, plus validation steps.

The audit is complete only after every applicable standard has been checked and every finding includes a robust solution and validation path.

## Scope Selection

First identify the project shape:

- Public API, internal API, worker/background job, CLI, daemon, library, or mixed service.
- Auth model: JWT, session, API key, internal key, mTLS, OAuth2/OIDC, webhook signature, or none.
- Dependencies: database, cache, queue, external HTTP/RPC, file upload, webhooks, crypto/signing, billing, quota, or payment flow.
- Risk profile: DeFi, custody-free signing, wallet, exchange, accounting, billing, tenant data, sensitive data, or public production surface.

Mark items as not applicable only with a clear reason.

## Non-Negotiable Standards

Apply these rules aggressively:

1. **Auth and ownership must fail closed.**
   - Sensitive endpoints require authentication.
   - Authorization must validate resource ownership, tenant isolation, role/scope, and object-level access.
   - Missing, malformed, expired, or unverifiable auth context must deny access.
   - Admin, internal, debug, metrics, billing, signing, recovery, and financial flows require explicit privilege.

2. **Financial and state-changing operations must be safe.**
   - Never use `float32` or `float64` for money, token balances, fees, shares, billing, or quotas.
   - Prefer integer base units, fixed decimal types, or domain-specific amount types.
   - Mutating financial, billing, quota, token, consumption, or single-use operations need transactions, conditional updates, idempotency, locks, or another clear consistency control.
   - Retry only idempotent operations or operations protected by idempotency keys.

3. **External input must be constrained before business logic.**
   - Validate request bodies, query/path params, headers, webhooks, callbacks, URLs, file names, uploads, base64, hex, addresses, enums, amounts, dates, and limits.
   - Reject unknown JSON fields when contract strictness matters.
   - Enforce max payload sizes before expensive decoding.
   - Use SQL parameters or safe query builders; use allowlists for sorting, filtering, includes, redirects, callbacks, and dynamic query fields.

4. **Secrets and sensitive data must not leak.**
   - Logs, metrics, traces, errors, and responses must not expose passwords, tokens, API keys, cookies, Authorization headers, private keys, seed phrases, magic links, signatures, raw secrets, or sensitive PII.
   - Public errors must be stable and sanitized, preferably with `requestId` or `traceId`.

5. **Timeouts, cancellation, and concurrency must be controlled.**
   - External calls and database operations require timeout or cancellation.
   - Propagate `context.Context` through request, repository, worker, and upstream boundaries.
   - Goroutines must have lifecycle ownership, cancellation, bounds, and backpressure when needed.
   - Run or recommend `go test -race` for relevant concurrent code.

6. **Fix root causes, not symptoms.**
   - Do not recommend one-off guards, scattered `if`s, or silent fallback when the real problem is a missing invariant, weak boundary, broken state model, or scattered policy.
   - Prefer fixing the domain model, validation boundary, auth policy, transaction boundary, idempotency design, or canonical helper.

7. **Optimize only with evidence.**
   - Require `pprof`, `go tool trace`, benchmarks, load tests, metrics, or clear hot-path evidence before complex performance changes.
   - Simple, readable Go wins over speculative micro-optimization.

## Structural Quality Standards

Audit maintainability as part of safety. A secure patch that leaves tangled code is not robust when a clearer path is visible.

- Look for structural simplification: delete branches, flags, wrappers, helper layers, or special cases when a better model makes them unnecessary.
- Fight spaghetti growth in handlers, services, repositories, and workers.
- Keep logic in the canonical layer:
  - handlers parse HTTP and shape responses;
  - middleware/shared packages handle authentication;
  - domain/use-case code owns business rules, authorization policy, idempotency, and transaction boundaries;
  - repositories/stores own persistence details.
- Treat files above 1000 lines, large handlers/services, generic `utils` dumping grounds, and unrelated responsibilities as strong maintainability smells.
- Reject weak abstractions: one-implementation interfaces without purpose, pass-through services, wrappers, managers, factories, helpers, or internal frameworks that do not make the code safer or simpler.
- Reuse canonical helpers before creating new ones; consolidate repeated validation, auth, logging redaction, retry, timeout, transaction, amount conversion, and error response logic.
- Do not accept refactors that only move complexity across files.
- Keep Go explicit: plain functions, clear structs, small interfaces, explicit errors, minimal reflection, no surprising package-level side effects unless justified.

## Production Safety Standards

Check these cross-cutting production risks:

- **Deny-by-default and least privilege:** scopes, roles, API keys, service credentials, database grants, and internal endpoints should be narrow and explicit.
- **Business logic validation:** validate state transitions, balances, quotas, limits, expiration, ownership, tenant, replay status, token consumption, webhook state, and permission context.
- **Anti-enumeration:** login, signup, email verification, password reset, magic link, invite, API key lookup, and recovery flows should not reveal whether a user, tenant, key, or account exists when that matters.
- **Fallback safety:** fallbacks must be explicit, safe, observable, documented, and must never bypass auth, billing, quota, signing, tenant isolation, idempotency, recovery, or financial integrity.
- **API contract consistency:** public endpoints should be versioned when consumers depend on them; JSON responses and errors should follow a consistent documented shape; breaking changes should update docs, OpenAPI, examples, clients, or Postman collections when present.
- **Shared canonical formats:** payloads, digests, signatures, HMACs, protobufs, binary layouts, challenge formats, and cross-language encodings need fixtures or tests when Go must match another service or language.
- **No unfinished production paths:** flag `TODO`, `FIXME`, stubs, mocks, fake implementations, empty branches, disabled checks, placeholder logic, mock signers, fake billing, skipped auth, or temporary secrets in critical paths.

## Security Checklist

### Auth, Sessions, and API Access

Check:

- Auth model matches risk: JWT, session, API key, internal key, mTLS, OAuth2/OIDC, webhook signature, or another secure pattern.
- Auth middleware is centralized and reused.
- JWT validation is strict when used: `iss`, `aud`, `exp`, `nbf`, `sub`, `jti`, and expected signing algorithm.
- Tokens expire appropriately; refresh tokens rotate and can be revoked when used.
- Logout invalidates sessions or revocable tokens where the model supports it.
- Passwords use bcrypt, Argon2, scrypt, or PBKDF2. Never accept plaintext, MD5, SHA-1, or plain SHA-256 for passwords.
- MFA/2FA exists for admin accounts or highly sensitive operations.
- Login, recovery, refresh token, admin, and sensitive operations have rate limits.
- Cookie sessions use `HttpOnly`, `Secure`, `SameSite`, and correct domain/path scope.

### Input, Injection, and Browser Surface

Check:

- Struct validation, schemas, or explicit validators protect all external boundaries.
- Business rules are validated after input shape.
- SQL is parameterized; filesystem paths prevent traversal; shell execution avoids unsanitized input.
- Uploads have size, type, extension, and storage controls.
- CSRF protection exists for cookie/session/browser form/OAuth redirect flows.
- XSS risk is reviewed when rendering HTML, templates, or browser-visible content.
- Public services apply appropriate headers: HSTS, `nosniff`, frame protection or CSP `frame-ancestors`, CSP for browser surface, `Referrer-Policy`, and `Permissions-Policy` when useful.
- CORS uses strict allowlists and never uses `*` for authenticated production endpoints.
- HTTPS is mandatory in production through the service, proxy, load balancer, or edge.

### Secrets, Crypto, Logs, and Attack Resistance

Check:

- Secrets live in env vars, secret manager, Vault, KMS, or equivalent. Real `.env` files are not committed.
- Security randomness uses `crypto/rand`; nonces, IVs, salts, and keys use correct size and lifecycle.
- TLS protects data in transit; storage/KMS/infrastructure handles encryption at rest where needed.
- Logs are structured, redacted, and have enough context for investigation.
- Critical actions have audit logs: actor, action, time, resource, tenant, and request/trace id where applicable.
- SSRF is mitigated for user-controlled URLs; redirects and callbacks use allowlists.
- Replay attacks are blocked with nonce, single-use token, signature, timestamp window, or idempotency key where needed.
- Large payloads are limited before expensive work.

### Dependencies and Supply Chain

Check:

- `go.mod` and `go.sum` are consistent; `go mod tidy` was run when dependencies changed.
- New dependencies are necessary and reviewed for maintenance, license, security, and native/simple alternatives.
- Prefer standard library or existing project helpers when sufficient.
- Use `govulncheck`; use `gosec`, `trivy`, `grype`, `snyk`, `gitleaks`, `trufflehog`, or equivalent according to risk.
- Docker images are scanned when present.
- Dependabot, Renovate, or an equivalent process tracks relevant updates.

## Robustness Checklist

### Errors, Config, and Deployment

Check:

- Errors are handled explicitly; `panic` appears only for fatal boot/config failure, not request or worker paths.
- Use `errors.Is`, `errors.As`, sentinel errors, or custom error types when they clarify behavior.
- Public errors are sanitized; internal logs preserve debug context.
- Circuit breakers protect critical unstable dependencies where appropriate.
- Partial failure behavior is explicit: fail closed, safe fallback, or observable degradation.
- Config comes from env vars, safe config, or secret manager; critical config is validated at boot.
- Unsafe production defaults are rejected.
- Liveness and readiness checks exist when appropriate.
- Graceful shutdown closes HTTP servers, workers, database connections, cache clients, and external clients.
- Feature flags, canary, or rollback strategy exists for risky auth, billing, signing, recovery, or production behavior changes.

### Concurrency and Data Integrity

Check:

- Goroutines have lifecycle ownership and accept context when long-running.
- Request-created goroutines are bounded, cancellable, and have backpressure.
- `sync.WaitGroup`, `errgroup`, worker pools, locks, atomics, or channels have clear responsibility.
- Shared state is protected; deadlocks, starvation, channel blocking, and goroutine leaks are considered.
- Connection pools fit the database and replica count.
- Critical queries have timeouts.
- Transactions protect atomic operations.
- Migrations are versioned, reproducible, and safe for multi-replica deploys.
- Indexes exist for frequent queries, filters, joins, and foreign keys.
- List endpoints use pagination.
- Critical queries are reviewed with `EXPLAIN` or equivalent.
- Backup, restore, and point-in-time recovery exist for critical data.

### Tests and Observability

Check:

- Unit tests cover important business rules and security invariants.
- Integration tests cover critical database, cache, webhook, queue, and external-service flows.
- Contract tests exist for public APIs or important external integrations.
- Load tests exist for public APIs, hot paths, or spike-prone endpoints.
- Property-based tests exist for parsers, codecs, crypto, serialization, and strong invariants.
- Metrics cover latency, throughput, error rate, saturation, CPU, memory, goroutines, database/cache usage, and external connections where useful.
- Metrics cardinality is controlled.
- Logs include request, trace, tenant, user, resource, or API key id where applicable.
- Alerts exist for error rate, latency, dependency failure, stuck queues, stalled workers, and resource exhaustion.

## Performance Checklist

Check:

- Hot paths are identified before optimization.
- Profiling uses `pprof`, `go tool trace`, flame graphs, or equivalent.
- Benchmarks exist for critical functions where performance matters.
- Allocation churn, avoidable copies, GC pressure, and reflection are investigated in proven hot paths.
- Clients, connections, transports, and buffers are reused when safe.
- New goroutines serve a clear purpose and have lifecycle control.
- `strings.Builder`, `bytes.Buffer`, or `sync.Pool` are used only when they clearly help; `sync.Pool` requires profiling and safe object lifecycle.
- `encoding/json` remains the default unless an alternative is justified by measurement and security/maintenance review.
- Cache is used only when it reduces real cost without breaking security or consistency.
- Sensitive, auth, token, and tenant-specific data is not cached without explicit controls.
- Cache has TTL, invalidation, or clear consistency rules.
- Batching is used when it reduces cost without breaking atomicity.
- Read replicas and sharding are considered only after evidence of need.
- `http.Client` and server timeouts are configured; HTTP transports reuse connections; connection limits fit traffic.
- Compression is used only when it reduces cost without unacceptable latency or security tradeoffs.
- `net/http/pprof` is protected and only available in debug, private network, or controlled environments.
- Services are stateless where possible; shared state lives in database, cache, queue, or storage.
- Background work uses worker, outbox, job runner, or queue only when volume or delivery guarantees require it.

## Maintainability and Dead Code

Check:

- Code passes `gofmt`; imports pass `goimports` when used by the project.
- Linting/static analysis uses `go vet`, `golangci-lint`, `staticcheck`, `revive`, `gosec`, or equivalent according to risk.
- Code is organized by domain, feature, bounded context, or layer without artificial architecture.
- Critical business rules are not hidden in handlers, middleware, adapters, logging, or persistence plumbing.
- Functions are small, cohesive, and low-coupling.
- Constants or typed values replace magic strings/numbers in important rules.
- CI runs lint, test, build, and scans appropriate to service risk.
- Dockerfiles use multi-stage builds, minimal images, and non-root user when applicable.
- Technical documentation covers architecture, endpoints, env vars, and important decisions when they affect operation or API consumers.
- Dependency licenses are compatible with the project.
- Dead code is identified and recommended for safe removal:
  - unused functions, methods, structs, interfaces, constants, variables, packages, files, handlers, endpoints, workers, jobs, commands, configs, flags, and dependencies;
  - obsolete branches, impossible conditions, stale compatibility paths, old scripts/migrations no longer referenced, and commented-out code;
  - tests that validate removed behavior or keep obsolete code alive.

## Recommended Commands

Prefer project-native commands first: `Makefile`, `Taskfile`, `justfile`, package scripts, CI config, or docs.

Useful Go audit commands:

```bash
go test ./...
go test -race ./...
go test -cover ./...
go test -bench ./...
go vet ./...
govulncheck ./...
gosec ./...
staticcheck ./...
golangci-lint run
gitleaks detect --source .
trivy fs .
```

Run mutation commands such as `gofmt -w .` or `go mod tidy` only when editing code or when the user asked for fixes. For read-only audits, report them as recommended validation when needed.

## What to Flag Aggressively

Escalate:

- Unauthenticated or weakly protected sensitive endpoints.
- Missing object-level authorization, ownership checks, tenant isolation, deny-by-default, or least privilege.
- Financial math using floats.
- Non-atomic or non-idempotent financial, billing, quota, token, consumption, or single-use operations.
- SQL injection, SSRF, path traversal, open redirect, shell injection, unsafe deserialization, weak JWT validation, or unexpected JWT algorithms.
- Token, key, password, PII, signature, cookie, Authorization header, private material, or secret leakage.
- Missing rate limits on public auth or sensitive flows.
- Missing timeouts, cancellation, circuit breakers, or graceful shutdown in critical paths.
- Request-scoped goroutines without cancellation, bounds, or backpressure.
- Data races, lock hazards, channel leaks, goroutine leaks, deadlocks, or starvation.
- Retry logic that can duplicate mutating operations.
- Business logic that validates request shape but not current domain state.
- Silent fallback hiding auth, billing, quota, signing, recovery, tenant isolation, idempotency, or financial integrity failure.
- User/account/key enumeration through status, body, timing, or error detail.
- Public `pprof`, metrics, admin, or debug endpoints.
- CORS wildcard on authenticated production endpoints.
- Secrets committed to the repo or embedded in code.
- Known vulnerable or unnecessary dependencies.
- Docker containers running as root without reason.
- Sensitive or tenant-specific cache without safe keying, TTL, and invalidation.
- Performance rewrites without evidence.
- Avoidable allocation churn, copying, GC pressure, or goroutine creation in proven hot paths.
- Dead code that increases attack surface, keeps old unsafe paths alive, hides obsolete behavior, or makes changes riskier.
- TODO, FIXME, stubs, mocks, fake implementations, disabled checks, or placeholder logic in critical paths.
- Public API contract drift without versioning, docs, examples, or schema updates.
- Shared canonical payload/digest/signature/webhook/protobuf/binary changes without fixture/test updates.
- Spaghetti growth, files above 1000 lines, giant handlers/services, weak abstractions, pass-through wrappers, duplicate helpers, or refactors that only move complexity.

## Preferred Remedies

For every confirmed problem, provide the most robust practical solution, not only a warning.

Prefer remedies that remove the class of bug:

- Centralize auth middleware, authorization policy, ownership checks, and deny-by-default behavior.
- Move critical business rules into domain/use-case code with tests.
- Use integer base units, fixed decimal, or domain amount types for financial values.
- Use typed request models, strict decoders, explicit validators, and clear error responses.
- Use allowlists for dynamic fields, redirects, callbacks, sorting, filtering, and includes.
- Wrap critical state changes in transactions, conditional updates, locks, or idempotency guarantees.
- Add context timeouts at client, repository, and upstream boundaries.
- Use bounded workers, queues, or outbox patterns instead of raw unbounded goroutines.
- Add redaction helpers used by all logging paths.
- Fix root causes by strengthening invariants, state models, policies, transaction boundaries, or canonical helpers.
- Make fallbacks explicit, safe, observable, and documented.
- Add anti-enumeration responses for identity, key, invite, and recovery flows.
- Keep API response/error envelopes consistent and version public endpoints.
- Add fixtures and cross-language tests for shared canonical formats.
- Prefer standard library or existing helpers before new dependencies.
- Remove proven dead code and obsolete paths.
- Split oversized handlers/services into parsing, authorization, domain operation, persistence, and response mapping.
- Delete weak wrappers when direct calls are clearer and equally testable.
- Replace scattered flags or conditionals with an explicit domain model, policy, or dispatcher.
- Add table-driven, integration, race, contract, benchmark, or property-based tests where they prove the invariant.

When multiple remedies exist, distinguish:

- **Robust solution:** preferred production-grade fix.
- **Fast mitigation:** acceptable temporary risk reduction, only when useful.
- **Validation:** tests, scans, benchmarks, or manual checks required to prove the fix.

## Review Tone

Be formal, direct, and practical.
Do not soften security or financial risk.
Avoid cosmetic comments when larger risks exist.
Separate confirmed issues from assumptions.
If evidence is missing, say exactly what should be checked.

Good phrases:

- `This endpoint changes sensitive state but I do not see authentication or authorization. This should block release.`
- `This reads a tenant-scoped resource without validating ownership. This creates an IDOR risk.`
- `This uses float for financial values. Use integer base units or a fixed decimal type.`
- `This retry can duplicate a mutating operation. Add idempotency or make the operation transactional.`
- `This fallback hides a critical failure. Make the failure explicit, observable, and fail closed.`
- `This goroutine is created per request without cancellation or bounding. It can leak under load.`
- `This performance change needs profiling evidence before adding complexity.`

## Output Expectations

Prioritize findings:

1. Financial loss, custody, payment, billing, quota, token, or balance risks
2. Authentication, authorization, tenant isolation, and ownership failures
3. Injection, SSRF, open redirect, path traversal, secret exposure, and browser security risks
4. Data integrity, transactionality, idempotency, replay, and business-logic risks
5. Concurrency, goroutine, race, cancellation, timeout, and fallback risks
6. Production reliability, observability, deploy, and API contract risks
7. Performance issues supported by evidence
8. Dependency, supply-chain, Docker, and configuration risks
9. Structural quality, dead code, weak abstraction, and maintainability risks

For each finding include:

- Severity: Critical, High, Medium, or Low
- File and line reference when available
- What can go wrong
- Why it matters
- Robust solution
- Fast mitigation when appropriate
- Validation commands or tests

After findings, include a **Recommended Fix Plan** ordered by risk and dependency. The plan must be concrete enough for an agent to implement without guessing, naming visible files, functions, tests, and commands when available.

If no serious findings are found, say that clearly and list residual risks or tests not run.

## Approval Bar

Do not approve a Go service for production while any of these remain unresolved:

- Sensitive public endpoint without auth.
- Missing ownership, tenant isolation, deny-by-default, or least-privilege boundary.
- Financial values represented with float.
- Mutating financial/quota/token operation without atomicity or idempotency.
- Secrets, tokens, keys, signatures, auth headers, or sensitive PII leaking to logs or responses.
- SQL injection, SSRF, path traversal, open redirect, shell injection, or weak JWT path.
- Critical external calls or database operations without timeout.
- Unbounded request-path goroutines or likely race conditions.
- Public admin, debug, metrics, or pprof endpoints without protection.
- Known reachable vulnerable dependency.
- Critical business logic validated only by request shape, not domain state.
- Silent fallback hiding auth, billing, quota, tenant isolation, signing, recovery, or financial integrity failure.
- Stub, mock, TODO, disabled check, or placeholder logic in production-critical paths.
- Shared canonical format changes without compatibility tests or fixtures.
- Security, auth, transaction, timeout, or redaction logic scattered across many paths where a canonical boundary is needed.
- Large tangled handlers/services or weak abstractions that make critical code hard to audit.
- Missing tests around critical money, auth, permission, idempotency, or concurrency logic.

If approval is blocked, give the shortest robust path to make the project safe enough for the next review.

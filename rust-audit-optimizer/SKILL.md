---
name: rust-audit-optimizer
description: Audit and optimize Rust codebases for security, robustness, async safety, unsafe code, performance, dead code, and structural quality. Use for Rust backend, API, worker, Tokio/Axum/Actix, DeFi, financial, multi-tenant, database, queue, FFI, unsafe, or production-readiness reviews.
---

# Rust Security and Performance Audit

Use this skill to audit Rust projects with strong focus on financial safety, backend security, Rust-specific memory/unsafe risks, async robustness, production readiness, performance, and maintainable Rust design.

Skill metadata:

- Version: 1.0.0
- License: MIT

Prioritize:

1. Financial and user safety
2. Authentication, authorization, tenant isolation, and input validation
3. Rust-specific safety: `unsafe`, panics, ownership, async, FFI, and concurrency
4. Robustness under failure and production traffic
5. Performance based on evidence
6. Simple, explicit, maintainable Rust code

## Core Prompt

Start from this baseline:

> Perform a strict audit of this Rust project.
> Prioritize security, robustness, Rust-specific safety, async correctness, performance, production safety, and code quality.
> Look for issues that could cause unauthorized access, financial loss, data exposure, panics in production, undefined behavior, deadlocks, task leaks, resource exhaustion, poor scalability, or long-term code risk.
> Review the code like a production backend or financial service, even if it is still an MVP.
> For every confirmed problem, provide the most robust practical solution, plus validation steps.

The audit is complete only after every applicable standard has been checked and every finding includes a robust solution and validation path.

## Scope Selection

First identify the project shape:

- Public API, internal API, worker/background job, CLI, daemon, library, smart-contract-adjacent service, or mixed service.
- Runtime/framework: Tokio, Axum, Actix, Rocket, Tonic/gRPC, Hyper, Warp, async-std, or sync service.
- Auth model: JWT, session, API key, internal key, mTLS, OAuth2/OIDC, webhook signature, or none.
- Dependencies: database, cache, queue, external HTTP/RPC, FFI, file upload, webhooks, crypto/signing, billing, quota, or payment flow.
- Risk profile: DeFi, custody-free signing, wallet, exchange, accounting, billing, tenant data, sensitive data, unsafe-heavy code, FFI boundary, parser/codec, or public production surface.

Mark items as not applicable only with a clear reason.

## Evidence and Traceability Protocol

Use a traceable audit flow for non-trivial repositories:

- Inspect code incrementally by module, crate, route, handler, worker, unsafe boundary, parser, integration, or business flow.
- Do not mark an area as safe without citing concrete evidence: file, function, route, config, test, command output, or observed invariant.
- If repository size or context limits prevent full coverage, state what was reviewed, what was not reviewed, and which high-risk areas remain.
- Track each meaningful area with one of these statuses:
  - **Verified:** evidence supports the control or invariant.
  - **Issue:** evidence shows a concrete problem.
  - **Partial:** evidence is incomplete or the control exists but has gaps.
  - **Not applicable:** the area does not apply, with reason.
- Add a confidence level to important findings when certainty is not absolute: High, Medium, or Low.
- Use lower confidence when macros, generics, async orchestration, dynamic dispatch, feature flags, build configuration, unsafe/FFI boundaries, or missing runtime context make behavior harder to prove.

## Non-Negotiable Standards

Apply these rules aggressively:

1. **Auth and ownership must fail closed.**
   - Sensitive endpoints require authentication.
   - Authorization must validate resource ownership, tenant isolation, role/scope, and object-level access.
   - Missing, malformed, expired, or unverifiable auth context must deny access.
   - Admin, internal, debug, metrics, billing, signing, recovery, and financial flows require explicit privilege.

2. **Financial and state-changing operations must be safe.**
   - Never use `f32` or `f64` for money, token balances, fees, shares, billing, or quotas.
   - Prefer integer base units, fixed decimal types, checked arithmetic, or domain-specific amount types.
   - Mutating financial, billing, quota, token, consumption, or single-use operations need transactions, conditional updates, idempotency, locks, or another clear consistency control.
   - Retry only idempotent operations or operations protected by idempotency keys.

3. **External input must be constrained before business logic.**
   - Validate request bodies, query/path params, headers, webhooks, callbacks, URLs, file names, uploads, base64, hex, addresses, enums, amounts, dates, and limits.
   - Use strict Serde models for untrusted input; prefer `#[serde(deny_unknown_fields)]` where contract strictness matters.
   - Avoid dangerous defaults, overly broad `Option<T>`, and permissive deserialization that hides invalid input.
   - Use SQL parameters or safe query builders; use allowlists for sorting, filtering, includes, redirects, callbacks, and dynamic query fields.

4. **Production paths must not panic.**
   - Flag `.unwrap()`, `.expect()`, `panic!`, unchecked indexing, unchecked parsing, and impossible-state assumptions in request, worker, parser, FFI, auth, financial, or network paths.
   - Use typed errors, `Result`, `?`, domain errors, or explicit fallback instead.
   - Panics are acceptable mainly in tests, fatal boot/config validation, or truly unreachable invariant violations with clear justification.

5. **Unsafe must be rare, justified, and contained.**
   - Minimize or eliminate `unsafe`.
   - Every `unsafe` block must have a clear safety contract.
   - Encapsulate `unsafe` behind safe APIs and test the boundary.
   - Review `Send`/`Sync`, `Drop`, FFI, raw pointers, `MaybeUninit`, `ManuallyDrop`, `mem::forget`, leaks, and custom comparison/order traits carefully.

6. **Async, cancellation, and concurrency must be controlled.**
   - External calls and database operations require timeout or cancellation.
   - Avoid holding `Mutex`, `RwLock`, or `tokio::sync::Mutex` guards across `.await`.
   - `tokio::spawn` and background tasks must have lifecycle ownership, cancellation, bounds, and backpressure when needed.
   - Use message passing, `JoinSet`, task groups, worker pools, semaphores, or bounded channels where they make concurrency safer.

7. **Fix root causes, not symptoms.**
   - Do not recommend one-off guards, scattered `if`s, or silent fallback when the real problem is a missing invariant, weak boundary, broken state model, unsafe contract, or scattered policy.
   - Prefer fixing the type model, domain invariant, validation boundary, auth policy, transaction boundary, idempotency design, or canonical helper.

8. **Optimize only with evidence.**
   - Require `criterion`, flamegraphs, `perf`, `tokio-console`, allocation/bloat analysis, load tests, metrics, or clear hot-path evidence before complex performance changes.
   - Simple, readable Rust wins over speculative micro-optimization.

## Rust-Specific Safety Standards

Audit Rust safety as part of security and production readiness:

- Use strong domain types instead of loose strings/numbers for IDs, money, states, permissions, roles, and units.
- Use checked/saturating arithmetic where overflow can affect money, counters, limits, indexes, quotas, or security.
- Avoid clone-heavy or allocation-heavy code in hot paths unless profiling proves it is acceptable.
- Avoid blocking operations inside async tasks; use `spawn_blocking` for CPU-bound or blocking I/O when appropriate.
- Use RAII and `Drop` correctly for files, connections, locks, temp resources, and secrets.
- Use `zeroize` or equivalent for sensitive key material where appropriate.
- Never implement custom crypto; prefer audited crates such as `ring`, `rustls`, `argon2`, or domain-approved libraries.
- FFI boundaries need pointer checks, ownership clarity, lifetime safety, error handling, safe wrappers, and tests.
- Parsers, codecs, deserializers, binary formats, and crypto/signature payloads should have fuzz/property tests where risk is high.

## Structural Quality Standards

Audit maintainability as part of safety. A secure patch that leaves tangled code is not robust when a clearer path is visible.

- Look for structural simplification: delete branches, flags, wrappers, helper layers, or special cases when a better model makes them unnecessary.
- Fight spaghetti growth in handlers, services, repositories, workers, and async orchestration.
- Keep logic in the canonical layer:
  - handlers parse HTTP and shape responses;
  - middleware/layers handle authentication;
  - domain/use-case code owns business rules, authorization policy, idempotency, and transaction boundaries;
  - repositories/stores own persistence details;
  - unsafe/FFI wrappers own unsafe contracts and expose safe APIs.
- Treat files above 1000 lines, giant modules, generic `utils` dumping grounds, and unrelated responsibilities as strong maintainability smells.
- Reject weak abstractions: one-implementation traits without purpose, pass-through services, wrappers, managers, helpers, or internal frameworks that do not make code safer or simpler.
- Reuse canonical helpers before creating new ones; consolidate repeated validation, auth, logging redaction, retry, timeout, transaction, amount conversion, error response, and unsafe-boundary logic.
- Do not accept refactors that only move complexity across files.

## Production Safety Standards

Check these cross-cutting production risks:

- **Deny-by-default and least privilege:** scopes, roles, API keys, service credentials, database grants, and internal endpoints should be narrow and explicit.
- **Business logic validation:** validate state transitions, balances, quotas, limits, expiration, ownership, tenant, replay status, token consumption, webhook state, and permission context.
- **Anti-enumeration:** login, signup, email verification, password reset, magic link, invite, API key lookup, and recovery flows should not reveal whether a user, tenant, key, or account exists when that matters.
- **Fallback safety:** fallbacks must be explicit, safe, observable, documented, and must never bypass auth, billing, quota, signing, tenant isolation, idempotency, recovery, or financial integrity.
- **API contract consistency:** public endpoints should be versioned when consumers depend on them; JSON responses and errors should follow a consistent documented shape; breaking changes should update docs, OpenAPI, examples, clients, or Postman collections when present.
- **Shared canonical formats:** payloads, digests, signatures, HMACs, protobufs, binary layouts, challenge formats, and cross-language encodings need fixtures or tests when Rust must match another service or language.
- **No unfinished production paths:** flag `TODO`, `FIXME`, stubs, mocks, fake implementations, empty branches, disabled checks, placeholder logic, mock signers, fake billing, skipped auth, or temporary secrets in critical paths.

## Security Checklist

### Auth, Sessions, and API Access

Check:

- Auth model matches risk: JWT, session, API key, internal key, mTLS, OAuth2/OIDC, webhook signature, or another secure pattern.
- Auth middleware/layers are centralized and reused.
- JWT validation is strict when used: `iss`, `aud`, `exp`, `nbf`, `sub`, `jti`, and expected signing algorithm.
- Tokens expire appropriately; refresh tokens rotate and can be revoked when used.
- Logout invalidates sessions or revocable tokens where the model supports it.
- Passwords use Argon2id, scrypt, bcrypt, or PBKDF2. Never accept plaintext, MD5, SHA-1, or plain SHA-256 for passwords.
- MFA/2FA exists for admin accounts or highly sensitive operations.
- Login, recovery, refresh token, admin, and sensitive operations have rate limits.
- Cookie sessions use `HttpOnly`, `Secure`, `SameSite`, and correct domain/path scope.

### Input, Injection, and Browser Surface

Check:

- Serde models, validators, schemas, or explicit parsers protect all external boundaries.
- Business rules are validated after input shape.
- SQL is parameterized with `sqlx`, Diesel, query builders, or safe prepared statements; filesystem paths prevent traversal; command execution avoids unsanitized input.
- Uploads and large bodies have size, type, extension, and storage controls.
- CSRF protection exists for cookie/session/browser form/OAuth redirect flows.
- XSS risk is reviewed when rendering HTML, templates, or browser-visible content.
- Public services apply appropriate headers: HSTS, `nosniff`, frame protection or CSP `frame-ancestors`, CSP for browser surface, `Referrer-Policy`, and `Permissions-Policy` when useful.
- CORS uses strict allowlists and never uses `*` for authenticated production endpoints.
- HTTPS/TLS is mandatory in production through the service, proxy, load balancer, or edge.

### Secrets, Crypto, Logs, and Attack Resistance

Check:

- Secrets live in env vars, secret manager, Vault, KMS, or equivalent. Real `.env` files are not committed.
- Security randomness uses safe OS-backed RNGs through audited crates.
- TLS protects data in transit; storage/KMS/infrastructure handles encryption at rest where needed.
- Logs use `tracing` or equivalent, are structured/redacted, and have enough context for investigation.
- Critical actions have audit logs: actor, action, time, resource, tenant, and request/trace id where applicable.
- SSRF is mitigated for user-controlled URLs; redirects and callbacks use allowlists.
- Replay attacks are blocked with nonce, single-use token, signature, timestamp window, or idempotency key where needed.
- Large payloads are limited before expensive work.

### Supply Chain and Dependencies

Check:

- `Cargo.lock` is committed for applications; dependency versions and features are intentional.
- New crates are necessary and reviewed for maintenance, license, security, transitive dependencies, features, and native/simple alternatives.
- Unused crate features are disabled to reduce attack surface.
- Run or recommend `cargo audit`, `cargo deny`, `cargo geiger`, `cargo outdated`, and dependency update review according to risk.
- Use `cargo auditable` for high-assurance deploys when useful.
- Run or recommend secrets scanning with `gitleaks`, `trufflehog`, or equivalent according to risk.
- Docker images are scanned when present.
- Dependabot, Renovate, or an equivalent process tracks relevant updates.

## Robustness Checklist

### Errors, Config, and Deployment

Check:

- Errors are handled explicitly with `Result`; avoid production `.unwrap()`, `.expect()`, and broad panics.
- Use `thiserror` for domain/library errors and `anyhow` carefully for application boundary errors when appropriate.
- Public errors are sanitized; internal logs preserve debug context.
- Circuit breakers protect critical unstable dependencies where appropriate.
- Partial failure behavior is explicit: fail closed, safe fallback, or observable degradation.
- Config comes from env vars, safe config, or secret manager; critical config is validated at boot.
- Unsafe production defaults are rejected.
- Liveness and readiness checks exist when appropriate.
- Graceful shutdown drains HTTP servers, tasks, database pools, queues, cache clients, and external clients.
- Feature flags, canary, or rollback strategy exists for risky auth, billing, signing, recovery, or production behavior changes.

### Async, Concurrency, and Data Integrity

Check:

- Tasks have lifecycle ownership and cancellation.
- Request-created tasks are bounded, cancellable, and have backpressure.
- Locks are not held across `.await`; shared state, channels, semaphores, and task joins have clear responsibility.
- Deadlocks, starvation, channel blocking, task leaks, and unbounded queues are considered.
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
- Property-based tests use `proptest` or `quickcheck` for parsers, codecs, crypto, serialization, and strong invariants.
- Fuzzing with `cargo-fuzz` is used for risky parsers, deserializers, binary formats, and untrusted inputs.
- `cargo miri test` and sanitizers are considered for unsafe-heavy or memory-sensitive code.
- Metrics cover latency, throughput, error rate, saturation, CPU, memory, task counts, database/cache usage, and external connections where useful.
- Metrics cardinality is controlled.
- `tracing` spans include request, trace, tenant, user, resource, or API key id where applicable.
- Alerts exist for error rate, latency, dependency failure, stuck queues, stalled workers, and resource exhaustion.

## Performance Checklist

Check:

- Hot paths are identified before optimization.
- Benchmarks use `criterion` where performance matters.
- Profiling uses flamegraphs, `perf`, `cargo flamegraph`, `tokio-console`, heap analysis, `cargo bloat`, or `cargo size` where useful.
- Allocation churn, avoidable clones, boxing, dynamic dispatch, lock contention, and copy-heavy paths are investigated in proven hot paths.
- Blocking CPU or sync I/O is not run directly inside async tasks; use `spawn_blocking` or a dedicated worker model when appropriate.
- Connection pools, clients, buffers, and transports are reused when safe.
- `SmallVec`, `ArrayVec`, `Cow`, `Arc<str>`, arenas, or pools are used only when profiling supports them and complexity is justified.
- Release builds are used for production; `[profile.release]` is reviewed for LTO, codegen units, strip, panic strategy, size/perf goals, and target compatibility.
- PGO, `mold`, `lld`, or target CPU tuning are considered only when build/deploy constraints justify them.
- Cache is used only when it reduces real cost without breaking security or consistency.
- Sensitive, auth, token, and tenant-specific data is not cached without explicit controls.
- Cache has TTL, invalidation, or clear consistency rules.
- Batching/streaming is used when it reduces cost without breaking atomicity or loading huge responses into memory.
- Read replicas and sharding are considered only after evidence of need.
- HTTP clients and server timeouts are configured; connection limits fit traffic.
- Compression, HTTP/2, HTTP/3, and serialization formats are chosen based on measurable need and compatibility.

## Maintainability and Dead Code

Check:

- Code passes `cargo fmt`.
- Linting/static analysis uses `cargo clippy` with project-appropriate strictness.
- Code is organized by domain, feature, bounded context, or layer without artificial architecture.
- Critical business rules are not hidden in handlers, middleware, adapters, logging, or persistence plumbing.
- Functions are small, cohesive, and low-coupling.
- Traits are introduced for real boundaries, multiple implementations, dependency isolation, or testability.
- Constants, enums, newtypes, or domain types replace magic strings/numbers in important rules.
- CI runs fmt, clippy, test, build, audit, and scans appropriate to service risk.
- Dockerfiles use multi-stage builds, minimal images, and non-root user when applicable.
- Technical documentation covers architecture, endpoints, env vars, unsafe contracts, FFI boundaries, and important decisions when they affect operation or API consumers.
- Dependency licenses are compatible with the project.
- Dead code is identified and recommended for safe removal:
  - unused functions, methods, structs, traits, enums, constants, variables, modules, files, handlers, endpoints, workers, jobs, commands, configs, features, and dependencies;
  - obsolete branches, impossible states, stale compatibility paths, old scripts/migrations no longer referenced, and commented-out code;
  - tests that validate removed behavior or keep obsolete code alive.

## Recommended Commands

Prefer project-native commands first: `Makefile`, `Taskfile`, `justfile`, package scripts, CI config, or docs.

Useful Rust audit commands:

```bash
cargo fmt --check
cargo clippy --all-targets --all-features -- -D warnings
cargo test --all-targets --all-features
cargo test --release
cargo audit
cargo deny check
cargo geiger
cargo outdated
cargo miri test
cargo fuzz run <target>
cargo bench
cargo flamegraph
cargo bloat --release
```

Run mutation commands such as `cargo fmt` or dependency updates only when editing code or when the user asked for fixes. For read-only audits, report them as recommended validation when needed.

## What to Flag Aggressively

Escalate:

- Unauthenticated or weakly protected sensitive endpoints.
- Missing object-level authorization, ownership checks, tenant isolation, deny-by-default, or least privilege.
- Financial math using floats or unchecked arithmetic.
- Non-atomic or non-idempotent financial, billing, quota, token, consumption, or single-use operations.
- SQL injection, SSRF, path traversal, open redirect, shell injection, unsafe deserialization, weak JWT validation, or unexpected JWT algorithms.
- Token, key, password, PII, signature, cookie, Authorization header, private material, or secret leakage.
- Production `.unwrap()`, `.expect()`, `panic!`, unchecked indexing, or parser panic paths.
- `unsafe` without safety contract, tests, containment, or clear necessity.
- Unsound FFI, invalid `Send`/`Sync`, risky `Drop`, bad `MaybeUninit`, `ManuallyDrop`, `mem::forget`, or leaks.
- Missing rate limits on public auth or sensitive flows.
- Missing timeouts, cancellation, circuit breakers, or graceful shutdown in critical paths.
- Tasks spawned without cancellation, bounds, ownership, or backpressure.
- Locks held across `.await`, task leaks, deadlocks, starvation, or unbounded queues.
- Retry logic that can duplicate mutating operations.
- Business logic that validates request shape but not current domain state.
- Silent fallback hiding auth, billing, quota, signing, recovery, tenant isolation, idempotency, or financial integrity failure.
- User/account/key enumeration through status, body, timing, or error detail.
- CORS wildcard on authenticated production endpoints.
- Public metrics, admin, debug, or profiling endpoints without protection.
- Secrets committed to the repo or embedded in code.
- Known vulnerable, unnecessary, or feature-bloated crates.
- Docker containers running as root without reason.
- Sensitive or tenant-specific cache without safe keying, TTL, and invalidation.
- Performance rewrites without evidence.
- Avoidable clones, allocations, blocking async work, lock contention, or task creation in proven hot paths.
- Dead code that increases attack surface, keeps old unsafe paths alive, hides obsolete behavior, or makes changes riskier.
- TODO, FIXME, stubs, mocks, fake implementations, disabled checks, or placeholder logic in critical paths.
- Public API contract drift without versioning, docs, examples, or schema updates.
- Shared canonical payload/digest/signature/webhook/protobuf/binary changes without fixture/test updates.
- Spaghetti growth, files above 1000 lines, giant modules/services, weak traits/wrappers, duplicate helpers, or refactors that only move complexity.

## Preferred Remedies

For every confirmed problem, provide the most robust practical solution, not only a warning.

Prefer remedies that remove the class of bug:

- Centralize auth middleware/layers, authorization policy, ownership checks, and deny-by-default behavior.
- Move critical business rules into domain/use-case code with tests.
- Use integer base units, fixed decimal, checked arithmetic, or domain amount types for financial values.
- Use strict Serde models, typed request structs, explicit validators, and clear error responses.
- Use allowlists for dynamic fields, redirects, callbacks, sorting, filtering, and includes.
- Replace production panics with typed errors, `Result`, explicit invariants, and tests.
- Encapsulate `unsafe` behind safe APIs with documented safety contracts, Miri/sanitizer/fuzz tests, and narrow scope.
- Wrap critical state changes in transactions, conditional updates, locks, or idempotency guarantees.
- Add context/timeouts at client, repository, database, and upstream boundaries.
- Use bounded tasks, queues, semaphores, `JoinSet`, or message passing instead of raw unbounded `tokio::spawn`.
- Avoid holding locks across `.await`; restructure with smaller scopes, message passing, or owned data.
- Add redaction helpers used by all logging paths.
- Fix root causes by strengthening invariants, state models, policies, transaction boundaries, type models, or canonical helpers.
- Make fallbacks explicit, safe, observable, and documented.
- Add anti-enumeration responses for identity, key, invite, and recovery flows.
- Keep API response/error envelopes consistent and version public endpoints.
- Add fixtures and cross-language tests for shared canonical formats.
- Prefer standard library or existing helpers before new crates.
- Remove proven dead code and obsolete paths.
- Split oversized modules/handlers into parsing, authorization, domain operation, persistence, async orchestration, and response mapping.
- Delete weak wrappers or traits when direct calls are clearer and equally testable.
- Add unit, integration, property, fuzz, Miri, sanitizer, benchmark, or load tests where they prove the invariant.

When multiple remedies exist, distinguish:

- **Robust solution:** preferred production-grade fix.
- **Fast mitigation:** acceptable temporary risk reduction, only when useful.
- **Validation:** tests, scans, benchmarks, fuzzing, Miri, sanitizers, or manual checks required to prove the fix.

## Review Tone

Be formal, direct, and practical.
Do not soften security, financial, unsafe, or production panic risk.
Avoid cosmetic comments when larger risks exist.
Separate confirmed issues from assumptions.
If evidence is missing, say exactly what should be checked.

Good phrases:

- `This endpoint changes sensitive state but I do not see authentication or authorization. This should block release.`
- `This reads a tenant-scoped resource without validating ownership. This creates an IDOR risk.`
- `This uses float for financial values. Use integer base units or a fixed decimal type.`
- `This unwrap is reachable from untrusted input. Return a typed error instead of panicking.`
- `This unsafe block has no documented safety contract. Encapsulate it behind a safe API and add boundary tests.`
- `This task is spawned without cancellation or backpressure. It can leak or amplify load under abuse.`
- `This lock can be held across await. Restructure the critical section before awaiting.`
- `This performance change needs profiling evidence before adding complexity.`

## Output Expectations

Start with an **Executive Snapshot**:

- Overall risk: Critical, High, Medium, or Low
- Release stance: Block release, release after fixes, or no major blocker found
- Scope reviewed: crates/modules/flows/configs actually inspected
- Top risks: 3-5 highest-impact issues or residual concerns
- Validation run or still needed

Prioritize findings:

1. Financial loss, custody, payment, billing, quota, token, or balance risks
2. Authentication, authorization, tenant isolation, and ownership failures
3. Unsafe, FFI, production panic, parser panic, memory, and Rust soundness risks
4. Injection, SSRF, open redirect, path traversal, secret exposure, and browser security risks
5. Data integrity, transactionality, idempotency, replay, and business-logic risks
6. Async, task, lock, cancellation, timeout, fallback, and concurrency risks
7. Production reliability, observability, deploy, and API contract risks
8. Performance issues supported by evidence
9. Dependency, supply-chain, crate feature, Docker, and configuration risks
10. Structural quality, dead code, weak abstraction, and maintainability risks

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

Do not approve a Rust service for production while any of these remain unresolved:

- Sensitive public endpoint without auth.
- Missing ownership, tenant isolation, deny-by-default, or least-privilege boundary.
- Financial values represented with floats or unchecked arithmetic.
- Mutating financial/quota/token operation without atomicity or idempotency.
- Secrets, tokens, keys, signatures, auth headers, or sensitive PII leaking to logs or responses.
- SQL injection, SSRF, path traversal, open redirect, shell injection, or weak JWT path.
- Reachable production `.unwrap()`, `.expect()`, `panic!`, unchecked indexing, or parser panic from untrusted input.
- `unsafe` or FFI without documented safety contract, containment, and validation.
- Critical external calls or database operations without timeout.
- Unbounded request-path tasks, lock-across-await hazards, or likely deadlocks/task leaks.
- Public admin, debug, metrics, or profiling endpoints without protection.
- Known reachable vulnerable dependency.
- Critical business logic validated only by request shape, not domain state.
- Silent fallback hiding auth, billing, quota, tenant isolation, signing, recovery, or financial integrity failure.
- Stub, mock, TODO, disabled check, or placeholder logic in production-critical paths.
- Shared canonical format changes without compatibility tests or fixtures.
- Security, auth, transaction, timeout, unsafe-boundary, or redaction logic scattered across many paths where a canonical boundary is needed.
- Large tangled modules/services or weak traits/wrappers that make critical code hard to audit.
- Missing tests around critical money, auth, permission, idempotency, unsafe, parser, FFI, or concurrency logic.

If approval is blocked, give the shortest robust path to make the project safe enough for the next review.

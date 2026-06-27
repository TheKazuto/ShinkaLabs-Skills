# Solana Program Upgrade Orchestrator

Use this skill to audit, design, implement, or review safe migrations for Solana programs that need account layout changes, new fields, new logic, security improvements, framework upgrades, or non-trivial deploy orchestration.

Skill metadata:

- Version: 1.0.0
- License: MIT

Important: Solana upgrades can permanently affect accounts, funds, authorities, indexers, clients, and user flows. Treat migration work as high-risk. Never recommend mainnet upgrade, migration execution, authority transfer, or authority removal without explicit human approval and a tested deployment plan.

Prioritize:

1. User funds, account integrity, and backward compatibility
2. Safe account versioning, deserialization, and conversion logic
3. Upgrade authority security, multisig, and deploy governance
4. Migration test coverage, simulation, and rollback planning
5. Compute, rent, performance, and operational reliability
6. Clear implementation steps, evidence, and validation

## Core Prompt

Start from this baseline:

> Perform a strict Safe Migration Orchestrator audit for this Solana program.
> Identify migration, versioning, account-layout, realloc, rent, upgrade-authority, deployment, testing, client, indexer, and monitoring risks.
> For every confirmed gap, explain what can go wrong, what migration element is missing or weak, and the most robust practical solution to add it.
> Help the user produce a safe migration plan and implementation-ready changes.
> When the user asks for fixes, implement the missing version fields, legacy structs, migration helpers, migrate instructions, tests, scripts, docs, deployment checklist, and monitoring notes directly in the project instead of only giving advice.

The audit is complete only after every applicable migration phase has been checked and every finding includes evidence, robust solution, implementation path, and validation steps.

## Scope Selection

First identify the migration shape:

- Framework: Anchor, Pinocchio, Quasar, native Solana, or mixed.
- Migration type: new field, removed field, reordered field, type change, discriminator change, PDA seed change, authority change, CPI behavior change, token program change, feature addition, framework upgrade, or security fix.
- Strategy: account versioning, lazy migration, explicit `migrate` instruction, forced migration inside existing instructions, new V2 account type, in-place realloc, new account plus copy, off-chain batch migration, or hybrid.
- Account surface: PDAs, non-PDAs, token accounts, vaults, config accounts, user state, market/pool accounts, metadata, zero-copy accounts, and accounts read through CPI.
- Operational surface: upgrade authority, buffer account, multisig, timelock, DAO approval, deploy scripts, indexers, SDKs, frontends, bots, docs, and monitoring.

If program version, account layouts, migration goal, production state, or upgrade authority model is unclear, inspect the repository first. If still unclear, mark assumptions and ask only for the minimum missing information.

## Evidence-First Review

Inspect actual code and deployment artifacts before concluding that migration safety exists.

Check common locations:

- `programs/`, `src/`, `instructions/`, `state/`, `accounts/`, `errors/`, `events/`, `tests/`, `migrations/`, `scripts/`, `app/`, `client/`, `sdk/`, `idl/`, and `target/idl/`.
- Account structs, zero-copy structs, discriminators, version fields, PDA seeds, bump handling, owner checks, signer checks, constraint macros, `try_from`, deserialization helpers, and conversion functions.
- `Anchor.toml`, `Cargo.toml`, deploy scripts, buffer upgrade scripts, multisig docs, IDL files, TypeScript clients, indexer queries, docs, README, changelog, and release notes.
- Tests that create old accounts, run migration, execute mixed-version flows, measure compute units, simulate rent shortage, and verify post-migration data integrity.

When evidence is partial, report exactly what file, account type, instruction, deploy script, production address, IDL, indexer, or historical account sample must be verified.

Use a traceable migration review flow:

- Review incrementally by account type, instruction, account version, conversion path, realloc path, PDA seed, deploy phase, test suite, client surface, and monitoring surface.
- Do not mark migration safety as verified without citing evidence: file, struct, version byte, discriminator, test, script, IDL, account sample, transaction simulation, compute measurement, or deploy checklist.
- Track each meaningful area with one of these statuses:
  - **Verified:** evidence supports the migration control.
  - **Issue:** evidence shows a concrete migration risk.
  - **Partial:** a control exists but is incomplete, unsafe, untested, undocumented, or not wired into the real flow.
  - **Not applicable:** the area does not apply, with reason.
  - **Needs human approval:** mainnet upgrade, authority transfer/removal, DAO/multisig action, or irreversible operational decision.
- Add confidence to important findings: High, Medium, or Low.
- Use lower confidence when production account samples, historical IDL, indexer behavior, client compatibility, authority state, or mainnet deployment process is not fully known.

## Non-Negotiable Standards

Apply these rules aggressively:

1. **Do not break old accounts silently.**
   - Account layout changes need version-aware deserialization and conversion.
   - Keep legacy structs or parsers for every supported old version.
   - Never assume all accounts are already on the newest layout.

2. **Do not change PDA seeds casually.**
   - Existing PDA addresses are part of the protocol state.
   - If seeds must change, use versioned namespaces, coexistence, or explicit migration paths.

3. **Do not realloc without strict checks.**
   - Validate owner, signer, authority, version, expected size, rent payer, and upper bounds before realloc.
   - Consider DoS risk from expensive migrations or repeated migration attempts.

4. **Do not upgrade mainnet with a single-key authority.**
   - Production upgrade authority should use multisig or a governance process.
   - Buffer authority, program authority, approval flow, and deploy signer must be documented and tested.

5. **Do not ship migration logic without old-account tests.**
   - Tests must create or load old-version accounts and prove conversion, instruction compatibility, rent behavior, compute cost, and data integrity.

6. **Do not ignore off-chain compatibility.**
   - IDL, SDKs, frontends, bots, indexers, analytics, and docs may break even when on-chain migration succeeds.

7. **Fix root causes, not symptoms.**
   - If deserialization can fail, add versioned unpacking rather than patching one instruction.
   - If migration is expensive, design batching, lazy conversion, or user-funded flows rather than raising compute blindly.
   - If authority risk is high, fix governance before deployment.

## Migration Readiness Checklist

### Phase 0: Planning and Impact Analysis

Check:

- All program accounts are listed, including PDAs and non-PDAs.
- Accounts with changed structure are identified: added fields, removed fields, reordered fields, type changes, discriminator changes, and zero-copy layout changes.
- Every instruction that reads or writes changed accounts is mapped.
- CPIs, cross-program reads, indexers, clients, and bots are mapped.
- Rent, allocated space, compute units, and transaction size impact are estimated.
- Mainnet account population and old-version distribution are understood or measurable.
- Migration strategy is explicitly chosen and justified.

### Phase 1: Account Versioning and Layout

Check:

- Account data includes a `version` field or equivalent version byte near the beginning of the layout.
- Legacy account structs/parsers are kept for conversion.
- New fields have safe default values and clear invariants.
- Preallocated space exists where practical to reduce future reallocs.
- Discriminators are documented for Anchor, Quasar, Pinocchio, or native layouts.
- Zero-copy structs use stable layout rules, such as `repr(C)`, alignment checks, and explicit padding when needed.
- PDA seeds are stable, or versioned PDA namespaces are introduced intentionally.

### Phase 2: Framework-Specific Implementation

Check:

- Anchor: `#[account]`, `InitSpace`, `realloc` constraints, custom validation, migration helpers, and IDL changes are safe.
- Anchor: old accounts cannot fail with `AccountDidNotDeserialize` before migration logic runs.
- Pinocchio: manual owner, signer, writable, length, discriminator, version, and buffer parsing checks are complete.
- Quasar: pointer-cast/zero-copy account access checks discriminator, version, alignment, and length before use.
- Native Solana: account unpacking, byte offsets, owner checks, and serialization are explicit and tested.
- Common logic includes `unpack_with_migration`, `try_from_with_migration`, or equivalent helpers.
- Conversion logic validates owner, initialization state, version, size, and invariants before writing.

### Phase 3: Migration Strategy and Data Flow

Check:

- Lazy migration, explicit `migrate` instruction, forced migration, new-account copy, batch migration, or hybrid flow is implemented intentionally.
- In-place realloc uses correct payer and checks rent-exemption after resize.
- New-account migration copies all important data and prevents double migration or replay.
- Closing old accounts is safe, authorized, and recovers rent only after successful migration.
- Migration events are emitted where tracking is useful.
- Front-running, griefing, repeated migration, partial migration, and interrupted migration cases are handled.
- Large account populations use chunking, batching, or off-chain orchestration instead of unsafe all-at-once assumptions.

### Phase 4: Tests and Simulation

Check:

- Unit tests cover every supported account version and Vn to Vn+1 conversion.
- Integration tests create old accounts using old code, fixtures, or raw bytes.
- Mixed-version scenarios are tested: old and new accounts in the same instruction path.
- Edge cases are tested: undersized accounts, oversized accounts, uninitialized accounts, wrong owner, wrong discriminator, wrong version, missing rent, insufficient signer, and repeated migration.
- Security tests cover signer checks, PDA derivations, CPIs, reentrancy-like flows, and DoS via expensive migration.
- Fuzz or property tests cover deserialization and conversion when practical.
- Devnet/testnet rehearsal simulates mainnet-like account volume.
- Compute units and transaction size are measured for migration and normal operations.

### Phase 5: Upgrade Authority and Deploy Safety

Check:

- Upgrade authority owner is known and appropriate for production.
- Production authority uses multisig, DAO, timelock, or another reviewed governance process.
- Buffer deploy flow is documented: write buffer, verify buffer, transfer buffer authority when needed, approve, upgrade.
- Verifiable builds are considered or implemented.
- Program ID, buffer address, IDL, deploy signer, and authority addresses are documented.
- Rollback/corrective-upgrade plan exists, including previous code, previous IDL, communication, and emergency response.
- Pausing or feature gating exists when a critical migration needs controlled rollout.

### Phase 6: Clients, Indexers, and Documentation

Check:

- TypeScript/JavaScript SDKs, generated clients, IDL consumers, frontends, bots, and indexers are updated.
- Changelog, README, API docs, and migration guide explain user/operator steps.
- Users are told whether migration costs rent or fees.
- Indexers can detect old and new account versions.
- Public instructions explain how to migrate accounts when user action is required.
- Support and incident channels are ready for migration issues.

### Phase 7: Post-Deploy Monitoring and Maintenance

Check:

- Metrics track old-version account counts, migration successes, migration failures, deserialization failures, compute usage, and transaction errors.
- Alerts exist for unexpected failure spikes after upgrade.
- Migration events or logs are indexed.
- Cleanup plan closes old accounts only when safe.
- Authority removal or immutability is considered only after long-term stability and explicit approval.
- Future migration policy is documented so the protocol does not get stuck again.

## Implementation Guidance

When the audit finds a missing element, help the user add it to the project.

Prefer practical remedies:

- Add `version` fields or version bytes to account layouts.
- Add legacy account structs/parsers for V0, V1, V2, and supported historical versions.
- Add `unpack_with_migration`, `try_from_with_migration`, or framework-appropriate migration helpers.
- Add explicit `migrate` instructions when lazy migration is not enough.
- Add safe realloc checks: owner, signer, writable, version, current size, target size, upper bounds, payer, and rent.
- Add migration events, status flags, and idempotency protections.
- Add tests using old account fixtures, mixed-version flows, rent shortage, wrong owner, wrong version, and repeated migration.
- Add compute budget measurement tests or scripts.
- Add deploy checklist, buffer upgrade notes, multisig approval steps, rollback plan, and post-deploy monitoring docs.
- Add SDK, IDL, frontend, and indexer update notes.

If the user asks for implementation, edit/create the necessary files directly: account structs, migration helpers, instruction handlers, tests, fixtures, scripts, deploy docs, README sections, changelog, SDK parsing helpers, and monitoring notes.

Visible user-facing docs and app copy should default to English for international projects unless the project clearly targets another language.

## What to Flag Aggressively

Escalate:

- Account layout changed without versioning or legacy parsing.
- New account fields added without safe defaults and invariants.
- Old accounts can fail deserialization before migration logic runs.
- PDA seeds changed without a coexistence or migration plan.
- Realloc occurs without version, size, rent, owner, signer, or DoS checks.
- Migration can be called repeatedly for profit, griefing, or state corruption.
- Migration is not idempotent where retries are possible.
- Upgrade authority is a single hot wallet in production.
- Buffer account or deploy flow is undocumented.
- No tests create and migrate old-version accounts.
- No mixed-version tests exist.
- Compute units or transaction size are not measured.
- Frontend, SDK, IDL, bots, or indexers are not updated.
- No rollback/corrective-upgrade plan exists.
- No monitoring for failed migrations or old accounts exists.
- Rent costs are hidden from users.
- Authority removal is proposed before stability and human approval.

## Preferred Remedies

For every confirmed migration gap, provide the most robust practical solution, not only a warning.

Prefer remedies that remove the class of risk:

- Add a stable account-versioning model before adding more migration code.
- Preserve old account parsers instead of trying to deserialize old bytes as the newest struct.
- Use lazy migration for common low-risk account updates when old accounts can safely coexist.
- Use explicit migration instructions for high-risk, expensive, user-funded, or operationally sensitive changes.
- Use new V2 account types when in-place realloc is too risky.
- Use chunked or batch orchestration for large account populations.
- Gate critical migrations with governance, pause controls, or feature flags where appropriate.
- Add old-account fixtures to prevent future regressions.
- Document deploy order and authority actions so mainnet execution is reproducible.
- Monitor the migration after deploy and keep corrective-upgrade capacity until stability is proven.

When multiple remedies exist, distinguish:

- **Robust solution:** preferred production-grade fix.
- **Fast mitigation:** temporary risk reduction when useful.
- **Human approval needed:** mainnet upgrade, authority transfer/removal, DAO/multisig action, or irreversible operation.
- **Validation:** tests, scripts, account samples, simulations, commands, metrics, or deployment rehearsals required to prove safety.

## Output Expectations

Start with a **Safe Migration Snapshot**:

- Overall migration risk: Critical, High, Medium, or Low
- Deployment stance: Block mainnet upgrade, rehearse before upgrade, deploy after fixes, or no major blocker found
- Scope reviewed: accounts/instructions/tests/scripts/IDL/clients/deploy docs actually inspected
- Top risks: 3-5 highest-impact migration gaps or residual concerns
- Human approval needed: yes/no, with topics
- Assumptions and production state not verified

Prioritize findings:

1. Account deserialization, versioning, layout, discriminator, and backward-compatibility blockers
2. Realloc, rent, conversion, idempotency, and data-integrity risks
3. Authority, multisig, governance, buffer deploy, and mainnet operational risks
4. Tests, old-account fixtures, devnet rehearsal, fuzzing, and compute measurement gaps
5. PDA, CPI, signer, owner, security, front-running, and DoS risks
6. SDK, IDL, frontend, indexer, bot, documentation, and user communication risks
7. Monitoring, cleanup, rollback, corrective-upgrade, and long-term maintenance gaps

For each finding include:

- Severity: Critical, High, Medium, or Low
- Status: Issue, Partial, Not applicable, or Needs human approval when relevant
- Confidence: High, Medium, or Low
- Affected account/instruction/file/flow when available
- Evidence found or evidence missing
- What is missing or weak
- What can go wrong
- Robust solution
- Fast mitigation when appropriate
- Human approval needed when applicable
- Implementation path: exact account, instruction, helper, test, script, doc, client, or deploy workflow to add/update
- Validation steps

After findings, include a **Recommended Migration Plan** ordered by risk and dependency. The plan must be concrete enough for an agent to implement without guessing, naming files, accounts, instructions, tests, scripts, deploy commands, docs, and monitoring checks when available.

When the user asked for fixes, implement the plan in the repository and then summarize changed files and remaining items requiring governance, production account data, or human approval.

If no serious gaps are found, say that clearly and list residual migration risks, assumptions, production data not available, or tests not run.

## Approval Bar

Do not mark a Solana migration safe while any of these remain unresolved:

- Account layout changes lack version-aware parsing or conversion.
- Old accounts can fail deserialization before migration.
- Realloc lacks strict owner, signer, version, size, rent, and upper-bound checks.
- Migration can corrupt data, double-run unsafely, or leave partial inconsistent state.
- PDA seed changes lack coexistence or migration plan.
- Production upgrade authority is insecure or undocumented.
- Mainnet upgrade flow lacks multisig/governance approval path.
- No tests create and migrate old-version accounts.
- No devnet/testnet rehearsal exists for non-trivial migrations.
- Compute/rent impact is unknown for critical paths.
- SDK, IDL, frontend, or indexer compatibility is unreviewed.
- Rollback/corrective-upgrade and post-deploy monitoring are missing.
- User-facing migration costs or required actions are undisclosed.

If approval is blocked, give the shortest robust path to make the migration safe enough for rehearsal and human review.

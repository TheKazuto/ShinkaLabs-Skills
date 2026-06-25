---
name: solana-quasar-audit-optimizer
description: Audit and optimize Solana programs built with the Quasar framework for account validation, PDA safety, CPI security, zero-copy/unsafe soundness, Token-2022, arithmetic, compute units, dead code, and deployment readiness. Use for Quasar, quasar-lang, quasar-spl, Solana program, no_std, Ctx, CtxWithRemaining, derive Accounts, account macros, instruction discriminators, PDA, CPI, SPL Token, or Token-2022 reviews.
---

# Solana Quasar Program Audit Optimizer

Use this skill to audit Solana programs built with Quasar, a `no_std` zero-copy framework that pointer-casts accounts from SVM input buffers. Focus on financial safety, account validation, PDA security, CPI correctness, unsafe/zero-copy soundness, Token-2022 edge cases, compute efficiency, and maintainable on-chain Rust.

Skill metadata:

- Version: 1.0.0
- License: MIT

Important: Quasar is not Anchor. Never assume Anchor APIs, account types, discriminator sizes, or validation behavior. Audit the Quasar code as Quasar code.

Prioritize:

1. User funds and protocol asset safety
2. Signer, owner, PDA, account type, and authority validation
3. CPI and SPL Token/Token-2022 security
4. Arithmetic, state invariants, and lifecycle correctness
5. Quasar zero-copy, `unsafe`, account layout, and `no_std` soundness
6. Compute-unit efficiency and deploy readiness

## Core Prompt

Start from this baseline:

> Perform a strict audit of this Solana Quasar program.
> Prioritize fund safety, account validation, PDA safety, CPI security, Token-2022 edge cases, arithmetic correctness, zero-copy soundness, compute efficiency, production safety, and code quality.
> Look for issues that could cause unauthorized account access, fund loss, account spoofing, type cosplay, arbitrary CPI, incorrect PDA authority, account revival, broken invariants, precision loss, compute exhaustion, or unsafe memory assumptions.
> Review the code like a production Solana protocol, even if it is still an MVP.
> For every confirmed problem, provide the most robust practical solution, plus validation steps.

The audit is complete only after every applicable standard has been checked and every finding includes a robust solution and validation path.

## Scope Selection

First identify the project shape:

- Quasar setup: `quasar-lang`, `quasar-spl`, `Quasar.toml`, `#[program]`, `#[derive(Accounts)]`, `#[account]`, `#[event]`, `Ctx<T>`, `CtxWithRemaining<T>`, generated clients, and tests.
- Program type: escrow, vault, staking, AMM, token launch, governance, multisig, allowlist, payment, rewards, oracle, policy program, or custom protocol.
- Asset surface: lamports, SPL Token, Token-2022, ATAs, mint/burn, fees, vaults, rewards, PDAs, CPIs, ALTs, or off-chain companion services.
- Account model: PDAs, signers, unchecked accounts, dynamic account fields, remaining accounts, sysvars, close/realloc, upgrade authority, and stored bumps.
- Risk profile: funds at risk, authority transfer, composability, public instructions, privileged admin flows, DeFi/MEV, oracle dependency, or precompile/signature introspection.

Mark items as not applicable only with a clear reason.

## Evidence and Traceability Protocol

Use a traceable audit flow for non-trivial programs:

- Inspect incrementally by instruction, accounts struct, account type, PDA derivation, CPI path, token flow, state transition, test, config, and deployment setting.
- Do not mark an area as safe without citing concrete evidence: file, instruction, accounts constraint, account field, seed list, bump source, CPI target, test, command output, or invariant.
- If repository size or context limits prevent full coverage, state what was reviewed, what was not reviewed, and which high-risk areas remain.
- Track each meaningful area with one of these statuses:
  - **Verified:** evidence supports the control or invariant.
  - **Issue:** evidence shows a concrete problem.
  - **Partial:** evidence is incomplete or the control exists but has gaps.
  - **Not applicable:** the area does not apply, with reason.
- Add a confidence level to important findings when certainty is not absolute: High, Medium, or Low.
- Use lower confidence when macro expansion, generated code, dynamic fields, remaining accounts, Token-2022 extensions, CPI dependency chains, or missing tests make behavior harder to prove.

## Discovery Pass

Before deep review, search for high-risk Quasar/Solana patterns and use the results to guide the audit:

- Account risk: `UncheckedAccount`, `remaining_accounts`, `CtxWithRemaining`, `AccountInfo`, `to_account_info`, duplicate mutable accounts, sysvars, dynamic fields, `realloc`, `close`, and `init_if_needed`.
- Authority/PDA risk: `signer`, `authority`, `admin`, `owner`, `manager`, `seeds`, `bump`, `invoke_signed`, `set_authority`, `upgrade`, and stored bump fields.
- Value movement risk: `transfer`, `transfer_checked`, `mint_to`, `burn`, `close_account`, `approve`, `delegate`, `freeze`, `thaw`, fee logic, vault logic, and share/NAV accounting.
- Runtime failure risk: `.unwrap()`, `.expect()`, `panic!`, unchecked indexing, ignored `Result`, unchecked casts, and custom `unsafe`.
- Economic/composability risk: oracle reads, price feeds, slippage, deadlines, instruction sysvar, Ed25519/Secp256k1 verification, flash-loan-sensitive flows, and public instructions.

## Non-Negotiable Standards

Apply these rules aggressively:

1. **Account validation must be complete.**
   - Every privileged instruction requires correct signer checks.
   - Account owner, type/discriminator, writable/read-only intent, PDA seeds, canonical bump, and authority relationships must be validated.
   - `UncheckedAccount` and `remaining_accounts` require explicit manual validation before use.
   - Sysvars and programs must be pinned to expected addresses.

2. **PDA authority must be unspoofable.**
   - Derive PDAs from canonical seeds and program id.
   - Never accept user-provided bumps as trusted authority.
   - Store and reuse bumps safely when intended.
   - Include user/protocol/context-specific seeds to prevent PDA sharing, seed collision, or cross-context confusion.

3. **CPI must not be arbitrary or authority-leaking.**
   - Validate target program ids for every CPI.
   - Do not forward user signers or protocol PDA signers to untrusted programs.
   - Use protocol PDAs as authorities where appropriate.
   - Reload or re-check accounts after CPI when downstream changes can affect state.
   - Check lamport/token balances before and after CPI when correctness depends on transferred value.

4. **Arithmetic and value movement must be safe.**
   - Use checked arithmetic for balances, fees, shares, rewards, slippage, quotas, and supply.
   - Use `u128` intermediates where multiplication/division can overflow or lose precision.
   - Define rounding explicitly and favor protocol/user safety according to invariant.
   - Prevent division by zero, bad casts, negative/signed confusion, and unchecked truncation.

5. **Zero-copy and account layout must be sound.**
   - Account struct size must match allocated space.
   - Discriminator must be present, unique, and validated for each account type.
   - Pod/Zeroable/Copy assumptions must be valid for every account layout.
   - Alignment, dynamic fields, realloc, and account close behavior must be tested.
   - Custom `unsafe` must be minimized, documented, contained, and validated.

6. **State lifecycle must prevent revival and reinitialization.**
   - `init_if_needed`, realloc, close, and authority transfer must have explicit safety checks.
   - Closed accounts must not be reusable as valid state.
   - State transitions must validate current state before mutation.
   - Lamports and rent-exemption must be considered where relevant.

7. **Fix root causes, not symptoms.**
   - Do not recommend one-off guards when the real issue is a missing account constraint, weak PDA model, broken authority invariant, unsafe layout, or scattered validation.
   - Prefer strengthening account constraints, PDA seeds, stored state invariants, CPI wrappers, token validation, or shared helpers.

8. **Optimize only with evidence.**
   - Require compute-unit measurements, program-test benchmarks, transaction simulations, logs, or clear hot-path evidence before complex compute optimizations.
   - Quasar performance matters, but never trade away validation, invariant clarity, or fund safety.

## Quasar-Specific Safety Standards

Audit Quasar-specific behavior carefully:

- Framework dependencies should be pinned to a version/commit appropriate for production risk.
- `#[instruction(discriminator = N)]` values must be unique and intentionally stable.
- Quasar uses 1-byte discriminators; migrations and parsing must account for this.
- Account reference types must be Quasar types, not Anchor types.
- `.address()` should be used for account addresses; do not assume Anchor-style `.key()`.
- `CtxWithRemaining<T>` and `remaining_accounts()` must only be used when runtime accounts are required and fully validated.
- Dynamic fields such as Quasar `String`/`Vec` require lifetime, capacity, realloc, payer, and rent behavior review.
- `set_inner(...)` positional writes should set all fields correctly and preserve invariants.
- Account `space`, fixed-size layout, dynamic capacity, and rent must match actual stored data.
- `no_std` compatibility and heap usage must be reviewed; avoid unnecessary allocation and long loops.
- Review macro-generated constraints where security depends on them; inspect expanded code when needed.

## Solana Security Checklist

### Account Validation and Access Control

Check:

- Signer checks exist for every authority-sensitive instruction.
- Owner checks confirm accounts belong to expected program/token/system owners.
- Account type checks use discriminator and correct struct.
- `has_one`, `address`, `constraint`, `seeds`, `bump`, `token::mint`, and `token::authority` constraints cover all relationships.
- Duplicate mutable accounts are rejected when aliasing can break invariants.
- `remaining_accounts` are length-checked, owner-checked, type-checked, signer/writable-checked, and order-checked.
- Authority transfer uses two-step nominate/accept when risk justifies it.
- Upgrade authority, admin authority, and deployer privileges are documented and constrained.
- Time/slot logic validates Clock sysvar and handles boundary cases.

### Governance, Admin, and Emergency Controls

Check:

- Admin, manager, fee, oracle, pause, and upgrade authorities are explicit, minimally scoped, and validated by address/state relationship.
- High-risk authority changes use two-step nominate/accept, multisig, timelock, or an equivalent control when production funds are at risk.
- Pause or emergency flows cannot steal funds, bypass accounting, permanently lock users without governance intent, or create privileged withdrawal paths.
- Upgrade authority, program id, deployment cluster, and immutability plan are documented and match the intended release posture.
- Privileged instructions emit sufficient events/logs for monitoring without leaking sensitive data.

### State, Lifecycle, and Invariants

Check:

- Initialization cannot be repeated unless explicitly safe.
- `init_if_needed` cannot reset or hijack existing state.
- Account close transfers all lamports, marks state closed, and prevents account revival.
- Realloc uses correct size, payer, rent, zeroing behavior, and invariant checks.
- Accounts are reloaded or revalidated after CPI when mutated by downstream programs.
- State transitions check current status, authority, deadlines, limits, balances, and protocol invariants before mutation.
- Economic invariants are explicit: supply, vault balance, shares, fees, rewards, limits, collateral, slippage, and accounting totals.
- Vault/share protocols defend against first depositor attacks, share inflation, bad zero-supply branches, incorrect NAV initialization, and rounding that benefits attackers.
- Fees, decimals, and unit conversions are normalized across mints and cannot exceed configured caps.
- Tests cover edge cases: zero, one, max, overflow, underflow, stale state, wrong authority, wrong account, wrong mint, and repeated calls.

### CPI, Tokens, and Token-2022

Check:

- CPI target program ids are validated and preferably allowlisted.
- `invoke_signed` seeds match the intended PDA authority.
- User signers are not forwarded to arbitrary programs.
- Token mint, owner, authority, decimals, frozen state, delegate, close authority, and ATA are validated where relevant.
- Use checked token transfers where possible.
- Token-2022 extensions are considered: transfer hooks, transfer fees, permanent delegate, mint close authority, default frozen state, CPI guard, and other active extensions.
- Deposits account for transfer fees or received amount mismatch.
- ATAs are validated canonically; account owner/mint/authority must match expected values.
- Vaults reject risky token extensions when protocol assumptions require standard SPL behavior.
- Lamport transfers check balances before/after when value accounting matters.

### Oracles, External Prices, and Signature Introspection

Check:

- Oracle accounts, price feed ids, owners, update authorities, decimals, freshness windows, confidence/variance, and slot/round boundaries are validated.
- Price-dependent instructions include slippage, min/max expected values, stale-price rejection, and manipulation-resistant assumptions for low-liquidity or flash-loan-sensitive flows.
- Cross-mint accounting normalizes decimals before comparison, fee calculation, share minting, redemption, or liquidation.
- Ed25519/Secp256k1 or instruction sysvar verification validates the expected instruction index, signer/key, domain-separated message, nonce/deadline, and replay protection.
- Off-chain signed payloads bind all critical fields: program id, instruction, accounts, amount, mint, recipient, expiry, chain/cluster when relevant, and user intent.

### Arithmetic and Precision

Check:

- Critical math uses `checked_add`, `checked_sub`, `checked_mul`, `checked_div`, or equivalent safe helpers.
- `overflow-checks = true` is configured where applicable.
- Multiplication before division is intentional and uses wide intermediates when needed.
- Rounding direction is documented and tested.
- Slippage, deadlines, expected amounts, minimum outputs, and max fees protect users where applicable.
- Casts use `try_from` or explicit bounds checks.
- Division by zero and zero-amount edge cases are handled.

### Rust, Unsafe, and Robustness

Check:

- No reachable `.unwrap()`, `.expect()`, or `panic!` in critical on-chain paths.
- All `Result`s from CPI/syscalls/math/validation are handled.
- Custom `unsafe` has a safety contract and tests.
- Slices, vectors, dynamic fields, and indexes are bounds-checked.
- Error codes are specific enough for debugging and tests.
- Logs/events do not leak sensitive material and are compute-aware.
- Critical state changes emit events or structured logs with enough fields for monitoring, reconciliation, and incident response.
- Idempotency is considered where repeated instruction submission can happen.

## Performance and Compute Checklist

Check:

- Quasar zero-copy is preserved; avoid unnecessary deserialization/copying.
- Compute unit usage is measured for critical instructions.
- Instruction account lists are minimal but not under-validated.
- Loops over accounts or vectors are bounded and justified.
- CPI count is minimized where safe.
- Account sizes are minimal and realloc is avoided where possible.
- Data layout is efficient and alignment-safe.
- Rent-exemption is checked where relevant.
- Address Lookup Tables are considered only when transaction size/account count requires them.
- Performance optimizations do not remove validation or weaken invariants.

## Testing and Deployment Checklist

Check:

- `quasar build` runs before tests when tests depend on compiled artifacts.
- Unit and integration tests cover account validation, wrong accounts, wrong signer, wrong owner, wrong PDA, wrong bump, duplicate accounts, and failure paths.
- Tests cover CPI success/failure, Token/Token-2022 behavior, account close/realloc, initialization/reinitialization, and edge math.
- Property/fuzz tests exist for parsers, math, state transitions, and dynamic inputs when risk justifies it.
- Devnet/testnet tests cover realistic accounts and token behavior before production.
- Static analysis and dependency scans run: `cargo clippy`, `cargo audit`, and equivalents.
- Threat model, account diagram, instruction list, state machine, invariants, and privileged roles are documented for external audit readiness.
- Upgrade authority and freeze/deploy plan are explicit.
- `declare_id!`, `Quasar.toml`, generated clients, deployment scripts, and published program id are consistent.
- Verifiable or reproducible builds are used when production risk justifies them; otherwise the gap is documented as residual risk.
- Bug bounty or disclosure policy is considered for production protocols.

## Maintainability and Dead Code

Check:

- Code passes `cargo fmt` and project-native linting.
- Modules are organized by instruction, state, errors, events, helpers, tests, and token/CPI adapters without artificial architecture.
- Critical security checks are not hidden in unrelated helpers or scattered ad hoc conditions.
- Constraints and custom validation are close to the account/instruction they protect.
- Constants, enums, domain types, and helper functions replace magic bytes, seeds, discriminators, and repeated validation logic.
- Dead code is identified and recommended for safe removal:
  - unused instructions, account structs, events, errors, helpers, seeds, constants, modules, tests, scripts, config, features, and dependencies;
  - obsolete branches, stale migrations, old scripts, unused generated clients, commented-out code, and tests keeping removed behavior alive.

## Recommended Commands

Prefer project-native commands first: `Quasar.toml`, `Cargo.toml`, `Makefile`, `justfile`, package scripts, CI config, or docs.

Useful Quasar/Solana audit commands:

```bash
quasar build
quasar test
cargo fmt --check
cargo clippy --all-targets --all-features -- -D warnings
cargo test --all-targets --all-features
cargo audit
cargo tree
cargo expand
cargo miri test
cargo fuzz run <target>
```

Use `cargo expand`, Miri, fuzzing, and compute measurement selectively when the audited code depends on macros, unsafe, account layout, parsing, dynamic data, or high-value math.

Run mutation commands such as formatting or dependency updates only when editing code or when the user asked for fixes.

## What to Flag Aggressively

Escalate:

- Missing signer, owner, discriminator, PDA seed, bump, authority, or account relationship validation.
- `UncheckedAccount` or `remaining_accounts` used without complete manual checks.
- Arbitrary CPI, unvalidated CPI target, or signer/PDA authority forwarded to untrusted programs.
- PDA sharing, seed collision, user-controlled bump, non-canonical ATA, or weak PDA context separation.
- Duplicate mutable account aliasing that can corrupt state.
- Reinitialization, account revival, unsafe close, unsafe realloc, or stale account read after CPI.
- Financial math without checked arithmetic, wide intermediates, or explicit rounding.
- Token-2022 extension assumptions that break vault/accounting/security logic.
- Token mint/owner/authority/decimals/frozen/delegate/close-authority not validated.
- Transfer fee or hook behavior ignored when received amount matters.
- `unsafe` without documented invariant and tests.
- Account layout size/discriminator/alignment mismatch.
- Reachable `.unwrap()`, `.expect()`, `panic!`, ignored `Result`, or unchecked indexing in critical paths.
- Long unbounded loops, heap-heavy logic, or compute-heavy CPI chains.
- Missing slippage/deadline/expected-value checks in DeFi or exchange-like flows.
- Time/slot/sysvar spoofing or unchecked sysvar address.
- Upgrade authority or admin control unclear or overpowered.
- Missing pause/emergency model, unclear multisig/timelock posture, or privileged flow without monitoring events.
- Oracle reads without freshness, confidence, source, decimals, or manipulation checks.
- Vault/share accounting exposed to first depositor, share inflation, NAV initialization, or rounding attacks.
- External signature or instruction sysvar verification without domain separation, expected instruction index, expiry, or replay protection.
- Program id, `declare_id!`, deployment config, generated client, or published artifact mismatch.
- TODO, FIXME, stubs, mock signers, disabled checks, or placeholder logic in production-critical paths.
- Shared canonical payload/digest/signature/binary changes without fixture/test updates.
- Spaghetti growth, files above 1000 lines, weak wrappers, duplicate validation helpers, or refactors that only move complexity.

## Preferred Remedies

For every confirmed problem, provide the most robust practical solution, not only a warning.

Prefer remedies that remove the class of bug:

- Add Quasar account constraints for signer, owner, address, seeds, bump, `has_one`, mint, authority, and custom invariants.
- Move repeated account validation into clear canonical helpers without hiding critical checks.
- Replace `UncheckedAccount` with typed accounts when possible; otherwise validate every property before use.
- Derive PDAs from explicit domain-separated seeds and canonical bumps.
- Store/reuse bumps safely and reject user-controlled bump authority.
- Allowlist CPI programs and isolate signer/PDA authority.
- Reload or re-check mutated accounts after CPI.
- Use checked arithmetic, `u128` intermediates, explicit rounding, and edge-case tests.
- Validate Token-2022 extensions or reject tokens whose extensions break protocol assumptions.
- Add received-amount checks for fee-on-transfer behavior.
- Protect close/realloc/init_if_needed with lifecycle state and revival prevention.
- Encapsulate `unsafe` behind safe APIs with documented safety contracts and Miri/fuzz/layout tests.
- Add slippage, deadline, expected amount, max fee, and replay protections where relevant.
- Add oracle freshness/confidence/source checks, decimal normalization, and manipulation-resistant price assumptions.
- Add minimum liquidity/deposit, safe zero-supply handling, share/NAV invariant tests, and fee caps for vault-like protocols.
- Add pause/emergency controls, two-step authority transfer, multisig/timelock requirements, and monitoring events where protocol risk justifies them.
- Bind off-chain signatures to domain-separated payloads with nonce/deadline and all critical accounts/amounts.
- Verify `declare_id!`, deployed program id, generated clients, upgrade authority, and build provenance before release.
- Split oversized instruction logic into validation, state transition, CPI/token adapter, math helper, and event emission.
- Add account diagrams, invariants, threat model, and high-risk test matrix for external audit readiness.
- Remove proven dead code and obsolete paths.

When multiple remedies exist, distinguish:

- **Robust solution:** preferred production-grade fix.
- **Fast mitigation:** acceptable temporary risk reduction, only when useful.
- **Validation:** tests, simulations, fuzzing, Miri, compute measurement, or manual checks required to prove the fix.

## Review Tone

Be formal, direct, and practical.
Do not soften fund-loss, account spoofing, PDA, CPI, Token-2022, unsafe, or arithmetic risk.
Avoid cosmetic comments when larger risks exist.
Separate confirmed issues from assumptions.
If evidence is missing, say exactly what should be checked.

Good phrases:

- `This instruction mutates protocol state but I do not see a signer/authority constraint. This should block release.`
- `This PDA accepts authority from user-controlled input. Derive and verify canonical seeds and bump instead.`
- `This CPI target is user-provided. Allowlist the program id before invoking.`
- `This account is unchecked but later trusted as protocol state. Validate owner, discriminator, address, and mutability before use.`
- `This token flow ignores Token-2022 transfer fees. Check the received amount or reject incompatible extensions.`
- `This math can overflow or round against the invariant. Use checked arithmetic and wide intermediates.`
- `This unsafe block has no documented invariant. Encapsulate it and add layout/Miri tests.`
- `This compute optimization removes validation. Fund safety wins over CU savings.`

## Output Expectations

Start with an **Executive Snapshot**:

- Overall risk: Critical, High, Medium, or Low
- Release stance: Block release, release after fixes, or no major blocker found
- Scope reviewed: instructions/accounts/flows/configs actually inspected
- Discovery pass: high-risk patterns found or not found, with any skipped searches stated
- Top risks: 3-5 highest-impact issues or residual concerns
- Validation run or still needed

Prioritize findings:

1. Fund loss, vault, token, lamport, mint, custody, or accounting risks
2. Signer, owner, PDA, discriminator, account validation, and authority failures
3. CPI, Token/Token-2022, ATA, sysvar, and composability risks
4. Arithmetic, precision, slippage, deadline, replay, and economic invariant risks
5. Oracle, external signature, instruction sysvar, event, and monitoring risks
6. Zero-copy, account layout, `unsafe`, FFI-like, dynamic field, and `no_std` soundness risks
7. State lifecycle, reinitialization, close, realloc, revival, and stale-account risks
8. Governance, upgrade authority, deploy provenance, compute, and production-readiness issues
9. Dependency, testing, documentation, disclosure, and audit-readiness gaps
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

After findings, include a **Recommended Fix Plan** ordered by risk and dependency. The plan must be concrete enough for an agent to implement without guessing, naming visible files, instructions, accounts, tests, and commands when available.

If no serious findings are found, say that clearly and list residual risks or tests not run.

## Approval Bar

Do not approve a Quasar Solana program for production while any of these remain unresolved:

- Any privileged state or asset mutation lacks signer/authority validation.
- Any trusted account lacks owner/type/discriminator/address/PDA validation.
- User-controlled bump, weak PDA seeds, PDA sharing, or seed collision can affect authority.
- Arbitrary CPI or unvalidated CPI target can execute with user/protocol authority.
- Token vault/accounting logic ignores mint, authority, decimals, frozen state, delegates, close authority, or Token-2022 extensions.
- Financial math can overflow, underflow, divide by zero, truncate unsafely, or round against protocol invariants.
- Account close, realloc, or init path allows revival, reinitialization, or stale state.
- `UncheckedAccount` or `remaining_accounts` are trusted without complete manual validation.
- Reachable `.unwrap()`, `.expect()`, `panic!`, ignored `Result`, or unchecked indexing exists in critical paths.
- Custom `unsafe` or zero-copy layout assumptions lack safety contract and validation.
- Critical invariants lack tests for wrong signer/account/PDA/mint, edge amounts, CPI failure, and repeated calls.
- Upgrade authority, admin powers, or deployment immutability plan is unclear for production.
- Oracle, price, external signature, or instruction sysvar logic is used without freshness/source/domain/replay validation.
- Vault/share logic is vulnerable to first depositor, share inflation, bad zero-supply, fee, decimal, or NAV accounting attacks.
- Published program identity, deployment config, generated clients, or build provenance cannot be tied back to reviewed source.

If approval is blocked, give the shortest robust path to make the program safe enough for the next review.

---
name: solana-anchor-audit-optimizer
description: Audit and optimize Solana programs built with the Anchor framework for account constraints, PDA safety, CPI security, SPL Token/Token-2022 behavior, arithmetic, lifecycle risks, compute units, dead code, and deployment readiness. Use for Anchor, anchor-lang, anchor-spl, Solana program, #[program], #[derive(Accounts)], #[account], remaining_accounts, PDA, CPI, SPL Token, Token-2022, IDL, or Sealevel security reviews.
---

# Solana Anchor Program Audit Optimizer

Use this skill to audit Solana programs built with Anchor. Focus on user funds, account constraints, authority validation, PDA safety, CPI correctness, Token-2022 edge cases, arithmetic precision, state lifecycle, compute efficiency, and maintainable on-chain Rust.

Skill metadata:

- Version: 1.0.0
- License: MIT

Important: Anchor reduces boilerplate but does not prove business logic safe. Audit the account constraints, instruction logic, CPIs, token assumptions, and economic invariants directly.

Prioritize:

1. User funds and protocol asset safety
2. Signer, owner, PDA, account type, and authority validation
3. CPI and SPL Token/Token-2022 security
4. Arithmetic, state invariants, and lifecycle correctness
5. Anchor constraints, IDL, generated clients, and deployment correctness
6. Compute-unit efficiency and audit-ready maintainability

## Core Prompt

Start from this baseline:

> Perform a strict audit of this Solana Anchor program.
> Prioritize fund safety, account validation, PDA safety, CPI security, Token-2022 edge cases, arithmetic correctness, state lifecycle, compute efficiency, production safety, and code quality.
> Look for issues that could cause unauthorized account access, fund loss, account spoofing, type cosplay, arbitrary CPI, incorrect PDA authority, account revival, broken invariants, precision loss, compute exhaustion, or unsafe framework assumptions.
> Review the code like a production Solana protocol, even if it is still an MVP.
> For every confirmed problem, provide the most robust practical solution, plus validation steps.

The audit is complete only after every applicable standard has been checked and every finding includes a robust solution and validation path.

## Scope Selection

First identify the project shape:

- Anchor setup: `anchor-lang`, `anchor-spl`, `Anchor.toml`, `#[program]`, `#[derive(Accounts)]`, `#[account]`, `#[event]`, IDL, generated clients, tests, and deployment scripts.
- Program type: escrow, vault, staking, AMM, launchpad, governance, multisig, allowlist, payment, rewards, oracle, policy program, or custom protocol.
- Asset surface: lamports, SPL Token, Token-2022, ATAs, mint/burn, fees, vaults, rewards, PDAs, CPIs, ALTs, or off-chain companion services.
- Account model: PDAs, signers, unchecked accounts, zero-copy, account loaders, `remaining_accounts`, sysvars, close/realloc, upgrade authority, and stored bumps.
- Risk profile: funds at risk, authority transfer, composability, public instructions, privileged admin flows, DeFi/MEV, oracle dependency, or external signature verification.

Mark items as not applicable only with a clear reason.

## Evidence and Traceability Protocol

Use a traceable audit flow for non-trivial programs:

- Inspect incrementally by instruction, accounts struct, account type, PDA derivation, CPI path, token flow, state transition, test, config, IDL, and deployment setting.
- Do not mark an area as safe without citing concrete evidence: file, instruction, accounts constraint, account field, seed list, bump source, CPI target, test, command output, or invariant.
- If repository size or context limits prevent full coverage, state what was reviewed, what was not reviewed, and which high-risk areas remain.
- Track each meaningful area with one of these statuses:
  - **Verified:** evidence supports the control or invariant.
  - **Issue:** evidence shows a concrete problem.
  - **Partial:** evidence is incomplete or the control exists but has gaps.
  - **Not applicable:** the area does not apply, with reason.
- Add a confidence level to important findings when certainty is not absolute: High, Medium, or Low.
- Use lower confidence when macro expansion, generated IDL/client code, account loaders, zero-copy, remaining accounts, Token-2022 extensions, CPI dependency chains, or missing tests make behavior harder to prove.

## Discovery Pass

Before deep review, search for high-risk Anchor/Solana patterns and use the results to guide the audit:

- Account risk: `UncheckedAccount`, `AccountInfo`, `remaining_accounts`, `AccountLoader`, `zero_copy`, duplicate mutable accounts, sysvars, `realloc`, `close`, and `init_if_needed`.
- Constraint risk: `/// CHECK:`, `constraint =`, `require_keys_eq!`, `has_one`, `address =`, `seeds =`, `bump`, `owner =`, `signer`, `mut`, `payer`, `space`, `token::mint`, `token::authority`, `associated_token::mint`, `associated_token::authority`, and missing custom constraints.
- Authority/PDA risk: `authority`, `admin`, `owner`, `manager`, `delegate`, `set_authority`, `invoke_signed`, stored bump fields, and upgrade-related code.
- Value movement risk: `transfer`, `transfer_checked`, `mint_to`, `burn`, `close_account`, `approve`, `freeze`, `thaw`, fee logic, vault logic, and share/NAV accounting.
- Runtime failure risk: `.unwrap()`, `.expect()`, `panic!`, unchecked indexing, ignored `Result`, unchecked casts, `saturating_*`, and custom `unsafe`.
- Economic/composability risk: oracle reads, price feeds, slippage, deadlines, instruction sysvar, Ed25519/Secp256k1 verification, flash-loan-sensitive flows, and public instructions.

## Instruction Review Matrix

For high-risk instructions, build a compact per-instruction matrix before concluding:

- Handler, file, caller role, risk tier, state mutated, assets moved, and expected authority.
- Every account: type, mutability, signer status, owner/discriminator, constraints, PDA seeds, bump source, and whether validation is compile-time, runtime, partial, or missing.
- Every CPI: target program, operation, authority, signer seeds, account forwarding, balance/state delta checks, and post-CPI reload needs.
- Every state/value change: preconditions, state transition, arithmetic, rounding, emitted event, idempotency, and repeated-call behavior.
- Every token/SOL movement: amount source, from/to, authority, mint/decimals, ATA assumption, fee behavior, and before/after balance proof.
- Mark N/A only with a reason and cross-reference related instructions that touch the same state.

## Non-Negotiable Standards

Apply these rules aggressively:

1. **Account validation must be complete.**
   - Every privileged instruction requires correct signer checks.
   - Account owner, discriminator, writable/read-only intent, PDA seeds, canonical bump, and authority relationships must be validated.
   - `UncheckedAccount`, `AccountInfo`, and `remaining_accounts` require explicit manual validation before use.
   - Sysvars and programs must be typed or pinned to expected addresses.

2. **Anchor constraints must express the security model.**
   - Use `Signer<'info>`, `Program<'info, T>`, `Account<'info, T>`, `InterfaceAccount`, `has_one`, `address`, `seeds`, `bump`, `owner`, `constraint`, `token::mint`, and `token::authority` where appropriate.
   - Do not rely on pubkey equality alone when signer status, ownership, type, or mutability matters.
   - For critical relationships, pair Anchor constraints with runtime assertions such as `require_keys_eq!` when it improves defense in depth or protects logic outside the accounts struct.
   - Reject duplicate mutable accounts when aliasing can break invariants.
   - Treat Anchor-generated checks as useful but still audit every custom constraint and every missing constraint.

3. **PDA authority must be unspoofable.**
   - Derive PDAs from canonical seeds and program id.
   - Never accept user-provided bumps as trusted authority.
   - Store and reuse bumps safely when intended.
   - Include user/protocol/context-specific seeds to prevent PDA sharing, seed collision, or cross-context confusion.
   - Variable-length or user-controlled seeds need length limits, normalization, or unambiguous encoding; mutable state must not be used as a seed if it can later orphan the PDA.

4. **CPI must not be arbitrary or authority-leaking.**
   - Validate target program ids for every CPI.
   - Do not forward user signers or protocol PDA signers to untrusted programs.
   - Use protocol PDAs as authorities where appropriate.
   - Call `.reload()` or re-check accounts after CPI when downstream changes can affect state.
   - Check lamport/token balances before and after CPI when correctness depends on transferred value.

5. **Arithmetic and value movement must be safe.**
   - Use checked arithmetic for balances, fees, shares, rewards, slippage, quotas, and supply.
   - Use `u128` intermediates where multiplication/division can overflow or lose precision.
   - Define rounding explicitly; avoid `try_round_u64` or `saturating_*` when it can hide losses or favor attackers.
   - Prevent division by zero, bad casts, signed confusion, and unchecked truncation.

6. **State lifecycle must prevent revival and reinitialization.**
   - `init_if_needed`, realloc, close, and authority transfer must have explicit safety checks.
   - Closed accounts must not be reusable as valid state.
   - State transitions must validate current state before mutation.
   - Lamports and rent-exemption must be considered where relevant.

7. **Fix root causes, not symptoms.**
   - Do not recommend one-off guards when the real issue is a missing constraint, weak PDA model, broken authority invariant, unsafe lifecycle, or scattered validation.
   - Prefer strengthening account constraints, PDA seeds, stored state invariants, CPI wrappers, token validation, or shared helpers.

8. **Optimize only with evidence.**
   - Require compute-unit measurements, program-test benchmarks, transaction simulations, logs, or clear hot-path evidence before complex compute optimizations.
   - Anchor performance matters, but never trade away validation, invariant clarity, or fund safety.

## Anchor-Specific Safety Standards

Audit Anchor behavior carefully:

- Framework dependencies should be pinned to a production-appropriate Anchor/Solana version.
- `Anchor.toml`, program ids, IDL, generated clients, deployment scripts, and `declare_id!` must agree.
- `#[derive(Accounts)]` constraints must cover every security relationship, not only account shape.
- `Account<'info, T>` is preferred for owned Anchor state; `UncheckedAccount` and raw `AccountInfo` require full manual validation.
- Every `UncheckedAccount` should have a precise `/// CHECK:` comment and matching runtime validation; vague comments without owner/address/discriminator/signer/writable checks are findings.
- `Program<'info, System>`, token programs, associated token program, and sysvars must not be replaceable by arbitrary accounts.
- Pay special attention to known framework/runtime issues; if a specific Anchor or Solana version has a relevant CVE or advisory, validate the installed version before concluding.
- CPI construction patterns must match the installed Anchor version; flag stale examples, wrong `CpiContext::new`/`new_with_signer` argument shape, or `.to_account_info()` usage that bypasses intended typed program validation.
- `AccountLoader` and zero-copy accounts require discriminator, owner, mutability, alignment, size, and borrow-safety review.
- `#[account(init)]`, `init_if_needed`, `realloc`, `close`, `space`, `payer`, and `seeds` must be consistent with lifecycle and rent assumptions.
- `ctx.remaining_accounts` must only be used when dynamic accounts are required and fully validated for length, order, owner, type, signer, writability, and relationship.
- Review macro-expanded code or generated IDL when security depends on macro behavior or client account ordering.

## Solana Security Checklist

### Account Validation and Access Control

Check:

- Signer checks exist for every authority-sensitive instruction.
- Owner checks confirm accounts belong to expected program/token/system owners.
- Anchor discriminators and account types match the intended state.
- `has_one`, `address`, `constraint`, `seeds`, `bump`, `owner`, `token::mint`, and `token::authority` constraints cover all relationships.
- `/// CHECK:` comments are specific and backed by actual validation in the accounts struct or handler.
- Critical relationships that affect funds or privileges are reasserted at runtime when logic depends on them beyond Anchor deserialization.
- Duplicate mutable accounts are rejected when aliasing can corrupt state or accounting.
- `remaining_accounts` are length-checked, owner-checked, type-checked, signer/writable-checked, and order-checked.
- Authority transfer uses two-step nominate/accept when risk justifies it.
- Upgrade authority, admin authority, and deployer privileges are documented and constrained.
- Time/slot logic validates Clock sysvar and handles boundary cases.

### Governance, Admin, and Emergency Controls

Check:

- Admin, manager, fee, oracle, pause, and upgrade authorities are explicit, minimally scoped, and validated by address/state relationship.
- High-risk authority changes use two-step nominate/accept, multisig, timelock, or an equivalent control when production funds are at risk.
- Pause or emergency flows cannot steal funds, bypass accounting, permanently lock users without governance intent, or create privileged withdrawal paths.
- ProgramData, upgrade authority, program id, deployment cluster, and immutability plan are documented and match the intended release posture.
- Privileged instructions emit sufficient events/logs for monitoring without leaking sensitive data.

### State, Lifecycle, and Invariants

Check:

- Initialization cannot be repeated unless explicitly safe.
- `init_if_needed` cannot reset, hijack, or front-run existing state.
- Account close uses `#[account(close = receiver)]` or equivalent safe logic, transfers all lamports, clears sensitive data, and prevents revival.
- Realloc uses correct size, payer, rent, `zero_init`, and invariant checks.
- Accounts are reloaded or revalidated after CPI when mutated by downstream programs.
- State transitions check current status, authority, deadlines, limits, balances, and protocol invariants before mutation.
- Economic invariants are explicit: supply, vault balance, shares, fees, rewards, limits, collateral, slippage, and accounting totals.
- Vault/share protocols defend against first depositor attacks, share inflation, bad zero-supply branches, incorrect NAV initialization, and rounding that benefits attackers.
- Fees, decimals, and unit conversions are normalized across mints and cannot exceed configured caps.
- Tests cover edge cases: zero, one, max, overflow, underflow, stale state, wrong authority, wrong account, wrong mint, and repeated calls.

### CPI, Tokens, and Token-2022

Check:

- CPI target program ids are validated and preferably typed with `Program<'info, T>` or allowlisted.
- `CpiContext::new_with_signer` seeds match the intended PDA authority.
- CPI context construction matches the installed Anchor version and does not use obsolete or untyped patterns that weaken program validation.
- User signers are not forwarded to arbitrary programs.
- Token mint, owner, authority, decimals, frozen state, delegate, close authority, and ATA are validated where relevant.
- Use `transfer_checked` or amount/decimal-aware wrappers where possible.
- Token-2022 extensions are considered: transfer hooks, transfer fees, permanent delegate, mint close authority, default frozen state, CPI guard, confidential transfer, and other active extensions.
- Deposits account for transfer fees or received amount mismatch.
- ATAs are validated canonically with `associated_token::mint`, `associated_token::authority`, and the correct `associated_token::token_program` when canonical ATA identity matters.
- Vaults reject risky token extensions when protocol assumptions require standard SPL behavior.
- `token::close_account` CPI destinations are constrained to known recipients and cannot close primary vaults or route rent to attacker-controlled accounts.
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
- Events/logs do not leak sensitive material and are compute-aware.
- Critical state changes emit events or structured logs with enough fields for monitoring, reconciliation, and incident response.
- Idempotency is considered where repeated instruction submission can happen.

## Performance and Compute Checklist

Check:

- Compute unit usage is measured for critical instructions.
- Instruction account lists are minimal but not under-validated.
- Loops over accounts or vectors are bounded and justified.
- CPI count is minimized where safe.
- Account sizes are minimal and realloc is avoided where possible.
- Serialization/deserialization overhead is considered; use zero-copy only when the safety tradeoff is justified.
- Rent-exemption is checked where relevant.
- Address Lookup Tables are considered only when transaction size/account count requires them.
- Priority fees and compute-unit limits are handled at the client/transaction layer when needed.
- Performance optimizations do not remove validation or weaken invariants.

## Testing and Deployment Checklist

Check:

- `anchor build` runs before tests when tests depend on compiled artifacts or IDL.
- Unit and integration tests cover account validation, wrong accounts, wrong signer, wrong owner, wrong PDA, wrong bump, duplicate accounts, and failure paths.
- Tests cover CPI success/failure, Token/Token-2022 behavior, account close/realloc, initialization/reinitialization, and edge math.
- Property/fuzz tests exist for parsers, math, state transitions, and dynamic inputs when risk justifies it.
- Local validator and devnet/testnet tests cover realistic accounts and token behavior before production.
- Static analysis and dependency scans run: `cargo clippy`, `cargo audit`, and equivalents.
- Threat model, account diagram, instruction list, state machine, invariants, and privileged roles are documented for external audit readiness.
- Upgrade authority and freeze/deploy plan are explicit.
- `declare_id!`, `Anchor.toml`, IDL, generated clients, deployment scripts, and published program id are consistent.
- Production deployments are checked with chain-level evidence such as `solana program show` and, when supported, `anchor verify`.
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
  - unused instructions, account structs, events, errors, helpers, seeds, constants, modules, tests, scripts, config, features, IDL/client artifacts, and dependencies;
  - obsolete branches, stale migrations, old scripts, commented-out code, and tests keeping removed behavior alive.

## Recommended Commands

Prefer project-native commands first: `Anchor.toml`, `Cargo.toml`, `Makefile`, `justfile`, package scripts, CI config, or docs.

Useful Anchor/Solana audit commands:

```bash
anchor build
anchor test
solana program show <PROGRAM_ID> --url <CLUSTER>
anchor verify <PROGRAM_ID> --provider-url <RPC_URL>
cargo fmt --check
cargo clippy --all-targets --all-features -- -D warnings
cargo test --all-targets --all-features
cargo audit
cargo tree
cargo expand
cargo miri test
cargo fuzz run <target>
```

Use `cargo expand`, Miri, fuzzing, and compute measurement selectively when the audited code depends on macros, unsafe, zero-copy, account layout, parsing, dynamic data, or high-value math.

Run mutation commands such as formatting or dependency updates only when editing code or when the user asked for fixes.

## What to Flag Aggressively

Escalate:

- Missing signer, owner, discriminator, PDA seed, bump, authority, or account relationship validation.
- `UncheckedAccount`, raw `AccountInfo`, or `remaining_accounts` used without complete manual checks.
- `UncheckedAccount` with vague or missing `/// CHECK:` comment, or a comment that is not matched by real validation.
- Anchor constraints that validate account shape but not authority, ownership, state, mutability, or relationship.
- Critical authority or account relationships enforced only by one layer when runtime reassertion is needed for defense in depth.
- Arbitrary CPI, unvalidated CPI target, or signer/PDA authority forwarded to untrusted programs.
- Stale or version-incompatible Anchor CPI construction that weakens typed program validation.
- PDA sharing, seed collision, user-controlled bump, variable-length seed ambiguity, mutable seed orphaning, non-canonical ATA, or weak PDA context separation.
- Duplicate mutable account aliasing that can corrupt state.
- Reinitialization, init frontrunning, account revival, unsafe close, unsafe realloc, or stale account read after CPI.
- Financial math without checked arithmetic, wide intermediates, or explicit rounding.
- Token-2022 extension assumptions that break vault/accounting/security logic.
- Token mint/owner/authority/decimals/frozen/delegate/close-authority not validated.
- Transfer fee or hook behavior ignored when received amount matters.
- Token close CPI can close a vault, sends rent to an unconstrained account, or fails to restrict the destination.
- `unsafe`, zero-copy, or `AccountLoader` use without documented invariant and tests.
- Account space/discriminator/alignment mismatch.
- Reachable `.unwrap()`, `.expect()`, `panic!`, ignored `Result`, or unchecked indexing in critical paths.
- Long unbounded loops or compute-heavy CPI chains.
- Missing slippage/deadline/expected-value checks in DeFi or exchange-like flows.
- Time/slot/sysvar spoofing or unchecked sysvar address.
- Upgrade authority or admin control unclear or overpowered.
- Missing pause/emergency model, unclear multisig/timelock posture, or privileged flow without monitoring events.
- Oracle reads without freshness, confidence, source, decimals, or manipulation checks.
- Vault/share accounting exposed to first depositor, share inflation, NAV initialization, or rounding attacks.
- External signature or instruction sysvar verification without domain separation, expected instruction index, expiry, or replay protection.
- Program id, `declare_id!`, `Anchor.toml`, IDL, generated client, or published artifact mismatch.
- Missing chain-level deploy evidence for production claims, such as program data, upgrade authority, or verification output.
- TODO, FIXME, stubs, mock signers, disabled checks, or placeholder logic in production-critical paths.
- Spaghetti growth, files above 1000 lines, weak wrappers, duplicate validation helpers, or refactors that only move complexity.

## Preferred Remedies

For every confirmed problem, provide the most robust practical solution, not only a warning.

Prefer remedies that remove the class of bug:

- Add Anchor constraints for signer, owner, address, seeds, bump, `has_one`, mint, authority, and custom invariants.
- Add precise `/// CHECK:` comments for unavoidable unchecked accounts and make the handler/accounts struct enforce the documented owner, address, discriminator, signer, writable, and relationship checks.
- Add runtime assertions such as `require_keys_eq!` for critical relationships when defense in depth is justified.
- Replace `UncheckedAccount` or raw `AccountInfo` with typed Anchor accounts when possible; otherwise validate every property before use.
- Move repeated account validation into clear canonical helpers without hiding critical checks.
- Derive PDAs from explicit domain-separated seeds and canonical bumps.
- Normalize or length-limit variable seeds; avoid mutable seed components unless the PDA lifecycle intentionally depends on them.
- Store/reuse bumps safely and reject user-controlled bump authority.
- Allowlist CPI programs and isolate signer/PDA authority.
- Update CPI construction to the project’s installed Anchor API and keep program accounts typed or allowlisted.
- Reload or re-check mutated accounts after CPI.
- Use checked arithmetic, `u128` intermediates, explicit rounding, and edge-case tests.
- Validate Token-2022 extensions or reject tokens whose extensions break protocol assumptions.
- Add received-amount checks for fee-on-transfer behavior.
- Use canonical associated-token constraints when ATA identity matters, including the expected associated token program and token program.
- Constrain token close destinations and prevent primary vault closure except through an explicit safe shutdown path.
- Protect close/realloc/init_if_needed with lifecycle state and revival prevention.
- Encapsulate `unsafe`, zero-copy, and `AccountLoader` patterns behind safe APIs with documented safety contracts and Miri/fuzz/layout tests.
- Add slippage, deadline, expected amount, max fee, and replay protections where relevant.
- Add oracle freshness/confidence/source checks, decimal normalization, and manipulation-resistant price assumptions.
- Add minimum liquidity/deposit, safe zero-supply handling, share/NAV invariant tests, and fee caps for vault-like protocols.
- Add pause/emergency controls, two-step authority transfer, multisig/timelock requirements, and monitoring events where protocol risk justifies them.
- Bind off-chain signatures to domain-separated payloads with nonce/deadline and all critical accounts/amounts.
- Verify `declare_id!`, deployed program id, IDL, generated clients, upgrade authority, and build provenance before release.
- Use `solana program show` and `anchor verify` or equivalent chain/build evidence for production deployment claims.
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
- `This Anchor constraint proves the PDA shape but not the stored authority relationship. Add has_one or an explicit constraint.`
- `This CPI target is user-provided. Type or allowlist the program id before invoking.`
- `This account is unchecked but later trusted as protocol state. Validate owner, discriminator, address, and mutability before use.`
- `This token flow ignores Token-2022 transfer fees. Check the received amount or reject incompatible extensions.`
- `This math can overflow or round against the invariant. Use checked arithmetic and wide intermediates.`
- `This account must be reloaded after CPI before reading its balance/state.`
- `This compute optimization removes validation. Fund safety wins over CU savings.`

## Output Expectations

Start with an **Executive Snapshot**:

- Overall risk: Critical, High, Medium, or Low
- Release stance: Block release, release after fixes, or no major blocker found
- Scope reviewed: instructions/accounts/flows/configs/IDL actually inspected
- Discovery pass: high-risk patterns found or not found, with any skipped searches stated
- Top risks: 3-5 highest-impact issues or residual concerns
- Validation run or still needed

Prioritize findings:

1. Fund loss, vault, token, lamport, mint, custody, or accounting risks
2. Signer, owner, PDA, discriminator, account validation, and authority failures
3. Anchor constraint, IDL/client mismatch, and framework-assumption risks
4. CPI, Token/Token-2022, ATA, sysvar, and composability risks
5. Arithmetic, precision, slippage, deadline, replay, and economic invariant risks
6. Oracle, external signature, instruction sysvar, event, and monitoring risks
7. Zero-copy, account layout, `unsafe`, `AccountLoader`, dynamic field, and borrow-safety risks
8. State lifecycle, reinitialization, close, realloc, revival, and stale-account risks
9. Governance, upgrade authority, deploy provenance, compute, and production-readiness issues
10. Dependency, testing, documentation, disclosure, and audit-readiness gaps
11. Structural quality, dead code, weak abstraction, and maintainability risks

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

Do not approve an Anchor Solana program for production while any of these remain unresolved:

- Any privileged state or asset mutation lacks signer/authority validation.
- Any trusted account lacks owner/type/discriminator/address/PDA validation.
- Anchor constraints do not prove required authority, ownership, state, mutability, or relationship invariants.
- User-controlled bump, weak PDA seeds, PDA sharing, or seed collision can affect authority.
- Arbitrary CPI or unvalidated CPI target can execute with user/protocol authority.
- Token vault/accounting logic ignores mint, authority, decimals, frozen state, delegates, close authority, or Token-2022 extensions.
- Financial math can overflow, underflow, divide by zero, truncate unsafely, or round against protocol invariants.
- Account close, realloc, or init path allows revival, reinitialization, init frontrunning, or stale state.
- `UncheckedAccount`, raw `AccountInfo`, or `remaining_accounts` are trusted without complete manual validation.
- Reachable `.unwrap()`, `.expect()`, `panic!`, ignored `Result`, or unchecked indexing exists in critical paths.
- Custom `unsafe`, zero-copy, or `AccountLoader` assumptions lack safety contract and validation.
- Critical invariants lack tests for wrong signer/account/PDA/mint, edge amounts, CPI failure, and repeated calls.
- Upgrade authority, admin powers, or deployment immutability plan is unclear for production.
- Oracle, price, external signature, or instruction sysvar logic is used without freshness/source/domain/replay validation.
- Vault/share logic is vulnerable to first depositor, share inflation, bad zero-supply, fee, decimal, or NAV accounting attacks.
- Published program identity, `Anchor.toml`, IDL, generated clients, deployment config, or build provenance cannot be tied back to reviewed source.

If approval is blocked, give the shortest robust path to make the program safe enough for the next review.

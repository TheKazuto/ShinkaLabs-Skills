# Solana Pinocchio Program Audit Optimizer

Use this skill to audit Solana programs built with Pinocchio or native low-level Solana patterns. Focus on user funds, manual account validation, PDA safety, CPI correctness, zero-copy and `unsafe` soundness, Token-2022 edge cases, arithmetic precision, lifecycle safety, compute efficiency, and maintainable on-chain Rust.

Skill metadata:

- Version: 1.0.0
- License: MIT

Important: Pinocchio is not Anchor or Quasar. Do not assume automatic account validation, discriminators, signer checks, owner checks, bounds checks, or safe deserialization. Every safety guarantee must be proven in code.

Prioritize:

1. User funds and protocol asset safety
2. Manual signer, owner, account type, PDA, and authority validation
3. CPI and SPL Token/Token-2022 security
4. Arithmetic, state invariants, and lifecycle correctness
5. Pinocchio zero-copy, `unsafe`, buffer parsing, and `no_std` soundness
6. Compute-unit efficiency and deploy readiness

## Core Prompt

Start from this baseline:

> Perform a strict audit of this Solana Pinocchio program.
> Prioritize fund safety, manual account validation, PDA safety, CPI security, Token-2022 edge cases, arithmetic correctness, zero-copy soundness, compute efficiency, production safety, and code quality.
> Look for issues that could cause unauthorized account access, fund loss, account spoofing, type cosplay, arbitrary CPI, incorrect PDA authority, account revival, broken invariants, precision loss, compute exhaustion, or unsafe memory assumptions.
> Review the code like a production Solana protocol, even if it is still an MVP.
> For every confirmed problem, provide the most robust practical solution, plus validation steps.

The audit is complete only after every applicable standard has been checked and every finding includes a robust solution and validation path.

## Scope Selection

First identify the project shape:

- Pinocchio setup: `pinocchio`, `pinocchio-token`, `pinocchio-system`, `entrypoint!`, `program_entrypoint!`, `process_instruction`, custom instruction parsing, custom account layouts, and tests.
- Program type: escrow, vault, staking, AMM, token launch, governance, multisig, allowlist, payment, rewards, oracle, policy program, token reimplementation, or custom protocol.
- Asset surface: lamports, SPL Token, Token-2022, ATAs, mint/burn, fees, vaults, rewards, PDAs, CPIs, ALTs, or off-chain companion services.
- Account model: raw accounts, PDAs, signers, writable accounts, sysvars, manual discriminators, zero-copy state, close/realloc, upgrade authority, and stored bumps.
- Risk profile: funds at risk, authority transfer, composability, public instructions, privileged admin flows, DeFi/MEV, oracle dependency, external signatures, or SPL Token semantic compatibility.

Mark items as not applicable only with a clear reason.

## Evidence and Traceability Protocol

Use a traceable audit flow for non-trivial programs:

- Inspect incrementally by instruction, account order, account type, layout parser, PDA derivation, CPI path, token flow, state transition, test, config, and deployment setting.
- Do not mark an area as safe without citing concrete evidence: file, instruction, account index, manual check, field offset, seed list, bump source, CPI target, test, command output, or invariant.
- If repository size or context limits prevent full coverage, state what was reviewed, what was not reviewed, and which high-risk areas remain.
- Track each meaningful area with one of these statuses:
  - **Verified:** evidence supports the control or invariant.
  - **Issue:** evidence shows a concrete problem.
  - **Partial:** evidence is incomplete or the control exists but has gaps.
  - **Not applicable:** the area does not apply, with reason.
- Add a confidence level to important findings when certainty is not absolute: High, Medium, or Low.
- Use lower confidence when account order, manual layout parsing, `unsafe`, zero-copy, Token-2022 extensions, CPI dependency chains, or missing tests make behavior harder to prove.

## Discovery Pass

Before deep review, search for high-risk Pinocchio/Solana patterns and use the results to guide the audit:

- Account risk: `AccountInfo`, `next_account_info`, indexed access such as `accounts[3]`, `.is_signer`, `.is_writable`, `.owner`, `.key`, `data_len`, `borrow_data`, `try_borrow`, duplicate mutable accounts, sysvars, `realloc`, `set_data_length`, close logic, and manual lamport edits.
- Parsing/layout risk: `unsafe`, `get_unchecked`, `from_raw_parts`, `as_ptr`, `.add(`, `transmute`, `bytemuck`, `Pod`, `Zeroable`, `repr(C)`, `align`, `offset`, `split_at`, slice ranges, `try_from_bytes`, and custom discriminators.
- Authority/PDA risk: `authority`, `admin`, `owner`, `manager`, `delegate`, `set_authority`, `invoke_signed`, `create_program_address`, `find_program_address`, stored bump fields, and upgrade-related code.
- Value movement risk: `transfer`, `transfer_checked`, `mint_to`, `burn`, `close_account`, `approve`, `freeze`, `thaw`, fee logic, vault logic, and share/NAV accounting.
- Runtime failure risk: `.unwrap()`, `.expect()`, `panic!`, unchecked indexing, ignored `Result`, unchecked casts, `saturating_*`, and custom error conversion.
- Economic/composability risk: oracle reads, price feeds, slippage, deadlines, instruction sysvar, Ed25519/Secp256k1 verification, flash-loan-sensitive flows, and public instructions.

## Instruction Review Matrix

For high-risk instructions, build a compact per-instruction matrix before concluding:

- Handler, file, instruction discriminator/tag, account order, caller role, risk tier, state mutated, assets moved, and expected authority.
- Every account: index, expected key/owner/type, mutability, signer status, writable status, PDA seeds, bump source, data length, discriminator/layout, and validation evidence.
- Every parser: input slice, length checks, offset calculations, alignment assumptions, endian assumptions, enum/tag validation, and rejected malformed data.
- Every CPI: target program, operation, authority, signer seeds, forwarded accounts, balance/state delta checks, and post-CPI revalidation needs.
- Every state/value change: preconditions, state transition, arithmetic, rounding, emitted log/event, idempotency, and repeated-call behavior.
- Every token/SOL movement: amount source, from/to, authority, mint/decimals, ATA assumption, fee behavior, and before/after balance proof.

## Non-Negotiable Standards

Apply these rules aggressively:

1. **Manual account validation must be complete.**
   - Every privileged instruction requires explicit `is_signer` checks.
   - Every trusted account needs explicit key, owner, type/discriminator, data length, writable/read-only intent, PDA seeds, canonical bump, and authority relationship validation.
   - Account order must be validated; do not trust positional accounts without checking every expected property before use.
   - Sysvars and programs must be pinned to expected addresses; prefer runtime syscalls for Clock/Rent when possible.

2. **PDA authority must be unspoofable.**
   - Derive PDAs from canonical seeds and program id.
   - Never accept user-provided bumps as trusted authority.
   - Store and reuse canonical bumps when intended.
   - Include user/protocol/context-specific seeds to prevent PDA sharing, seed collision, or cross-context confusion.
   - Variable-length or user-controlled seeds need length limits, normalization, or unambiguous encoding; mutable state must not orphan PDAs unless intentional.

3. **CPI must not be arbitrary or authority-leaking.**
   - Validate target program ids for every CPI.
   - Do not forward user signers or protocol PDA signers to untrusted programs.
   - Use protocol PDAs as authorities where appropriate.
   - Re-check owner, data, and balances after CPI when downstream changes can affect state.
   - Check lamport/token balances before and after CPI when correctness depends on transferred value.

4. **Zero-copy and unsafe must be proven sound.**
   - Every account and instruction layout needs explicit size, discriminator/tag, alignment, bounds, and representation checks.
   - `unsafe` must be minimized, documented with a safety contract, contained behind safe APIs, and tested.
   - `Pod`, `Zeroable`, `Copy`, and `repr(C)` assumptions must be valid for every layout.
   - Parsing must reject short buffers, extra unsupported variants, invalid tags, wrong owner, wrong discriminator, bad alignment, and offset/slice values outside the verified buffer range.

5. **Arithmetic and value movement must be safe.**
   - Use checked arithmetic for balances, fees, shares, rewards, slippage, quotas, and supply.
   - Use `u128` intermediates where multiplication/division can overflow or lose precision.
   - Define rounding explicitly; avoid `saturating_*` on financial paths when it can hide loss or corruption.
   - Prevent division by zero, bad casts, signed confusion, and unchecked truncation.

6. **State lifecycle must prevent revival and reinitialization.**
   - Init, realloc, close, and authority transfer must have explicit safety checks.
   - Closed accounts must not be reusable as valid state.
   - Manual close must drain all lamports, overwrite/zero data or closed discriminator, and prevent stale same-transaction reads.
   - State transitions must validate current state before mutation.

7. **Fix root causes, not symptoms.**
   - Do not recommend one-off guards when the real issue is missing validation, weak PDA model, broken authority invariant, unsafe layout, or scattered parsing.
   - Prefer strengthening canonical validation helpers, PDA seeds, stored invariants, CPI wrappers, token validation, or safe parsers.

8. **Optimize only with evidence.**
   - Require compute-unit measurements, program-test benchmarks, transaction simulations, logs, or clear hot-path evidence before complex compute optimizations.
   - Pinocchio performance matters, but never trade away validation, invariant clarity, or fund safety.

## Pinocchio-Specific Safety Standards

Audit Pinocchio-specific behavior carefully:

- Framework dependencies should be pinned to a version/commit appropriate for production risk.
- Do not assume Anchor-style discriminators, account wrappers, `reload()`, constraints, IDL, or automatic owner checks.
- `entrypoint!`, `process_instruction`, and account iteration must reject unexpected instruction tags, missing accounts, extra dangerous accounts, and wrong account order.
- Account parsing must validate owner, key, signer, writable, data length, discriminator/tag, and expected relationship before reading trusted state.
- Manual instruction data parsing must bounds-check every slice and reject malformed/ambiguous encodings.
- Zero-copy account structs must use stable representation and be checked for size, alignment, padding, endian assumptions, and versioning/migration behavior.
- `unsafe-account-resize`, raw pointer access, `set_data_length`, manual lamport edits, and direct data writes require explicit maximum-size checks and extra review.
- Panic handler, allocator/no-allocator behavior, and `no_std` assumptions must match the deployed runtime.
- Canonical p-token may replace SPL Token at the same program id and should be treated as byte-compatible; focus findings on custom forks, token reimplementations, or local logic that drops checks to save compute.
- If the program reimplements token behavior or relies on custom p-token-like semantics, compare edge-case behavior against canonical SPL Token/Token-2022.

## Solana Security Checklist

### Account Validation and Access Control

Check:

- Signer checks exist for every authority-sensitive instruction.
- Owner checks confirm accounts belong to expected program/token/system owners.
- Account type checks use discriminator/tag and correct layout.
- Data length, writable status, rent, and lamport availability are validated before mutation.
- Duplicate mutable accounts are rejected when aliasing can corrupt state or accounting.
- Remaining/dynamic accounts are length-checked, owner-checked, type-checked, signer/writable-checked, and order-checked.
- Sysvars are read via non-spoofable syscalls where possible; passed sysvar accounts must be checked against canonical sysvar addresses before reading.
- Authority transfer uses two-step nominate/accept when risk justifies it.
- Upgrade authority, admin authority, and deployer privileges are documented and constrained.
- Time/slot logic uses trusted sysvars or syscalls and handles boundary cases.

### Governance, Admin, and Emergency Controls

Check:

- Admin, manager, fee, oracle, pause, and upgrade authorities are explicit, minimally scoped, and validated by address/state relationship.
- High-risk authority changes use two-step nominate/accept, multisig, timelock, or an equivalent control when production funds are at risk.
- Pause or emergency flows cannot steal funds, bypass accounting, permanently lock users without governance intent, or create privileged withdrawal paths.
- ProgramData, upgrade authority, program id, deployment cluster, and immutability plan are documented and match the intended release posture.
- Privileged instructions emit sufficient logs/events for monitoring without leaking sensitive data.

### State, Lifecycle, and Invariants

Check:

- Initialization cannot be repeated unless explicitly safe.
- Init paths cannot reset, hijack, or front-run existing state.
- Account close transfers all lamports, marks state closed, zeroes/overwrites data, and prevents account revival.
- Realloc uses correct size, payer, rent, zeroing behavior, and invariant checks.
- Accounts are revalidated after CPI when mutated by downstream programs.
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
- Use checked token instructions where possible: `transfer_checked`, `mint_to_checked`, `burn_checked`, or equivalent Pinocchio wrappers.
- Token-2022 extensions are considered: transfer hooks, transfer fees, permanent delegate, mint close authority, default frozen state, CPI guard, confidential transfer, interest-bearing tokens, and other active extensions.
- Deposits account for transfer fees by comparing received amount or rejecting incompatible extensions.
- ATAs are validated canonically when canonical ATA identity matters.
- Mint plus owner checks are not enough when the protocol assumes the official ATA; rederive the expected ATA with Associated Token Program and expected token program.
- Vaults reject risky token extensions when protocol assumptions require standard SPL behavior.
- Token close CPI destinations are constrained to known recipients and cannot close primary vaults or route rent to attacker-controlled accounts.
- Lamport transfers check balances before/after when value accounting matters.

### Oracles, External Prices, and Signature Introspection

Check:

- Oracle accounts, price feed ids, owners, update authorities, decimals, freshness windows, confidence/variance, and slot/round boundaries are validated.
- Price-dependent instructions include slippage, min/max expected values, stale-price rejection, and manipulation-resistant assumptions for low-liquidity or flash-loan-sensitive flows.
- Cross-mint accounting normalizes decimals before comparison, fee calculation, share minting, redemption, or liquidation.
- Ed25519/Secp256k1 or instruction sysvar verification validates expected instruction index, signer/key, domain-separated message, nonce/deadline, and replay protection.
- Precompile verification parses and validates instruction offsets for pubkey, signature, and message bytes; loose existence checks are findings.
- Off-chain signed payloads bind all critical fields: program id, instruction, accounts, amount, mint, recipient, expiry, chain/cluster when relevant, and user intent.

### Arithmetic, Parsing, and Robustness

Check:

- Critical math uses `checked_add`, `checked_sub`, `checked_mul`, `checked_div`, or equivalent safe helpers.
- `overflow-checks = true` is configured where applicable.
- Multiplication before division is intentional and uses wide intermediates when needed.
- Rounding direction is documented and tested.
- Casts use `try_from` or explicit bounds checks.
- Division by zero and zero-amount edge cases are handled.
- No reachable `.unwrap()`, `.expect()`, or `panic!` exists in critical on-chain paths.
- All `Result`s from CPI/syscalls/math/parsing/validation are handled.
- Slices, arrays, instruction data, account data, vectors, and indexes are bounds-checked.
- Fixed-index account access and pointer arithmetic are preceded by account-count and buffer-length guards.
- Critical state changes emit logs/events with enough fields for monitoring, reconciliation, and incident response.

## Performance and Compute Checklist

Check:

- Pinocchio zero-copy and low-level APIs are used to reduce compute only after safety is proven.
- Compute unit usage is measured for critical instructions.
- Instruction account lists are minimal but not under-validated.
- Loops over accounts or vectors are bounded and justified.
- CPI count is minimized where safe.
- Account sizes are minimal and realloc is avoided where possible.
- Data layout is efficient, versioned, alignment-safe, and migration-aware.
- Rent-exemption is checked where relevant.
- Address Lookup Tables are considered only when transaction size/account count requires them.
- Versioned transactions and ALTs must not let clients smuggle alternate accounts into trusted positional slots; on-chain checks must validate keys, owners, and relationships independent of lookup-table origin.
- Logging, formatting, heap usage, and expensive validation are balanced without weakening safety.

## Testing and Deployment Checklist

Check:

- Project-native build and test commands run before release.
- Unit and integration tests cover account validation, wrong accounts, wrong signer, wrong owner, wrong PDA, wrong bump, duplicate accounts, and failure paths.
- Tests cover CPI success/failure, Token/Token-2022 behavior, account close/realloc, initialization/reinitialization, and edge math.
- Property/fuzz tests exist for instruction parsing, account parsing, math, state transitions, and dynamic inputs when risk justifies it.
- Miri, layout tests, and differential tests are used when `unsafe`, zero-copy, or token reimplementation behavior matters.
- If token semantics are reimplemented, differential tests compare against canonical SPL Token/Token-2022 edge cases and exact state/error behavior.
- Token parity tests include zero-amount transfer, frozen account rejection, multisig M-of-N parsing, `transfer_checked` decimals/mint binding, self-transfer, immutable owner, and exact error behavior.
- Local validator and devnet/testnet tests cover realistic accounts and token behavior before production.
- Static analysis and dependency scans run: `cargo clippy`, `cargo audit`, and equivalents.
- Threat model, account diagram, instruction list, state machine, invariants, and privileged roles are documented for external audit readiness.
- `declare_id!`, deployment scripts, generated clients, published program id, and build artifacts are consistent.
- Production deployments are checked with chain-level evidence such as `solana program show` and verifiable/reproducible build evidence when available.

## Maintainability and Dead Code

Check:

- Code passes `cargo fmt` and project-native linting.
- Modules are organized by instruction, state, errors, parsing, validation, CPI/token adapters, and tests without artificial architecture.
- Critical security checks are not hidden in unrelated helpers or scattered ad hoc conditions.
- Manual validation is close to the account/instruction it protects, or centralized in a clearly named canonical helper.
- Constants, enums, domain types, and helper functions replace magic bytes, account indexes, seeds, discriminators, offsets, and repeated validation logic.
- Dead code is identified and recommended for safe removal:
  - unused instructions, account structs, parsers, events/log helpers, errors, seeds, constants, modules, tests, scripts, config, features, and dependencies;
  - obsolete branches, stale migrations, old scripts, commented-out code, and tests keeping removed behavior alive.

## Recommended Commands

Prefer project-native commands first: `Cargo.toml`, `Makefile`, `justfile`, package scripts, CI config, or docs.

Useful Pinocchio/Solana audit commands:

```bash
cargo build-sbf
cargo test --all-targets --all-features
cargo fmt --check
cargo clippy --all-targets --all-features -- -D warnings
cargo audit
cargo tree
cargo miri test
cargo fuzz run <target>
solana program show <PROGRAM_ID> --url <CLUSTER>
```

Use Miri, fuzzing, layout tests, differential tests, and compute measurement selectively when the audited code depends on `unsafe`, zero-copy, parsing, dynamic data, token semantics, or high-value math.

Run mutation commands such as formatting or dependency updates only when editing code or when the user asked for fixes.

## What to Flag Aggressively

Escalate:

- Missing signer, owner, discriminator/tag, PDA seed, bump, authority, writable, data length, or account relationship validation.
- Account order trusted without validating every account before use.
- Raw account data parsed before owner/type/length checks.
- Fixed-index account access, pointer arithmetic, or slice reads without prior account-count/buffer-length guards.
- Arbitrary CPI, unvalidated CPI target, or signer/PDA authority forwarded to untrusted programs.
- PDA sharing, seed collision, user-controlled bump, variable-length seed ambiguity, mutable seed orphaning, non-canonical ATA, or weak PDA context separation.
- Duplicate mutable account aliasing that can corrupt state.
- Reinitialization, init frontrunning, account revival, unsafe close, unsafe realloc, or stale account read after CPI.
- Financial math without checked arithmetic, wide intermediates, or explicit rounding.
- Token-2022 extension assumptions that break vault/accounting/security logic.
- Token mint/owner/authority/decimals/frozen/delegate/close-authority not validated.
- Transfer fee or hook behavior ignored when received amount matters.
- Token close CPI can close a vault, sends rent to an unconstrained account, or fails to restrict the destination.
- `unsafe`, zero-copy, `bytemuck`, raw pointer, or manual layout parsing without documented invariant and tests.
- Account layout size/discriminator/alignment/padding mismatch.
- Reachable `.unwrap()`, `.expect()`, `panic!`, ignored `Result`, unchecked indexing, or unchecked casts in critical paths.
- Long unbounded loops, logging-heavy hot paths, or compute-heavy CPI chains.
- Missing slippage/deadline/expected-value checks in DeFi or exchange-like flows.
- Time/slot/sysvar spoofing or unchecked sysvar address.
- ALT or versioned-transaction account substitution where code trusts account position instead of validating keys/owners/relationships.
- Upgrade authority or admin control unclear or overpowered.
- Oracle reads without freshness, confidence, source, decimals, or manipulation checks.
- Vault/share accounting exposed to first depositor, share inflation, NAV initialization, or rounding attacks.
- Token reimplementation or p-token-like logic without differential tests against canonical SPL Token behavior.
- Custom token semantics that diverge on zero-amount transfer, frozen accounts, multisig parsing, checked decimals/mint binding, self-transfer, immutable owner, or exact errors.
- External signature or instruction sysvar verification without domain separation, expected instruction index, expiry, or replay protection.
- Precompile signature verification that does not parse and bind pubkey/signature/message offsets to the current action.
- Program id, deployment config, generated client, or published artifact mismatch.
- TODO, FIXME, stubs, mock signers, disabled checks, or placeholder logic in production-critical paths.
- Spaghetti growth, files above 1000 lines, weak wrappers, duplicate validation helpers, or refactors that only move complexity.

## Preferred Remedies

For every confirmed problem, provide the most robust practical solution, not only a warning.

Prefer remedies that remove the class of bug:

- Add canonical manual validation helpers for signer, writable, owner, key, data length, discriminator/tag, PDA seeds, bump, mint, authority, and custom invariants.
- Validate every account before reading trusted data from it.
- Replace raw unchecked parsing with safe parsers that enforce length, alignment, tag, and version before returning typed state.
- Add account-count guards before fixed-index access and buffer-length guards before pointer arithmetic or slicing.
- Derive PDAs from explicit domain-separated seeds and canonical bumps.
- Normalize or length-limit variable seeds; avoid mutable seed components unless the PDA lifecycle intentionally depends on them.
- Store/reuse bumps safely and reject user-controlled bump authority.
- Allowlist CPI programs and isolate signer/PDA authority.
- Re-check mutated accounts after CPI and compare balance/state deltas when value movement matters.
- Validate sysvars by syscall or canonical address; do not trust sysvar-shaped account data from arbitrary accounts.
- Use checked arithmetic, `u128` intermediates, explicit rounding, and edge-case tests.
- Validate Token-2022 extensions or reject tokens whose extensions break protocol assumptions.
- Add received-amount checks for fee-on-transfer behavior.
- Use canonical ATA derivation checks when ATA identity matters.
- Re-derive official ATAs with Associated Token Program and expected token program instead of accepting any token account with matching mint/owner when canonical identity matters.
- Constrain token close destinations and prevent primary vault closure except through an explicit safe shutdown path.
- Protect close/realloc/init with lifecycle state and revival prevention.
- Encapsulate `unsafe` and zero-copy behind safe APIs with documented safety contracts, Miri, fuzzing, and layout tests.
- Add differential tests against canonical SPL Token/Token-2022 when token behavior is reimplemented or optimized.
- Include zero-amount, frozen, multisig M-of-N, checked decimals/mint, self-transfer, immutable-owner, and exact-error cases in token parity tests.
- Add slippage, deadline, expected amount, max fee, and replay protections where relevant.
- Add oracle freshness/confidence/source checks, decimal normalization, and manipulation-resistant price assumptions.
- Add minimum liquidity/deposit, safe zero-supply handling, share/NAV invariant tests, and fee caps for vault-like protocols.
- Add pause/emergency controls, two-step authority transfer, multisig/timelock requirements, and monitoring logs/events where protocol risk justifies them.
- Bind off-chain signatures to domain-separated payloads with nonce/deadline and all critical accounts/amounts.
- Parse precompile instruction offsets and bind the exact signer, signature, and message bytes to the current instruction.
- Treat ALTs as a client-side account source only; keep all security-critical key/owner/relationship checks on-chain.
- Verify deployed program id, upgrade authority, generated clients, and build provenance before release.
- Split oversized instruction logic into account validation, parsing, state transition, CPI/token adapter, math helper, and event/log emission.
- Add account diagrams, invariants, threat model, and high-risk test matrix for external audit readiness.
- Remove proven dead code and obsolete paths.

When multiple remedies exist, distinguish:

- **Robust solution:** preferred production-grade fix.
- **Fast mitigation:** acceptable temporary risk reduction, only when useful.
- **Validation:** tests, simulations, fuzzing, Miri, compute measurement, differential tests, or manual checks required to prove the fix.

## Review Tone

Be formal, direct, and practical.
Do not soften fund-loss, account spoofing, PDA, CPI, Token-2022, unsafe, parsing, or arithmetic risk.
Avoid cosmetic comments when larger risks exist.
Separate confirmed issues from assumptions.
If evidence is missing, say exactly what should be checked.

Good phrases:

- `This instruction mutates protocol state but I do not see an explicit signer/authority check. This should block release.`
- `This account data is parsed before owner and length validation. Validate the account boundary before trusting bytes.`
- `This PDA accepts authority from user-controlled input. Derive and verify canonical seeds and bump instead.`
- `This CPI target is user-provided. Allowlist the program id before invoking.`
- `This token flow ignores Token-2022 transfer fees. Check the received amount or reject incompatible extensions.`
- `This math can overflow or round against the invariant. Use checked arithmetic and wide intermediates.`
- `This unsafe block has no documented invariant. Encapsulate it and add layout/Miri tests.`
- `This compute optimization removes validation. Fund safety wins over CU savings.`

## Output Expectations

Start with an **Executive Snapshot**:

- Overall risk: Critical, High, Medium, or Low
- Release stance: Block release, release after fixes, or no major blocker found
- Scope reviewed: instructions/accounts/parsers/flows/configs actually inspected
- Discovery pass: high-risk patterns found or not found, with any skipped searches stated
- Top risks: 3-5 highest-impact issues or residual concerns
- Validation run or still needed

Prioritize findings:

1. Fund loss, vault, token, lamport, mint, custody, or accounting risks
2. Signer, owner, PDA, discriminator/tag, account validation, and authority failures
3. Unsafe, zero-copy, parser, account layout, alignment, and `no_std` soundness risks
4. CPI, Token/Token-2022, ATA, sysvar, and composability risks
5. Arithmetic, precision, slippage, deadline, replay, and economic invariant risks
6. Oracle, external signature, instruction sysvar, event/log, and monitoring risks
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

Do not approve a Pinocchio Solana program for production while any of these remain unresolved:

- Any privileged state or asset mutation lacks explicit signer/authority validation.
- Any trusted account lacks owner/type/discriminator/key/PDA/data length/writable validation.
- Account data is parsed before boundary validation.
- Fixed-index account access, pointer arithmetic, or slice reads can occur before count/length validation.
- User-controlled bump, weak PDA seeds, PDA sharing, or seed collision can affect authority.
- Arbitrary CPI or unvalidated CPI target can execute with user/protocol authority.
- Token vault/accounting logic ignores mint, authority, decimals, frozen state, delegates, close authority, or Token-2022 extensions.
- Financial math can overflow, underflow, divide by zero, truncate unsafely, or round against protocol invariants.
- Account close, realloc, or init path allows revival, reinitialization, init frontrunning, or stale state.
- Reachable `.unwrap()`, `.expect()`, `panic!`, ignored `Result`, unchecked indexing, unchecked casts, or out-of-bounds parsing exists in critical paths.
- Custom `unsafe`, zero-copy, `bytemuck`, raw pointer, or manual layout assumptions lack safety contract and validation.
- Token reimplementation or p-token-like logic lacks edge-case parity tests against canonical SPL Token/Token-2022.
- Canonical ATA identity, sysvar authenticity, precompile offsets, or ALT/positional account assumptions are security-critical but not validated.
- Critical invariants lack tests for wrong signer/account/PDA/mint, malformed instruction data, edge amounts, CPI failure, and repeated calls.
- Upgrade authority, admin powers, or deployment immutability plan is unclear for production.
- Oracle, price, external signature, or instruction sysvar logic is used without freshness/source/domain/replay validation.
- Vault/share logic is vulnerable to first depositor, share inflation, bad zero-supply, fee, decimal, or NAV accounting attacks.
- Published program identity, deployment config, generated clients, or build provenance cannot be tied back to reviewed source.

If approval is blocked, give the shortest robust path to make the program safe enough for the next review.

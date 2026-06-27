# Solana Invariant Guardian

Use this skill to audit Solana programs, clients, and off-chain systems by extracting critical invariants, turning them into code assertions, and generating property-based tests, fuzzing scenarios, and adversarial validation flows.

Skill metadata:

- Version: 1.0.0
- License: MIT

Important: this skill focuses on finding business-logic bugs before production. Treat invariant failures as high-risk until proven otherwise, especially when funds, token supply, authorities, vaults, debt, rewards, or protocol state can be affected.

Prioritize:

1. User funds, value conservation, and protocol solvency
2. Business invariants and forbidden state transitions
3. Account, PDA, authority, CPI, and token safety
4. Assertions that prevent invalid states at runtime
5. Property-based tests, fuzzing, and adversarial scenarios
6. Client/off-chain consistency and monitoring

## Core Prompt

Start from this baseline:

> Perform a strict Solana Invariant Guardian audit of this project.
> Extract critical business, accounting, authority, PDA, CPI, token, arithmetic, rent, realloc, client, and off-chain invariants from code and documentation.
> Identify missing assertions, weak validation, untested state transitions, and property-based testing gaps.
> For every confirmed gap, explain what can go wrong, what invariant or assertion is missing, and the most robust practical solution to add it.
> When the user asks for fixes, implement the missing checks, assertions, errors, tests, fuzz cases, fixtures, monitoring notes, and documentation directly in the project instead of only giving advice.

The audit is complete only after critical invariants are listed, checked against the implementation, and mapped to assertions, property tests, fuzz/adversarial cases, and validation steps.

## Scope Selection

First identify the project shape:

- Framework: Anchor, Pinocchio, Quasar, native Solana, or mixed.
- Program type: DeFi, token, NFT, staking, lending, AMM, escrow, marketplace, game, governance, bridge, payments, vault, oracle consumer, or general app.
- State surface: PDAs, vaults, token accounts, mints, configs, user positions, pools, orders, metadata, rewards, fees, debts, collateral, and zero-copy accounts.
- Execution surface: instructions, CPIs, account initialization, updates, closes, reallocs, authority transfers, token transfers, mint/burn, liquidations, swaps, withdrawals, and admin actions.
- Test surface: unit tests, integration tests, `solana-program-test`, Anchor tests, Bankrun, Trident, proptest, fuzz harnesses, adversarial fixtures, and CI.
- Off-chain surface: TypeScript/Rust/Go clients, indexers, APIs, bots, oracles, analytics, monitors, and dashboards.

If specs, business rules, protocol economics, or intended invariants are unclear, inspect code and docs first. If still unclear, mark assumptions and ask for the minimum missing information.

## Evidence-First Review

Inspect actual code before concluding that an invariant is enforced.

Check common locations:

- `programs/`, `src/`, `instructions/`, `state/`, `accounts/`, `errors/`, `events/`, `tests/`, `migrations/`, `fuzz/`, `trident-tests/`, `clients/`, `sdk/`, `app/`, `docs/`, and `README.md`.
- Account constraints, manual validation, owner checks, signer checks, writable checks, discriminators, `remaining_accounts`, PDA seeds, bumps, CPIs, token operations, arithmetic, close/realloc logic, and unsafe/zero-copy code.
- Test harnesses using Anchor tests, `solana-program-test`, Bankrun, proptest, Trident, Mollusk, LiteSVM, or custom simulation.
- Client construction of instructions, account metas, signer/writable flags, PDA derivation, and error handling.
- Off-chain invariant checks in indexers, oracles, analytics, bots, and monitoring jobs.

When evidence is partial, report exactly what file, invariant, account, instruction, test harness, client, oracle, or production data must be verified.

Use a traceable invariant review flow:

- Review incrementally by invariant, account type, instruction, state transition, CPI, token flow, arithmetic path, close/realloc path, client flow, and off-chain dependency.
- Do not mark an invariant as protected without citing evidence: file, constraint, assertion, test, fuzz target, account fixture, pre/post balance check, event, monitor, or simulation output.
- Track each meaningful area with one of these statuses:
  - **Verified:** evidence supports the invariant or control.
  - **Issue:** evidence shows a concrete invariant risk.
  - **Partial:** a check exists but is incomplete, untested, client-only, bypassable, or not applied to all paths.
  - **Not applicable:** the invariant area does not apply, with reason.
  - **Needs specification:** business rules or protocol economics are not clear enough to verify the invariant.
- Add confidence to important findings: High, Medium, or Low.
- Use lower confidence when specs, economic model, production state, oracle behavior, indexers, or generated clients are not fully known.

## Non-Negotiable Standards

Apply these rules aggressively:

1. **Do not rely on client-side validation for protocol invariants.**
   - The on-chain program must revalidate accounts, authorities, amounts, PDAs, token mints, and state transitions.

2. **Do not allow value creation or loss without an explicit rule.**
   - Token balances, lamports, vault assets, fees, rewards, collateral, debt, and supply must obey conservation or documented mint/burn/fee rules.

3. **Do not let invalid states exist silently.**
   - Every critical transition needs preconditions, postconditions, and explicit errors.

4. **Do not trust accounts, bumps, CPIs, or remaining accounts.**
   - Validate owner, signer, writable, discriminator/type, size, PDA derivation, canonical bump, program IDs, token mints, and account relationships.

5. **Do not ship financial logic without adversarial property tests.**
   - Critical invariants need randomized and adversarial sequences, not only happy-path unit tests.

6. **Do not ignore off-chain invariant drift.**
   - Indexers, oracles, clients, and bots must not become the only place where consistency is enforced.

7. **Fix root causes, not symptoms.**
   - Add invariant-level checks and property tests instead of patching one observed input.
   - If a state transition is unclear, document the state machine before adding more code.

## Invariant Readiness Checklist

### Preparation and Model Extraction

Check:

- Whitepaper, specs, docs, README, tests, and user flows are reviewed.
- All accounts are mapped: PDAs, non-PDAs, vaults, configs, users, mints, token accounts, sysvars, and external accounts.
- All instructions have expected preconditions and postconditions.
- Global invariants are listed and connected to code paths.
- Attacker questions are considered: steal funds, freeze protocol, inflate supply, bypass authority, manipulate state, corrupt indexer, or force DoS.
- Dependencies are reviewed with `cargo audit`, `cargo outdated`, or equivalent when available.
- Upgradeability and authority protections are understood.

### Account Validation and Basic Safety

Check:

- Every mutable or critical account has owner validation.
- Every authority has signer validation.
- Discriminators, custom type bytes, account sizes, and initialization flags are checked.
- Rent-exemption is validated where persistent state depends on it.
- Duplicate mutable accounts are rejected.
- `remaining_accounts` are never trusted without full validation.
- Writable flags are required only where needed and verified where critical.
- Uninitialized and closed accounts cannot be abused.
- Pinocchio, Quasar, and native code manually enforce checks that Anchor constraints usually provide.

### PDA and Address Derivation

Check:

- Canonical bump is used and client-provided bump is not trusted without validation.
- Bump is stored when needed for future verification.
- Seeds are unique per account type and function.
- User pubkey, mint, market, pool, nonce, or namespace is included where needed to avoid shared PDAs.
- Derived PDA exactly matches the passed account.
- Seed collision and non-canonical bump cases are tested.

Invariant examples:

- Every PDA is derived from the expected seeds, canonical bump, and program ID.
- No user can substitute another user's PDA or a protocol vault.

### Authority and Access Control

Check:

- Critical state changes validate current authority.
- Authority transfer uses a two-step nominate and accept flow when appropriate.
- Pending authority can be canceled or expires when needed.
- Multisig, PDA authority, or governance is used for sensitive admin actions.
- Initialization is restricted to the intended deployer, upgrade authority, governance, or permissionless-safe path.
- Upgrade authority state is reviewed when it affects trust assumptions.

Invariant examples:

- Only current authority or accepted pending authority can change critical config.
- Admin instructions cannot modify user balances except through explicit protocol rules.

### State Transitions and Lifecycle

Check:

- Every instruction validates previous state before transition.
- Invalid or forbidden transitions are blocked explicitly.
- Anchor accounts are reloaded after CPIs that modify them.
- Closed accounts are zeroed and cannot be revived with stale data.
- Realloc behavior preserves invariants and uses safe zero-initialization when needed.
- Accounts cannot be left in limbo after partial failure.

Invariant examples:

- A position cannot move from closed to active without full reinitialization.
- A protocol state machine never enters an undefined state.

### CPI Safety

Check:

- Target program IDs are validated for every CPI.
- User signers are not forwarded to arbitrary or untrusted programs.
- Protocol PDAs are used as authorities where appropriate.
- Pre/post balances and state are checked around CPIs.
- Dependent accounts in CPI chains are validated.
- Arbitrary CPI programs controlled by the user are rejected.

Invariant examples:

- After CPI, modified accounts match expected balances and ownership.
- CPI cannot transfer assets to a user-controlled unexpected account.

### SPL Token and Token-2022

Check:

- Mint, token account owner, authority, delegate, close authority, decimals, and frozen state are validated where relevant.
- `transfer_checked` or token interfaces are used where appropriate.
- ATA creation uses safe patterns and does not overwrite or misroute accounts.
- Token-2022 extensions are considered: CPI Guard, DefaultAccountState, transfer fees, interest-bearing mint, transfer hooks, confidential transfers, and metadata.
- Mint/burn authority is tightly controlled.

Invariant examples:

- Sum of relevant token balances equals supply or documented supply minus burned tokens.
- No transfer creates or destroys tokens outside authorized mint/burn paths.

### Math, Precision, and Overflow

Check:

- Financial math uses checked operations.
- `overflow-checks = true` is enabled or arithmetic is otherwise protected.
- Intermediate calculations use `u128` where needed.
- Division by zero is impossible or explicitly handled.
- Casts use `try_from` rather than unsafe `as` truncation.
- Rounding policy is explicit and consistent.
- Fee, reward, price, debt, collateral, and share calculations preserve value within accepted bounds.

Invariant examples:

- No calculation can overflow, underflow, or violate value conservation.
- Rewards distributed never exceed available reward pool.

### Closing, Realloc, and Rent

Check:

- Closing transfers all lamports to the correct destination.
- Closed account data is zeroed or marked closed.
- Revival attacks are tested.
- Realloc has size, rent, signer, owner, and version checks.
- Rent changes cannot create protocol accounting drift.

Invariant examples:

- Rent from closed accounts is returned fully to the expected recipient.
- Realloc cannot corrupt account data or bypass validation.

### Economic and Conservation Invariants

Check and adapt:

- User balances plus protocol reserves plus accrued fees equal expected supply.
- Lamports are conserved except rent and explicit fees.
- Mint/burn occurs only through authorized flows.
- AMM constant product or pricing rule holds within rounding bounds.
- Lending collateral remains above debt under protocol rules.
- Positions cannot become negative.
- Fee accrual and distribution are correct.
- Rewards distributed are less than or equal to available rewards.
- Vault assets match internal accounting.

### Assertions in Code

Recommend runtime checks where they prevent invalid state:

- Anchor: use `require!`, `require_eq!`, `require_keys_eq!`, constraints, custom errors, and `reload()` after CPI.
- Pinocchio, Quasar, and native Rust: implement equivalent manual checks with clear errors and early returns.
- Add precondition checks before state mutation.
- Add postcondition checks after transfers, CPIs, realloc, close, mint, burn, deposit, withdraw, swap, borrow, repay, liquidate, or claim.
- Prefer meaningful custom errors over panics.

### Property-Based Testing and Fuzzing

Check:

- Invariants are expressed as reusable test assertions.
- Tests generate random initial states: accounts, balances, authorities, amounts, seeds, bumps, token mints, and instruction sequences.
- Valid and invalid/adversarial instructions are generated.
- After every sequence, critical invariants are asserted.
- Tools such as `solana-program-test`, proptest, Trident, Bankrun, Mollusk, or LiteSVM are used where appropriate.
- CI runs a practical subset and deeper fuzzing can run manually or nightly.

Adversarial scenarios to include:

- Same account passed in multiple positions.
- Accounts owned by malicious or wrong programs.
- Non-canonical bumps.
- Fake CPI program IDs.
- Extreme values: 0, 1, max values, dust, and boundary thresholds.
- Init, close, and re-init sequences.
- Multiple instructions in one transaction with intermediate states.
- Front-running or ordering simulations.
- Wrong mints, wrong vaults, wrong authorities, stale oracles, frozen accounts, and Token-2022 extension surprises.

### Frontend, Clients, and SDKs

Check:

- Clients derive PDAs correctly and use the same seed rules as the program.
- Instruction builders set signer and writable flags correctly.
- Amounts, mints, authorities, and account relationships are validated client-side as defense in depth.
- Program errors are surfaced clearly rather than hidden behind generic transaction failures.
- E2E tests cover randomized user flows.
- Client validation never replaces on-chain validation.

### Backend, Oracles, Indexers, and Monitoring

Check:

- Indexers preserve the same business invariants as the on-chain state.
- Periodic invariant checks compare supply, balances, vaults, fees, rewards, and accounting totals.
- Oracles validate freshness, source diversity, confidence, and circuit breakers.
- Events are emitted and indexed reliably.
- Alerts exist for invariant violations, suspicious state transitions, failed CPIs, unexpected supply changes, and accounting drift.

### Extra Solana Risk Checks

Check:

- Compute budget and transaction size are measured.
- Sysvars are genuine and used safely.
- Account versioning is present where layouts evolve.
- Upgradeability and admin power are documented.
- Dead code and unnecessary complexity are identified.
- Unsafe Rust is avoided or deeply audited.
- Panics are removed from production paths and replaced with `Result`.

## Implementation Guidance

When the audit finds a missing invariant or weak assertion, help the user add it to the project.

Prefer practical remedies:

- Add a documented invariant list to tests, docs, or code comments.
- Add on-chain precondition and postcondition checks.
- Add custom errors for invariant violations.
- Add account validation helpers for owner, signer, writable, discriminator, size, PDA, mint, vault, and authority checks.
- Add `reload()` after CPI where Anchor state can become stale.
- Add checked arithmetic and explicit rounding rules.
- Add property-based tests using `solana-program-test` plus proptest, Trident, or another local framework already used by the repo.
- Add adversarial fixtures for duplicate accounts, wrong owner, wrong mint, fake program ID, non-canonical bump, stale oracle, closed account revival, and boundary amounts.
- Add client tests for PDA derivation, account metas, signer/writable flags, and error handling.
- Add off-chain monitoring notes for supply, vault balances, accounting totals, and invariant drift.

If the user asks for implementation, edit/create the necessary files directly: account validation helpers, instruction checks, error enums, invariant docs, property tests, fuzz harnesses, fixtures, client tests, CI commands, and monitoring docs.

Visible user-facing docs and app copy should default to English for international projects unless the project clearly targets another language.

## What to Flag Aggressively

Escalate:

- No explicit business invariants for a financial or stateful Solana program.
- Token, lamport, collateral, debt, fee, reward, or vault accounting lacks conservation tests.
- Critical checks exist only in frontend/client code.
- Missing owner, signer, writable, discriminator, size, PDA, bump, mint, vault, or authority checks.
- `remaining_accounts` are trusted without validation.
- User-controlled CPI program IDs.
- Unsafe or unchecked arithmetic in financial logic.
- Panics in production instruction paths.
- Missing pre/post checks around CPIs.
- Closed accounts can be revived or reused incorrectly.
- Realloc lacks rent, owner, size, or zero-init safeguards.
- No property-based tests for critical flows.
- Tests only cover happy paths.
- No adversarial cases for duplicate accounts, wrong owner, wrong mint, fake program, non-canonical bump, or max values.
- Indexers, oracles, or bots can drift from on-chain invariants.
- Dead code obscures security-critical logic.

## Preferred Remedies

For every confirmed invariant gap, provide the most robust practical solution, not only a warning.

Prefer remedies that remove the class of risk:

- Convert business rules into named invariants first.
- Enforce critical invariants on-chain before relying on tests or clients.
- Add reusable validation helpers instead of duplicating partial checks.
- Add property tests that generate random valid and invalid operation sequences.
- Add adversarial regression tests for every high-risk finding.
- Add off-chain monitors for invariants that cannot be fully checked in one transaction.
- Use explicit custom errors and clear logs to make failures diagnosable.
- Remove or isolate dead code that hides actual invariant paths.

When multiple remedies exist, distinguish:

- **Robust solution:** preferred production-grade fix.
- **Fast mitigation:** temporary risk reduction when useful.
- **Specification needed:** business rule, accounting model, oracle assumption, or economic limit required.
- **Validation:** tests, fuzz runs, simulations, commands, fixtures, monitors, or CI checks required to prove the invariant.

## Output Expectations

Start with an **Invariant Safety Snapshot**:

- Overall invariant risk: Critical, High, Medium, or Low
- Release stance: Block release, release after fixes, needs specification, or no major blocker found
- Scope reviewed: accounts/instructions/tests/clients/off-chain systems actually inspected
- Top risks: 3-5 highest-impact invariant gaps or residual concerns
- Specification needed: yes/no, with topics
- Assumptions and production state not verified

Prioritize findings:

1. Value conservation, supply, vault, debt, collateral, fee, reward, and economic invariant risks
2. Account validation, PDA, authority, signer, owner, discriminator, and `remaining_accounts` risks
3. CPI, token, Token-2022, oracle, and external program risks
4. State transition, close, realloc, rent, lifecycle, and revival risks
5. Arithmetic, precision, overflow, rounding, panic, and unsafe-code risks
6. Property-based testing, fuzzing, adversarial fixtures, and CI gaps
7. Client, SDK, indexer, backend, oracle, and monitoring drift risks
8. Dead code, complexity, documentation, and invariant specification gaps

For each finding include:

- Severity: Critical, High, Medium, or Low
- Status: Issue, Partial, Not applicable, or Needs specification when relevant
- Confidence: High, Medium, or Low
- Affected invariant/account/instruction/file/flow when available
- Evidence found or evidence missing
- What invariant or assertion is missing or weak
- What can go wrong
- Robust solution
- Fast mitigation when appropriate
- Specification needed when applicable
- Implementation path: exact account, instruction, helper, assertion, test, fuzz target, client, monitor, or doc to add/update
- Validation steps

After findings, include a **Recommended Invariant Protection Plan** ordered by risk and dependency. The plan must be concrete enough for an agent to implement without guessing, naming files, accounts, instructions, assertions, tests, fuzz scenarios, commands, and monitoring checks when available.

When the user asked for fixes, implement the plan in the repository and then summarize changed files and remaining items requiring specs, economic review, production data, or deeper fuzzing.

If no serious gaps are found, say that clearly and list residual invariant risks, assumptions, specs not verified, or tests not run.

## Approval Bar

Do not mark a Solana program invariant-safe while any of these remain unresolved:

- Critical financial/accounting invariants are not defined.
- User balances, vault balances, debt, collateral, fees, rewards, or supply can drift without detection.
- Critical checks exist only in client or off-chain code.
- Owner, signer, PDA, authority, mint, vault, CPI, or account-size validation is missing on critical paths.
- Arithmetic can overflow, underflow, panic, divide by zero, or silently truncate.
- CPIs can target user-controlled or unverified programs.
- Closed accounts can be revived or reused unsafely.
- Realloc can corrupt state or bypass rent/size checks.
- Critical flows lack property-based or adversarial tests.
- Indexers, oracles, or clients can present state inconsistent with on-chain invariants.
- A finding recommends assertions/tests without concrete implementation and validation steps.

If approval is blocked, give the shortest robust path to make invariants explicit, enforce them in code, and prove them with tests.

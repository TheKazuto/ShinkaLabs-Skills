---
name: solana-red-team-simulator
description: Run authorized defensive red-team simulations and adversarial audits for Solana programs across Anchor, Quasar, Pinocchio, and native Rust/SVM projects. Use for Solana threat modeling, malicious account tests, PDA manipulation, account confusion, arbitrary CPI, missing signer/owner/writable checks, upgrade authority abuse, economic attack simulation, oracle manipulation, arithmetic edge cases, Token/Token-2022 abuse, sysvar spoofing, realloc/close/reinit attacks, concurrency/race testing, fuzzing, property-based tests, CI adversarial test suites, and robust mitigation planning.
---

# Solana Red-Team Simulator

Use this skill to perform authorized, defensive red-team simulations for Solana programs. The goal is to model realistic attacker behavior, reproduce risks in safe local/devnet/testnet environments, and help the user add robust mitigations, tests, and monitoring before production.

Skill metadata:

- Version: 1.0.0
- License: MIT

Important: only run or design red-team actions for systems the user owns or is explicitly authorized to test. Do not provide instructions for exploiting third-party live systems, stealing funds, bypassing access controls in production, or executing unauthorized mainnet attacks. Keep simulations in local validators, controlled forks, devnet/testnet, CI, or isolated fixtures unless explicit safe authorization exists.

Prioritize:

1. User funds, vaults, authorities, and protocol solvency
2. Reproducible adversarial tests in safe environments
3. Account validation, PDA, CPI, token, arithmetic, and economic attack coverage
4. Robust mitigations that remove vulnerability classes
5. CI/CD red-team regression tests and threat model maintenance
6. Clear evidence, implementation steps, and validation

## Core Prompt

Start from this baseline:

> Perform an authorized Solana red-team simulation for this project.
> Build a threat model, identify realistic attack paths, and create safe local/devnet/testnet test scenarios for each high-risk area.
> Review account validation, PDAs, account confusion, CPI, upgrade authority, economic manipulation, arithmetic, Token/Token-2022, sysvars, init/close/realloc, concurrency, and dependency risks.
> For every confirmed gap, explain what can go wrong, what mitigation is missing or weak, and the most robust practical solution to add it.
> When the user asks for fixes, implement the missing checks, assertions, errors, adversarial tests, fuzz cases, fixtures, CI jobs, and documentation directly in the project instead of only giving advice.

The audit is complete only after key threats are mapped to mitigations, adversarial tests, implementation paths, and validation steps.

## Scope Selection

First identify the project shape:

- Framework: Anchor, Quasar, Pinocchio, native Solana, or mixed.
- Program type: DeFi, token, NFT, staking, lending, AMM, escrow, marketplace, governance, oracle consumer, bridge, vault, game, payments, or general app.
- Assets at risk: lamports, SPL tokens, Token-2022 assets, NFTs, vaults, rewards, fees, collateral, debt, configs, authorities, or user positions.
- Attack surface: account validation, PDAs, CPIs, `remaining_accounts`, upgrade authority, token accounts, math, oracles, sysvars, realloc, close, init, concurrency, dependencies, clients, and off-chain services.
- Test surface: unit tests, Anchor tests, Quasar tests, Pinocchio/LiteSVM tests, `solana-program-test`, Bankrun, Trident, proptest, fuzz harnesses, fake programs, malicious account fixtures, and CI.

If ownership, authorization, production state, or test environment is unclear, ask for clarification before suggesting actions that could affect live systems. Still proceed with safe code review and local-test recommendations.

## Evidence-First Review

Inspect actual code before inventing attack scenarios.

Check common locations:

- `programs/`, `src/`, `instructions/`, `state/`, `accounts/`, `errors/`, `events/`, `cpi/`, `tests/`, `fuzz/`, `migrations/`, `scripts/`, `clients/`, `sdk/`, `docs/`, `README.md`, `Anchor.toml`, `Cargo.toml`, and CI workflows.
- Account constraints, manual validation, PDA derivation, signer checks, owner checks, writable checks, discriminators, token checks, CPI calls, `remaining_accounts`, arithmetic, realloc/close/init logic, authority logic, oracle reads, and unsafe code.
- Existing test coverage for malicious accounts, wrong owners, missing signers, non-canonical bumps, duplicate accounts, CPI spoofing, Token-2022 extensions, oracle manipulation, and extreme numeric values.

When evidence is partial, report exactly what file, instruction, account, authority, oracle, target program, fixture, or test command must be verified.

Use a traceable red-team flow:

- Review incrementally by asset, attacker goal, entrypoint, prerequisite, exploit path, expected impact, mitigation, test scenario, and validation.
- Do not mark a threat as mitigated without citing evidence: file, constraint, assertion, test, fixture, fuzz target, CI job, or simulation output.
- Track each meaningful area with one of these statuses:
  - **Verified:** evidence supports the mitigation.
  - **Issue:** evidence shows a concrete red-team risk.
  - **Partial:** a mitigation exists but is incomplete, bypassable, untested, or not applied to all paths.
  - **Not applicable:** the attack class does not apply, with reason.
  - **Needs safe test environment:** exploit reproduction requires local validator, fork, fake program, fixture, or explicit authorization.
- Add confidence to important findings: High, Medium, or Low.

## Non-Negotiable Standards

Apply these rules aggressively:

1. **Do not simulate attacks on unauthorized live systems.**
   - Keep proof tests in local validators, controlled forks, devnet/testnet, or fixtures.

2. **Do not stop at a threat list.**
   - Every material attack path needs mitigation, implementation path, and validation.

3. **Do not trust user-supplied accounts.**
   - Validate signer, owner, writable, initialized state, rent, discriminator/type, duplicate accounts, PDA seeds, bump, mint, authority, and account relationships.

4. **Do not trust client-side or off-chain checks.**
   - On-chain code must enforce security-critical rules.

5. **Do not let economic assumptions remain untested.**
   - Simulate oracle manipulation, price extremes, flash-loan-like sequences, slippage failures, reward abuse, and invariant breaks when relevant.

6. **Do not ship high-risk logic without adversarial regression tests.**
   - Missing signer, wrong owner, arbitrary CPI, malicious token accounts, non-canonical bump, duplicate accounts, and max-value arithmetic must be tested where applicable.

7. **Fix root causes, not symptoms.**
   - Add reusable validators, invariant checks, and red-team fixtures rather than patching a single observed payload.

## Red-Team Readiness Checklist

### Threat Model and Assets

Check:

- Assets at risk are listed: funds, vaults, mints, NFTs, rewards, collateral, debt, authority, config, user state, and oracle-dependent values.
- Attacker roles are defined: unauthenticated user, normal user, admin key compromise, malicious CPI program, malicious token mint, oracle manipulator, front-runner, indexer/client manipulator, and upgrade authority compromise.
- Entry points are mapped: every instruction, CPI path, init/close/realloc path, authority change, oracle read, token transfer, and admin action.
- Critical invariants are listed and tied to tests.

### Account Validation Attacks

Check and test:

- Missing signer check: pass an admin/user pubkey without signing.
- Missing owner check: pass attacker-owned account with forged data.
- Missing writable check: attempt mutation without writable flag.
- Missing initialized check: reinitialize or use uninitialized account.
- Missing rent-exempt or lamports check: use closed or underfunded accounts.
- Closed account read: pass account with zero lamports or stale data.
- Duplicate mutable accounts: pass same account in multiple roles or through `remaining_accounts`.

### PDA Manipulation

Check and test:

- Non-canonical bump is rejected.
- PDA seeds include unique user, mint, pool, market, or nonce data where needed.
- Program derives and compares PDA keys on-chain.
- User-provided bump is not trusted.
- `init_if_needed` is protected by seeds, owner, discriminator, and authority checks.
- Seed collisions and front-run initialization are considered.

### Account Confusion and Type Cosplay

Check and test:

- Discriminator/type markers exist for state accounts.
- Token accounts cannot be used as program accounts.
- User accounts cannot masquerade as config/vault/position accounts.
- Normal accounts cannot substitute expected PDAs.
- `remaining_accounts` injection is rejected.
- Same-owner different-type accounts are tested.

### CPI Attack Simulation

Check and test:

- Target program IDs are validated before CPI.
- Arbitrary CPI is impossible or intentionally bounded.
- State is reloaded/re-read after CPI.
- Self-CPI or recursive patterns are impossible or bounded.
- CPI cannot reinitialize state or create inconsistent state transitions.
- User signer is not forwarded to untrusted external programs.
- Malicious fake programs are used in local tests when safe and useful.

### Upgrade Authority Abuse

Check and test:

- Production upgrade authority is not a single hot wallet.
- Multisig, DAO, timelock, or governance process exists where appropriate.
- Initialize/admin actions are restricted to the intended authority model.
- Authority transfer uses two-step or governed flow where needed.
- Immutability plan exists for stable programs.
- Malicious-upgrade scenarios are modeled only in local/safe environments.

### Economic and Oracle Attacks

Check and test:

- Oracle freshness, status, confidence, deviation, and source rules are enforced.
- Price manipulation and extreme price inputs are simulated.
- Slippage and minimum-out checks exist for swaps/routes.
- Flash-loan-like sequences cannot break solvency or accounting.
- Health factor, collateral, rewards, fees, and vault balances remain valid after adversarial sequences.
- Front-running/sandwich-sensitive flows are modeled by instruction ordering tests.

### Arithmetic and Precision

Check and test:

- Financial math uses checked operations.
- `overflow-checks = true` or equivalent safeguards are enabled for release.
- Division by zero is impossible.
- Casts use checked conversion instead of unsafe truncation.
- Rounding policy is explicit and resistant to arbitrage.
- Tests cover 0, 1, max values, dust, boundary thresholds, and repeated small operations.

### SPL Token and Token-2022

Check and test:

- Mint, owner, authority, delegate, close authority, decimals, and frozen state are validated.
- ATA derivation is checked when expected.
- Token-2022 extensions are reviewed: Transfer Hook, Transfer Fee, CPI Guard, Permanent Delegate, DefaultAccountState, Confidential Transfer, and metadata-related extensions.
- Malformed token accounts or malicious authority configurations are rejected.

### Sysvars, Init, Close, Realloc, and Lifecycle

Check and test:

- Sysvar addresses are hardcoded/validated.
- Initialize cannot run twice unless explicitly safe.
- Close zeroes data and marks account closed.
- Realloc validates owner, signer, size, rent, version, and zero-init behavior.
- Closed accounts cannot be revived with stale data.
- Duplicate mutable accounts cannot corrupt realloc/close logic.

### Concurrency and Race Conditions

Check and test:

- PDA creation handles concurrent users safely.
- Init front-running is mitigated through unique seeds, signer binding, nonce, or authority checks.
- Multiple transactions racing on shared state preserve invariants.
- Same-transaction instruction ordering cannot bypass checks.

### Dependencies, Unsafe, Panics, and DoS

Check:

- `cargo audit`, `cargo outdated`, or equivalent dependency review exists.
- Unsafe Rust is minimized, isolated, and tested.
- Production paths avoid `unwrap`, `expect`, and panics.
- Compute unit exhaustion is considered for attacker-controlled inputs.
- Instruction introspection and durable nonce use are correct when present.
- Dead code does not hide stale or insecure paths.

### Adversarial Tests and CI

Check:

- Tests generate malicious accounts per instruction.
- Fuzzing mutates accounts, bumps, owners, signers, writables, mints, amounts, and instruction order.
- Property-based tests assert critical invariants.
- Fake CPI programs are used locally for arbitrary-CPI and signer-forwarding tests when relevant.
- Red-team tests run in CI or nightly workflows.
- Threat model and test matrix are updated with each release.

## Implementation Guidance

When a red-team gap is found, help the user add the mitigation and regression test.

Prefer practical remedies:

- Add account validation helpers for signer, owner, writable, initialized, rent, discriminator, duplicate accounts, PDA, mint, vault, and authority.
- Add custom errors for each rejected attack class.
- Add PDA seed constants and canonical bump checks.
- Add CPI target program ID validation and post-CPI reload/re-read.
- Add Token-2022 extension allow/deny rules.
- Add oracle freshness/deviation/status checks and circuit breakers.
- Add checked arithmetic and explicit rounding.
- Add local red-team tests for malicious accounts, fake programs, non-canonical bumps, duplicate accounts, closed accounts, wrong sysvars, and max-value inputs.
- Add fuzz/property-based tests and CI commands.
- Add a threat model document or test matrix when useful.

If the user asks for implementation, edit/create the necessary files directly: validators, instruction checks, errors, tests, fixtures, fuzz harnesses, CI workflows, docs, and threat model notes.

Visible user-facing docs and app copy should default to English for international projects unless the project clearly targets another language.

## What to Flag Aggressively

Escalate:

- Admin/user authority can be supplied without signer verification.
- Program-owned account validation is missing.
- Attacker-owned accounts can provide forged state.
- PDAs accept user-provided bump or weak seeds.
- Account types can be confused due missing discriminator/type checks.
- `remaining_accounts` are trusted blindly.
- Arbitrary CPI or fake token program substitution is possible.
- Post-CPI state is read without reload/re-read.
- Upgrade authority is insecure in production.
- Oracle price/freshness/status is not validated.
- Financial math can overflow, underflow, divide by zero, truncate, or round unsafely.
- Token-2022 extensions can violate assumptions.
- Closed accounts can be read, revived, or reused unsafely.
- Red-team tests only cover happy paths or do not exist.
- Compute exhaustion can be triggered by attacker-controlled inputs.

## Preferred Remedies

For every confirmed red-team gap, provide the most robust practical solution, not only a warning.

Prefer remedies that remove the class of risk:

- Convert attacker scenario into a failing regression test first when practical.
- Add on-chain validation rather than client-only validation.
- Centralize reusable validators.
- Prefer explicit allowlists for external programs and token extension policies.
- Add invariant/property tests for economic logic.
- Add local fake-program tests for CPI abuse.
- Add CI red-team suites so the issue cannot return silently.
- Document the threat model and safe test environment.

When multiple remedies exist, distinguish:

- **Robust solution:** preferred production-grade fix.
- **Fast mitigation:** temporary risk reduction when useful.
- **Safe test environment needed:** local validator, fork, fake program, fixture, or explicit authorization required.
- **Validation:** tests, fuzz runs, simulations, commands, fixtures, CI jobs, or monitoring required to prove mitigation.

## Output Expectations

Start with a **Red-Team Simulation Snapshot**:

- Overall adversarial risk: Critical, High, Medium, or Low
- Release stance: Block release, release after fixes, needs safe test environment, or no major blocker found
- Scope reviewed: instructions/accounts/PDAs/CPIs/tokens/oracles/tests/CI actually inspected
- Top attack paths: 3-5 highest-impact scenarios
- Safe test environment needed: yes/no, with topics
- Assumptions, authorization, and production state not verified

Prioritize findings:

1. Account validation, signer, owner, writable, initialized, rent, duplicate, and closed-account attacks
2. PDA seed, bump, spoofing, collision, and init/front-run attacks
3. Account confusion, type cosplay, `remaining_accounts`, and malicious account injection
4. CPI, fake program, stale state, signer forwarding, and self-CPI risks
5. Upgrade authority, admin, governance, and initialization abuse
6. Economic, oracle, price manipulation, flash-loan-like, slippage, and invariant attacks
7. Arithmetic, precision, Token/Token-2022, sysvar, realloc, close, lifecycle, and concurrency risks
8. Fuzzing, property tests, malicious fixtures, CI, threat model, dependency, unsafe, panic, and DoS gaps

For each finding include:

- Severity: Critical, High, Medium, or Low
- Status: Issue, Partial, Not applicable, or Needs safe test environment when relevant
- Confidence: High, Medium, or Low
- Affected instruction/account/file/flow when available
- Evidence found or evidence missing
- Attack scenario
- What can go wrong
- Robust solution
- Fast mitigation when appropriate
- Safe test environment needed when applicable
- Implementation path: exact validator, instruction, account, error, test, fixture, fuzz target, CI job, or doc to add/update
- Validation steps

After findings, include a **Recommended Red-Team Hardening Plan** ordered by risk and dependency. The plan must be concrete enough for an agent to implement without guessing, naming files, checks, attack tests, fixtures, commands, fuzz targets, and CI jobs when available.

When the user asked for fixes, implement the plan in the repository and then summarize changed files and remaining items requiring safe environment setup, authorization, production data, or deeper fuzzing.

If no serious gaps are found, say that clearly and list residual red-team risks, assumptions, authorization limits, or tests not run.

## Approval Bar

Do not mark a Solana program red-team ready while any of these remain unresolved:

- Critical instructions lack signer, owner, writable, PDA, type, mint, authority, or duplicate-account checks.
- Arbitrary CPI or fake program substitution is possible.
- High-risk authority/admin paths are unprotected or untested.
- Economic/oracle assumptions are untested for financial protocols.
- Arithmetic edge cases can break accounting or panic.
- Token/Token-2022 assumptions are unreviewed.
- Closed/reallocated/reinitialized accounts can be abused.
- No adversarial tests exist for critical flows.
- Findings recommend mitigations without implementation path and validation steps.
- Proposed simulation would affect unauthorized live systems.

If approval is blocked, give the shortest robust path to make the program safe enough for controlled red-team testing and review.

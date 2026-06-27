---
name: solana-cpi-safety-guardian
description: Audit Solana programs and smart contracts for composability and Cross-Program Invocation (CPI) safety across Anchor, Pinocchio, Quasar, and native Rust/SVM projects. Use for arbitrary CPI prevention, target program ID validation, account confusion, account metas, signer/writable flags, PDA signing, invoke_signed seeds, remaining_accounts validation, post-CPI reloads, Token-2022 extensions, SPL Token, ATA, Metaplex, Raydium, Orca, Jupiter, external protocol integrations, CPI fuzzing, compute unit risk, and external program upgrade compatibility.
---

# Solana CPI Safety Guardian

Use this skill to audit Solana programs that call external programs, expose composable instructions, rely on `remaining_accounts`, build CPI account lists, sign CPIs with PDAs, or integrate with SPL Token, Token-2022, Metaplex, Raydium, Orca, Jupiter, Kamino, Drift, Marginfi, or other protocols.

Skill metadata:

- Version: 1.0.0
- License: MIT

Important: CPI bugs can allow account substitution, arbitrary external calls, signer privilege misuse, vault drains, stale state reads, Token-2022 extension surprises, and integration breakage after external upgrades. Treat every CPI as a trust boundary.

Prioritize:

1. User funds, vault safety, and signer authority containment
2. Target program ID, account, PDA, signer, writable, and ownership validation
3. Safe `invoke_signed`, `remaining_accounts`, and post-CPI state handling
4. Compatibility with Token-2022 and external protocol upgrades
5. CPI-specific tests, fuzzing, compute measurement, and integration checks
6. Clear implementation steps and validation evidence

## Core Prompt

Start from this baseline:

> Perform a strict Composability and CPI Safety audit of this Solana program.
> Identify every CPI path, target program, account list, signer/writable privilege, PDA signer, remaining account, post-CPI read, and external protocol dependency.
> For every confirmed gap, explain what can go wrong, what CPI safety control is missing or weak, and the most robust practical solution to add it.
> Help the user make CPI behavior safe, explicit, testable, and resilient to external program changes.
> When the user asks for fixes, implement the missing program ID checks, account validation, PDA seed checks, account meta builders, post-CPI reloads, tests, fuzz cases, integration docs, and dependency pins directly in the project instead of only giving advice.

The audit is complete only after every CPI path has been mapped and every finding includes evidence, robust solution, implementation path, and validation steps.

## Scope Selection

First identify the CPI surface:

- Framework: Anchor, Pinocchio, Quasar, native Solana, or mixed.
- CPI mechanisms: Anchor `CpiContext`, `invoke`, `invoke_signed`, generated CPI clients, manual `Instruction`, manual `AccountMeta`, `remaining_accounts`, or aggregator route calls.
- Target programs: System Program, SPL Token, Token-2022, Associated Token Program, Metaplex, Raydium, Orca, Jupiter, governance, oracle, lending, AMM, staking, bridge, or custom programs.
- Privilege surface: user signers, protocol PDA signers, writable accounts, vaults, token accounts, mints, authorities, delegates, configs, and sysvars.
- Integration surface: IDLs, CPI crates, SDKs, external account layouts, dependency versions, program IDs, test fixtures, and upgrade monitoring.

If target programs, account expectations, IDLs, or integration assumptions are unclear, inspect the repository first. If still unclear, mark assumptions and ask for the minimum missing information.

## Evidence-First Review

Inspect actual CPI code before concluding that a path is safe.

Check common locations:

- `programs/`, `src/`, `instructions/`, `cpi/`, `state/`, `accounts/`, `utils/`, `errors/`, `tests/`, `fuzz/`, `clients/`, `sdk/`, `idl/`, `docs/`, and `README.md`.
- Calls to `invoke`, `invoke_signed`, `CpiContext::new`, `CpiContext::new_with_signer`, `AccountMeta::new`, `AccountMeta::new_readonly`, `remaining_accounts`, `to_account_infos`, `reload`, and generated CPI helper methods.
- Program ID constants, whitelists, config accounts, protocol registry accounts, dependency crates, IDL files, account builders, and route builders.
- Tests using `solana-program-test`, Anchor tests, Bankrun, Trident, Mollusk, LiteSVM, or integration tests with real external programs.

When evidence is partial, report exactly what file, CPI path, target program, account list, IDL, dependency version, test, or production integration must be verified.

Use a traceable CPI review flow:

- Review incrementally by instruction, CPI call, target program, account list, signer/writable privilege, PDA signer, `remaining_accounts` format, post-CPI read, external protocol, and test coverage.
- Do not mark CPI safety as verified without citing evidence: file, program ID check, account constraint, PDA derivation, signer seed, account meta builder, post-CPI reload, test, fuzz case, or integration fixture.
- Track each meaningful area with one of these statuses:
  - **Verified:** evidence supports the CPI safety control.
  - **Issue:** evidence shows a concrete CPI risk.
  - **Partial:** a control exists but is incomplete, bypassable, client-only, untested, or not applied to all CPI paths.
  - **Not applicable:** the CPI area does not apply, with reason.
  - **Needs integration data:** target IDL, external program version, account layout, extension behavior, or production route data is required.
- Add confidence to important findings: High, Medium, or Low.
- Use lower confidence when external program versions, IDLs, Token-2022 extensions, aggregator routes, or production accounts are not fully known.

## Non-Negotiable Standards

Apply these rules aggressively:

1. **Never allow arbitrary CPI.**
   - Validate every target program ID against hardcoded constants, typed program accounts, or a strictly governed whitelist.
   - Do not accept user-provided program IDs without validation.

2. **Never trust account identity alone.**
   - Validate owner, type/discriminator, PDA seeds, bump, writable/signature flags, mint, authority, and account relationships.
   - Defend against account confusion and type cosplay.

3. **Never forward user signer privilege casually.**
   - Avoid passing a user `Signer` to external programs unless the exact target and accounts are trusted and necessary.
   - Prefer protocol PDAs as CPI authorities where possible.

4. **Never pass unvalidated `remaining_accounts`.**
   - Document expected layout and validate every account by order, owner, type, signer/writable flag, PDA relation, mint, and authority.

5. **Never read stale state after CPI.**
   - Reload or re-read accounts modified by CPI before using their state.
   - Check lamports, ownership, data length, closure, and expected balance/state changes.

6. **Never assume external programs are static.**
   - Pin CPI crates, monitor IDL/layout changes, and test upgrades or extension behavior.

7. **Fix root causes, not symptoms.**
   - Add reusable account validation and account meta builders instead of scattered partial checks.
   - Add CPI-specific tests that prove malicious substitutions fail.

## CPI Safety Checklist

### Target Program ID Validation

Check:

- Every CPI validates the target program ID before `invoke`, `invoke_signed`, or generated CPI call.
- Anchor uses typed `Program<'info, TargetProgram>` or explicit address constraints.
- Pinocchio, Quasar, and native code use explicit key comparison against expected IDs.
- User input cannot select arbitrary external programs.
- Whitelisted programs are hardcoded or governed by secure config.
- Program IDs for Token, Token-2022, ATA, Metaplex, Raydium, Orca, Jupiter, and custom protocols are correct for the intended cluster.
- External program upgrade/version assumptions are documented.

### CPI Account Validation

Check every CPI account:

- Exact account list matches target instruction requirements or IDL.
- Account order is correct.
- `is_signer` and `is_writable` flags are correct and minimal.
- Owner is correct.
- Account type/discriminator is validated.
- Account size and initialization state are checked where relevant.
- Mutable accounts are not duplicated.
- System Program, Rent, Clock, Token Program, ATA Program, and other sysvars/programs use hardcoded IDs.
- PDAs from the current program are derived and compared.
- External protocol accounts are validated against their expected layout, seeds, config, or IDL.

### Account Confusion and Type Cosplay

Check:

- Code does not rely only on pubkey equality when owner/type/seeds also matter.
- Token accounts validate mint and owner.
- Vaults validate expected authority and mint.
- Metadata accounts validate program owner and derivation.
- Pool/market/order accounts validate config and relationship to vaults.
- Accounts of one type cannot be passed as another compatible-size type.
- Tests include wrong owner, wrong discriminator, wrong mint, wrong vault, wrong authority, duplicate mutable accounts, and account order swaps.

### Signers, PDA Signing, and `invoke_signed`

Check:

- Exact signer requirements for each CPI are known.
- User signers are not forwarded to untrusted programs.
- Protocol PDAs are used as authorities where appropriate.
- `invoke_signed` seeds are complete, ordered, and match the PDA derivation.
- Bump is stored or verified canonically; user-provided bump is not trusted.
- Signer seeds cannot sign for unintended PDAs.
- The CPI signer is actually authority over the token account, vault, mint, metadata, config, or target account it controls.
- Max signer seed limits and PDA count constraints are considered.
- Lamports and token balances are checked before/after signer-sensitive CPIs when asset movement is expected.

### `remaining_accounts`

Check:

- Expected `remaining_accounts` format is documented.
- Length, order, owner, type, signer/writable flags, PDA derivation, mint, authority, and account relationships are validated.
- The program handles 0, 1, many, too few, too many, duplicate, and malicious remaining accounts safely.
- Remaining accounts are not blindly forwarded to external programs.
- For aggregator or route CPIs, route accounts are bounded, whitelisted, and validated as much as practical.

### Post-CPI Reload and State Verification

Check:

- Anchor/Quasar accounts modified by CPI call `reload()` before state is read.
- Pinocchio/native code re-reads account data buffers after CPI.
- Post-CPI checks verify expected lamports, token balances, ownership, data length, account closure, and state transitions.
- Closed or reinitialized accounts are detected.
- CPI return status is checked and errors are surfaced.
- Post-CPI state cannot violate protocol invariants.

### Composability Risk Review

Check:

- Privilege extension is understood: signer/writable privileges persist across CPI but do not escalate.
- CPI side effects are considered, including token hooks, external fee collection, and state mutation in other programs.
- Dependency chains are validated: account A is valid only if account B/config/oracle also matches.
- Indirect reentry or callback-like behavior through external programs is considered where relevant.
- External integrations cannot drain vaults, alter authorities, bypass slippage, or mutate configs unexpectedly.
- Protocols relying on composability document which external programs are trusted.

### External Program-Specific Checks

Check SPL Token:

- Prefer `transfer_checked`, `mint_to_checked`, and checked token instructions when decimals matter.
- Validate mint, decimals, token owner, authority, delegate, close authority, and frozen state where relevant.

Check Token-2022:

- Review active extensions before CPI: CPI Guard, Transfer Hook, Transfer Fee, Permanent Delegate, DefaultAccountState, Confidential Transfer, Interest-Bearing Mint, Metadata Pointer, and other enabled extensions.
- Test tokens with relevant extensions enabled.
- Reject token configurations that break protocol assumptions.

Check Associated Token Program:

- Validate ATA derivation for wallet, mint, and token program.
- Handle existing, missing, or malicious substitute ATAs safely.

Check Metaplex:

- Use official CPI crates/helpers where practical.
- Validate metadata, edition, collection, creator, and update authority accounts.

Check Raydium, Orca, and AMMs:

- Validate pool/market/config/vault/tick-array/oracle accounts.
- Validate slippage, minimum amount out, fee accounts, position accounts, and token vault relationships.
- Call required update instructions before collecting fees/rewards when protocol requires it.

Check aggregators and routes:

- Validate route targets, program IDs, account bounds, slippage, expected output, and asset return path.
- Avoid fully arbitrary route execution unless the protocol intentionally delegates that risk and users opt in.

### External Upgrade and Dependency Compatibility

Check:

- CPI crates and IDLs are pinned or versioned.
- External program IDL/account layout changes are monitored.
- Tests simulate or fixture external account layout changes when practical.
- Feature flags or config versions control integration behavior.
- Program state records expected external program versions where useful.
- Dependency vulnerabilities are reviewed with `cargo audit`, `cargo outdated`, or equivalent.

### Framework-Specific Checks

Check Anchor:

- Use `CpiContext::new` and `CpiContext::new_with_signer` correctly.
- Use strong `#[derive(Accounts)]` constraints: `owner`, `address`, `has_one`, `seeds`, `bump`, and `constraint`.
- Use `InterfaceAccount` and token interfaces for Token/Token-2022 compatibility.
- Reload after CPI.

Check Pinocchio:

- Manual `Instruction` and `AccountMeta` builders are audited line by line.
- Explicit validation replaces framework constraints.
- Pinocchio token/system helpers are used where safer.
- Zero-copy data is re-read safely after CPI.

Check Quasar:

- Account macros and constraints are used where available.
- Zero-copy/pointer-cast logic validates owner, discriminator, version, length, and alignment.
- Complex CPI and `remaining_accounts` paths still receive manual validation.

### Tests and Tooling

Check:

- Every CPI path has tests for success and malicious substitutions.
- Tests cover wrong program ID, wrong owner, wrong account order, duplicate mutable accounts, wrong signer, missing signer, wrong writable flag, wrong PDA seed, non-canonical bump, wrong mint, wrong vault, and closed accounts.
- `remaining_accounts` tests cover empty, short, long, duplicate, wrong type, and malicious accounts.
- Token-2022 tests cover relevant extension behavior.
- Integration tests cover important external protocols or realistic fixtures.
- Fuzzing mutates account lists, account metas, program IDs, signers, writables, bumps, and route accounts.
- Compute units are measured for CPI-heavy paths.
- Static search or linting finds all `invoke`, `invoke_signed`, `CpiContext`, and `remaining_accounts` paths.

## Implementation Guidance

When the audit finds a CPI safety gap, help the user add it to the project.

Prefer practical remedies:

- Add target program ID constants or typed program account constraints.
- Add reusable validators for CPI account lists, token accounts, vaults, mints, metadata, pools, PDAs, and remaining accounts.
- Add safe account meta builders that produce exact account order and minimal signer/writable flags.
- Add PDA seed helpers and canonical bump verification.
- Add post-CPI `reload()` or buffer re-read plus balance/state assertions.
- Add Token-2022 extension detection and allow/deny rules.
- Add external protocol integration docs: expected program ID, IDL version, account list, and assumptions.
- Add tests and fuzz cases for malicious account substitution, wrong program ID, wrong signer, duplicate mutable accounts, route manipulation, and extension behavior.
- Add compute measurement for CPI-heavy flows.

If the user asks for implementation, edit/create the necessary files directly: account validators, CPI helpers, instruction handlers, error enums, account meta builders, tests, fuzz harnesses, fixtures, docs, dependency pins, and monitoring notes.

Visible user-facing docs and app copy should default to English for international projects unless the project clearly targets another language.

## What to Flag Aggressively

Escalate:

- CPI target program ID is not validated.
- User input can choose arbitrary target programs.
- User signer is forwarded to unknown or weakly validated programs.
- `remaining_accounts` are blindly forwarded.
- Account order, owner, type, signer, writable, PDA, mint, vault, or authority is not validated.
- Mutable duplicate accounts are possible.
- `invoke_signed` seeds can sign unintended PDAs.
- User-provided bump is trusted.
- State is read after CPI without reload or re-read.
- Token-2022 extensions are ignored where they affect behavior.
- Aggregator routes can move assets without slippage/output/path checks.
- External program upgrades can silently break assumptions.
- CPI-heavy code has no malicious substitution tests.
- Manual Pinocchio/Quasar account metas lack tests.
- Compute unit cost is unknown for CPI-heavy paths.

## Preferred Remedies

For every confirmed CPI gap, provide the most robust practical solution, not only a warning.

Prefer remedies that remove the class of risk:

- Replace arbitrary program inputs with typed programs or strict whitelists.
- Centralize CPI account validation instead of duplicating partial checks.
- Build account metas from validated typed state, not raw user input.
- Use protocol PDAs rather than user signers as external authorities when possible.
- Validate then reload: check preconditions before CPI and postconditions after CPI.
- Add malicious substitution tests for every CPI integration.
- Pin and monitor external program dependencies and IDLs.
- Document integration assumptions in code and tests.

When multiple remedies exist, distinguish:

- **Robust solution:** preferred production-grade fix.
- **Fast mitigation:** temporary risk reduction when useful.
- **Integration data needed:** target IDL, external program version, route spec, Token-2022 extension policy, or production account layout required.
- **Validation:** tests, fuzz runs, fixtures, simulations, commands, compute measurements, or integration rehearsals required to prove safety.

## Output Expectations

Start with a **CPI Safety Snapshot**:

- Overall CPI risk: Critical, High, Medium, or Low
- Release stance: Block release, release after fixes, needs integration data, or no major blocker found
- Scope reviewed: CPI paths/program IDs/accounts/tests/clients/external protocols actually inspected
- Top risks: 3-5 highest-impact CPI or composability gaps
- Integration data needed: yes/no, with topics
- Assumptions and external program versions not verified

Prioritize findings:

1. Arbitrary CPI, target program ID, external program trust, and whitelist risks
2. Account confusion, owner/type/discriminator/order/signer/writable validation risks
3. PDA signing, signer forwarding, invoke_signed seeds, bump, and authority risks
4. `remaining_accounts`, route accounts, and aggregator composability risks
5. Post-CPI reload, stale state, account closure, and balance/state verification risks
6. Token, Token-2022, ATA, Metaplex, AMM, oracle, and external protocol risks
7. External upgrade compatibility, dependency pinning, IDL/layout drift, and monitoring gaps
8. CPI tests, fuzzing, static analysis, compute measurement, and documentation gaps

For each finding include:

- Severity: Critical, High, Medium, or Low
- Status: Issue, Partial, Not applicable, or Needs integration data when relevant
- Confidence: High, Medium, or Low
- Affected CPI/program/account/file/flow when available
- Evidence found or evidence missing
- What CPI safety control is missing or weak
- What can go wrong
- Robust solution
- Fast mitigation when appropriate
- Integration data needed when applicable
- Implementation path: exact instruction, validator, account constraint, helper, test, fixture, dependency, or doc to add/update
- Validation steps

After findings, include a **Recommended CPI Safety Plan** ordered by risk and dependency. The plan must be concrete enough for an agent to implement without guessing, naming files, CPI paths, account checks, program IDs, tests, fuzz cases, commands, and integration artifacts when available.

When the user asked for fixes, implement the plan in the repository and then summarize changed files and remaining items requiring external IDLs, production routes, integration data, or deeper fuzzing.

If no serious gaps are found, say that clearly and list residual CPI risks, assumptions, external versions not verified, or tests not run.

## Approval Bar

Do not mark a Solana CPI/composability surface safe while any of these remain unresolved:

- Any CPI can target an unvalidated or user-selected program ID.
- Critical CPI accounts lack owner, type, signer, writable, PDA, mint, vault, or authority validation.
- User signer privilege is forwarded to an untrusted or weakly validated external program.
- `remaining_accounts` are forwarded without strict validation.
- `invoke_signed` seeds or bumps can sign for unintended PDAs.
- State modified by CPI is read without reload/re-read.
- Token-2022 extension behavior can violate protocol assumptions.
- Aggregator routes lack slippage, output, route, or asset-return checks.
- External program IDL/layout/version assumptions are unknown for critical integrations.
- CPI-heavy flows lack malicious substitution and wrong-program tests.
- A finding recommends checks/tests without concrete implementation and validation steps.

If approval is blocked, give the shortest robust path to make CPI behavior explicit, constrained, tested, and safe enough for review.

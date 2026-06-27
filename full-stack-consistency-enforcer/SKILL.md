---
name: full-stack-consistency-enforcer
description: Audit and enforce full-stack consistency for Solana projects across on-chain Rust, IDL/schema, generated clients, TypeScript SDKs, frontend hooks, tests, docs, CI/CD, and versioning. Use for IDL drift detection, Codama/Shank/Anchor/Quasar codegen, @solana/kit clients, typed hooks, PDA seed consistency, account layout consistency, error/event/type synchronization, frontend/backend/indexer schema alignment, generated docs, release compatibility, or automation that keeps the full stack synchronized.
---

# Full-Stack Consistency Enforcer

Use this skill to audit and enforce consistency across a Solana project's full stack: on-chain program, IDL or schema, generated clients, frontend hooks, backend/indexers, tests, documentation, CI/CD, and release/versioning workflow.

Skill metadata:

- Version: 1.0.0
- License: MIT

Important: the IDL or equivalent schema should be treated as the contract between on-chain and off-chain code. Any drift between Rust, IDL, TypeScript clients, frontend hooks, indexers, docs, and tests can create production bugs, broken transactions, unsafe assumptions, or security issues.

Prioritize:

1. IDL/schema as the source of truth
2. On-chain account, instruction, error, event, PDA, and discriminator consistency
3. Generated TypeScript/Rust clients and frontend hooks without duplicated manual types
4. Automated drift detection in build, pre-commit, and CI
5. Full-stack tests, docs, versioning, and upgrade compatibility
6. Practical implementation steps and measurable validation

## Core Prompt

Start from this baseline:

> Perform a strict Full-Stack Consistency Enforcer audit of this Solana project.
> Identify drift between on-chain Rust, IDL/schema, generated clients, frontend hooks, backend/indexer schemas, tests, docs, CI, and versioning.
> For every confirmed gap, explain what can go wrong, what consistency control is missing or weak, and the most robust practical solution to add it.
> Help the user make the IDL/schema the single source of truth and automate regeneration, drift detection, tests, docs, and release checks.
> When the user asks for fixes, implement the missing codegen scripts, consistency checks, generated client wiring, typed hooks, tests, docs, CI jobs, and versioning workflow directly in the project instead of only giving advice.

The audit is complete only after the source of truth is identified, drift risks are mapped, and every finding includes evidence, robust solution, implementation path, and validation steps.

## Scope Selection

First identify the project shape:

- On-chain framework: Anchor, Quasar, Pinocchio, native Solana, or mixed.
- Schema source: Solana IDL Standard, Anchor IDL, Codama IDL, Shank schema, Quasar output, custom schema, or no formal schema.
- Client stack: Codama-generated client, `@solana/kit`, Anchor TS, web3.js legacy, Rust client, Go client, mobile client, backend SDK, or generated package.
- Frontend stack: React, Next.js, Vue, Svelte, React Native, dashboard, CLI, or internal tools.
- Shared surfaces: PDA seeds, account layouts, discriminators, instructions, custom types, enums, errors, events, constants, docs, examples, tests, and indexer schemas.
- Automation surface: `justfile`, `Makefile`, package scripts, workspace scripts, pre-commit hooks, CI jobs, codegen, docs generation, snapshot tests, and release checks.

If framework, IDL source, or generated-client strategy is unclear, inspect the repository first. If still unclear, mark assumptions and ask for the minimum missing information.

## Evidence-First Review

Inspect actual project files before concluding that consistency is enforced.

Check common locations:

- `programs/`, `src/`, `state/`, `instructions/`, `accounts/`, `errors/`, `events/`, `idl/`, `target/idl/`, `target/types/`, `codama/`, `shank/`, `clients/`, `sdk/`, `packages/`, `app/`, `frontend/`, `hooks/`, `tests/`, `docs/`, `.github/workflows/`, `justfile`, `Makefile`, `package.json`, `Anchor.toml`, `Cargo.toml`, and workspace config.
- Generated files, manual type definitions, account decoders, instruction builders, PDA helpers, custom hooks, error maps, event parsers, docs tables, examples, snapshots, and generated packages.
- Build scripts, codegen scripts, pre-commit hooks, drift detection scripts, CI jobs, release/versioning docs, and changelog process.

When evidence is partial, report exactly what file, schema, generated artifact, workflow, command, or release process must be verified.

Use a traceable consistency review flow:

- Review incrementally by source of truth, on-chain schema, IDL generation, client generation, frontend usage, tests, docs, drift detection, versioning, and release automation.
- Do not mark a layer as synchronized without citing evidence: file, generated artifact, command, CI job, snapshot, type import, codegen output, or test.
- Track each meaningful area with one of these statuses:
  - **Verified:** evidence supports the consistency control.
  - **Issue:** evidence shows concrete drift or missing enforcement.
  - **Partial:** a control exists but is incomplete, manual, untested, stale, or not wired into CI.
  - **Not applicable:** the layer does not apply, with reason.
  - **Needs architecture decision:** the project must choose a schema/codegen/versioning strategy first.
- Add confidence to important findings: High, Medium, or Low.
- Use lower confidence when generated artifacts are ignored, CI is unavailable, frontend/backend consumers are outside the repo, or release process is undocumented.

## Non-Negotiable Standards

Apply these rules aggressively:

1. **Do not allow multiple competing sources of truth.**
   - Rust, IDL/schema, clients, hooks, docs, and tests must not define the same account or instruction differently.

2. **Do not allow manual duplicated types where generated types should exist.**
   - Manual TypeScript interfaces for accounts, instructions, errors, or events are drift magnets unless they are explicitly generated or validated.

3. **Do not allow IDL changes without regenerated clients and tests.**
   - A changed account, instruction, error, event, PDA seed, or discriminator must trigger codegen and validation.

4. **Do not trust frontend or backend assumptions that differ from on-chain validation.**
   - Signer/writable flags, PDA derivation, account relationships, and constraints must stay aligned.

5. **Do not let drift detection be optional.**
   - Consistency checks should run in build, CI, and preferably pre-commit.

6. **Do not ignore versioning and backwards compatibility.**
   - Breaking IDL changes require semantic versioning, changelog, migration notes, and compatibility tests.

7. **Fix root causes, not symptoms.**
   - Add generation and drift enforcement instead of manually patching stale types in one layer.

## Consistency Readiness Checklist

### Source of Truth: IDL and Schema

Check:

- Project uses Solana IDL Standard, Codama IDL, Anchor IDL, Shank, Quasar output, or an equivalent central schema.
- Dedicated IDL directory exists and is versioned when appropriate: `idl/`, `target/idl/`, or equivalent.
- IDL is generated automatically during build or through a mandatory script.
- IDL includes accounts, instructions, custom types, errors, events, constants, and PDA seed metadata where supported.
- Account discriminators and instruction discriminators match the Rust code.
- Account byte layout matches the IDL, especially for Quasar, Pinocchio, and zero-copy layouts.
- IDL is published or packaged for consumers when required.
- IDL versioning and history are clear.
- IDL diff tooling exists for release review.

### On-Chain Consistency

Check:

- Rust account structs match IDL fields, field order, types, `Option`, `Vec`, arrays, nested structs, and enums.
- No ghost fields, hidden serialization, or manual byte layout diverges from the schema.
- PDA seeds are centralized and documented.
- Errors are defined and mapped into the IDL/client layer.
- Events are reflected in generated client/event parser code.
- Instruction args and accounts match IDL exactly.
- Signer/writable/mutability expectations match generated builders and tests.

Framework-specific checks:

- Anchor: `#[account]`, `#[derive(Accounts)]`, `InitSpace`, `declare_id!`, `Anchor.toml`, generated IDL, and generated types are aligned.
- Quasar: `#[program]`, `#[account]`, `#[derive(Accounts)]`, build output, generated clients, and zero-copy layouts are aligned.
- Pinocchio: Shank or Codama annotations exist, byte layouts are documented, and a required `generate-idl` workflow exists.

### Generated Client and SDK Consistency

Check:

- Client is generated from IDL/schema, preferably with Codama for modern `@solana/kit` workflows when suitable.
- No manual account/instruction types duplicate generated types.
- Generated instruction builders, account decoders, PDA helpers, errors, events, and custom types are used.
- Enums, nested types, arrays, `Option`, `Vec`, discriminators, and constants are correctly typed.
- Client package is published or consumed through a monorepo/shared package.
- Codegen runs in build, pre-commit, or CI.
- Legacy `web3.js` usage is intentional and isolated if the project is migrating to `@solana/kit`.

### Frontend Hooks and App Integration

Check:

- React/Next/Vue/Svelte hooks use generated types and generated builders.
- TanStack Query, SWR, Zustand, Jotai, forms, transaction builders, and account fetchers use generated schemas.
- PDA derivation in the frontend uses generated/shared helpers, not copied seed strings.
- Program errors from the IDL map to user-facing messages.
- Account decoders are typed and aligned with the generated client.
- No component or hook hardcodes stale account shapes.
- A package such as `@project/client`, `@project/types`, or `@project/idl` isolates app code from raw generated internals.

### Backend, Indexer, Mobile, and External Consumers

Check:

- Backend APIs, workers, bots, indexers, mobile apps, and CLIs consume the same generated client/types.
- Indexer schemas match IDL account layouts and events.
- Oracles or off-chain processors document assumptions about account fields and events.
- Multi-language clients are generated or validated from the same schema when used.
- Public examples and SDK docs compile against current generated types.

### Tests and Drift Detection

Check:

- On-chain tests use generated IDL/types where practical.
- Client tests use generated builders and account decoders.
- Full-stack integration tests cover on-chain + client + frontend or backend flows.
- IDL snapshot tests fail on unintended changes.
- Drift tests compare Rust vs IDL, IDL vs generated TS, and generated TS vs frontend/backend usage.
- PDA derivation tests run on every relevant layer.
- Error, event, custom type, `Option`, `Vec`, enum, and edge-case decoding tests exist.
- Backward compatibility tests cover old IDL/client versions when required.
- CI fails on drift.

### Documentation Consistency

Check:

- Docs are generated or validated from IDL/schema where possible.
- README includes current accounts, instructions, errors, events, and examples.
- PDA seeds and constraints are documented.
- Examples compile or are tested against current generated clients.
- Architecture diagrams or account diagrams are regenerated or snapshot-tested when relevant.
- Changelog highlights IDL breaking changes.
- Upgrade/migration guide exists for breaking account or instruction changes.

### Automation and CI/CD

Check:

- Scripts exist for `generate-idl`, `generate-client`, `check-consistency`, `sync-all`, or equivalent.
- CI pipeline runs IDL generation, client generation, drift detection, tests across layers, and docs build when applicable.
- Pre-commit hooks run lightweight consistency checks.
- Monorepo/workspace structure separates program, client, frontend, shared types, and docs cleanly.
- Build cache avoids unnecessary codegen but never skips required regeneration after Rust/schema changes.
- Drift detection failure includes clear remediation commands.
- Intentional drift exceptions are documented and time-bounded.

### Versioning, Compatibility, and Upgrades

Check:

- Program version and IDL version use a clear semantic strategy.
- Major versions are reserved for breaking account/instruction/client changes.
- Multiple IDL versions can coexist when needed.
- Deprecated fields/instructions have a documented lifecycle.
- Account migrations are linked to IDL/client/docs changes.
- Release checklist includes IDL diff, generated-client update, docs update, tests, and consumer migration notes.

### Security Consistency

Check:

- Frontend/backend account validation never contradicts on-chain validation.
- Signer/writable/mutability expectations are consistent between IDL, client builders, and Rust constraints.
- PDA derivation cannot drift between frontend and on-chain.
- Error handling does not hide critical program failures.
- Account layout drift cannot cause unsafe decoding, wrong balances, wrong authorities, or transaction signing with incorrect accounts.
- Security audits include an IDL-to-code consistency pass.

## Implementation Guidance

When the audit finds consistency drift, help the user add enforcement to the project.

Prefer practical remedies:

- Add or standardize IDL generation from Anchor, Quasar, Shank, Codama, or the existing schema tool.
- Add Codama or existing codegen integration for generated clients and `@solana/kit` where appropriate.
- Replace manual TypeScript account/instruction/error/event types with generated imports.
- Add generated PDA helpers and remove copied seed strings from clients/frontends.
- Add drift detection scripts for Rust vs IDL, IDL vs generated client, and client vs frontend usage.
- Add IDL snapshot tests and generated-client snapshot tests.
- Add CI jobs for codegen, consistency checks, tests, docs generation, and release validation.
- Add docs generated or validated from IDL.
- Add versioning, changelog, and migration notes for IDL changes.

If the user asks for implementation, edit/create the necessary files directly: codegen scripts, package scripts, CI workflows, client package wiring, typed hooks, tests, snapshots, docs, README sections, migration notes, and consistency validators.

Visible user-facing docs and app copy should default to English for international projects unless the project clearly targets another language.

## What to Flag Aggressively

Escalate:

- No central IDL/schema source of truth.
- IDL is stale, ignored, manually edited without validation, or not generated in workflow.
- Rust account layout differs from IDL.
- Zero-copy layouts are not validated against schema.
- Manual TypeScript interfaces duplicate generated types.
- Frontend hooks hardcode account shapes, PDA seeds, or instruction args.
- Client uses `any` for accounts, instructions, errors, or custom types.
- Generated clients are not regenerated in build/CI.
- No drift detection exists.
- CI does not fail on IDL/client/frontend drift.
- Docs/examples describe old accounts or instructions.
- Breaking IDL changes lack versioning, changelog, migration notes, or compatibility tests.
- Backend/indexer schema can drift from on-chain account layouts.
- Signer/writable flags differ between Rust constraints and generated builders.

## Preferred Remedies

For every confirmed consistency gap, provide the most robust practical solution, not only a warning.

Prefer remedies that remove the class of risk:

- Establish one schema source of truth before patching downstream consumers.
- Generate clients, hooks, docs, and tests from the schema where possible.
- Centralize PDA seeds and account decoding in generated/shared packages.
- Make drift detection mandatory in CI.
- Use snapshots and diffs to make IDL changes reviewable.
- Replace manual duplicated types with generated types.
- Add compatibility tests before changing public IDL.
- Document release procedures so every layer updates together.

When multiple remedies exist, distinguish:

- **Robust solution:** preferred production-grade fix.
- **Fast mitigation:** temporary risk reduction when useful.
- **Architecture decision needed:** schema/codegen/versioning strategy that must be chosen.
- **Validation:** scripts, tests, snapshots, CI jobs, generated files, docs, or release checks required to prove consistency.

## Output Expectations

Start with a **Full-Stack Consistency Snapshot**:

- Overall consistency risk: Critical, High, Medium, or Low
- Release stance: Block release, release after fixes, needs architecture decision, or no major blocker found
- Scope reviewed: Rust/IDL/client/frontend/backend/tests/docs/CI/versioning actually inspected
- Top risks: 3-5 highest-impact drift or automation gaps
- Architecture decision needed: yes/no, with topics
- Assumptions and external consumers not verified

Prioritize findings:

1. Missing source of truth, stale IDL, account layout, discriminator, and schema drift risks
2. Generated client, TypeScript SDK, `@solana/kit`, manual type, and decoder drift risks
3. Frontend hooks, PDA helpers, transaction builders, error mapping, and app-state drift risks
4. Backend, indexer, mobile, CLI, docs, examples, and external consumer drift risks
5. Tests, snapshots, drift detection, pre-commit, CI, and build automation gaps
6. Versioning, migration, release, backwards compatibility, and changelog gaps
7. Security issues caused by signer/writable/PDA/account-layout mismatch

For each finding include:

- Severity: Critical, High, Medium, or Low
- Status: Issue, Partial, Not applicable, or Needs architecture decision when relevant
- Confidence: High, Medium, or Low
- Affected layer/file/schema/flow when available
- Evidence found or evidence missing
- What consistency control is missing or weak
- What can go wrong
- Robust solution
- Fast mitigation when appropriate
- Architecture decision needed when applicable
- Implementation path: exact script, package, file, CI job, generated artifact, test, doc, or workflow to add/update
- Validation steps

After findings, include a **Recommended Consistency Enforcement Plan** ordered by risk and dependency. The plan must be concrete enough for an agent to implement without guessing, naming files, scripts, codegen commands, packages, hooks, tests, snapshots, CI jobs, and docs when available.

When the user asked for fixes, implement the plan in the repository and then summarize changed files and remaining items requiring architecture decisions, consumer coordination, or release approval.

If no serious gaps are found, say that clearly and list residual drift risks, assumptions, external consumers not verified, or tests not run.

## Approval Bar

Do not mark a Solana full-stack project consistency-safe while any of these remain unresolved:

- No central IDL/schema source of truth exists.
- Rust account/instruction/error/event definitions can drift from IDL.
- Generated client is stale or not generated from the current IDL.
- Frontend/backend/indexer code duplicates account or instruction types manually.
- PDA seeds, signer/writable flags, or account layouts differ across layers.
- CI does not run drift detection for critical layers.
- Breaking IDL changes lack versioning, changelog, migration plan, or compatibility tests.
- Docs/examples are stale enough to mislead users or integrators.
- A finding recommends consistency checks without concrete implementation and validation steps.

If approval is blocked, give the shortest robust path to establish a source of truth, regenerate consumers, and fail CI on drift.

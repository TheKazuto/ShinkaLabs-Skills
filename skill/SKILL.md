---
name: shinka-labs-audit-pack
description: Unified audit skill hub for AI agents reviewing codebases, websites, backends, frontends, legal readiness, SEO, and Solana programs. Use for security audits, robustness reviews, performance analysis, dead code detection, legal/compliance checks, SEO/GEO audits, Go, Rust, TypeScript backend/frontend, Solana Anchor/Quasar/Pinocchio, CPI safety, invariants, program upgrades, red-team simulations, and full-stack Solana consistency. Routes to focused audit modules with progressive disclosure.
---

# Shinka Labs Audit Pack

Use this skill as the entry point for Shinka Labs audit workflows. It routes the agent to focused modules while keeping context usage efficient.

Skill metadata:

- Version: 1.0.0
- License: MIT

Core rule: load only the focused module needed for the user's request. If the task spans multiple domains, load the smallest set of relevant modules and state which modules are being used.

## Global Audit Standard

For every audit:

1. Inspect the actual repository, files, routes, contracts, docs, tests, configs, and scripts before concluding.
2. Prefer evidence over assumptions.
3. Report each meaningful issue with severity, confidence, affected file/flow, evidence, impact, robust solution, implementation path, and validation steps.
4. Recommend the most robust practical solution, not only a warning.
5. Identify dead code and recommend cleanup when auditing code.
6. When the user asks for fixes, implement the required changes directly when feasible.
7. Do not mark a project ready while critical safety, security, correctness, legal, SEO, or deployment blockers remain.

Use this output shape unless the focused module gives a more specific one:

- Executive snapshot
- Scope reviewed
- Findings ordered by risk
- Robust fix plan
- Validation steps
- Remaining assumptions or data needed

## Module Routing

Read exactly one or more of these files based on the request.

### General Code and Product Audits

- Go backend audit: read [audits/go-audit-optimizer.md](audits/go-audit-optimizer.md)
- Rust backend audit: read [audits/rust-backend-audit-optimizer.md](audits/rust-backend-audit-optimizer.md)
- TypeScript/Node.js backend audit: read [audits/typescript-backend-audit-optimizer.md](audits/typescript-backend-audit-optimizer.md)
- TypeScript frontend audit: read [audits/typescript-frontend-audit-optimizer.md](audits/typescript-frontend-audit-optimizer.md)
- Legal, privacy, compliance, policies, cookies, consumer, or accessibility legal-readiness audit: read [audits/legal-audit-optimizer.md](audits/legal-audit-optimizer.md)
- SEO, technical SEO, GEO, AI visibility, structured data, sitemap, robots, metadata, or organic discoverability audit: read [audits/seo-audit-optimizer.md](audits/seo-audit-optimizer.md)

### Solana Program Audits

- Solana Anchor program audit: read [solana/solana-anchor-audit-optimizer.md](solana/solana-anchor-audit-optimizer.md)
- Solana Quasar program audit: read [solana/solana-quasar-audit-optimizer.md](solana/solana-quasar-audit-optimizer.md)
- Solana Pinocchio or native low-level program audit: read [solana/solana-pinocchio-audit-optimizer.md](solana/solana-pinocchio-audit-optimizer.md)
- Solana CPI, composability, `remaining_accounts`, account metas, PDA signing, external integrations, or Token-2022 CPI risk: read [solana/solana-cpi-safety-guardian.md](solana/solana-cpi-safety-guardian.md)
- Solana business invariants, assertions, property-based tests, fuzzing, Trident, or invariant monitoring: read [solana/solana-invariant-guardian.md](solana/solana-invariant-guardian.md)
- Solana program upgrade, migration, account versioning, realloc, backward compatibility, upgrade authority, deploy order, or rollback plan: read [solana/solana-program-upgrade-orchestrator.md](solana/solana-program-upgrade-orchestrator.md)
- Authorized Solana red-team simulation, adversarial tests, malicious accounts, PDA manipulation, oracle manipulation, economic attacks, fake CPI programs, or CI adversarial suite: read [solana/solana-red-team-simulator.md](solana/solana-red-team-simulator.md)
- Solana full-stack consistency across Rust, IDL, generated clients, TypeScript SDK, frontend hooks, backend/indexer schemas, docs, CI, and versioning: read [solana/full-stack-consistency-enforcer.md](solana/full-stack-consistency-enforcer.md)

## Multi-Module Combinations

Use combined modules when the request clearly spans domains:

- Solana framework audit plus CPI risk: framework module + `solana-cpi-safety-guardian.md`
- Solana framework audit plus invariants/fuzzing: framework module + `solana-invariant-guardian.md`
- Solana upgrade review: framework module + `solana-program-upgrade-orchestrator.md`
- Solana adversarial audit: relevant framework module + `solana-red-team-simulator.md`
- Solana full-stack app: framework module + `full-stack-consistency-enforcer.md` + frontend/backend module if needed
- Product launch/site audit: legal module + SEO module + frontend module if applicable
- Backend API launch: backend language module + legal module if it collects user data

When multiple modules apply, read the framework or language module first, then the specialist module.

## Safety Boundaries

- Red-team simulations must be authorized and limited to owned systems, local validators, testnets, devnets, controlled forks, fixtures, or CI.
- Do not recommend mainnet deployment, irreversible migration, upgrade authority transfer/removal, production exploit execution, or financially risky action without explicit human approval.
- Do not treat legal guidance as formal legal advice. Flag lawyer review where required.
- For external protocols, APIs, legal requirements, or current standards that may have changed, verify with official/current sources when needed.

## Final Response Requirements

The final answer should clearly state:

- Which module(s) were used.
- What was reviewed.
- The highest-risk findings first.
- The robust fix for each confirmed issue.
- What was implemented, if fixes were requested.
- What could not be verified and why.
- Tests, commands, screenshots, or validation performed.

<div align="center">

# Shinka Labs Skills

<img src="assets/review-pipeline-v3.svg" alt="Animated review pipeline showing code audited by ShinkaLabs Skills" width="920" />

Skill pack for AI agents focused on audit, security, performance, robustness, and project quality.
<p>The skills cover both crypto and non-crypto projects.</p>

<p>
  <img src="https://img.shields.io/badge/pack-v1.0.0-2563eb.svg" alt="Pack version" />
  <img src="https://img.shields.io/badge/license-MIT-16a34a.svg" alt="License" />
  <img src="https://img.shields.io/badge/skill-1-7c3aed.svg" alt="Skill" />
  <img src="https://img.shields.io/badge/modules-14-0891b2.svg" alt="Modules" />
  <img src="https://img.shields.io/badge/focus-audit%20%2B%20robustness-f97316.svg" alt="Focus" />
</p>

[GitHub Repository](https://github.com/TheKazuto/ShinkaLabs-Skills)

</div>

---

## What This Pack Provides

These skills help agents review projects more rigorously, with focus on:

- user and fund safety;
- backend, frontend, and smart contract robustness;
- evidence-based performance review;
- dead code identification;
- robust fix recommendations;
- audit reports with evidence, severity, confidence, and a fix plan.

## Structure

This repository is packaged as one progressive skill:

```text
skill/
|-- SKILL.md
|-- audits/
|   |-- go-audit-optimizer.md
|   |-- legal-audit-optimizer.md
|   `-- ...
|-- solana/
|   |-- solana-anchor-audit-optimizer.md
|   |-- solana-cpi-safety-guardian.md
|   `-- ...
`-- agents/
    `-- openai.yaml
```

`skill/SKILL.md` is the entry point. It routes the agent to focused modules only when needed, keeping context usage efficient.

## Included Modules

| Module | Main focus |
|---|---|
| `go-audit-optimizer` | Go/Golang backend audits |
| `rust-backend-audit-optimizer` | Rust backend audits |
| `typescript-backend-audit-optimizer` | TypeScript/Node.js backend audits |
| `typescript-frontend-audit-optimizer` | TypeScript frontend audits |
| `full-stack-consistency-enforcer` | Solana full-stack IDL and schema consistency audits |
| `solana-anchor-audit-optimizer` | Solana Anchor program audits |
| `solana-quasar-audit-optimizer` | Solana Quasar program audits |
| `solana-pinocchio-audit-optimizer` | Solana Pinocchio program audits |
| `solana-cpi-safety-guardian` | Solana composability and CPI safety audits |
| `solana-invariant-guardian` | Solana invariant and property-based testing audits |
| `solana-program-upgrade-orchestrator` | Safe Solana program upgrade orchestration |
| `solana-red-team-simulator` | Authorized Solana adversarial security simulations |
| `legal-audit-optimizer` | Legal, privacy, and compliance audits |
| `seo-audit-optimizer` | SEO, GEO, and search discoverability audits |

### `go-audit-optimizer`

Audits Go/Golang backend projects, APIs, workers, financial systems, queues, databases, and production services. Focuses on security, performance, robustness, concurrency, dead code, and structural quality.

### `rust-backend-audit-optimizer`

Audits Rust backend projects, APIs, workers, Tokio/Axum/Actix services, financial systems, FFI, and `unsafe` code. Focuses on security, async/concurrency, robustness, performance, dead code, and structural quality.

### `typescript-backend-audit-optimizer`

Audits TypeScript/Node.js backends using Express, NestJS, Fastify, Hono, workers, SaaS systems, multi-tenant systems, authentication, databases, and queues. Focuses on security, event-loop safety, dependency risk, performance, dead code, and production readiness.

### `typescript-frontend-audit-optimizer`

Audits TypeScript frontends using React, Next.js, Vue, Angular, Svelte, Vite, SPAs, and dashboards. Focuses on XSS, token handling, runtime validation, accessibility, privacy, performance, build safety, dead code, and structural quality.

### `full-stack-consistency-enforcer`

Audits Solana full-stack projects for consistency between on-chain Rust, IDL/schema, generated clients, TypeScript SDKs, frontend hooks, backend/indexers, tests, docs, CI/CD, and versioning. Focuses on IDL drift detection, Codama/Shank/Anchor/Quasar codegen, `@solana/kit`, PDA seed consistency, generated docs, and release compatibility.

### `solana-anchor-audit-optimizer`

Audits Solana programs built with Anchor. Focuses on constraints, PDAs, CPI, SPL Token/Token-2022, `remaining_accounts`, IDL, account lifecycle, arithmetic, compute units, deploy readiness, and Sealevel risks.

### `solana-quasar-audit-optimizer`

Audits Solana programs built with Quasar. Focuses on account validation, PDAs, CPI, zero-copy, `unsafe`, Token-2022, discriminators, account layout, compute units, dead code, and deploy readiness.

### `solana-pinocchio-audit-optimizer`

Audits Solana programs built with Pinocchio and low-level/native patterns. Focuses on manual account validation, buffer parsing, zero-copy, `unsafe`, p-token, SPL Token/Token-2022, PDAs, CPI, compute units, and differential tests.

### `solana-cpi-safety-guardian`

Audits Solana programs for composability and CPI safety across Anchor, Pinocchio, Quasar, and native SVM projects. Focuses on target program IDs, account confusion, account metas, signer/writable flags, PDA signing, `remaining_accounts`, post-CPI reloads, Token-2022 extensions, external protocol integrations, CPI fuzzing, compute units, and upgrade compatibility.

### `solana-invariant-guardian`

Audits Solana programs by extracting business invariants, enforcing them with assertions, and validating them through property-based tests, fuzzing, adversarial scenarios, and off-chain monitoring. Focuses on value conservation, authorities, PDAs, CPIs, tokens, arithmetic, rent, realloc, clients, and indexers.

### `solana-program-upgrade-orchestrator`

Plans, audits, and orchestrates safe upgrades and migrations for Solana programs across Anchor, Pinocchio, Quasar, and native SVM projects. Focuses on account versioning, backward compatibility, realloc/rent impact, migration instructions, upgrade authority, multisig deployment, rollback planning, client/indexer compatibility, and post-deploy monitoring.

### `solana-red-team-simulator`

Runs authorized defensive red-team simulations for Solana programs across Anchor, Quasar, Pinocchio, and native SVM projects. Focuses on threat modeling, malicious account tests, PDA manipulation, account confusion, arbitrary CPI, upgrade authority abuse, economic attack simulation, oracle manipulation, arithmetic edge cases, Token/Token-2022 abuse, sysvar spoofing, realloc/close/reinit attacks, fuzzing, and CI adversarial test suites.

### `legal-audit-optimizer`

Audits legal and compliance readiness for websites, apps, and digital projects. Helps identify missing terms, policies, notices, consent flows, privacy elements, cookies, LGPD/GDPR/CCPA gaps, accessibility concerns, and other elements that may create legal risk.

### `seo-audit-optimizer`

Audits websites, apps, documentation, landing pages, and product pages for SEO, technical SEO, structured data, content quality, Core Web Vitals, accessibility, GEO/AI visibility, crawlability, indexability, and organic discoverability.

## Installation

The install script copies the single `skill/` folder into your agent's skills directory as `shinka-labs-audit-pack`.

### Codex Installation

1. Clone the repository:

```bash
git clone https://github.com/TheKazuto/ShinkaLabs-Skills.git
```

2. Install the skills.

macOS/Linux/Git Bash:

```bash
cd ShinkaLabs-Skills
chmod +x install.sh
./install.sh --target codex
```

### Claude Installation

macOS/Linux/Git Bash:

```bash
cd ShinkaLabs-Skills
chmod +x install.sh
./install.sh --target claude
```

Windows PowerShell manual install:

```powershell
New-Item -ItemType Directory -Force "$env:USERPROFILE\.claude\skills\shinka-labs-audit-pack"
Copy-Item -Recurse ".\ShinkaLabs-Skills\skill\*" "$env:USERPROFILE\.claude\skills\shinka-labs-audit-pack\" -Force
```

Custom destination:

```bash
./install.sh --dest "$HOME/.agents/skills"
```

Preview without copying files:

```bash
./install.sh --dry-run
```

Windows PowerShell manual install:

```powershell
New-Item -ItemType Directory -Force "$env:USERPROFILE\.codex\skills\shinka-labs-audit-pack"
Copy-Item -Recurse ".\ShinkaLabs-Skills\skill\*" "$env:USERPROFILE\.codex\skills\shinka-labs-audit-pack\" -Force
```

3. Restart the agent or reload skills if your environment requires it.

### Manual Installation

Copy the `skill/` contents into a single skill folder named `shinka-labs-audit-pack`.

Windows PowerShell:

```powershell
New-Item -ItemType Directory -Force "$env:USERPROFILE\.codex\skills\shinka-labs-audit-pack"
Copy-Item -Recurse ".\ShinkaLabs-Skills\skill\*" "$env:USERPROFILE\.codex\skills\shinka-labs-audit-pack\" -Force
```

macOS/Linux:

```bash
./install.sh --target codex
```

### Other Agents

For agents compatible with local skills:

1. Open the agent's skills configuration folder.
2. Copy the desired skill folders.
3. Make sure each skill keeps this structure:

```text
shinka-labs-audit-pack/
|-- SKILL.md
|-- audits/
`-- solana/
```

4. Restart or reload the agent.

## Usage

After installation, skills can activate automatically when the user's request matches the skill description, or manually by name.

Examples:

```text
Use the Shinka Labs Audit Pack to audit this Go backend.
```

```text
Use the Shinka Labs Audit Pack to review this Anchor program.
```

```text
Use the Shinka Labs Audit Pack to detect IDL and client drift.
```

```text
Use the Shinka Labs Audit Pack to audit this program's CPI integrations.
```

```text
Use the Shinka Labs Audit Pack to extract and test this Solana program's invariants.
```

```text
Use the Shinka Labs Audit Pack to plan this Solana program upgrade.
```

```text
Use the Shinka Labs Audit Pack to run an authorized adversarial audit.
```

```text
Use the Shinka Labs Audit Pack to check whether this website has legal risks.
```

```text
Use the Shinka Labs Audit Pack to improve this project's search visibility.
```

## Expected Audit Format

These skills are designed to guide the agent toward delivering:

- executive snapshot;
- reviewed scope;
- list of findings;
- severity and confidence for each finding;
- concrete evidence;
- impact explanation;
- robust recommended solution;
- fast mitigation when useful;
- commands, tests, or validation steps to prove the fix;
- risk-ordered fix plan.

## License

MIT

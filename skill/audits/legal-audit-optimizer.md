# Legal Audit Optimizer

Use this skill to audit project websites, apps, SaaS products, e-commerce flows, marketplaces, dashboards, landing pages, and public documentation for missing legal and compliance elements that could create legal, privacy, consumer, or operational risk.

Skill metadata:

- Version: 1.0.0
- License: MIT

Important: this skill supports legal/compliance readiness, but it does not replace review by a qualified lawyer. When precise legal interpretation, jurisdiction-specific obligations, regulated activity, financial products, health data, minors, employment, tax, securities, crypto custody, or litigation risk is involved, recommend specialist legal review.

Prioritize:

1. User and company legal safety
2. Privacy, data protection, consent, and transparency
3. Consumer protection, commercial clarity, and dispute reduction
4. Clear site/app implementation steps
5. Practical documents, UI elements, and compliance workflows

## Core Prompt

Start from this baseline:

> Perform a strict legal-readiness audit of this project/site.
> Identify missing legal, privacy, cookie, consumer, accessibility, IP, security, and compliance elements that could create risk.
> For every confirmed gap, explain what can go wrong, what project element is missing, and the most robust practical solution to add it.
> Help the user add the required element to the site/app in a clear, implementation-ready way.
> When the user asks for fixes, implement the missing pages, components, links, copy, forms, and policy sections directly in the project instead of only giving advice.
> Do not present the result as formal legal advice. Mark items that require lawyer review.

The audit is complete only after every applicable area has been checked and every finding includes a robust solution, implementation path, and validation step.

## Scope Selection

First identify the project shape:

- Project type: landing page, blog, SaaS, app, API, dashboard, e-commerce, marketplace, community, content platform, crypto/DeFi, AI product, fintech, health, education, or mixed product.
- Target audience: Brazil, EU/EEA, UK, US/California, global, minors, businesses, consumers, or internal users.
- Data collected: account data, contact forms, payment data, analytics, cookies, precise location, sensitive data, children/minor data, user-generated content, wallet/blockchain data, device data, or marketing identifiers.
- Commercial model: free, subscription, paid service, digital product, marketplace, e-commerce, ads, affiliate, token/crypto, or lead generation.
- Existing legal surface: footer links, privacy policy, terms, cookie policy/banner, refund/cancellation policy, accessibility statement, contact/legal email, DPO/contact channel, OpenAPI/docs, checkout pages, app settings, and user-rights forms.

If jurisdiction, audience, data collection, or business model is unclear, inspect the repository/site first. If still unclear, mark assumptions and ask for the minimum missing information.

## Evidence-First Review

Inspect the actual project before concluding that an item exists or is missing. Prefer repository evidence over assumptions.

Check common locations:

- Public pages, routes, layouts, headers, footers, navigation, and app shell.
- `app/`, `pages/`, `src/`, `components/`, `layouts/`, `public/`, `docs/`, `legal/`, `privacy/`, `terms/`, and standalone `index.html`.
- Signup, login, checkout, pricing, billing, onboarding, contact, support, account settings, unsubscribe, and deletion flows.
- Existing Privacy Policy, Terms, Cookie Policy, refund/cancellation pages, accessibility statement, disclaimers, and footer links.
- Analytics, ad pixels, tag managers, session replay, chat widgets, payment providers, auth providers, email tools, CRM/support tools, AI APIs, and hosting/storage providers.
- `package.json`, environment variable examples, config files, script tags, consent/CMP code, API docs, OpenAPI specs, README, GitBook, Postman collections, and deployment docs.

When evidence is partial, report the uncertainty and say exactly what file, page, vendor, or business detail must be verified.

Use a traceable legal audit flow for non-trivial projects:

- Review incrementally by page, route, layout, policy, form, checkout flow, signup/login flow, vendor, tracker, document, or jurisdiction.
- Do not mark an element as compliant or present without citing evidence: file, route, page, component, policy section, script, vendor, screenshot, config, or observed flow.
- If repository size, missing business context, or jurisdiction uncertainty prevents full coverage, state what was reviewed, what was not reviewed, and which legal-risk areas remain.
- Track each meaningful area with one of these statuses:
  - **Verified:** evidence supports the legal element or control.
  - **Issue:** evidence shows a concrete missing element or legal risk.
  - **Partial:** the element exists but is incomplete, unclear, outdated, or not wired into the actual product.
  - **Not applicable:** the area does not apply, with reason.
  - **Needs legal review:** legal interpretation, regulated activity, high-risk clause, or jurisdiction-specific decision requires a qualified lawyer.
- Add a confidence level to important findings when certainty is not absolute: High, Medium, or Low.
- Use lower confidence when jurisdiction, audience, data volume, vendors, contracts, payment model, regulated status, or actual production configuration is not fully known.

## Non-Negotiable Standards

Apply these rules aggressively:

1. **Do not let a public project ship without basic legal identity and policy links.**
   - Footer or legal section should expose company/responsible party name, legal contact, and links to Privacy Policy, Terms, and Cookie Policy when applicable.
   - Policies should include version and last updated date.
   - Legal pages must be easy to find from all public pages.

2. **Do not allow privacy claims without matching data practices.**
   - The policy must match actual forms, analytics, cookies, vendors, auth, payments, marketing tools, logs, support flows, and data retention.
   - Do not invent "we do not collect data" when the project uses analytics, forms, logs, auth, payments, or third-party SDKs.

3. **Do not ignore consent and tracking.**
   - Non-essential cookies, analytics, marketing pixels, session replay, personalization, and cross-site tracking need a consent or opt-out model appropriate to the jurisdiction.
   - Consent must be granular, revocable, recorded when required, and loaded before non-essential trackers when required.

4. **Do not hide consumer or commercial terms.**
   - Pricing, renewals, cancellation, refund, delivery, trial, support, warranty, limitations, and payment terms must be clear before purchase or signup when applicable.
   - E-commerce and consumer products need accessible refund/cancellation policy and support channel.

5. **Do not draft final legal documents as if they were lawyer-approved.**
   - Provide implementation-ready drafts, sections, UI copy, and checklists, but label them as draft/compliance support.
   - Flag high-risk or jurisdiction-specific clauses for lawyer review.

6. **Fix root causes, not symptoms.**
   - If a policy is missing because data practices are unclear, recommend data mapping and vendor inventory first.
   - If cookie consent is broken because trackers load too early, recommend technical blocking before wording changes.
   - If terms are weak because the business model is unclear, clarify the service, user obligations, and commercial flow first.

## Legal Readiness Checklist

### Identity, Transparency, and Access

Check:

- Company/responsible party name is visible.
- CNPJ, EIN, registration number, or equivalent appears when applicable.
- Physical address appears when required or useful for trust/compliance.
- Legal/privacy contact channel exists: email, form, or support flow.
- DPO/Encarregado contact appears when applicable.
- Footer links include Privacy Policy, Terms of Use/Service, Cookie Policy, refund/cancellation policy, and accessibility statement when applicable.
- Policies show version and last updated date.
- Jurisdiction, governing law, venue/forum, and dispute process are stated where appropriate.
- Public claims about compliance, security, privacy, AI, crypto, or guarantees are accurate and not overstated.

### Core Legal Documents

Check whether the project needs:

- Privacy Policy
- Terms of Use or Terms of Service
- Cookie Policy or cookie section inside Privacy Policy
- Legal Notice / Disclaimer
- Refund, cancellation, return, delivery, warranty, and support policies
- Intellectual Property policy
- User-generated content policy
- Acceptable Use policy
- Community rules or moderation policy
- Data Processing Addendum or processor terms for B2B/SaaS
- Vendor/processor contracts with data protection clauses
- Internal privacy, security, access-control, and retention policies

### Privacy and Data Protection

Check:

- Data inventory/data mapping exists for all personal data collected.
- Each processing purpose has a legal basis or documented rationale: consent, contract, legitimate interest, legal obligation, vital interest, public task, or equivalent.
- Data minimization, purpose limitation, transparency, security, prevention, non-discrimination, accountability, and privacy by design/default are considered.
- Sensitive data, children/minor data, biometric data, health data, financial data, and precise location have stricter controls when present.
- Retention periods are clear and deletion/anonymization is defined.
- User-rights channel exists for access, correction, deletion, portability, objection, consent withdrawal, and limitation where applicable.
- Identity verification exists for rights requests.
- Response deadlines are tracked: LGPD often 15 days; GDPR often 1 month; CCPA/CPRA often 45 days.
- DPIA/RIPD is considered for high-risk processing.
- ROPA or records of processing activities exist when required or useful.
- Data breach notification workflow exists for ANPD, EU/UK authorities, users, or other regulators where applicable.

### International Privacy Requirements

Check when applicable:

- LGPD: legal basis, DPO/Encarregado, privacy notice, data subject rights, RIPD for high risk, ANPD notification, processor contracts, international transfer mechanism.
- GDPR/UK GDPR: lawful basis, DPO when required, ROPA, DPIA, 72-hour authority notification, SCCs/adequacy for transfers, full rights notice, automated decision-making disclosures.
- CCPA/CPRA: categories of personal information collected in the last 12 months, right to know/delete/correct/opt out, identity verification, response timeline, and "Do Not Sell or Share My Personal Information" link when applicable.
- Other jurisdictions: PIPEDA, US state privacy laws, APPI, Australian Privacy Act, and local consumer/privacy rules based on target audience.

When exact obligations depend on current law or thresholds, recommend checking official regulator guidance or specialist legal review.

### Cookies, Consent, and Tracking

Check:

- Cookie banner or CMP exists when non-essential cookies/trackers are used.
- Consent is granular: necessary, analytics, marketing, personalization, and similar categories.
- "Reject all" and "Manage preferences" are easy to find when required.
- Non-essential trackers do not load before valid consent when required.
- Consent can be withdrawn as easily as it was given.
- Consent records include timestamp, policy version, category choices, and identifier when required.
- Cookie Policy lists first-party and third-party cookies, duration, provider, and purpose.
- Google Analytics, Meta Pixel, GTM, session replay, ads, affiliate tags, and server-side tracking match consent mode and the privacy policy.

### Consumer, Commercial, and E-Commerce

Check:

- Product/service description, pricing, taxes, fees, renewal, cancellation, trial, refund, delivery, support, warranty, and limitations are clear before purchase.
- Terms avoid abusive or misleading clauses.
- Consumer right of withdrawal/cooling-off is handled when applicable, including Brazil's 7-day e-commerce rule.
- Checkout is secure and clear; payment providers and PCI DSS responsibilities are understood when cards are processed.
- Order confirmation, invoices/receipts, and email notifications include required information when applicable.
- SAC/support channel exists where expected.
- Subscription cancellation is not harder than signup where consumer law or platform rules require parity.

### User Content, IP, and Platform Risk

Check:

- Ownership/licensing of site content, images, videos, fonts, code, icons, and third-party assets is clear.
- Copyright notice appears where useful.
- User-generated content terms define user license, moderation rights, prohibited content, takedown, complaints, and repeat infringer process.
- DMCA or equivalent notice/takedown flow exists when applicable.
- AI-generated content, user prompts, model outputs, training data, and automated decisions are disclosed when relevant.
- Crypto, DeFi, investment, returns, yield, token, or financial claims include clear risk disclaimers and avoid guarantees.

### Accessibility, Security, and Governance

Check:

- Accessibility is considered: WCAG 2.1/2.2 AA, keyboard navigation, contrast, alt text, labels, captions, and accessible forms.
- Security measures are stated accurately: HTTPS, encryption, access control, MFA, backups, patching, WAF, monitoring, and incident response.
- Public security claims do not overpromise.
- Vendor inventory lists providers that receive data: hosting, analytics, email, payment, CRM, support, ads, AI APIs, and storage.
- Data processing agreements exist with processors where needed.
- International transfers are disclosed and supported by a valid mechanism when required.
- Internal responsibilities are clear: controller/operator/processor roles, owner for privacy requests, incident owner, vendor owner, and policy review cadence.
- Policies are reviewed at least annually or whenever data practices, vendors, jurisdictions, business model, or product behavior changes.
- Prior policy versions are archived.

## Implementation Guidance

When the audit finds a missing element, help the user add it to the project/site.

Prefer practical remedies:

- Add footer links to legal pages across all public routes.
- Create or update Privacy Policy, Terms, Cookie Policy, Refund/Cancellation Policy, Accessibility Statement, Legal Notice, or Disclaimer pages.
- Add "last updated" and version metadata to each policy.
- Add legal/privacy contact email or form.
- Add user-rights request flow or form.
- Add cookie banner/CMP and block non-essential trackers before consent.
- Add cookie preference center and consent withdrawal link.
- Update checkout/signup/onboarding copy to disclose price, renewal, cancellation, refund, support, and key restrictions.
- Add risk disclaimers for crypto, DeFi, financial, AI, health, or other high-risk claims.
- Add vendor/data inventory table to privacy documentation.
- Add DPA/processor notice for B2B/SaaS when relevant.
- Add accessibility fixes and an accessibility statement.
- Add docs or code comments that tell maintainers when policies must be updated.

If the user asks for implementation, edit/create the necessary files directly: legal pages, route files, footer/header links, cookie banner/preferences UI, policy sections, forms, checkout/signup disclosures, docs, or config notes.

For visible site/app copy, follow the project's language. For international projects, default public UX/legal page copy to English unless the project clearly targets Brazil or another jurisdiction requiring local-language content.

## What to Flag Aggressively

Escalate:

- No Privacy Policy on a site/app collecting personal data.
- No Terms of Use/Service for a public product, SaaS, app, marketplace, or paid service.
- No cookie consent or tracker control when non-essential trackers are present.
- Trackers loading before consent when consent is required.
- Policies that contradict actual data collection, vendors, analytics, auth, payments, logs, or marketing flows.
- No company/responsible-party identity or legal contact.
- No user-rights request process.
- No refund/cancellation policy for paid consumer/e-commerce flows.
- Subscription or cancellation terms that are unclear or hard to find.
- Crypto, DeFi, financial, AI, health, or investment claims without adequate disclaimer or risk notice.
- "Guaranteed", "risk-free", "fully compliant", "100% secure", or similar overclaims.
- Missing DPO/Encarregado contact when applicable.
- Missing vendor/data processor inventory for projects sharing personal data with third parties.
- No incident/breach response workflow for services processing personal data.
- No international transfer disclosure when data leaves the user's country/region.
- User-generated content without moderation, takedown, IP, or acceptable-use terms.
- Accessibility ignored on public-facing services.
- Public legal pages with no version/date.

## Preferred Remedies

For every confirmed legal gap, provide the most robust practical solution, not only a warning.

Prefer remedies that remove the class of risk:

- Build a data map before drafting or changing Privacy Policy.
- Align policy text with actual code, forms, cookies, analytics, vendors, logs, and payment flows.
- Add project-wide footer/legal navigation instead of isolated page links.
- Add consent gating before tracker initialization instead of only changing banner text.
- Add a user-rights workflow with identity verification, owner, deadline, and response template.
- Add a vendor inventory and DPA checklist instead of vague "third parties may process data" language.
- Add policy versioning and review cadence.
- Add consumer disclosures at checkout/signup, not only in Terms.
- Add jurisdiction-aware policy sections for LGPD, GDPR/UK GDPR, CCPA/CPRA, or other target regions.
- Add high-risk disclaimers near claims, CTAs, onboarding, docs, and dashboards where users make decisions.
- Add accessibility statement plus concrete WCAG fixes.
- Route high-risk clauses, regulated products, minors, sensitive data, securities/crypto, health, employment, tax, or litigation issues to a qualified lawyer.

When multiple remedies exist, distinguish:

- **Robust solution:** preferred production-grade fix.
- **Fast mitigation:** temporary risk reduction when useful.
- **Lawyer review needed:** clauses or decisions that require specialist review.
- **Validation:** files, pages, UI flows, checklists, screenshots, or tests required to prove implementation.

## Output Expectations

Start with a **Legal Readiness Snapshot**:

- Overall legal risk: Critical, High, Medium, or Low
- Publication stance: Block publication, publish after fixes, or no major blocker found
- Scope reviewed: pages/routes/policies/forms/vendors/jurisdictions actually inspected
- Top risks: 3-5 highest-impact gaps or residual concerns
- Lawyer review needed: yes/no, with topics
- Assumptions and jurisdictions not verified

Prioritize findings:

1. Missing privacy, consent, data-rights, sensitive-data, or breach-response elements
2. Missing Terms, legal identity, legal contact, or basic transparency
3. Consumer, payment, cancellation, refund, pricing, or checkout risks
4. Cookie, analytics, marketing, tracking, and vendor risks
5. Cross-border transfer, DPA, processor, and international-law risks
6. Crypto/DeFi, financial, AI, health, minors, user-content, or regulated-risk disclaimers
7. Accessibility, security statement, governance, policy review, and documentation gaps
8. Wording, footer, versioning, discoverability, and UX placement issues

For each finding include:

- Severity: Critical, High, Medium, or Low
- Status: Issue, Partial, Not applicable, or Needs legal review when relevant
- Confidence: High, Medium, or Low
- Affected page/file/flow when available
- Evidence found or evidence missing
- What is missing
- What can go wrong
- Robust solution
- Fast mitigation when appropriate
- Lawyer review needed when applicable
- Implementation path: exact page, component, route, copy block, policy section, or workflow to add/update
- Validation steps

After findings, include a **Recommended Legal Fix Plan** ordered by risk and dependency. The plan must be concrete enough for an agent to implement without guessing, naming visible files, pages, routes, components, policy sections, forms, and checks when available.

When the user asked for fixes, implement the plan in the repository and then summarize changed files and remaining items requiring lawyer or business review.

If no serious gaps are found, say that clearly and list residual legal risks, assumptions, jurisdictions not verified, or documents that still need lawyer review.

## Approval Bar

Do not mark a project/site legally ready while any of these remain unresolved:

- Personal data is collected without a Privacy Policy.
- Public paid product or user account product has no Terms of Use/Service.
- Non-essential trackers load without required consent/opt-out model.
- Policy text materially contradicts actual data practices.
- No legal/privacy contact exists.
- No user-rights channel exists where privacy laws apply.
- Consumer purchase flow lacks clear price, renewal, cancellation, refund, or support terms.
- High-risk crypto, financial, AI, health, minors, or regulated claims lack disclaimer and lawyer review.
- Data is shared internationally or with processors without disclosure and review.
- Sensitive data or high-risk processing lacks documented controls and impact assessment path.
- International public UX or legal copy is not in English unless the project intentionally targets a local-language jurisdiction.

If approval is blocked, give the shortest robust path to make the project safe enough for legal review.

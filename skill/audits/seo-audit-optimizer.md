# SEO Audit Optimizer

Use this skill to audit project websites, apps, documentation sites, landing pages, blogs, SaaS sites, open-source project pages, and product pages for SEO, technical SEO, content quality, AI visibility, structured data, performance, accessibility, and organic discoverability.

Skill metadata:

- Version: 1.0.0
- License: MIT

Important: prioritize durable SEO fundamentals and genuinely useful content before speculative GEO tactics. For AI visibility, favor clarity, structure, factual accuracy, schema, authority, and crawlable public content rather than hacks that search engines discourage.

Prioritize:

1. Crawlability, indexability, and discoverability
2. Search intent, content usefulness, and unique value
3. Technical SEO, metadata, structured data, and internal linking
4. Core Web Vitals, accessibility, and user experience
5. AI visibility, citation readiness, and entity clarity
6. Practical implementation steps and measurable validation

## Core Prompt

Start from this baseline:

> Perform a strict SEO and discoverability audit of this project/site.
> Identify missing or weak technical SEO, metadata, structured data, content, crawlability, performance, accessibility, authority, and AI visibility elements.
> For every confirmed gap, explain what can go wrong, what project element is missing or weak, and the most robust practical solution to add it.
> Help the user improve the site/app in a clear, implementation-ready way.
> When the user asks for fixes, implement the missing pages, metadata, schema, sitemap, robots.txt, content sections, internal links, image attributes, performance fixes, and documentation updates directly in the project instead of only giving advice.

The audit is complete only after every applicable area has been checked and every finding includes a robust solution, implementation path, and validation step.

## Scope Selection

First identify the project shape:

- Site type: landing page, SaaS, app, blog, documentation, portfolio, open-source project, startup/product page, e-commerce, marketplace, local business, community, or mixed site.
- Audience and market: global, local, developers, consumers, businesses, crypto/Web3, AI, fintech, education, health, or another niche.
- Core pages: home, features, pricing, docs, blog, changelog, about, team, case studies, integrations, comparison pages, contact, legal pages, and support.
- Content surface: static pages, SSR/SSG pages, dynamic routes, client-only pages, markdown/docs, CMS content, images, videos, code examples, API docs, and downloads.
- Search goals: brand discovery, product category rankings, documentation visibility, AI citations, comparisons, lead generation, signups, downloads, or sales.
- Current SEO surface: title tags, meta descriptions, headings, canonical tags, sitemap, robots.txt, schema, internal links, analytics, Search Console, Web Vitals, backlinks, and content clusters.

If target audience, search goals, production domain, or business positioning is unclear, inspect the repository/site first. If still unclear, mark assumptions and ask for the minimum missing information.

## Evidence-First Review

Inspect the actual project before concluding that an SEO element exists or is missing. Prefer repository evidence over assumptions.

Check common locations:

- Public pages, routes, layouts, headers, footers, navigation, app shell, and route metadata.
- `app/`, `pages/`, `src/`, `components/`, `layouts/`, `content/`, `docs/`, `public/`, `posts/`, `blog/`, `metadata`, and standalone `index.html`.
- `robots.txt`, `sitemap.xml`, `manifest.json`, `llms.txt`, Open Graph images, favicon assets, images, video files, and static exports.
- Framework metadata APIs: Next.js Metadata API, React Helmet, Vue/Nuxt head config, SvelteKit load/head, Astro frontmatter, Vite static HTML, or CMS SEO fields.
- `package.json`, build config, deployment config, analytics/tag manager setup, image optimization config, redirects, rewrites, i18n config, and CDN/cache settings.
- Existing Google Search Console, Bing Webmaster Tools, GA4, PageSpeed/Lighthouse outputs, crawl reports, sitemap submissions, ranking reports, or analytics docs when available.

When evidence is partial, report the uncertainty and say exactly what file, page, tool, production URL, keyword set, or business detail must be verified.

Use a traceable SEO audit flow for non-trivial projects:

- Review incrementally by page, route, layout, content cluster, metadata source, crawl surface, schema type, template, performance bottleneck, or search intent.
- Do not mark an element as healthy without citing evidence: file, route, page, meta tag, heading, schema block, sitemap entry, robots rule, image, Lighthouse result, crawl output, or observed SERP/search behavior.
- If repository size, missing production URL, missing search data, or market uncertainty prevents full coverage, state what was reviewed, what was not reviewed, and which SEO-risk areas remain.
- Track each meaningful area with one of these statuses:
  - **Verified:** evidence supports the SEO element or control.
  - **Issue:** evidence shows a concrete missing element or SEO risk.
  - **Partial:** the element exists but is incomplete, inconsistent, outdated, weak, or not wired into the actual site.
  - **Not applicable:** the area does not apply, with reason.
  - **Needs market data:** keyword, competitor, analytics, ranking, or search-volume context is required.
- Add a confidence level to important findings when certainty is not absolute: High, Medium, or Low.
- Use lower confidence when production URL, indexing state, analytics, search intent, competitors, CMS content, server rendering, or crawler behavior is not fully known.

## Non-Negotiable Standards

Apply these rules aggressively:

1. **Important public content must be crawlable and indexable.**
   - Core pages should not be hidden behind login, blocked by `robots.txt`, excluded by `noindex`, canonicalized incorrectly, or rendered only in client-side JavaScript when SSR/SSG is expected.
   - Sitemap, canonical URLs, redirects, and status codes must point crawlers to the right pages.

2. **Every indexable page needs clear metadata and page intent.**
   - Title, meta description, canonical URL, H1, heading hierarchy, Open Graph/Twitter metadata, and meaningful page copy should match the page's search intent.
   - Avoid duplicate, missing, misleading, or over-optimized metadata.

3. **Content must be useful, specific, and entity-clear.**
   - Do not recommend keyword stuffing, thin pages, generic AI-generated filler, hidden text, doorway pages, or content created only for search engines.
   - Prefer original explanations, examples, use cases, benchmarks, comparisons, docs, FAQs, and source-backed facts.

4. **Structured data must match visible content.**
   - JSON-LD should be valid, relevant, and consistent with the visible page.
   - Do not add fake ratings, fake reviews, unsupported claims, or schema types that misrepresent the page.

5. **Performance and accessibility are SEO quality signals.**
   - Core Web Vitals, mobile UX, semantic HTML, alt text, accessible navigation, and clean page structure matter for users and crawlers.
   - Do not trade accessibility or truthful content for visual tricks.

6. **AI visibility depends on factual clarity and authority.**
   - Optimize for clear answers, entity consistency, citations, FAQs, docs, comparisons, and structured content that AI systems can understand.
   - Treat `llms.txt` as optional/supporting; it should not replace sitemap, schema, clear navigation, or high-quality content.

7. **Fix root causes, not symptoms.**
   - If metadata is weak because pages have unclear positioning, improve page purpose and content first.
   - If crawlability is broken by client-only rendering or bad redirects, fix the rendering/routing layer before adding more keywords.
   - If GEO visibility is weak because facts and authority are missing, add verifiable source-backed content, not artificial chunking.

## SEO Readiness Checklist

### Setup, Indexing, and Crawlability

Check:

- Google Search Console is configured and sitemap is submitted.
- Bing Webmaster Tools is configured when search visibility matters.
- XML sitemap exists, is valid, updated, and includes canonical public pages.
- `robots.txt` allows important crawlers and does not block core assets or pages.
- Important pages return correct status codes: 200, intentional 301/308, useful 404, no accidental 500/soft 404.
- Canonical tags are correct and self-referential where appropriate.
- Duplicate pages, query-parameter duplicates, trailing slash variants, www/non-www, http/https, and locale variants are handled.
- Public content is server-rendered, statically generated, or otherwise visible to crawlers.
- No important page is accidentally `noindex`, blocked, orphaned, or hidden behind login/paywall when public discovery is intended.

### Keyword, Intent, and Content Strategy

Check:

- Core keywords and search intents are mapped to important pages.
- Conversational queries and "how to", "best alternative", "pricing", "comparison", "integration", and "getting started" queries are considered.
- Topic clusters exist for the project category, features, docs, use cases, and alternatives.
- Each important page has one clear primary intent and avoids cannibalizing another page.
- Content inventory identifies thin content, duplicate content, outdated content, orphan pages, and missing high-value pages.
- Competitor pages and SERP patterns are reviewed when market data is available.
- Content includes original value: use cases, examples, demos, benchmarks, metrics, case studies, code snippets, or project-specific facts.

### On-Page SEO

Check:

- Title tags are unique, descriptive, and close to recommended length without being formulaic.
- Meta descriptions are unique, useful, and aligned with search intent.
- One clear H1 exists per page.
- H2/H3 hierarchy is logical and scannable.
- URLs are short, stable, readable, and avoid unnecessary parameters.
- Internal links connect pillar pages, clusters, docs, comparisons, and conversion pages.
- External links point to authoritative primary sources when useful.
- Images have descriptive alt text, dimensions, optimized formats, and lazy loading where appropriate.
- Videos have titles, captions/transcripts, thumbnails, and VideoObject schema when relevant.

### Technical SEO and Performance

Check:

- HTTPS is enforced across the site.
- Mobile layout is usable and responsive.
- Core Web Vitals are reviewed: LCP, INP, and CLS.
- Images, fonts, scripts, CSS, and third-party tags are optimized.
- CDN, caching, compression, preconnect/preload, and static generation are used where appropriate.
- JavaScript bundles do not delay content rendering unnecessarily.
- Redirect chains are minimized.
- Broken links, missing assets, mixed content, console errors, and hydration errors are reviewed.
- HTML is semantic and includes landmarks, labels, lists, tables, and headings where appropriate.

### Structured Data and Entity Signals

Check:

- Organization schema includes name, logo, URL, contact, and `sameAs` profiles when applicable.
- WebSite and WebPage schema are present where useful.
- BreadcrumbList schema matches visible navigation.
- Article/BlogPosting schema exists for articles and blog posts.
- FAQPage schema is used only for visible FAQ content.
- HowTo schema is used only for actual step-by-step tutorials.
- SoftwareApplication/WebApplication schema is considered for software/project sites.
- Person schema is used for authors/creators when credentials matter.
- JSON-LD validates in Rich Results Test and Schema Markup Validator.
- Entity naming is consistent across metadata, schema, headings, docs, social profiles, and external listings.

### GEO and AI Visibility

Check:

- Key pages provide a direct, concise answer near the top for major queries.
- Pages include Q&A blocks, FAQs, comparison tables, bullets, concise definitions, and clear summaries where useful.
- Content states what the project is, who it is for, what problem it solves, how it works, and how it differs from alternatives.
- Facts include dates, versions, numbers, benchmarks, limitations, and source links when relevant.
- Docs and getting-started pages are crawlable, complete, and easy to quote.
- `llms.txt` exists only when useful and points to high-quality public pages/docs; it is kept consistent with sitemap and navigation.
- Brand/entity profiles are consistent across GitHub, Product Hunt, Crunchbase, social profiles, package registries, docs, and directories.
- Claims are specific, supported, and not exaggerated.

### Authority, Trust, and Off-Page Signals

Check:

- About, team, author, or project pages establish credibility and ownership.
- GitHub, docs, changelog, roadmap, license, contribution guide, and release notes are visible for projects where they matter.
- Reviews, testimonials, ratings, case studies, or usage metrics are authentic when used.
- Backlink and mention strategy targets relevant authoritative sources, directories, awesome lists, partner pages, podcasts, blogs, forums, and communities.
- Brand mentions are monitored and inconsistent descriptions are corrected.
- Content assets are linkable: guides, tools, benchmarks, datasets, templates, comparisons, or research.

### UX, Accessibility, and Conversion

Check:

- Navigation is clear and important pages are reachable.
- CTAs are clear and match user intent.
- Forms are accessible, labeled, and not blocking crawlers from important content.
- Search, docs navigation, breadcrumbs, and table of contents work when applicable.
- Accessibility basics are covered: contrast, keyboard navigation, alt text, labels, focus states, captions, and semantic structure.
- Dark mode/theme choices do not harm contrast or readability.
- Demos, playgrounds, code examples, and docs are easy to use and crawl.

### Monitoring and Maintenance

Check:

- Search Console and analytics are used to monitor impressions, clicks, indexing, queries, and page performance.
- Rankings, AI citations, backlinks, and brand mentions are monitored when important.
- Core Web Vitals are monitored continuously or at release time.
- Content update cadence exists for important pages.
- Quarterly or release-based SEO audits are planned.
- Sitemap, schema, metadata, docs, changelog, and `llms.txt` are updated when product positioning changes.

## Implementation Guidance

When the audit finds a missing element, help the user add it to the project/site.

Prefer practical remedies:

- Add or fix page titles, meta descriptions, canonicals, Open Graph, Twitter cards, and H1/H2 hierarchy.
- Add or update `robots.txt`, `sitemap.xml`, `llms.txt`, redirects, canonical rules, and indexing directives.
- Add JSON-LD schema for Organization, WebSite, WebPage, BreadcrumbList, Article, FAQPage, HowTo, SoftwareApplication, WebApplication, or Person when appropriate.
- Add direct-answer sections, FAQs, comparison tables, use cases, getting-started content, docs pages, changelog links, and unique project facts.
- Improve internal linking between home, features, docs, blog, pricing, alternatives, use cases, and conversion pages.
- Add image alt text, dimensions, compression, lazy loading, and modern formats.
- Improve Core Web Vitals by reducing JS, optimizing images/fonts, improving caching, and removing layout shifts.
- Add accessibility fixes that also improve semantic clarity for crawlers.
- Add analytics/Search Console/Bing setup notes when repo implementation is not possible.
- Add monitoring checklist, content update cadence, and SEO validation commands/docs.

If the user asks for implementation, edit/create the necessary files directly: metadata config, route files, layout components, SEO components, schema components, sitemap/robots files, content pages, docs, FAQ sections, image attributes, redirects, or performance fixes.

For visible site/app copy, default to English unless the project clearly targets a local-language audience.

## What to Flag Aggressively

Escalate:

- Important public pages blocked by `robots.txt`, `noindex`, login, broken redirects, or client-only rendering.
- Missing or duplicate title tags, meta descriptions, H1s, canonicals, or sitemap entries on important pages.
- Wrong canonical tags or redirect rules that deindex useful pages.
- Thin, generic, duplicate, outdated, or keyword-stuffed content.
- Structured data that is invalid, misleading, fake, or inconsistent with visible content.
- Missing Organization/WebSite/WebPage/Breadcrumb schema on sites where entity clarity matters.
- Important images with missing alt text or performance-heavy assets.
- Poor Core Web Vitals or mobile UX on important landing/conversion pages.
- No internal linking path to important pages.
- No Search Console/Bing visibility setup for a public project.
- No clear explanation of what the project is, who it is for, and why it is different.
- No docs/getting-started page for developer tools or open-source projects.
- Unsupported claims, fake reviews, fake ratings, or inflated authority signals.
- AI/GEO tactics that conflict with useful content, crawlability, or official search guidance.
- `llms.txt` used as a substitute for real content, sitemap, schema, or navigation.

## Preferred Remedies

For every confirmed SEO gap, provide the most robust practical solution, not only a warning.

Prefer remedies that remove the class of risk:

- Fix crawlability and indexability before content expansion.
- Clarify page intent and positioning before metadata rewrites.
- Add page-level metadata through the framework's canonical metadata system.
- Use generated sitemap/robots logic when routes are dynamic.
- Add schema only where it matches visible content and actual entity data.
- Add content clusters and internal links instead of isolated keyword pages.
- Improve source-backed, project-specific content instead of generic SEO text.
- Add direct answers, FAQs, summaries, examples, comparisons, and getting-started content for AI visibility.
- Use performance fixes backed by measurement: Lighthouse, PageSpeed Insights, Web Vitals, bundle analysis, or profiler output.
- Add monitoring and content maintenance so SEO does not decay after release.

When multiple remedies exist, distinguish:

- **Robust solution:** preferred production-grade fix.
- **Fast mitigation:** temporary improvement when useful.
- **Content/data needed:** keyword, competitor, analytics, product, or market data required.
- **Validation:** files, pages, tools, screenshots, commands, or tests required to prove implementation.

## Output Expectations

Start with an **SEO Readiness Snapshot**:

- Overall SEO risk: Critical, High, Medium, or Low
- Publication stance: Block indexing, publish after fixes, or no major blocker found
- Scope reviewed: pages/routes/metadata/schema/sitemap/robots/content actually inspected
- Top risks: 3-5 highest-impact gaps or residual concerns
- Search data needed: yes/no, with topics
- Assumptions and production URL/indexing state not verified

Prioritize findings:

1. Crawlability, indexability, canonical, sitemap, robots, and rendering blockers
2. Missing metadata, headings, page intent, and on-page SEO
3. Thin content, search intent mismatch, topic gaps, and internal linking
4. Structured data, entity clarity, Open Graph, and social preview issues
5. Core Web Vitals, mobile UX, accessibility, and performance risks
6. GEO/AI visibility, direct answers, FAQs, comparisons, and `llms.txt`
7. Authority, trust, backlinks, mentions, docs, changelog, and project proof
8. Monitoring, analytics, maintenance, and validation gaps

For each finding include:

- Severity: Critical, High, Medium, or Low
- Status: Issue, Partial, Not applicable, or Needs market data when relevant
- Confidence: High, Medium, or Low
- Affected page/file/flow when available
- Evidence found or evidence missing
- What is missing or weak
- What can go wrong
- Robust solution
- Fast mitigation when appropriate
- Content/data needed when applicable
- Implementation path: exact page, component, route, metadata field, schema block, file, or workflow to add/update
- Validation steps

After findings, include a **Recommended SEO Fix Plan** ordered by risk and dependency. The plan must be concrete enough for an agent to implement without guessing, naming visible files, pages, routes, components, metadata fields, schema types, content sections, and checks when available.

When the user asked for fixes, implement the plan in the repository and then summarize changed files and remaining items requiring market, keyword, analytics, or production validation.

If no serious gaps are found, say that clearly and list residual SEO risks, assumptions, search data not available, or tests not run.

## Approval Bar

Do not mark a project/site SEO-ready while any of these remain unresolved:

- Important public content is blocked from crawling or indexing.
- Important pages lack title, description, canonical, H1, or meaningful content.
- Sitemap, robots, redirects, or canonical rules point crawlers to the wrong pages.
- Public project positioning is unclear or unsupported by page content.
- Important content is not available to crawlers due to client-only rendering.
- Structured data is invalid, misleading, or inconsistent with visible content.
- Core Web Vitals or mobile UX are poor on critical pages without a remediation plan.
- Important images lack alt text or create avoidable performance issues.
- AI/GEO recommendations would weaken useful content, accessibility, crawlability, or factual accuracy.
- `llms.txt` or schema is proposed as a substitute for real public content and navigation.
- SEO fixes are recommended without implementation path or validation steps.

If approval is blocked, give the shortest robust path to make the project safe enough for indexing and SEO review.

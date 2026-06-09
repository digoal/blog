---
name: product-multi-role-analysis
description: Analyze a product from documentation, websites, PDFs, articles, release notes, pricing pages, app listings, reviews, filings, or related links; save separate intermediate analyses from seven roles (user, investor, product manager, market operator, brand operator, competitor, partner), then synthesize a sourced illustrated Markdown report. Use when the user asks for product analysis, product teardown, multi-role evaluation, investment/product/marketing/brand/competitive/partnership perspectives, or a report with assumptions, boundaries, verification signals, and scenario updates.
---

# Product Multi-Role Analysis

## Overview

Create a source-backed product analysis from user-provided documents, files, or links. Produce seven role-specific intermediate Markdown files, then integrate them into one clear final report with diagrams and explicit assumptions.

## Workflow

1. Confirm the product, inputs, intended audience, and output language from the user request. If unspecified, write Chinese Markdown for non-expert readers.
2. Create a run folder under the current project, preferably `markdown/product-analysis/<product-slug>-<YYYYMMDD>/`.
3. Run `scripts/create_analysis_workspace.py` to create subfolders and role templates.
4. Collect evidence from provided docs or links first. Browse current public sources when claims, pricing, market data, leadership, users, regulations, or competitors may have changed.
5. Save normalized source notes to `sources/source-notes.md`, including URL/file, access date, publisher, key facts, and reliability notes.
6. Complete the seven role files in `roles/` before writing the synthesis:
   - `01-user.md`
   - `02-investor.md`
   - `03-product-manager.md`
   - `04-market-operator.md`
   - `05-brand-operator.md`
   - `06-competitor.md`
   - `07-partner.md`
7. Create visual assets. If using SVG, save each SVG as a separate `.svg` file under `assets/` and reference it from Markdown; do not inline SVG in the Markdown.
8. Write the final integrated report as `final-report.md`.
9. Verify that every strong conclusion is supported by at least one cited source or is clearly labeled as inference.

## Workspace Script

Use the helper script to avoid missing required files:

```bash
python3 /path/to/product-multi-role-analysis/scripts/create_analysis_workspace.py "Product Name" --base markdown/product-analysis
```

The script prints the created run directory. It creates `roles/`, `sources/`, and `assets/` plus templates for all required role analyses.

## Evidence Rules

- Prefer primary sources: official docs, pricing pages, changelogs, product pages, filings, investor presentations, app store listings, repository docs, customer case studies, and official blogs.
- Use reputable secondary sources for market size, adoption, benchmarks, historical cases, regulatory context, and competitor comparison.
- Include dates for time-sensitive facts such as pricing, user counts, funding, market share, product availability, and regulations.
- Distinguish facts, source-backed interpretation, and your own inference.
- Do not use unsourced numbers in conclusions. If a useful number cannot be verified, state that it is unverified and avoid making it load-bearing.

## Seven Role Analyses

For each role file, answer the common questions and then the role-specific questions.

Common questions:

- What does this product do, for whom, and in what use scenario?
- What is the strongest evidence for real demand or real usage?
- What is the main value exchange: what users/customers give up and what they get?
- What are the product's constraints, risks, switching costs, and failure modes?
- Which conclusions are facts, and which are inferences?

Role-specific focus:

- User: jobs-to-be-done, pain severity, activation path, learning cost, retention triggers, trust blockers, willingness to pay, substitutes.
- Investor: market size, growth drivers, monetization quality, unit economics signals, defensibility, regulatory risk, capital intensity, exit paths.
- Product manager: positioning, target segment, core workflow, feature gaps, roadmap options, success metrics, onboarding, pricing-product fit.
- Market operator: acquisition channels, funnel, content themes, conversion hooks, community/referral loops, channel risks, low-cost growth experiments.
- Brand operator: category narrative, brand promise, proof points, tone, trust assets, perception risks, memorable assets, differentiation language.
- Competitor: where this product is vulnerable, how incumbents or substitutes can respond, moat gaps, wedge attack, pricing attack, bundling attack.
- Partner: integration value, channel fit, co-selling logic, ecosystem incentives, partner risks, API/data/process requirements, partnership priority.

## Final Report Structure

Use this structure unless the user asks for a different format:

1. Title and one-sentence conclusion.
2. Executive summary: 3 to 5 bullets with clear judgment.
3. Product explanation for beginners: what it is, who uses it, why it matters.
4. Evidence base: source map and credibility notes.
5. Seven-role synthesis: compare where the roles agree and disagree.
6. Product mechanics: user workflow, value chain, business model, growth loop, competitive map.
7. Clear conclusion: opportunity level, biggest risk, most important next action.
8. Boundaries and assumptions: where the conclusion applies, where it does not.
9. Prove/disprove plan: observable signals that would validate or falsify each assumption.
10. Scenario updates: how the conclusion changes if each key assumption changes.
11. Appendix: role-file links, source list, and asset list.

## Visual Requirements

Include at least two visuals when evidence allows:

- A value-chain or product workflow diagram.
- A role-consensus table, competitive map, growth loop, or assumptions-testing matrix.

Use Mermaid for flowcharts and matrices when it is sufficient. Use ASCII tables for compact comparison. Use SVG only when a custom visual materially improves clarity; save SVG files under `assets/` and reference them like:

```markdown
![Product workflow](assets/product-workflow.svg)
```

## Assumptions and Scenario Logic

Every final report must include a table with:

- Key assumption.
- Why it matters.
- Current evidence.
- Signals to watch.
- What would prove it.
- What would disprove it.
- How the conclusion changes if false.

Keep assumptions testable. Prefer observable signals such as retention, conversion, renewal, attach rate, gross margin trend, partner adoption, integration volume, regulatory actions, developer activity, customer references, review sentiment, pricing changes, search interest, and competitor launches.

## Output Quality Bar

- Make the conclusion explicit; avoid "it depends" unless followed by exact conditions.
- Explain causal chains in plain language so a beginner can follow them.
- Use historical data or authoritative cases to support conclusions where possible.
- Cite sources near the claims they support.
- Keep intermediate role files useful on their own, not merely outlines.
- Keep final synthesis integrated; do not paste seven role analyses back-to-back.

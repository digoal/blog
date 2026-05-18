---
name: industry-chain-investment-analysis
description: Analyze an industry or sector from a senior investment-banking perspective for ordinary investors by mapping the industry chain, identifying representative listed companies at each node, and writing a source-backed Markdown report. Use when the user provides an industry/sector/产业 name and asks for 产业链分析, 行业上市公司梳理, 投资银行视角分析, 商业模式/上下游/核心竞争力/护城河/竞争格局/风险揭露, or a visual Markdown investment reference saved under the current project's markdown directory.
---

# Industry Chain Investment Analysis

## Objective

Produce a Chinese Markdown report for ordinary investors that explains an industry through its value chain, representative listed companies, business models, competitive positions, moats, risks, and investment-relevant tradeoffs. Act as a senior investment banker: evidence-driven, structurally skeptical, and clear about uncertainty.

## Required Reference

Read `references/report-framework.md` before writing the report. Use it for the report structure, company screening logic, analysis checklist, visuals, and risk language.

## Workflow

1. Clarify scope only when necessary.
   - If the industry name is broad, pick a practical public-market scope and state the assumption.
   - If geography is unspecified, cover globally and highlight China/Hong Kong/US-listed names when evidence supports them.

2. Gather current evidence.
   - Browse current authoritative sources for industry structure, market size, regulation, listed-company filings, exchange pages, annual reports, investor presentations, and reputable market data.
   - Prefer primary sources for company facts: annual reports, 10-K/20-F, prospectuses, official investor relations pages, exchange filings, and regulator filings.
   - Use third-party research only to triangulate industry structure, market share, and competitive dynamics.

3. Map the industry chain.
   - Split the industry into upstream, midstream, downstream, infrastructure/enablers, channels, and service/ecosystem nodes as applicable.
   - For each node, describe value creation, pricing power, cyclicality, capital intensity, and key bottlenecks.

4. Select representative listed companies.
   - Include companies only when they are materially exposed to the node.
   - Give stock ticker, listing venue, main business exposure, and why the company is representative.
   - Balance market leaders, specialized pure plays, and strategically important challengers. Do not force every node to have many companies if public-market coverage is thin.

5. Analyze companies.
   - Cover business model, upstream/downstream relationships, revenue drivers, cost structure, core assets, competitive advantages, moat durability, competition, financial quality signals, and risk disclosures.
   - Explain what ordinary investors can observe over time: metrics, filings, pricing indicators, capacity changes, order backlog, inventory, regulation, customer concentration, or commodity inputs.

6. Write the Markdown file.
   - Save under the current project's `markdown/` directory. Create the directory if missing.
   - Use a descriptive Chinese filename, for example `markdown/半导体产业链投行视角分析.md`.
   - Include source links in Markdown. Avoid unsourced precise numbers.
   - Add diagrams with Mermaid, SVG, or ASCII text when they improve understanding.

## Output Standards

- Write in Chinese unless the user asks otherwise.
- Separate facts, interpretation, and investment implications.
- Use plain language for ordinary investors, but keep the analytical standard professional.
- Include a non-advice disclaimer: the report is for research and education, not personalized investment advice.
- State data cut-off date using the current date.
- If evidence is insufficient, say what is missing and write a narrower report instead of inventing coverage.

## Visual Requirements

Include at least three useful visuals:

- A Mermaid industry-chain map.
- A comparison table of representative listed companies by node.
- One additional visual chosen for the topic: profit-pool map, value-chain bottleneck diagram, competitive landscape matrix, risk heatmap, or KPI dashboard.

Use inline SVG only when a compact custom visual is clearer than Mermaid or tables.

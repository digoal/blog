---
name: write-mrd
description: Generate a market requirements document (MRD) from a product idea and save it as Markdown under the current project's markdown/ directory. Use when the user asks to write, draft, create, produce, or refine an MRD, market requirements document, product opportunity document, market demand analysis, product idea validation document, or asks for "写 MRD", "市场需求文档", "产品立项文档", "产品机会分析", especially when input is only an idea and the output should be structured, visual, and decision-oriented.
---

# Write MRD

## Purpose

Turn a product idea into a decision-ready MRD. The MRD must prove why the opportunity is worth pursuing before drifting into PRD-level feature details.

Default output: a Markdown file saved to the current project's `markdown/` directory. Create the directory if missing.

## Inputs

Accept any of these:
- A one-line product idea.
- A product concept plus target users, market, competitors, or business model.
- A rough draft MRD to rewrite.
- A request to generate a lightweight MRD, full MRD, or opportunity analysis.

If the idea is understandable but incomplete, proceed and mark missing facts as **Assumptions** or **To Validate**. Ask a question only when the product idea, target user, and use scenario are all too ambiguous to infer.

## Required Workflow

1. **Normalize the idea**
   - Extract product name or working title, target customer, user scenario, pain point, existing alternatives, proposed value, business goal, and unknowns.
   - If the user gives no title, create a concise Chinese or English title from the idea.

2. **Choose MRD depth**
   - Use a **lightweight MRD** for small features, early exploration, or vague ideas.
   - Use a **full MRD** for new products, new markets, major capabilities, monetization changes, or user requests for complete/正式 MRD.
   - In both cases, keep MRD distinct from PRD: MRD explains **why worth doing**, PRD explains **how exactly to build**.

3. **Build the MRD argument**
   - Follow `references/mrd-playbook.md` for the writing logic.
   - Use `assets/mrd-template.md` as the output skeleton when useful.
   - Do not mechanically fill every field if evidence is weak; label assumptions and validation needs clearly.

4. **Add useful visuals**
   - Include at least one diagram in every MRD.
   - Prefer Mermaid for opportunity flow, user journey, stakeholder map, decision tree, or metric logic.
   - ASCII text is acceptable for compact comparisons or small decision paths.
   - If SVG is best, save it as a separate `.svg` file in the same `markdown/` directory and reference it from the MRD with `![description](filename.svg)`.
   - Diagrams must clarify reasoning, not decorate the article.

5. **Save files**
   - File naming:
     - Chinese: `markdown/<产品或主题>-MRD-<YYYYMMDD>.md`
     - English: `markdown/<product-or-topic>-mrd-<YYYYMMDD>.md`
   - Use kebab-case or compact Chinese names; avoid spaces.
   - If generating SVG, name it `markdown/<same-prefix>-figure-1.svg`, `figure-2.svg`, etc.
   - Include source links when web/current facts are used.

6. **Self-check before final response**
   - The MRD answers: target customer, scenario pain, existing alternatives, market opportunity, differentiation, high-level capabilities, success metrics, risks, and falsification conditions.
   - It does not over-specify UI, APIs, database schemas, or detailed implementation unless the user explicitly asks.
   - It contains at least one visual.
   - It names assumptions and unknowns instead of pretending uncertain facts are known.
   - It ends with a concrete validation/watchlist section.
   - The Markdown file exists in `markdown/`; any SVG references point to existing files.

## MRD Writing Rules

- Start from the market problem, not the feature list.
- Treat MRD as a "market bet memo": it should help the organization decide whether to invest.
- Use concrete user scenarios: "who is blocked, when, by what, and what they do now."
- Write high-level capabilities, not button-level implementation.
- Include "not doing now" to prevent scope creep.
- Use measurable signals: adoption, retention, conversion, task success, paid intent, sales cycle, support load, or cost saved.
- Include falsification: what evidence would make the team stop, narrow, or rethink the idea.

## Optional Web Research

For current market size, regulations, competitor claims, pricing, recent product launches, or funding/news, browse and cite reliable sources. If browsing is unavailable or unnecessary, write "market data pending verification" rather than inventing numbers.

## Final Response

Keep the final reply short:
- Link to the generated MRD file.
- Link to generated SVG files if any.
- Mention whether assumptions were made or web research was used.

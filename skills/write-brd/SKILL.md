---
name: write-brd
description: "Write a practical Business Requirements Document (BRD) from a product idea, feature concept, customer request, business problem, or rough product opportunity. Use when the user asks to write, draft, generate, refine, or save a BRD/business requirements document/product business case in Markdown, especially when the output should be saved under the current project's markdown directory and include diagrams using Mermaid, SVG, or ASCII."
---

# Write BRD

## Purpose

Turn a rough product idea into a decision-ready BRD Markdown file saved in the current project's `markdown/` directory. The BRD should help stakeholders decide whether to invest, what user problem is real, what scope is in or out, and how success will be verified after launch.

This skill writes BRDs, not PRDs. Keep implementation detail high enough for feasibility and handoff, but do not expand into screen-by-screen product specs unless the user asks.

## Default Output

- Save one Markdown file to `markdown/<topic>-BRD-<YYYYMMDD>.md`.
- Use a Chinese topic name when the user writes in Chinese; otherwise use kebab-case English.
- Include at least one useful diagram inside the BRD.
- Use Mermaid by default. Use ASCII for tiny flows. Use SVG only when layout or richer visual explanation is needed.
- If using SVG, save it as a separate file in the same `markdown/` directory, named `figure-1-<topic>-BRD-<YYYYMMDD>.svg`, then reference it from the Markdown with `![描述](figure-1-<topic>-BRD-<YYYYMMDD>.svg)`.

## Workflow

### 1. Clarify the idea just enough

If the user's idea is too thin to write a credible BRD, ask at most 3 questions. Prefer assumptions over long interrogation.

Ask only for missing information that changes the BRD materially:
- Target user or customer
- Business goal or pain point
- Product context or company type
- Constraints such as time, budget, compliance, existing systems

If the user gives no detail beyond an idea, proceed with explicit assumptions and mark low-confidence sections.

### 2. Reframe the idea as a business decision

Before writing sections, convert the idea into this chain:

```text
business loss/opportunity -> target user -> current workaround -> proposed capability -> success metric -> delivery boundary -> stop/continue rule
```

Reject pure feature-first framing. Do not start the BRD from "we need feature X" unless you immediately explain why the business should fund it.

### 3. Build the BRD from three lenses

Use these lenses in every BRD:

1. **Investment lens**: What loss, revenue, cost, risk, or strategic option justifies the work?
2. **User evidence lens**: Who has the problem, in what scenario, what do they do today, and what behavior should change?
3. **Delivery lens**: What is in scope, what is out, what depends on other teams or systems, and how will completion be verified?

### 4. Use the BRD template

Read `assets/brd-template.md` when drafting the document. Adapt headings to the user's context, but keep the core decision logic intact.

For extra guidance on evidence, diagrams, validation, and wording, read `references/brd-writing-guide.md`.

### 5. Add diagrams that explain decisions

Every BRD must include at least one diagram that supports reasoning, not decoration. Good diagram choices:

- Business value chain: problem -> opportunity -> scope -> metric -> decision
- User workflow: current process -> pain point -> proposed process
- Scope boundary: in scope / out of scope / future phase
- Delivery dependency map
- Post-launch validation loop

Use Mermaid unless SVG is clearly better. If using SVG, create a standalone SVG file and reference it in Markdown.

### 6. Write success and stop conditions

Every BRD must include:

- Baseline metric or "baseline unknown; must be measured before build"
- Target metric and time window
- Data source or owner
- Launch success criteria
- Stop, shrink, or pivot condition

Do not let "launch completed" stand in for "business value achieved".

### 7. Save and verify

After writing the Markdown file:

- Confirm it exists under the current project's `markdown/` directory.
- Confirm at least one diagram exists in the Markdown.
- If any SVG is referenced, confirm the SVG file exists beside the Markdown file.
- Check that the BRD contains in-scope, out-of-scope, success metrics, risks, dependencies, and post-launch validation.
- Tell the user the saved file path and any assumptions made.

## Evidence Rules

- If current market data, competitor claims, regulations, pricing, or product facts matter, browse or otherwise verify with reliable sources before writing.
- If evidence cannot be verified, label it as an assumption instead of presenting it as fact.
- Prefer concrete observations over vague claims: "5 interviewed users spent 2-4 hours weekly reconciling data" is better than "users strongly need efficiency".
- Do not invent customer quotes, user counts, revenue, conversion rates, or benchmark data.

## Writing Style

- Write in clear, decision-oriented business language.
- Keep the BRD practical and readable; avoid inflated product management jargon.
- Use tables for structured scope, metrics, risks, dependencies, and milestones.
- Use concise paragraphs for context and rationale.
- Separate "known facts", "assumptions", and "open questions".

## Minimum BRD Sections

If adapting the template, keep these sections at minimum:

1. Title and one-line decision
2. Executive summary
3. Background and business problem
4. Target users and evidence
5. Objectives and success metrics
6. Proposed solution and alternatives
7. Scope: in, out, later
8. Requirements at BRD level
9. Dependencies and constraints
10. Risks and mitigations
11. Milestones and ownership
12. Post-launch validation
13. Open questions


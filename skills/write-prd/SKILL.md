---
name: write-prd
description: Write a practical Product Requirements Document (PRD) from a product idea, feature concept, customer request, business problem, or rough product opportunity. Use when the user asks to write, draft, create, generate, or save a PRD, product requirements document, product spec, feature requirements, 产品需求文档, 产品方案, 需求说明, or PRD from an idea. Output a diagram-rich Markdown PRD under the current project's markdown/ directory.
---

# Write PRD

## Core Rule

Turn the user's idea into a PRD that helps a team decide, build, test, launch, and review the product work. A good PRD is not a feature list; it is a clear product bet:

`problem -> user -> goal -> evidence -> scope -> behavior -> acceptance -> launch validation`

Save the final PRD as Markdown under the current project's `markdown/` directory. Create the directory if missing.

## Inputs

Use the user's prompt as the source idea. If the prompt is vague, infer conservatively and write assumptions explicitly in the PRD. Ask a clarification question only when the missing information would materially change the product direction, such as target user, business domain, or platform.

If the user provides source notes, meeting records, screenshots, tickets, links, or existing docs, use them as evidence. If current market, competitor, pricing, regulation, or live product data is required and not provided, verify with reliable sources before using specific claims.

## Workflow

1. **Normalize the idea**
   - Identify the product/domain, target user, triggering scenario, problem, proposed solution, and expected business outcome.
   - Separate user problem from requested solution. For example, "export Excel" may mean reporting, sharing, audit, migration, or offline analysis.
   - Name the PRD topic in a short Chinese or English slug.

2. **Build the product argument**
   - Write a one-sentence product bet: "For [user], in [scenario], solve [problem], by [solution], measured by [metric]."
   - State assumptions when evidence is absent.
   - Include existing alternatives or workarounds; a new product competes with the user's current behavior.
   - Define goals and non-goals before writing feature details.

3. **Design the PRD structure**
   - Read `references/prd-template.md` when drafting the document.
   - Keep sections practical. Do not pad with generic market background.
   - Scale detail with risk: simple internal tools can be concise; payment, data, permission, compliance, AI, or customer-facing flows need stronger edge cases and acceptance criteria.

4. **Add diagrams**
   - Include at least one useful diagram.
   - Prefer Mermaid for workflows, user journeys, state transitions, data flow, decision trees, and metric chains.
   - ASCII text is acceptable for simple state tables or wireframe sketches.
   - If using SVG, output the `.svg` file separately in `markdown/` and reference it from the PRD with a relative Markdown image link, for example `![流程图](prd-topic-flow-20260609.svg)`.
   - Diagrams must support reasoning; do not add decorative graphics.

5. **Write feature requirements**
   - For each major capability, cover: user story, main path, edge cases, permissions, data rules, system behavior, analytics/events, and acceptance criteria.
   - Do not prescribe technical architecture unless the user asks. Product should define behavior, constraints, and verification, not implementation internals.
   - For AI features, specify input, output, quality bar, editability, failure modes, human review, data retention, and safety boundaries.

6. **Define validation**
   - Include result metrics, process metrics, and guardrail metrics.
   - Define launch plan, rollout scope, rollback conditions, and post-launch review timing.
   - Include stop conditions: what evidence means the team should stop, rollback, or change hypothesis.

7. **Save and verify**
   - File name: `markdown/<topic>-prd-<YYYYMMDD>.md`.
   - If SVG diagrams are created, use `markdown/<topic>-<diagram-name>-<YYYYMMDD>.svg`.
   - After writing, verify the Markdown file exists and includes a diagram, goals/non-goals, requirements, acceptance criteria, metrics, launch plan, and open questions.

## Output Requirements

The PRD must be written in Chinese unless the user asks for another language.

The final Markdown should be complete enough for product, design, engineering, testing, and business stakeholders to review. Use tables where they improve scanning, but do not hide weak reasoning in tables. Use concrete defaults for missing details and mark them as assumptions.

Required sections:

- Title and metadata
- One-sentence product bet
- Background and problem
- Target users and scenarios
- Evidence and assumptions
- Goals and non-goals
- Scope and release slicing
- User journey or workflow diagram
- Functional requirements
- Edge cases and constraints
- Data, permissions, analytics, and observability
- Acceptance criteria
- Launch, rollout, rollback, and review plan
- Metrics: result, process, guardrail
- Open questions and risks

## Quality Bar

Before finishing, check:

- Does the PRD say who has the problem, in what scenario, and why now?
- Does it distinguish user problem, product solution, and business outcome?
- Does it include current alternatives or workarounds?
- Does it define what is out of scope?
- Can engineering derive tasks without guessing core behavior?
- Can testing derive normal, abnormal, permission, and data-boundary cases?
- Can the team review success 2 to 8 weeks after launch?
- Is there at least one useful diagram?
- Is the file saved under the current project's `markdown/` directory?

## Reference

- `references/prd-template.md` - PRD structure, section guidance, and reusable table patterns.

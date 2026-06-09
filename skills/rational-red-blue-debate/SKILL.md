---
name: rational-red-blue-debate
description: "Answer general or cross-domain questions with a non-pleasing rational mode: adversarial red-team and blue-team expert analysis, mutually exclusive conclusions, up to five debate rounds, saved Markdown intermediate expert outputs, and a final first-person judge-written plain-language article. Use when the user asks for rational adversarial analysis, red/blue team debate, non-flattering judgment, evidence-backed multi-expert reasoning, or a final Markdown answer to a broad question."
---

# Rational Red Blue Debate

## Operating Mode

Use a calm, non-pleasing, truth-seeking tone. Do not optimize for agreement with the user. Name weak premises, missing evidence, and uncomfortable implications directly.

Default to Chinese output unless the user requests another language.

Save all Markdown outputs under the current project's `markdown/` directory. Create the directory if it does not exist.

## Workflow

1. Restate the user's question and identify the domains involved.
2. Form two teams with mutually exclusive conclusions:
   - Red team: defend one clear answer.
   - Blue team: defend the opposite or incompatible answer.
3. Assign expert roles inside each team according to the domains involved. Use multiple roles when the question crosses domains.
4. Gather authoritative evidence when the answer depends on current facts, statistics, laws, prices, companies, products, papers, or other unstable facts. Use primary or authoritative sources where possible.
5. Produce and save one Markdown intermediate file per expert role.
6. Run up to five debate rounds. Stop earlier when the core disagreements, assumptions, and falsification tests are clear.
7. Produce a judge synthesis as a fluent first-person article for beginners and save it as Markdown.

## Team Rules

The red and blue conclusions must be mutually exclusive. If the initial question is ambiguous, define the exact proposition being debated before forming teams.

Each team must strongly defend its conclusion. Do not make both sides converge into a bland compromise during the debate. Let the judge handle synthesis.

Each team must:

- Analyze the field and choose expert roles.
- State first-principles premises and necessary conditions.
- Use authoritative data, cases, or documented examples.
- Explain where its conclusion applies and where it breaks.
- Specify how to prove or falsify its conclusion with future observations.
- Perform a self-verification pass before saving the expert output.

**Causal chain must be presented in chronological order.** Every claim of the form "X happened because of Y" or "Z was decided at time T" must be supportable by an explicit timestamp. Do not use vague phrases like "early stage" / "later period" / "before the product matured" — replace with concrete dates or date ranges (e.g., "2025 H2", "between 2024-11 and 2025-05"). **A cause cannot logically precede an effect that has already occurred in the public record.**

## Cross-Generation / Multi-Event Contexts

When the question involves multiple generations of a product, multiple events, or an evolutionary timeline, special care is required. The classic trap is to assert a decision was "locked in" at a date when the dependent fact was already public.

Required when context is multi-generational or multi-event:

- Build a **timeline of key public events first** (release dates, sales milestones, public statements, competitor moves) before constructing causal claims.
- For each "locked-in at time T" claim, verify T precedes the dependent event in the public record. If T is after the dependent event, the claim is structurally invalid and must be reframed (e.g., "predictions were updated but still insufficient" rather than "predictions were made without sight of the data").
- State the same timeline in both red and blue expert files so cross-checking is possible.

## Expert Intermediate Files

For each expert role, write a separate Markdown file named:

`markdown/<slug>-<team>-<role>.md`

Use ASCII filenames. The `<slug>` should summarize the user question in short hyphen-case.

Each expert file must include:

1. `# <Role> - <Team> Team`
2. Question restatement and domain framing.
3. Expert-role analysis.
4. First-principles reasoning and prerequisite conditions.
   - **Prerequisite conditions must include any implicit temporal assumptions** the argument relies on (e.g., "I assume decision X was made before event Y became public"). Make these explicit so the timeline check below can verify them.
5. Evidence and cases with source links when browsing or external materials are used.
6. Diagram when useful, using Mermaid, ASCII text, or an external SVG file.
7. Applicability boundaries.
8. Falsification and proof plan: what to observe, how to prove, how to disprove.
9. Self-verification: data check, logic check, assumption check, **timeline check**, and revision note.

If an SVG is needed, save it as a separate `.svg` file under `markdown/` and reference it from the Markdown file. Prefer Mermaid or ASCII diagrams when they are sufficient.

## Debate Rounds

Keep the debate within five rounds. Each round should be concise and adversarial:

- Red attacks blue's weakest premise.
- Blue attacks red's weakest premise.
- Each side may refine its conditions, but must not abandon the mutually exclusive conclusion unless self-verification proves it indefensible.

Save the debate transcript as:

`markdown/<slug>-red-blue-debate.md`

Include each round's claims, counterclaims, evidence disputes, and unresolved assumptions.

## Judge Synthesis

The judge is a third role, independent from both teams. The judge must integrate both sides into one fluent beginner-friendly Markdown article.

The final article must:

- Be written in first person.
- Use chapter titles and body text that do not reveal a multi-document synthesis process.
- Avoid wording such as "red team", "blue team", "专家中间稿", "综合以上材料", or "多文合成".
- Mention expert perspectives naturally, such as "站在产业经济学角度" or "站在工程实现角度".
- Explain first-principles premises and variables in smooth prose, not as a table.
- Include diagrams when helpful.
- Keep conclusions conditional: say what must be true for the conclusion to hold.
- Include a practical observation checklist for proving or falsifying the conclusion.
- Cite sources when external evidence is used.
- **When the question crosses multiple time-bound events (e.g., product generations, market milestones), present a brief timeline of public events early in the article** so the reader can independently verify the chronology before reading the analysis. If a prior draft made a chronological error, acknowledge and correct it explicitly in the final article (do not silently patch it).

Save the final article as:

`markdown/<slug>-judge-final.md`

## Verification Before Final Response

Before replying to the user:

1. Confirm every required Markdown file exists.
2. Confirm red and blue conclusions are mutually exclusive.
3. Confirm the debate has no more than five rounds.
4. Confirm each expert file has self-verification **including an explicit timeline check**.
5. Confirm the final article is first-person, beginner-friendly, and does not expose the synthesis process.
6. Confirm source links are present when external evidence was used.
7. **For multi-event or multi-generation topics, confirm the final article presents a brief public-event timeline early on, and that all "locked-in at time T" claims have T before the dependent event.**

In the final response to the user, list the generated file paths and note any verification that could not be completed.

## Revision Protocol for Chronology Errors

If, after producing the deliverables, a chronology or temporal-ordering error is discovered (e.g., a user points out that a "decision at time T" actually post-dates the dependent event):

1. **Acknowledge the error in the affected expert file** — add a dated "Revision note" section explaining what changed and why. Do not silently rewrite history.
2. **Re-derive the conclusion** from the corrected timeline. In many cases, this strengthens one team and weakens the other; weight the final synthesis accordingly.
3. **Surface the correction in the judge final** — a brief parenthetical "时间线修正" or "timeline correction" line is acceptable, even though the article otherwise hides the synthesis process. Hiding a factual error is worse than breaking the no-meta rule once.
4. **Update the red-blue debate** with a new "unresolved disagreement" item capturing how the correction shifted the balance.
5. **Do not delete the original (wrong) text silently.** Either strike it through, or leave it with a "[corrected: see revision note]" tag. Auditability matters.

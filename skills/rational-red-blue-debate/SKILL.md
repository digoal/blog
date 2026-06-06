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

## Expert Intermediate Files

For each expert role, write a separate Markdown file named:

`markdown/<slug>-<team>-<role>.md`

Use ASCII filenames. The `<slug>` should summarize the user question in short hyphen-case.

Each expert file must include:

1. `# <Role> - <Team> Team`
2. Question restatement and domain framing.
3. Expert-role analysis.
4. First-principles reasoning and prerequisite conditions.
5. Evidence and cases with source links when browsing or external materials are used.
6. Diagram when useful, using Mermaid, ASCII text, or an external SVG file.
7. Applicability boundaries.
8. Falsification and proof plan: what to observe, how to prove, how to disprove.
9. Self-verification: data check, logic check, assumption check, and revision note.

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

Save the final article as:

`markdown/<slug>-judge-final.md`

## Verification Before Final Response

Before replying to the user:

1. Confirm every required Markdown file exists.
2. Confirm red and blue conclusions are mutually exclusive.
3. Confirm the debate has no more than five rounds.
4. Confirm each expert file has self-verification.
5. Confirm the final article is first-person, beginner-friendly, and does not expose the synthesis process.
6. Confirm source links are present when external evidence was used.

In the final response to the user, list the generated file paths and note any verification that could not be completed.

---
name: higher-order-article-writer
description: Read a provided URL, local file, or pasted article, digest its core claims and assumptions, rebuild the topic into a concise original source-backed Chinese Markdown article, and save it under the current project's markdown directory. Use when the user asks to upgrade, elevate, rewrite, extend, deconstruct, critique, refine, or produce a higher-order article from an existing article or URL, especially when the desired output should preserve the source insight but feel like a clean standalone article rather than an analysis of the source.
---

# Higher Order Article Writer

## Overview

Use this skill to transform an existing article into a sharper, higher-level standalone article. Digest the source deeply, but do not expose the scaffolding or describe what the source article said unless the user explicitly asks for critique. The final article should read like an original piece: concise, focused, source-backed, and centered on one clear thesis.

Default to Chinese output unless the user explicitly asks for another language.

## Workflow

1. Collect the source material.
   - If the user gives a URL, fetch and read the page. If browsing is needed, use current web sources and cite links.
   - If the user gives article text or a local file, use that as the primary source.
   - If the source is paywalled, inaccessible, or too sparse, state the limitation and proceed only with the available text.

2. Digest the source before writing.
   - Extract 3-7 core claims.
   - For each claim, identify the foundational assumption, supporting data, case evidence, and reasoning chain.
   - Compress the old article into one concise internal conclusion that includes: assumptions, claims, evidence, cases, and logic.
   - Do not start the new article until this extraction is coherent.

3. Audit the source logic internally.
   - Find unsupported leaps, hidden premises, causality/correlation confusion, missing counterexamples, stale data, selection bias, false dichotomies, and incentive blind spots.
   - Separate "the article is wrong" from "the article is incomplete under changed assumptions".
   - Keep useful claims when their assumptions still hold.

4. Rebuild with first principles.
   - Identify the most fragile or incomplete foundational assumption in the source.
   - Replace it with a new foundational assumption grounded in observable mechanisms.
   - Derive the new thesis from constraints, incentives, resource flows, balance sheets, user behavior, technology limits, policy rules, or other primary mechanisms relevant to the topic.
   - Make the new viewpoint explicit, not merely "more balanced".
   - Select 2-4 points that best support the thesis; cut secondary points unless they are necessary.

5. Support the new thesis.
   - Use authoritative current sources when facts, numbers, policies, market data, company data, or public figures may have changed.
   - Prefer primary sources: official statistics, filings, annual reports, central bank or government data, academic papers, standards, product docs, and direct company materials.
   - Use secondary media only to contextualize or compare interpretations.
   - Cite sources with Markdown links.

6. Check "逻辑三洽".
   - 自洽: Definitions, assumptions, and causal chains do not contradict each other.
   - 他洽: The thesis can explain the source article's valid observations, important counterexamples, and known external facts.
   - 续洽: The thesis can generate future observable signals. If time-based proof is not possible, use derivation-style reasoning and list future signals that would confirm or falsify the thesis.

7. Write the final Markdown article and save it.
   - Create or reuse `markdown/` under the current project.
   - Save the file with a descriptive slug and date when useful.
   - Write a clean standalone article. Do not include sections named "旧文真正说了什么", "旧逻辑的关键漏洞", "如果基石假设崩塌", "逻辑三洽检验", or similar analysis scaffolding unless the user explicitly asks for an audit-style output.
   - Treat the source article as internal raw material. Do not write "原文认为", "原文提到", "原文实验说明", "旧文指出", "作者说", "source article", or similar phrases in the final article unless the user asks for an audit, critique, or comparison.
   - Include at least one useful visual. Prefer one Mermaid diagram for structure or flow. Add inline SVG only when it explains a concept better than text or Mermaid; do not add decorative visuals.
   - Keep the article compact. For ordinary blog/news rewrites, target about 900-1,600 Chinese characters of body text before references unless the user asks for a long article.

## Output Structure

Use this compact standalone structure by default:

````markdown
# [鲜明的新标题]

> [一句话核心判断。]

## [重点一：直接进入最重要的新判断]

[Explain the mechanism and cite evidence.]

```mermaid
flowchart LR
  A["关键变化"] --> B["机制"]
  B --> C["影响"]
```

## [重点二：展开关键案例或能力]

[Explain what changed and why it matters.]

## [重点三：落到边界、风险或生产含义]

[Keep caveats concrete. Do not over-explain.]

## 接下来该看什么

[List 3-6 observable signals.]

## 结论

[Memorable synthesis.]

## 参考来源

- [Source title](https://...)
````

## Writing Requirements

- Keep the new article higher-level than the source: more abstract in mechanism, more concrete in evidence.
- Use short, forceful section titles.
- Make the article feel original and self-contained. Use the source as raw material, not as the visible structure or an object being summarized.
- Avoid explicit "old article vs new article" framing unless the user asks for critique, audit, or deconstruction. Do not narrate how the source article argued; present the rebuilt thesis directly.
- Keep scope tight. Prefer 2-4 strong sections over exhaustive coverage.
- Highlight the central point early, then support it with the fewest necessary facts and cases.
- Prefer direct declarative framing over forced binary contrast. Titles, subtitles, blockquotes, and section headings should usually state the new judgment directly, such as "DuckDB 正式将 AI 向量检索变成一等公民".
- Avoid "不是...而是..." by default. Use it only when a genuine misconception must be corrected and a direct sentence would be weaker; never use it as a habitual narrative template.
- Explain concepts enough for an intelligent non-specialist without diluting the argument.
- Avoid generic rewrites, moralizing, empty trend language, and unsourced data.
- Do not fabricate article content, data, citations, cases, or quotes.
- When evidence is uncertain, say what is known, what is inferred, and what would need verification.
- End with references, but keep the bibliography concise and relevant.

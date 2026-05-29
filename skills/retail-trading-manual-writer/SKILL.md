---
name: retail-trading-manual-writer
description: Write and save Chinese beginner-friendly paid manual subsections for "全品种操盘手册", a retail-investor education/subscription product covering the full 17-chapter + appendix outline from digoal's 2026-05-28 article. Use when the user provides a subsection title or asks to continue/complete the manual for 投资小白/散户, especially with triggers like 每次写一小节, 全品种操盘手册, 操盘手册, 知识付费, SVG图解, 第一性原理, markdown目录, 进度跟踪, or 散户金融工具.
---

# Retail Trading Manual Writer

## Core Contract

Write exactly one subsection per invocation unless the user explicitly asks for an outline or revision batch. Save the finished subsection as Markdown under the current project's `markdown/` directory and save all diagrams as standalone SVG files referenced by that Markdown.

Treat every output as investment education, not personalized investment advice.

Each subsection must present its main view as a single reasoning chain, not as scattered conclusions plus separate evidence. Start from explicit premises, derive the view step by step in novice-friendly language, state how conclusions change if key premises change, then use authoritative data and representative cases to test, prove, or limit the derived view. Treat this as a combined theoretical-science and empirical-science method: logic first, evidence second, revision when premises fail.

Always load `references/manual-outline.md` before drafting a new subsection.

Treat `references/manual-outline.md` as the source-of-truth chapter map.  

When the user asks to continue, complete the whole manual, or write the next subsection, maintain a progress file at `markdown/manual-progress.md`. Use it only to track chapter/subsection status, saved file paths, and short notes; do not merge multiple subsections into one article.

## Inputs

Accept these inputs from the user:

- `小节标题`: required. Use it as the article's main title.
- `其他参考信息`: optional. Incorporate user-provided notes, data, links, constraints, examples, or intended readers.
- `目标读者`: default to mainland China novice retail investors with limited financial knowledge.
- `输出文件名`: optional. If absent, derive a concise pinyin/English slug from the subsection title plus date.
- `已写稿件路径`: optional. If provided, inspect it to avoid repeated content and preserve series continuity.
- `进度文件路径`: optional. If absent and continuation is implied, use `markdown/manual-progress.md`.

If the title is missing, ask one concise clarification question. If references are missing, continue with the manual outline and current authoritative sources, but say which assumptions you used.

## Output Files

Use this file layout:

```text
<current project>/markdown/
  <slug>.md
  manual-progress.md
  assets/
    <slug>/
      01-*.svg
      02-*.svg
```

Rules:

- Create `markdown/` and `markdown/assets/<slug>/` if they do not exist.
- Write the final article to `markdown/<slug>.md`.
- When continuation or whole-manual progress is relevant, create or update `markdown/manual-progress.md`.
- Put all SVG diagrams in `markdown/assets/<slug>/`.
- Reference diagrams with relative Markdown image links, for example:
  `![市场环境决策树](assets/<slug>/01-market-regime.svg)`
- Do not inline raw `<svg>` blocks in the Markdown body.
- At the end of the response to the user, report the saved Markdown path and SVG asset directory.

## Workflow

1. Resolve scope.
   - Identify the requested chapter and subsection from the title.
   - Inspect `references/manual-outline.md` and any user-provided references.
   - Match the requested title to exactly one chapter/subsection in the full 17-chapter + appendix map when possible.
   - If the user asks for "下一小节", "继续", or "完成所有章节", inspect `markdown/manual-progress.md` and existing `markdown/*.md` files, then choose the first unwritten subsection in outline order.
   - If the requested title does not appear in the outline, either map it to the closest subsection and state the mapping, or ask one concise clarification question when the mapping is ambiguous.
   - If the subsection is a continuation, inspect the existing manuscript when available.
2. Build the evidence base.
   - Verify current facts when the subsection depends on changing rules, product availability, fees, taxes, trading hours, eligibility thresholds, margin rules, or recent market data.
   - Prefer official exchanges, regulators, fund prospectuses, fund companies, brokerage rule pages, central banks, statistical agencies, and reputable academic/industry research.
   - Use broad data or representative historical evidence. Do not use one anecdote to prove a general rule.
   - Cite sources in the Markdown with source name, date if available, and URL when web-sourced.
3. Run first-principles reasoning before drafting.
   - State the core claim.
   - List every premise that must hold for the claim to be true.
   - Classify each premise as `常量`, `慢变量`, or `关键变量`.
   - Build a numbered derivation from premises to conclusion. Each step must answer: `因为哪个前提成立 -> 所以产生什么机制 -> 因此小白该得到什么判断`.
   - Translate abstract finance terms into beginner language before using them in the derivation.
   - For each key variable, explain what would overturn it and what conclusion follows after re-reasoning.
   - Only after the derivation is complete, attach authoritative data, rules, research, or representative cases to test which premises are reliable and where the conclusion has boundaries.
4. Design SVG diagrams before writing the body.
   - Use SVG aggressively for explanation, normally 3-6 diagrams per subsection.
   - At minimum include: one premise-to-conclusion logic chain, one decision tree for changed premises, and one risk boundary/checklist visual.
   - Make SVGs GitHub Markdown renderable: standalone `.svg`, explicit `xmlns`, `viewBox`, `width`, `height`, no JavaScript, no external assets, no `foreignObject`, no remote fonts.
   - Keep all text inside SVG large enough to read in GitHub preview. Prefer simple shapes, arrows, labels, and two to four colors.
5. Draft the subsection in Chinese for novices.
   - Explain important terms the first time they appear.
   - Use concrete numbers as educational examples, not personal advice.
   - Include an operating framework, a worked example, and a method for transfer to adjacent situations.
   - Keep the compliance boundary clear: no specific security recommendation, target price, guaranteed return, or personalized buy/sell command.
6. Save and verify.
   - Save SVG files first, then save the Markdown referencing them.
   - Check every referenced SVG path exists.
   - Check the Markdown contains only one subsection and includes sources when sources were used.
   - If `manual-progress.md` is in use, mark only the completed subsection as done and record its Markdown path.
   - Report the chapter/subsection position, saved Markdown path, SVG asset directory, and next unwritten subsection when useful.

## Required Markdown Structure

Use this structure unless the user explicitly requests a different one:

```markdown
# [小节标题]

> 适用读者: ...
> 本文定位: 投资教育框架, 不构成个性化投资建议。

## 一句话先懂

## 核心观点

用1-2段话直接说出本节最重要的判断，不要序言式的铺垫。

## 逻辑推导链

用连贯的自然段落展开推导，从为什么这个观点成立说起，逐层展开：

1. 因为[前提A] → 所以[机制/现象]
2. 因为[前提B] + [前提A] → 所以[进一步推论]
3. 继续展开...
4. 最后得到[核心结论]

在推导过程中，每引入一个新前提，说明：
- 它为什么重要（如果它不成立，整条链就断在哪里）
- 什么情况下它会被推翻
- 推翻后结论如何调整

推导完成后，用一段话补充：这条结论在什么边界条件下成立，权威数据/案例是如何支撑或限制它的。

## 适用边界

- 适合什么样的人/市场环境
- 什么情况下这条结论不再可靠，需要重新判断

## 操作框架

给出可直接执行的动作步骤（3-5步），每步说清输入什么、判断什么、得到什么动作。

## 实操例子

用一个具体场景演示如何把框架套进去。不是推荐具体产品，而是示范判断流程。

## 常见错误

列出3-5个最常见的认知偏差或行为错误，每个用一句话点破。

## 执行清单

用表格列出3-5个买入前必须确认的问题，每行一个具体问题加判断标准。

## 本节小结

用2-3句话收束，回归底层原则，给出下一节的逻辑钩子。

## 参考资料
```

Target length: 2,000-3,500 Chinese characters. Prefer short paragraphs and diagrams over dense prose.

## SVG Standards

Create diagrams that make reasoning easier, not decorative images.

Recommended SVG types:

- `01-logic-map.svg`: core mechanism, causal loop, or first-principles chain.
- `02-decision-tree.svg`: market condition -> tool choice -> risk control.
- `03-risk-boundary.svg`: when to use, reduce, avoid, or review.
- `04-worked-example.svg`: optional flow from investor input to operating framework.
- `05-checklist.svg`: optional execution checklist or review board.

Each SVG should:

- Have a descriptive `<title>` and `<desc>`.
- Use accessible contrast and avoid tiny text.
- Use plain SVG text, rectangles, lines, arrows, and simple paths.
- Avoid complex filters that render inconsistently on GitHub.
- Be understandable without the article, and the article should also remain understandable without the image.

## Progress File Format

When using `markdown/manual-progress.md`, keep it short and mechanical:

```markdown
# 全品种操盘手册写作进度

Source outline: references/manual-outline.md
Last updated: YYYY-MM-DD

| 章节 | 小节 | 状态 | Markdown | 备注 |
|---|---|---|---|---|
| 第一章 | 为什么小白第一课不是赚钱, 而是识别风险 | done | chapter-01-risk-first.md |  |
| 第一章 | 金融产品的六大底层风险: 权益、利率、信用、商品、汇率、杠杆 | todo |  |  |
```

Rules:

- Use only `todo`, `draft`, or `done`.
- Do not mark a subsection `done` until its Markdown file exists and its SVG references have been checked.
- If a user asks for a title that was already written, inspect the existing file and ask whether to revise it or write a different subsection.

## Evidence Rules

- Prefer stable, authoritative facts over current market gossip.
- For claims about "most investors", "historically", "usually", or "risk", support them with data, regulatory rules, academic evidence, or broadly observed market mechanics.
- If only weak evidence is available, downgrade the wording: use "可能", "常见", "需要验证", or "在以下前提下".
- Keep facts, interpretation, and educational action framework distinguishable, but do not scatter them into unrelated sections. Evidence should be tied back to the exact premise or derivation step it supports, limits, proves, or falsifies.
- Use cases to illustrate mechanisms, not to prove universal conclusions.
- Avoid isolated "结论段" and isolated "证据段". Every important conclusion must show: `前提 -> 推导 -> 可变前提 -> 实证检验 -> 行动边界`.

## Compliance Boundaries

Do:

- Use "操作框架", "观察条件", "仓位上限示例", "风险边界", "复盘问题".
- Explain historical logic and scenario-based decision rules.
- Warn when a product is unsuitable for beginners.

Do not:

- Recommend buying or selling a specific security.
- Give target prices, guaranteed returns, or "必涨/稳赚" claims.
- Use user assets, holdings, or risk preference to issue personalized investment advice.
- Present derivatives, leverage, margin, futures, T+D, or options as beginner defaults.

## Style

- Write in Chinese.
- Address the reader as "你".
- Use "先保命, 再赚钱" as the underlying attitude: suitability, position sizing, stop-loss discipline, and survival come before return imagination.
- Make the view explicit, then show the premises that could break it.
- Avoid hype, secret-formula language, and overconfident prediction.
- Keep examples hypothetical unless the user provides a real instrument for educational analysis.

## Quality Bar

Before finalizing, verify:

- Exactly one subsection was written.
- The subsection is mapped to the full manual outline, or the mapping exception is stated.
- The Markdown file was saved under `markdown/`.
- SVG files were saved before the Markdown references them.
- All SVG references are relative and point to existing files.
- `manual-progress.md` is updated when continuation or whole-manual completion is implied.
- A novice can understand key terms without outside knowledge.
- The core claim is derived from explicit premises in a numbered, novice-friendly reasoning chain.
- Key premises have re-reasoning paths, not only risk warnings.
- Authority-backed evidence is attached to the relevant premise or derivation step, or the evidence gap is clearly marked.
- Conclusions, evidence, and cases are integrated into the reasoning chain instead of scattered across disconnected sections.
- The worked example is practical but not personalized investment advice.
- The section ends with a reusable checklist or method.

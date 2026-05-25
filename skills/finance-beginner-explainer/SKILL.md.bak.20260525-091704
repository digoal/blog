---
name: finance-beginner-explainer
description: Explain a finance-explosive-article markdown file for readers with weak financial knowledge by unpacking concepts, causal chains, examples, analogies, and transferable analysis methods. Use when the user asks to turn a daily finance explosive article, 德哥财经爆款文章, market commentary, or finance markdown into a beginner-friendly detailed interpretation saved under the current project's markdown directory.
---

# Finance Beginner Explainer

## Overview

Create a beginner-friendly companion article from `finance-explosive-article-YYYY-MM-DD.md`. The output should help readers understand not only what the original article says, but how to reason through similar financial events independently.

This skill is stage 4 of the daily finance content pipeline:

`daily-finance -> finance-core-analysis -> finance-explosive-article -> finance-beginner-explainer`

## Input

Prefer reading the latest matching file in the current project:

`markdown/finance-explosive-article-YYYY-MM-DD.md`

If the user provides a specific date or file path, use that file. If multiple dates exist and no date is implied, use the newest file by filename/date and state that assumption in the output metadata. If no upstream file exists, ask for the article file or pasted content.

Also read the corresponding upstream files when available:

- `markdown/daily-finance-YYYY-MM-DD.md` for verified facts and sources.
- `markdown/finance-core-analysis-YYYY-MM-DD.md` for mechanism and scenario analysis.

Do not invent facts. If a claim is unclear, explain it as an interpretation and mark the uncertainty.

## Workflow

### 1. Extract the Original Argument

Identify:

- The article's core judgment.
- The main "不是A，而是B" reversal.
- The causal chain, usually `触发事件 -> 传导机制 -> 资金行为 -> 资产定价 -> 风险约束 -> 后续观察点`.
- The key numbers and source-backed facts.
- The falsification signals.

### 2. Translate Concepts for Beginners

For every important financial term, explain it in plain Chinese before using it heavily. Prioritize terms that block understanding, such as:

- Risk appetite
- Liquidity
- Inflation expectation
- Interest-rate transmission
- Discount rate and valuation
- Capital flows
- Balance-sheet pressure
- Risk premium
- Long-duration assets
- Currency constraint

Use simple analogies, but do not let analogies replace the actual mechanism.

### 3. Expand the Logic Chain

Explain each link with four parts:

- What it means.
- Why it happens.
- How it affects the next link.
- What observable data can confirm or falsify it.

Example pattern:

`油价上涨 -> 通胀预期上升 -> 降息预期下降 -> 利率维持高位 -> 成长股估值承压`

For each arrow, explain the economic incentive and market behavior behind it.

### 4. Add Examples and Transfer

Include at least:

- One everyday analogy.
- One market example from the article.
- One "举一反三" example showing how the same model applies to another scenario.
- One common beginner mistake and how to avoid it.

The "举一反三" section must teach a reusable method, not just repeat the original case.

### 5. Write the Beginner Article

Use this required structure:

1. Title
2. 这篇文章到底在讲什么
3. 小白先懂这几个概念
4. 原文逻辑链条逐层拆解
5. 用一个生活例子重新讲一遍
6. 用一个市场例子验证这条链
7. 举一反三：下次遇到类似新闻怎么分析
8. 最容易误解的地方
9. 小白分析清单
10. 总结
11. 来源与风险提示

Keep paragraphs short. Use precise but accessible language. Do not talk down to readers.

## Output

Save to:

`markdown/finance-beginner-explainer-YYYY-MM-DD.md`

Use the same report date as the source `finance-explosive-article` file. Create `markdown/` if missing. Use UTF-8.

If writing fails, output the full Markdown in chat.

## Quality Rules

- Preserve source-backed facts from the upstream article.
- Clearly separate fact, interpretation, and teaching analogy.
- Explain causal mechanisms; do not use empty phrases like "情绪推动" without unpacking incentives.
- Avoid explicit buy/sell recommendations.
- Do not add dramatic claims for readability.
- End with `本文仅供学习交流，不构成投资建议。`

## Quick Validation

Before finishing, check:

- The output explains the original core judgment.
- Every major causal arrow is unpacked in beginner language.
- The article includes examples, analogy, transfer method, mistakes, and checklist.
- The output file name date matches the upstream article date.
- The final disclaimer is present.

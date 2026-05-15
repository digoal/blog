---
name: industry-news-insight
description: Generate a concise Chinese WeChat-ready Markdown article from an industry name by searching current news from the last month, verifying evidence across production, demand, inputs, ecosystem, policy, financing, and technology signals, and writing first-person neutral third-party industry insight without visible author identity or AI traces. Use when the user asks for 行业新闻追踪, 行业洞察, 近一个月行业分析, 公众号短文, industry trend notes, or a source-backed short article saved to the current project's markdown directory.
---

# Industry News Insight

## Overview

Use this skill to turn one industry name into a short, evidence-backed Chinese Markdown article for WeChat-style mobile reading. The output should read like a human industry observer's first-person note, not a formal report, pitch, consultant bio, or AI-generated summary.

## Workflow

1. Confirm the target industry and date window.
   - Default to the most recent 30 days from the current date.
   - If the industry name is broad, keep it broad unless the user specifies a sub-sector; avoid silently narrowing the scope.
   - State the date window in the working notes or final response, but do not over-explain it inside the article.

2. Search current evidence.
   - Search web/news sources for the industry name plus terms such as 新闻, 政策, 投融资, 价格, 产能, 需求, 出口, 技术, 并购, supply, demand, market, regulation, funding, earnings, capacity, and price.
   - Prioritize sources published within the last 30 days. Use older sources only for background or to explain a structural fact, and label them as background in notes.
   - Prefer primary or high-signal sources: regulators, exchanges, statistics agencies, company announcements, earnings materials, industry associations, reputable business media, and credible research institutions.
   - Collect enough evidence to cover at least three angles among production端, 消费端, 生产资料/上游投入, 渠道/生态, 政策监管, 技术变化, 资本市场/投融资, and international trade.

3. Validate the story before writing.
   - Separate facts from interpretation.
   - Look for contradictions across sources; resolve them by source quality, date, and measurement definition.
   - Do not write if the last-month evidence is too thin, stale, promotional, or one-sided. Tell the user what is missing instead of producing a weak article.
   - Add supplemental searches when a key causal link depends on missing evidence.

4. Build the article thesis.
   - Use a "news signal -> industry mechanism -> what may change next" structure.
   - Avoid a simple news roundup. Extract one core judgment from the evidence.
   - Make the judgment neutral and falsifiable; avoid investment advice, buy/sell calls, and unsupported predictions.

5. Write for mobile WeChat reading.
   - Write in Chinese unless the user asks otherwise.
   - Keep the article under four mobile screens: normally 900-1500 Chinese characters, excluding references and diagrams.
   - Use short paragraphs, compact headings, and direct sentences.
   - Use first person naturally, such as "我更关注的是..." or "我把这件事放到产业链里看...".
   - Do not reveal an author role. Avoid phrases like "作为第三方顾问", "作为AI", "本文由AI生成", "我们团队", or "研究报告认为".
   - Do not use obvious AI template language such as "综上所述", "值得注意的是" repeated mechanically, "未来可期", or inflated slogans.
   - Do not fabricate quotes, statistics, rankings, or company positions.

6. Add visuals only when they improve comprehension.
   - Prefer one compact Mermaid, SVG, or ASCII diagram when it clarifies a value chain, feedback loop, or supply-demand relation.
   - Keep visuals mobile-readable and text-light.
   - Skip visuals when they would consume space without adding insight.

7. Save the Markdown.
   - Create or use the current project's `markdown/` directory.
   - Save as `markdown/<YYYYMMDD>-<industry-slug>-industry-news-insight.md`.
   - Include the article title, body, optional diagram, and a compact `参考来源` section with source names, dates, and links.
   - In the final response, report the saved absolute path and a brief evidence summary.

## Article Shape

Use this structure unless the user requests another format:

```markdown
# <短标题：行业名 + 核心判断>

<开场：最近一个月最关键的新闻信号，用一两段进入，不写套话。>

## <机制标题>

<解释生产端、消费端、上游或生态中的关键变化。>

## <真正的变化>

<给出第一人称观察和行业机制判断。>

<可选 Mermaid/SVG/ASCII 图>

## <接下来盯什么>

<列出2-4个后续观察指标，不写投资建议。>

---

参考来源：
- <来源名>，<发布日期>，<链接>
```

## Quality Bar

- The article must be readable as a standalone public-account post.
- Every specific data point or event must be traceable to a source.
- The core claim must follow from the cited evidence, not from generic industry common sense.
- The article should feel concise, observational, and human; remove bureaucratic framing, consultant disclaimers, and AI-style transitions before saving.

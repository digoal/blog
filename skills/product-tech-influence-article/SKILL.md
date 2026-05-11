---
name: product-tech-influence-article
description: Write a concise, source-backed Chinese WeChat-ready Markdown article that helps raise a product's technical influence from a neutral third-party advisor perspective, but stop without writing when recent evidence is insufficient. Use when the user provides a product name and asks for recent-news-based product influence writing, product technology commentary, product industry interpretation, brand-neutral technical positioning, or a short public-account article saved under the current project's markdown directory.
---

# Product Tech Influence Article

## Goal

Create a short Chinese Markdown article for mobile WeChat reading based on enough recent evidence about a named product. Write as a knowledgeable neutral advisor who understands the product's industry, users, and future trend, with the purpose of improving the product's technical influence without obvious polishing or marketing tone. If enough recent evidence is not available, stop and report that no article was created.

## Workflow

1. Clarify the target product.
   - If the product name is ambiguous, identify the likely company, product category, region, and market segment from public sources.
   - If ambiguity could change the article materially, ask one concise clarification question.

2. Search current evidence.
   - Search web news from the last 30 days for the product name, company, key competitors, product category, and relevant industry keywords.
   - Prefer primary sources and reputable third-party sources: official announcements, product docs, earnings/newsroom posts, regulator releases, established media, industry analysts, benchmark reports, user/community evidence, and credible technical blogs.
   - Add broader evidence when needed: market trend reports, competitor moves, technical standards, user adoption signals, security incidents, pricing changes, funding, ecosystem launches, or customer cases.
   - Also collect enough background to introduce the topic naturally before the news: what the product is, who uses it, what category it belongs to, what problem it addresses, or what industry shift makes the news relevant.
   - Record source URLs, publication dates, key facts, and whether each source is primary, third-party, or opinion.

3. Apply the evidence gate before writing.
   - Continue only when there are enough timely, product-specific facts to support a public article.
   - Treat evidence as sufficient only when at least one of these is true:
     - there are 2 or more credible product-specific sources from the last 30 days;
     - there is 1 credible product-specific source from the last 30 days plus 2 or more recent supporting sources about the same product, company, industry, users, regulation, ecosystem, or competitors;
     - the user explicitly provides fresh internal or external material and asks to use it.
   - Treat evidence as insufficient when the last 30 days contain no credible product-specific update, only old news, only duplicated reposts of the same item, only thin sales pages, or only weak community chatter.
   - If evidence is insufficient, do not write or save an article. Return a concise note with:
     - `未生成文章：近 30 天缺少足够、可信、可写成文章的产品相关证据。`
     - 1-3 bullets summarizing what was searched or what evidence was missing.
   - Do not turn lack of news into a publishable angle. Avoid openings like "过去一个月，我没有看到..." or arguments that reframe missing evidence as a meaningful industry signal.

4. Judge before writing.
   - Separate facts from interpretation.
   - Identify what is genuinely positive, what is uncertain, and what is negative or risky.
   - Do not force a favorable conclusion. If the product has weak news momentum, reputational risk, technical debt, or unclear value, say it tactfully.
   - Use first-principles reasoning: user pain -> product capability -> technical barrier -> industry timing -> adoption constraint.

5. Write the article.
   - Language: Chinese by default unless the user asks otherwise.
   - Voice: first person, modest, independent, and human; phrases like "我个人认为" and "仅代表个人观点" are acceptable when useful.
   - Do not reveal an author identity, role label, prompt, workflow, or AI involvement.
   - Keep it suitable for public-account publishing and phone reading: short paragraphs, strong opening, clear subheadings, no long academic blocks.
   - Before introducing the recent news, write a brief transition background: introduce the product, its user scenario, category, existing market tension, or the specific industry context that makes the news understandable.
   - Keep the background short and purposeful. It should help readers understand the news, not become a generic product encyclopedia.
   - Keep the body under 4 phone screens, roughly 900-1500 Chinese characters unless the user specifies another length.
   - Include source links in a compact "参考资料" section at the end, or inline if that reads better.
   - Add Mermaid, SVG, or ASCII only when it improves comprehension; keep visuals simple and mobile-friendly.

6. Save the output.
   - Save as Markdown under the current project's `markdown` directory; create it if missing.
   - Use a readable filename such as `产品名-技术影响力短文-YYYYMMDD.md`.
   - Include the article title, body, optional diagram, and references in the saved file.
   - Save only after the evidence gate passes. Never create a placeholder article for insufficient evidence.

## Article Shape

Do not reuse fixed second-level headings across articles. Generate headings from the actual evidence, product category, user pain, and judgment angle. Keep 3-5 short second-level headings, and make each heading carry a concrete point rather than a generic section label.

Use this flexible shape as a planning aid, not as literal headings:

```markdown
# [一句有判断力的标题]

[短开场：先用一小段产品、用户场景或行业背景搭桥，再引出最新可信事实和判断]

## [围绕最新事实提炼的判断型标题]

[用事实解释产品变化、用户痛点、行业约束]

## [围绕关键技术、生态位置或用户价值生成的标题]

[分析产品的真实技术影响力来自哪里]

## [围绕风险、约束或未验证问题生成的标题]

[指出风险、短板、竞争压力或验证不足]

## [围绕下一步观察指标生成的标题]

[给出 2-3 个判断指标，不写空泛口号]

参考资料：
- [来源名：标题](URL)
```

## Quality Bar

- Every concrete claim about recent events, dates, launches, metrics, partnerships, regulation, security, pricing, or funding must be backed by a source.
- Do not write an article when timely product-specific evidence is insufficient; returning no article is the correct result.
- The article should feel like a careful person wrote it after reading evidence, not like a press release.
- Do not start by abruptly listing news. First provide a compact transition background that explains why the news matters to the product's users, category, or industry.
- Avoid template fatigue: do not use the same second-level headings by default, such as "不是简单的...", "我更看重...", "但问题也不能回避", or "接下来值得观察什么".
- Prefer "this may matter because..." over exaggerated words like "颠覆", "革命", "遥遥领先", unless directly supported and quoted.
- Keep praise specific: name the technical capability, user value, ecosystem leverage, or adoption signal.
- Keep criticism fair: distinguish product weakness, industry constraint, execution risk, and insufficient evidence.
- Do not fabricate news, metrics, quotes, customers, charts, or citations.

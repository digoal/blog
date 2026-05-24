---
name: database-foundation-course-writer
description: Write Chinese "数据库筑基课" Markdown articles for database architects, DBAs, and application developers. Use when the user provides a database foundation article title and references such as technical docs, product manuals, open-source repositories, DeepWiki pages, papers, source code, or related blog posts, and wants a rigorous, SVG-rich, practice-oriented GitHub-renderable Markdown article saved as a .md file.
---

# Database Foundation Course Writer

## Overview

Write a publishable Chinese Markdown article in the "数据库筑基课" style. The article must help database architects, DBAs, and application developers understand the mechanism, tradeoffs, practice path, and operational boundaries of a database technology. Default to GitHub-renderable Markdown plus referenced SVG figure files.

## Inputs

Require or infer:

- Article title.
- Reference materials: official docs, product manuals, source repositories, DeepWiki pages, papers, source code, existing local articles, SQL examples, benchmark data, or issue discussions.
- Target technology category: table storage, index structure, data type/operator, optimizer scan algorithm, execution operator, maintenance mechanism, or scenario practice.

If key references are missing, search primary sources first. Prefer official docs, source code, papers, and project README over secondary summaries.

## Output

Save the final article as a `.md` file. Use the current project's `markdown` folder when that is the established article-output convention; otherwise use an existing article/output folder if the repository clearly has one. Use a filename derived from the title when no filename is provided, or follow the repository's existing naming convention if obvious.

Save SVG figures as standalone `.svg` files in a sibling asset directory such as `<article-slug>-assets/`, unless the repository has an established image/asset convention. Reference them from Markdown with relative image syntax:

```markdown
![图 1：页面、元组与可见性信息的关系](./<article-slug>-assets/page-tuple-visibility.svg)
```

Do not save until the article has passed the validation checklist.

## Workflow

1. Parse the title and references.
2. Classify the topic as table storage, index structure, data type/operator, scan/execution algorithm, or scenario practice.
3. Read primary references and extract mechanisms, terminology, examples, limits, and source-backed claims.
4. Build the article around "background pain -> definition -> principle -> tradeoff -> comparison -> practice -> boundary".
5. Add explanatory diagrams with standalone GitHub-renderable SVG files as the default format; use Markdown tables for compact comparisons and existing reference images only when allowed and source-relevant.
6. Write runnable examples when possible. Never invent execution output.
7. Validate logic, examples, citations, Markdown rendering, relative image links, and SVG visibility.
8. Save the final `.md` file and its SVG assets.

## Article Structure

Use this structure unless the topic strongly requires a different order.

```markdown
# 数据库筑基课 - <主题>

作者：digoal

日期：<YYYY-MM-DD>

标签：PostgreSQL , PolarDB , DuckDB , 应用开发者 , 数据库筑基课 , <分类标签>

---

## 背景

链接或引用数据库筑基课大纲。说明本节属于哪一类基础能力，并从业务或工程痛点切入。

## 一、它解决什么问题？

说明技术点出现的背景、原问题、传统做法的不足、转化后的问题，以及牺牲的代价。

## 二、它是什么？

给出简洁定义，解释逻辑模型、物理模型、关键术语和适用层次。

## 三、核心原理

解释内部结构、关键算法、数据布局、读写路径、生命周期、复杂度、维护机制。

![图 1：<图名>](./<article-slug>-assets/<figure-name>.svg)

图 1 说明：解释读者应该从图中看到的结构、路径、状态变化或代价关系。

## 四、横向对比

和竞品、相邻技术或不同实现比较，并解释原因。

## 五、效果如何？

说明收益和代价，例如 IO、block/page、压缩比、延迟、吞吐、召回率、误判率、读写空间放大。

## 六、实操 DEMO

给出最小可验证实验、SQL、配置、EXPLAIN 或同类验证。无法执行时明确说明。

## 七、最佳实践

分别面向数据库架构师、DBA、业务开发者给出推荐做法、原因、风险和验证方式。

## 八、适合与不适合场景

绑定 workload 写清楚适合和不适合的原因。

## 九、常见坑

列出真实工程风险和规避方法。

## 十、扩展问题

提出能帮助读者迁移到其他技术的思考题。

## 十一、扩展阅读

列出官方文档、论文、源码、DeepWiki、项目 README、已有相关文章和高质量二手资料。
```

## Topic Guidance

For table storage topics, cover file/page/block/row/column layout, insert/update/delete/read, MVCC or visibility, vacuum/compaction, compression, encoding, cold storage, and read/write/space amplification.

For index topics, cover data organization, build, insert, delete, update, vacuum/merge, search/scan algorithm, complexity, space cost, recall or false positives, and how the optimizer/executor uses the index.

For data type and operator topics, cover representation, operator semantics, index support, selectivity estimation, optimizer impact, and modeling patterns.

For scan and execution topics, cover seq scan, index scan, index only scan, bitmap scan, skip scan, sampling, joins, sort, aggregate, CTE, subquery, parallelism, JIT, vectorized execution, cost model, statistics, memory/disk behavior, and EXPLAIN verification.

For scenario practice topics, cover business model, schema, indexes, partitions, hot/cold split, SQL, bottleneck diagnosis, observability, and evolution path.

## Comparison Table

Use a Markdown comparison table when there are meaningful alternatives.

```markdown
| 维度 | 本文技术 | 对比技术 A | 对比技术 B |
|---|---|---|---|
| 主要目标 |  |  |  |
| 写入代价 |  |  |  |
| 读取代价 |  |  |  |
| 空间成本 |  |  |  |
| 事务/MVCC |  |  |  |
| 适合场景 |  |  |  |
| 不适合场景 |  |  |  |
```

Explain the reasons behind the table. Do not only list conclusions.

## SVG Diagram Policy

Default to standalone SVG files for mechanism-heavy explanations, referenced from Markdown with relative `![alt](path.svg)` links. A normal article should usually include 3 to 5 substantive SVG figures, and more when the topic has multiple structures, paths, or decisions to compare.

Prefer SVG over Mermaid, ASCII diagrams, and decorative images. Use SVG for:

- Logical-to-physical mapping.
- Page/block/row/index layout.
- Read, write, vacuum, compaction, merge, or execution pipelines.
- Optimizer/executor decision flows.
- Space/time amplification and cost tradeoffs.
- Scenario architecture, bottleneck location, and observability paths.

Each SVG must be a self-contained `.svg` file, include `xmlns`, `viewBox`, `width`, `height`, `title`, and `desc`, and use readable Chinese labels. Add a nearby paragraph below the Markdown image explaining what the reader should learn from the figure.

GitHub rendering requirements:

- Do not put raw inline `<svg>` blocks in the Markdown body.
- Do not use JavaScript, `foreignObject`, external CSS, remote fonts, remote images, animation, or browser-dependent filters.
- Use basic SVG elements such as `rect`, `circle`, `line`, `path`, `text`, `g`, `marker`, and simple gradients only when they materially improve clarity.
- Keep all styles inside element attributes or a simple internal `<style>` block; avoid CSS that depends on page context.
- Escape special characters in labels, and keep text large enough to read in GitHub's rendered image view.
- Verify every referenced SVG file exists at the relative path used by the Markdown article.

Avoid decorative SVGs. Every SVG must explain structure, flow, comparison, state transition, cost, or decision logic.

## Style Rules

Write in Chinese.

Use a direct, practical technical style:

- Start from concrete business pain.
- Explain mechanisms from first principles.
- Use analogies only when they reduce cognitive cost.
- Prefer "为什么、怎么做、代价是什么、怎么验证" over abstract description.
- Be explicit about tradeoffs and limitations.

Every diagram must explain structure, flow, comparison, or decision logic. Avoid decorative diagrams.

Use GitHub-flavored Markdown: headings, paragraphs, lists, Markdown tables, fenced code blocks, blockquotes when needed, and relative links. Use raw HTML only when Markdown cannot express the structure and GitHub supports the tag safely.

## Source Handling

When references include source code, inspect relevant files instead of relying only on README text.

When references include papers, extract the algorithm, assumptions, limitations, and evaluation conditions.

When references include DeepWiki, use it to understand architecture, then verify important claims against source code or official docs when possible.

When references conflict, prefer primary sources and state the discrepancy.

## Validation Checklist

Before saving the final file, verify:

- The title matches the topic.
- The article links back to the database foundation course outline when available.
- The topic category is clear.
- Every major claim is backed by a source, code path, experiment, or clearly marked inference.
- Examples are syntactically correct.
- SQL examples are executable or explicitly marked as unexecuted.
- Performance numbers are not fabricated.
- Tradeoffs include both benefits and costs.
- Suitable and unsuitable scenarios are concrete.
- Cross-product comparison is technically fair.
- Terminology is consistent.
- Markdown renders correctly on GitHub.
- SVG diagrams are valid standalone files, visible through Markdown image links, and have readable labels.
- SVG files avoid GitHub-unsafe features such as JavaScript, `foreignObject`, external assets, and remote CSS.
- The article uses substantive SVGs wherever diagrams materially improve understanding.
- The final article is saved as a `.md` file, with referenced SVG assets saved beside it using stable relative paths.

## Final Response

After saving the Markdown file, reply with:

- Saved Markdown file path.
- Saved SVG asset directory or figure file paths.
- Main sources used.
- Whether examples were executed.
- Any unresolved uncertainty.

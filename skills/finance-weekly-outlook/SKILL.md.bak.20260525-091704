---
name: finance-weekly-outlook
description: Generate a source-backed weekly financial trading outlook from daily-finance, finance-core-analysis, and finance-explosive-article outputs plus fresh authoritative market data. Use when the user asks for future-one-week market outlook, weekly bullish/bearish sectors, stock picks, China A-share and US stock coverage, explicit buy/sell/hold trading plans, entry/exit levels, staged position sizing, sector rotation, or next-week investment opportunities; also use after the daily-finance → finance-core-analysis → finance-explosive-article pipeline when a concrete weekly action report is requested.
---

# Finance Weekly Outlook

## Overview

Generate a Markdown weekly outlook that identifies high-probability bullish and bearish industries and stocks for the next trading week, covering both US equities and China A-shares. The report must combine upstream finance articles, fresh authoritative data, market-behavior validation, expectation-gap reasoning, scenario falsification, and explicit trading action plans.

This skill is downstream of:

`daily-finance -> finance-core-analysis -> finance-explosive-article -> finance-weekly-outlook`

It can also run independently when upstream files are absent, but never invent missing data.

## Required Inputs

Prefer the newest available files in the current project's `markdown/` directory:

1. `markdown/daily-finance-YYYY-MM-DD.md`
2. `markdown/finance-core-analysis-YYYY-MM-DD.md`
3. `markdown/finance-explosive-article-YYYY-MM-DD.md`

If multiple dates exist, use the most recent trading-relevant date unless the user specifies a date. Preserve upstream facts and sources, but re-check any number used in the final thesis.

## Mandatory External Data Step

Always access current external data before writing a current weekly outlook. Use primary/authoritative sources where possible:

- Official: central banks, statistics agencies, exchanges, regulators, listed-company filings, investor relations, earnings releases
- Market data: exchange pages, ETF/fund issuer data, CBOE/FRED/Treasury/Nasdaq/NYSE, HKEX, SSE/SZSE, CSRC/PBOC, Wind/Eastmoney/同花顺 only when official data is unavailable
- News: Reuters, Bloomberg, FT, WSJ, 财新, 第一财经, 财经, 21世纪经济报道, 经济观察报

Read `references/data-checklist.md` when planning the data pull. Read `references/tradingagents-method.md` when structuring the reasoning and risk review.

Do not rely on self-media, unverified social posts, headlines without source traceability, or a single isolated stock example to support an industry conclusion.

## Workflow

### 1. Build the Fact Base

Extract upstream facts from daily/core/explosive articles, then add fresh data:

- Macro liquidity: Fed/PBOC signal, US 10Y, China 10Y, DXY, SHIBOR/DR007, Treasury/TGA or Fed balance-sheet context when relevant
- Risk appetite: VIX, put/call, market breadth, new highs/new lows, major index trend
- Capital flow: US sector ETF flow when available, A-share northbound/southbound if available, margin financing, main-board/STAR/ChiNext turnover structure
- Sector behavior: weekly relative strength vs S&P 500 and CSI 300, volume confirmation, support/resistance, breakout/failure
- Expectations and crowding: earnings revisions, revenue/EPS consensus direction, valuation percentile if available, fund positioning/crowdedness proxies
- Catalysts: earnings calendar, macro data calendar, policy events, product/order/legal/regulatory events

Tag data clearly:

- `【实】` confirmed actual data
- `【预】` market expectation or consensus
- `【估】` model/analyst estimate
- `【待】` reported but not independently verified; avoid using as core evidence

### 2. Decide Macro Positioning

State whether next week should be `偏进攻`, `中性偏进攻`, `中性偏防守`, or `偏防守`.

Use this chain:

`宏观约束 -> 资金行为 -> 风格偏好 -> 仓位上限 -> 证伪信号`

Do not say "risk appetite improves" without naming the observable variable that improved.

### 3. Select Bullish and Bearish Industries

Cover both US equities and A-shares. Output at least:

- 2-4 bullish industries across the two markets
- 2-4 bearish industries across the two markets
- At least one bullish and one bearish view for each market unless data quality makes this unsafe; if so, explain why

For each industry, require:

- Industry-level evidence, not only a single stock move
- Market-behavior validation: price, volume, relative strength, breadth, or fund flow
- Catalyst and expectation-gap judgment
- Assumptions and what changes if assumptions fail
- Crowding/overpricing risk check

Avoid hindsight logic:

- Do not mark a current hot theme bullish merely because it is hot.
- Do not mark a falling industry bearish merely because it fell.
- Ask: "what is not yet priced for the coming week?"

### 4. Select Stocks and Trading Plans

For each market, provide a small number of stock calls. Prefer quality over quantity:

- US equities: 2-4 stocks total, including bullish and bearish/avoid candidates
- A-shares: 2-4 stocks total, including bullish and bearish/avoid candidates

Each stock must include:

- Name, ticker/code, market
- Direction: buy/add/hold/reduce/sell/avoid/watch
- Thesis with 2-4 evidence points
- Three-factor score: earnings expectation, valuation/sentiment, liquidity/risk premium
- Expectation-gap quadrant:
  - Good news + high expectation = risk of "priced in"
  - Good news + low expectation = bullish catalyst
  - Bad news + high expectation = bearish shock
  - Bad news + low expectation = possible exhaustion/reversal
- Concrete action plan:
  - Entry trigger or buy zone
  - Staged position sizing
  - Stop-loss or invalidation level
  - Take-profit or reduction plan
  - Hold/sell/buy decision for existing positions
  - Daily tracking indicators and action timetable

If precise price levels are unavailable from reliable data, use technical conditions instead of fabricated numbers, such as "daily close above prior 20-day high with volume above 20-day average".

### 5. Run TradingAgents-Style Internal Review

Before finalizing, simulate these roles in writing or internally:

- Fundamental analyst: earnings, balance sheet, valuation, guidance
- News/policy analyst: catalysts, official data, regulatory and geopolitical events
- Technical/market analyst: trend, volume, breadth, support/resistance
- Bull researcher: best case and upside path
- Bear researcher: strongest counterargument and downside path
- Trader: translate thesis into action rules
- Risk manager: position sizing, invalidation, drawdown, correlated exposures

Use structured findings rather than long dialogue. The final article should show the result of the debate through assumptions, alternatives, and risk controls.

### 6. Validate Before Saving

Check:

- Every major number has a source.
- Dates, units, direction, actual vs expected, intraday vs close are correct.
- US and A-share coverage is explicit.
- Bullish and bearish views are both present.
- Industry calls have industry-level evidence.
- Stock calls include clear trading actions, not vague "关注".
- Each key thesis has assumptions and falsification signals.
- The report includes charts/tables/Mermaid diagrams.
- The article ends with a disclaimer.

If a claim cannot be verified, weaken it, label it, or remove it.

## Output Structure

Save the final Markdown to:

`markdown/finance-weekly-outlook-YYYY-MM-DD.md`

Use the report date, create `markdown/` if needed, and write UTF-8.

Required structure:

```markdown
# 未来一周中美股多空展望｜YYYY-MM-DD 至 YYYY-MM-DD

> 执行摘要：...

## 一、结论先行：下周仓位与主线

## 二、数据仪表盘

Include tables and at least one Mermaid diagram showing:
触发变量 -> 数据验证 -> 预期差 -> 交易计划 -> 证伪信号

## 三、行业多空矩阵

## 四、美股个股操盘计划

## 五、A股个股操盘计划

## 六、情景推演：前提、备选观点、证伪信号

## 七、下周关键日历与跟踪清单

## 八、数据来源

## 免责声明
本文仅供参考，不构成投资建议。市场有风险，投资需谨慎。文中观点基于公开信息、特定前提假设和当时可得数据，未来可能因宏观政策、流动性、财报、监管、地缘政治和市场情绪变化而失效。任何买入、卖出、持有或仓位安排都不应被视为个性化投资建议，投资者应结合自身风险承受能力独立决策。
```

## Writing Rules

- Write in Chinese unless the user requests another language.
- Be direct, structured, and source-backed.
- Use "不是A，而是B" only when it exposes a real mechanism mismatch.
- Do not overstate probability; use "基准情景/备选情景/尾部风险" instead of false certainty.
- Give explicit actions for individual stocks, but keep the disclaimer and assumption boundaries clear.
- Prefer concise tables over long prose where decisions need comparison.

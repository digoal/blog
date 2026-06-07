# 搜证查询模板库

> 这是 SKILL.md 步骤 2 的展开。每类情境给出具体的 `mcp__MiniMax__web_search` 查询字符串。
> **关键原则**:一次只搜 1-2 个查询,不要堆砌关键词;搜完后看 3-5 个 source 链接交叉验证。

## 通用搜索规则

```
查询结构:{ticker 或 公司名} + {时间修饰} + {信息类型} + {可选:对比/数据点}
```

例:
- ✅ `{ticker} earnings after-hours reaction`
- ✅ `AAPL 8-K filing March 2026`
- ❌ `AAPL earnings price target news analyst upgrade downgrade` (太杂)

---

## 类别 1:财报后盘后反应(P0,必须查)

```
{ticker} earnings after-hours
{ticker} Q{X} earnings results
{ticker} EPS beats misses consensus
{ticker} revenue guidance Q{X}
{ticker} conference call transcript
{ticker} 8-K filing earnings release
```

**抓取目标**:
- EPS actual vs consensus(找 "beats by $X" 或 "misses by $Y")
- Revenue actual vs consensus
- Guidance 上下调
- 盘后股价反应(after-hours % change)
- 高管电话会关键 quote

**典型数据格式**:
> "AAPL reported Q1 EPS of $1.50 vs $1.45 consensus, revenue $95B vs $94B expected. Q2 guidance $1.55-$1.60. Stock +5.2% in after-hours."

---

## 类别 2:盘后重大公告(P0)

```
{ticker} 8-K filing
{ticker} press release {关键词,如 buyback/M&A/lawsuit/FDA}
{ticker} SEC filing today
{ticker} material event announcement
```

**关注关键词**:
- "buyback authorization"
- "acquisition"
- "merger agreement"
- "FDA approval / rejection"
- "lawsuit filed / settled"
- "CEO / CFO resignation"
- "dividend increase / initiation"
- "guidance raised / lowered / suspended"

---

## 类别 3:隔夜大盘与期货(P0)

```
ES futures overnight today
S&P 500 futures premarket
Nasdaq futures NQ today
VIX index today
US 10 year Treasury yield today
DXY dollar index today
```

**抓取目标**(全部数字 + 时点):
- ES 期货涨跌幅(%,ET 时点)
- NQ 期货涨跌幅
- VIX 当前值 + 涨跌幅
- 10Y 收益率 + 涨跌幅
- DXY 当前值 + 涨跌幅

---

## 类别 4:宏观日历(P1)

```
US economic calendar this week
CPI release date time
FOMC meeting schedule {年份}
NFP non-farm payrolls release
PCE inflation data
PPI producer price index
```

**用途**:确认目标交易日是否有大事件,如有则概率区间放大/仓位减半。

---

## 类别 5:期权异动(P1)

```
{ticker} unusual options activity
{ticker} options flow today
{ticker} call put ratio
{ticker} open interest change
{ticker} large options order
{ticker} LEAPS activity
```

**关注信号**:
- 单笔 > 50 万美元的期权交易
- 远月(LEAPS)大单 = 机构行为
- OI 暴增的执行价 = 关键支撑/压力
- Put/Call 比率突变(> 1.5 或 < 0.3 异常)

**抓取目标**:大单的方向(Call/Put)、行权价、到期日、金额。

---

## 类别 6:内部人交易(P1)

```
{ticker} Form 4 insider trading
{ticker} insider buying selling today
{ticker} CEO CFO shares transaction
{ticker} director stock purchase
```

**抓取目标**:
- 交易人(CEO/CFO/Director)
- 方向(Buy/Sell)
- 金额($X)
- 交易日期

**关键判读**:
- $100K+ 增持 = 极强信号
- 高管集体减持 + 节奏加快 = 预警
- 多位董事同向增持 = 强信号

---

## 类别 7:分析师评级(P1)

```
{ticker} analyst upgrade downgrade today
{ticker} price target change
{ticker} Wall Street rating
{ticker} consensus price target
```

**抓取目标**:
- 评级变动(Buy/Hold/Sell)
- 目标价调整(尤其多家同向)
- 一致预期 consensus EPS / 目标价

---

## 类别 8:行业联动(P2)

```
{板块名} sector ETF performance today
{板块名} stocks news today
{权重股 ticker} news today
```

**典型关联**:
- 半导体:SOX、TSM、NVDA、AMD
- 科技大盘:M7(AAPL/MSFT/GOOGL/AMZN/META/TSLA/NVDA)
- 银行:JPM、BAC、WFC、KBE
- 能源:XLE、XOM、CVX、OXY
- 生物科技:XBI、IBB

---

## 类别 9:大宗与暗池(P2)

```
{ticker} block trade today
{ticker} dark pool activity
{ticker} large transaction SEC
```

**抓取目标**:单笔 > 10 万股或 > 2000 万美元的交易,溢价/折价 > 5% 的尤其关注。

---

## 类别 10:散户情绪(反向指标,P2)

```
{ticker} Reddit WSB discussion
{ticker} Stocktwits sentiment
{ticker} retail investor interest
AAII investor sentiment survey
CNN Fear and Greed Index
```

**判读规则**:
- 关注度激增 = 散户涌入 = 短期反向风险
- 极端恐惧(< 20) = 可能见底
- 极端贪婪(> 80) = 警惕

---

## 类别 11:技术面参考(P2,如搜不到可用 TradingView 等工具)

```
{ticker} technical analysis support resistance
{ticker} 200 day moving average
{ticker} chart pattern breakout
```

**注意**:技术面最好直接看行情软件(TradingView、富途、Bloomberg),搜索只能补充。

---

## 搜证时的 4 条铁律

1. **每次只搜 1-2 个查询,看完结果再搜下一批** — 不要堆关键词
2. **必须看 3-5 个独立 source 做交叉验证** — 单一来源不可信
3. **找不到原文 = 不存在** — Twitter/Reddit 传闻不能进决策
4. **失败要降级** — 如果 P0 搜不到,直接降级为"中低置信度",不要补全数据

---

## 常见搜证失败场景与应对

| 失败场景 | 应对 |
|---|---|
| 财报刚发布,新闻太多 | 优先看 SEC 8-K + 主流财经媒体(CNBC/Bloomberg/Reuters) |
| 期权异动数据搜不到 | 改用期权扫描平台(需订阅),或承认"信息缺失",置信度降级 |
| 中概股信息缺失 | 用 Wind/华尔街见闻补,标注来源差异 |
| 内部人数据滞后 | Form 4 是 T+2 披露,搜索加 "this week" 而不是 "today" |
| 大盘期货盘前数据缺 | 用 Investing.com / CNBC Pre-market 数据,标注时点 |

---

## 搜证输出格式(在 markdown 中如何呈现)

每条数据后面用 [n] 编号引用,文末"八、数据来源"列出链接:

```markdown
盘后股价 $208(+6.7%,2026-06-07 18:00 ET)[1]
EPS $1.50 vs $1.45 consensus, beats by $0.05[2]
10Y 收益率 4.32%(+5bp,2026-06-07)[3]
```

```markdown
## 数据来源
1. Yahoo Finance AAPL After-Hours: https://finance.yahoo.com/quote/AAPL/
2. SEC EDGAR 8-K: https://www.sec.gov/...
3. CNBC US 10Y Yield: https://www.cnbc.com/...
```

**注意**:链接必须是真实可达的 URL,不要伪造。

# Digoal Research 03: Expression DNA

## Scope

- Focus: phrasing, recurring framing, public short-form expression, and article openings/endings.
- Source policy: prefer primary writing and direct public posts.
- Main corpus: local mirror at `/Users/digoal/blog`, sampled across older PostgreSQL technical writing, community/product notes, `每天5分钟,PG聊通透`, `德说`, and recent analytical/teaching posts.
- Supplement: direct public profile/Q&A surface on Aliyun Developer Community. Excluded by policy: Zhihu, WeChat public-account pages, Baidu Baike, Baidu Zhidao.
- Evidence labels below:
  - `Primary`: digoal's own local blog/profile/post/Q&A surface.
  - `Secondary`: outside characterization of digoal. None was needed for this pass.
  - `Inference`: synthesis from repeated primary patterns; do not present as a quote or hard biographical fact.

## Findings

### Corpus Signals

| Observation | Evidence | Label | Confidence |
| --- | --- | --- | --- |
| The local blog is a large, long-running writing corpus rather than a handful of essays. | Local scan on 2026-05-22 found 7,444 Markdown files under `/Users/digoal/blog`; the root catalog currently lists posts through `202605`. | Primary | High |
| `背景` is the default article doorway. | Local scan found 7,112 Markdown files with a `## 背景` heading. Representative files: `/Users/digoal/blog/201709/20170921_01.md`, `/Users/digoal/blog/202112/20211220_04.md`, `/Users/digoal/blog/202605/20260522_01.md`. | Primary + Inference | High |
| References and distribution footers are repetitive parts of the publishing habit. | Local scan found 2,965 Markdown files with a `## 参考` heading and 3,428 with the `PostgreSQL 许愿链接` footer string; older and newer samples end with solution/profile/product links. | Primary + Inference | High |
| Explicit wrap-up headings exist, but are less universal than `背景` and `参考`. | Local scan found 506 Markdown files with `## 小结`; `/Users/digoal/blog/201709/20170921_01.md` uses a compact recap after a long technical derivation. | Primary + Inference | High |

### Core Expression DNA

#### 1. He starts from a problem, not from scene-setting

- `Primary`: The stable opening move is a short metadata block followed by `## 背景`. The `背景` may be one sentence, a checklist, a blunt position, or the problem itself.
- `Primary`: FAQ/teaching openings turn the reader's pain into explicit questions: `为什么`, `如何`, `到底`, `配置多少`, `会不会`. See `/Users/digoal/blog/202112/20211220_04.md`, `/Users/digoal/blog/202112/20211209_02.md`, and the root title catalog in `/Users/digoal/blog/README.md`.
- `Inference`: A digoal-style hook should quickly answer "what practical confusion are we clearing up?" or "what accepted story are we challenging?" Avoid slow literary warm-up.

#### 2. Recurring title and hook formulas

| Pattern | Evidence | Effect | Label | Confidence |
| --- | --- | --- | --- | --- |
| Question-title | `为什么增加连接不能无限提高TPS或QPS? 配置多少个链接合适?` in `/Users/digoal/blog/202112/20211220_04.md`; many `为什么`/`如何` titles in `/Users/digoal/blog/README.md`. | Promises diagnosis and decision guidance. | Primary | High |
| Practical recipe | `PostgreSQL 规格评估 - 微观、宏观、精准 多视角估算数据库性能(选型、做预算不求人)` in `/Users/digoal/blog/201709/20170921_01.md`. | Names audience value directly and compresses taxonomy into title. | Primary | High |
| Analogy-as-title | `为什么数据库选型和找对象一样重要` in `/Users/digoal/blog/202003/20200322_01.md`. | Makes a database decision legible through ordinary life. | Primary | High |
| Contrarian binary | `透明分布式是蜜糖还是毒药?` in `/Users/digoal/blog/202601/20260108_02.md`; `格式战已死` in `/Users/digoal/blog/202605/20260522_01.md`. | Creates tension before the mechanism is explained. | Primary | High |
| `不是 A, 而是 B` reframing | Recent root-catalog titles repeatedly use this structure, e.g. `/Users/digoal/blog/README.md` entries around `202605`. | Replaces a surface story with a deeper causal frame. | Primary + Inference | Medium-High |

Hook progression is usually one of these:

1. `Problem -> why the common intuition fails -> mechanism -> recommendation`.
2. `Provocative thesis -> three assumptions/constraints -> decomposition -> boundary conditions`.
3. `Concrete analogy -> mapped checklist -> practical selection rule`.

#### 3. Certainty is high on mechanisms, conditional on futures

- `Primary`: Technical prose often states mechanism plainly after narrowing the conditions. In `/Users/digoal/blog/202112/20211220_04.md`, the connection-count answer names network, CPU, memory, storage, response-time gaps, resource ceilings, and then ends with "要辩证的看待问题, 不能死板."
- `Primary`: Older decision posts leave blanks for reader context: `/Users/digoal/blog/202003/20200322_01.md` repeats "一定不完整, 请各位自行补充" around selection indicators.
- `Primary`: Recent analytical prose can open with a hard headline, then restore uncertainty through prerequisites or signals. `/Users/digoal/blog/202605/20260522_01.md` turns its Catalog-layer thesis into observable future signals and ends on an open question.
- `Primary`: `/Users/digoal/blog/202605/20260507_09.md` explicitly teaches "用可能性替代绝对化判断"; this aligns with the better-calibrated parts of the corpus but should not be used to erase the louder headline style.
- `Inference`: The skill should sound decisive when explaining a tested mechanism or a scoped tradeoff. For predictions, preserve conditionals, time horizon, evidence strength, and failure cases even when the title is sharp.

#### 4. Evidence habit: show the work

| Habit | Primary evidence | What to imitate |
| --- | --- | --- |
| Mechanism before verdict | `/Users/digoal/blog/201709/20170921_01.md` walks through PostgreSQL cost structure, execution-tree concepts, code references, and evaluation methods before its `小结`. | Explain the causal chain, not just the answer. |
| Reproducible artifacts | `/Users/digoal/blog/202112/20211209_02.md` uses SQL sessions, WAL positions, backup timelines, and a verification process in the backup discussion. | Use commands, SQL, code, diagrams, or metrics when available. |
| Checklists and taxonomies | `/Users/digoal/blog/202003/20200322_01.md` splits technical/business/ecosystem selection indicators; `/Users/digoal/blog/202103/20210329_01.md` maps community building with questions and stakeholder lists. | Turn vague decisions into inspectable dimensions. |
| Links and references | Thousands of local posts include `参考`; the root README asks readers to correct errors. | Leave source trails and correction room. |

`Inference`: Digoal's strongest evidence voice is not "trust me"; it is "here is the mechanism, the test or observable signal, the dimensions that matter, and the scoped conclusion."

#### 5. Phrasing and vocabulary

High-frequency lexical families in the sampled corpus:

- Database/operator vocabulary: `PG`, `PostgreSQL`, `PolarDB`, `SQL`, `QUERY`, `TPS`, `QPS`, `RT`, `WAL`, `索引`, `事务`, `内核`, `扩展`, `架构`, `选型`, `场景`, `成本`, `性能`, `生态`.
- Decision vocabulary: `为什么`, `如何`, `问题`, `分析`, `结论`, `建议`, `指标`, `模型`, `方法`, `价值`, `边界`, `机会`, `风险`, `闭环`.
- Community/product vocabulary: `用户`, `开发者`, `DBA`, `架构师`, `厂商`, `行业`, `社区`, `布道`, `人才`, `产品`, `市场`, `核心价值`.
- Recent analytical vocabulary: `AI`, `Agent`, `未来`, `护城河`, `控制平面`, `一等公民`, `信号`, `资产`, `数据`, `开源`, `云`.

Punctuation and cadence:

- `Primary`: Dense commas, parentheses, arrows, slash-like alternatives, numbered lists, and compact Chinese mixed with English technical tokens are normal.
- `Primary`: Rhetorical questions and short interjections occur: `为什么?`, `真的是这样吗?`, `那么...呢?`, `提醒一下`, `最后`.
- `Inference`: Preserve the pragmatic compressed cadence. Do not polish it into uniformly elegant essay prose or erase the bilingual technical tokens.

#### 6. Metaphor bank

| Metaphor family | Primary evidence | Use |
| --- | --- | --- |
| Everyday tradeoff analogies | Database selection mapped to finding a partner in `/Users/digoal/blog/202003/20200322_01.md`; connection pools mapped to bank VIP counters in `/Users/digoal/blog/202112/20211220_04.md`. | Explain architecture consequences to practitioners outside the narrow subsystem. |
| Physical/system constraints | Execution nodes as a relay race in `/Users/digoal/blog/201709/20170921_01.md`; resource ceilings and response-time gaps in `/Users/digoal/blog/202112/20211220_04.md`. | Make invisible database mechanisms concrete. |
| Competition/medicine/war framing | `蜜糖/毒药`, `战场`, `护城河`, `守门人` in `/Users/digoal/blog/202601/20260108_02.md` and `/Users/digoal/blog/202605/20260522_01.md`. | Add force to a strategic thesis after the constraints are stated. |
| Classical/moral register | `/Users/digoal/blog/me/readme.md` opens with Eastern-classic lines and the slogan around `公益`; `/Users/digoal/blog/202108/20210818_02.md` anchors `德说` with `德者...`. | Use sparingly for values/community voice, not as fake ornament in technical derivations. |

#### 7. Endings

- `Primary`: Technical posts commonly end with `小结`, `参考`, or a final practical rule. Examples: `/Users/digoal/blog/201709/20170921_01.md` recaps three evaluation methods; `/Users/digoal/blog/202112/20211220_04.md` ends with a dialectical warning after giving rough connection-count guidance.
- `Primary`: Blog distribution footers then point to PostgreSQL wishes, solution collections, profile/about pages, PolarDB learning material, or social contact surfaces.
- `Primary`: Strategic analysis may end by handing the reader a still-open question rather than a slogan. `/Users/digoal/blog/202605/20260522_01.md` closes by asking whether governance-layer lock-in fills the gap left by open storage formats.
- `Inference`: For the skill, the semantic ending matters more than copying link footers: end with a recommendation, boundary, recap, or next question.

### Public Short-Form Output

- `Primary`: The direct Aliyun Developer Community profile uses the compressed identity line `公益是一辈子的事, I am digoal, just do it.` and exposes a short Q&A surface alongside article/video activity: `https://developer.aliyun.com/profile/3x5dm5sgv4yq6`.
- `Primary`: The public Q&A examples on that profile answer with immediate action or a pointer, not ceremony: one answer says a superuser is needed to create an extension; another points a MySQL-pressure question straight toward PostgreSQL material.
- `Primary`: The local root README and `德说` index also function as short-form output: titles are mini-arguments optimized for scanning, often carrying audience, conflict, and conclusion in one line.
- `Inference`: In short-form mode, prefer `diagnosis + next action/link` over a long preamble. The strongest short hook is a useful compression of the long-form mechanism, not empty outrage.

### Period Shift and Voice Hygiene

- `Primary`: Older technical pieces and FAQ posts are heavily tutorial-shaped: `背景`, mechanism, examples/tests, references, links.
- `Primary`: The later `德说`/analysis surface uses more headline heat: contrarian absolutes, "future" stakes, `已死`, `毒药`, `真正`, `绝不是`, and `不是 A 而是 B` reframes appear in recent titles and samples.
- `Primary + Inference`: Some recent local posts visibly shift into dialogic analytical blocks after digoal's own framing. `/Users/digoal/blog/202601/20260127_22.md` moves from first-person blog setup into an expansion that directly addresses "你的结论"; treating that shift as generated-looking is an inference from the text, not an authorship fact.
- `Inference`: Treat long-running technical habits, self-authored framing, recurring catalogs, and direct Q&A as stronger DNA evidence than any one recent high-heat or generated-looking block.

### Taboo Overclaims for a Digoal Perspective Skill

These are guardrails inferred from the corpus, not quotes:

1. Do not turn a headline absolute into an evidence-free fact. If using `已死`, `终局`, `绝不是`, `唯一`, or `注定`, either keep it as hook rhetoric or immediately state the mechanism and scope.
2. Do not claim production suitability, performance superiority, cost savings, or market inevitability without a scenario, workload, comparison basis, or source trail.
3. Do not erase caveats the corpus itself preserves: `建议`, `可能`, `也许`, boundary conditions, assumptions, and reader correction requests are part of the voice.
4. Do not imitate distribution footers, awards, follower counts, or brand promotion as if they were reasoning.
5. Do not copy the hottest recent title voice into every answer. It is a mode, not the whole DNA.
6. Do not cite excluded surfaces for this skill research: Zhihu, WeChat public-account pages, Baidu Baike, Baidu Zhidao.

### Practical Style Recipe

`Inference`, high confidence:

1. Open with `背景` in spirit: name the live confusion, decision, or false intuition.
2. Ask the reader's operative question in plain language.
3. State a scoped stance early.
4. Decompose by mechanism, cost, dimensions, and boundary conditions.
5. Use a checklist, taxonomy, SQL/code/test trail, diagram, metric, or observable signal where the claim needs weight.
6. Use one concrete analogy when it lowers explanation cost.
7. End with a recommendation, recap, boundary, or question that keeps the reader practical.

## Sources

### Primary Local Sources

| Source | Why used | Confidence |
| --- | --- | --- |
| `/Users/digoal/blog/README.md` | Root catalog, title formulas, correction request, public distribution posture. | High |
| `/Users/digoal/blog/me/readme.md` | Self-profile, values register, `公益` slogan, public-channel map. | High |
| `/Users/digoal/blog/201709/20170921_01.md` | Older long technical derivation, execution-cost explanation, `小结`, reference/footer habit. | High |
| `/Users/digoal/blog/202003/20200322_01.md` | Everyday analogy, decision checklist, explicit incompleteness caveat. | High |
| `/Users/digoal/blog/202103/20210329_01.md` | Community/product framing, long stakeholder decomposition, question-led planning vocabulary. | High |
| `/Users/digoal/blog/202108/20210818_02.md` | `德说` index and value anchor. | High |
| `/Users/digoal/blog/202112/20211209_02.md` | FAQ series template, problem/analysis/conclusion framing, SQL/test-backed explanation. | High |
| `/Users/digoal/blog/202112/20211220_04.md` | FAQ cadence, resource-bound reasoning, bank-counter analogy, explicit anti-dogma ending. | High |
| `/Users/digoal/blog/202601/20260108_02.md` | Recent `德说` thesis heat, assumptions-first argument, `蜜糖/毒药` metaphor. | Medium-High |
| `/Users/digoal/blog/202601/20260127_22.md` | Recent future-facing piece with a visible shift from first-person framing into dialogic analytical expansion. | Medium |
| `/Users/digoal/blog/202605/20260507_09.md` | Recent probability/uncertainty teaching register. | Medium-High |
| `/Users/digoal/blog/202605/20260522_01.md` | Recent analytical hook, evidence-with-signals style, open-question ending. | Medium-High |

### Primary Public URLs

| URL | Why used | Confidence |
| --- | --- | --- |
| `https://github.com/digoal/blog` | Public home of the main writing corpus and public profile surface for the repository. | High |
| `https://developer.aliyun.com/profile/3x5dm5sgv4yq6` | Direct public profile and short Q&A/post surface. | Medium-High |

### Secondary Sources

- None used. The local blog corpus and direct public surfaces were sufficient for this expression-DNA pass.

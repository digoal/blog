# Digoal Research 01: Writings

## Scope

- Focus: books, long-form posts, systematic technical essays, repeated concepts.
- Source policy: prefer digoal's own blog, public profiles, repositories, and direct writing.
- Primary corpus used first: local `/Users/digoal/blog`, especially `me/readme.md`, `README.md`, `class/35.md`, the `德说` index, and dated posts linked from those indexes.
- Exclusions honored: no Zhihu, WeChat public-account pages, Baidu Baike, or Baidu Zhidao were used as research sources. Some local posts link to excluded sites in their own references; those links were not relied on here.
- Source labels below mean:
  - `Primary`: digoal-authored local post or his public repository/index.
  - `Secondary`: a public profile/index written or curated outside the local post under review.
  - `Inference`: synthesis from repeated primary evidence, not a quote or explicit self-description.

## Findings

### Corpus Shape

`me/readme.md` names the main self-curated paths for this dimension: the technical blog, `德说`, and `最近的一些思考` (`class/35.md`). The root `README.md` confirms a long-running corpus that is not only PostgreSQL technique: it indexes training curricula, best-practice compendia, community/product essays, AI and DuckDB writing, book notes, and `思维筑基课`/`数据库筑基课` series. The public GitHub repository description also frames the corpus as "Opensource,Database,AI,Business,Minds", which matches the local source spread. `[Primary: /Users/digoal/blog/me/readme.md; /Users/digoal/blog/README.md; /Users/digoal/blog/class/35.md; https://github.com/digoal/blog | Confidence: high]`

For mental-model extraction, the writings divide into four useful strata:

| Stratum | Representative primary writing | Why it matters |
|---|---|---|
| Applied database systems | `201702/20170209_01.md` ("大象十八摸"), `201706/20170601_02.md` ("如来神掌"), `202409/20240914_01.md` ("数据库筑基课") | He repeatedly turns product capability into scenario taxonomies and learning maps. |
| Community/product/ecosystem analysis | `202003/20200321_01.md`, `202004/20200426_01.md`, `202103/20210329_01.md`, `202007/20200727_04.md` | The writing names actors, value flows, incentives, metrics, operating loops, and failure modes. |
| Explicit thinking-method writing | `202104/20210414_04.md`, `202206/20220610_01.md`, `202210/20221001_03.md`, `202211/20221116_03.md` | These posts state his preferred abstractions: evidence ladders, axioms, base assumptions, supply-demand links, images/models. |
| Cross-domain public notebook | `202108/20210818_02.md` (`德说` index), the "人生最重要的事" posts, and newer `思维筑基课` indexes/posts | The same framework-seeking habit is applied to careers, AI, society, economics, classics, and personal legacy. |

### Repeated Long-Form Moves

1. **Start from a live problem, then widen the frame.** In the technical posts, the start is usually a concrete business pain or workload: multi-field search, streaming IoT data, location search, application developers failing to release database potential. In community posts, the start is a practical question such as why enterprises should contribute cases, why the PG community growth loop slows, or how community strategy should be decomposed. He then widens to scenario, stakeholder, incentive, and operating model. `[Primary: /Users/digoal/blog/201702/20170209_01.md; /Users/digoal/blog/201706/20170601_02.md; /Users/digoal/blog/202003/20200321_01.md; /Users/digoal/blog/202004/20200426_01.md; /Users/digoal/blog/202409/20240914_01.md | Confidence: high]`

2. **Prefer reusable methods over isolated skill.** The post "没有方法论的技能 无法 稳定发挥 它的应有价值" says this directly: technical skill without a method/system cannot reliably scale its value. His own long posts follow that rule by converting experience into checklists, question chains, taxonomies, metrics, and named frameworks. `[Primary: /Users/digoal/blog/202103/20210329_02.md | Confidence: high]`

3. **Use question chains as analysis engines.** "为什么企业应该参与PG社区建设?" is written almost entirely as numbered questions whose answers form a causal chain from enterprise database dependence to case sharing and ecosystem health. "五看三定" community writing similarly walks from purpose, users, opponents, self-assessment, direction, goals, strategy, and landing guidance. `[Primary: /Users/digoal/blog/202003/20200321_01.md; /Users/digoal/blog/202103/20210329_01.md | Confidence: high]`

4. **Tie abstraction back to proof or measurability.** The compact 2021 decision note ranks support for a viewpoint as `数据 -> 案例 -> 逻辑 -> 理想理念`. Community essays ask for north-star metrics, user counts, content counts, activity measures, conversion loops, ROI, and repeatability. The 2022 "公理体系" post still asks a reader to extract viewpoint, purpose, data, cases, logic, and base assumptions from classics. `[Primary: /Users/digoal/blog/202104/20210414_04.md; /Users/digoal/blog/202004/20200426_01.md; /Users/digoal/blog/202103/20210329_01.md; /Users/digoal/blog/202206/20220610_01.md | Confidence: high]`

5. **Cross domains by carrying a small set of models.** In `德说`, `供需连`, `公理体系`, `第一性原理`, `生态`, `产品`, `势差/能量`, `求存`, `知行合一`, and `目标/需求/结果` recur across open source, products, teams, education, classics, AI, and personal advice. This is stronger evidence of a mental-model lattice than any single aphorism. `[Primary: /Users/digoal/blog/202108/20210818_02.md; /Users/digoal/blog/202206/20220610_01.md; /Users/digoal/blog/202210/20221001_03.md; /Users/digoal/blog/202211/20221116_03.md | Confidence: high]`

### Recurring Concepts With Evidence

| Concept | Direct writing evidence | Mental-model signal | Source status |
|---|---|---|---|
| `公理体系`, `基石假设`, logic that can update | "人生最重要的事3" says good readers extract axioms and supporting data/cases/logic, inspect base assumptions, and update axioms when premises break. The 2026 AI axiom course repeats the same "bottom rules under changing products" posture. | He seeks underlying rules that can migrate across surfaces, but treats their premises as revisable. | `[Primary: /Users/digoal/blog/202206/20220610_01.md; /Users/digoal/blog/202605/20260519_57.md | Confidence: high]` |
| Evidence ladder | A short decision post places data before cases, cases before self-consistent logic, and logic before ideals. | In a perspective skill, avoid pure slogan output; his better writing tries to show evidence tier and proof burden. | `[Primary: /Users/digoal/blog/202104/20210414_04.md | Confidence: high]` |
| `生态思维` as `供需连` | "人生最重要的事5" defines ecology thinking as examining all participants' supply and demand and connecting them to create value. "成象能力" uses `供需连` to map books, ecosystems, database optimization, pharmacology, and relationships. | His system view is relational and value-flow oriented, not just component decomposition. | `[Primary: /Users/digoal/blog/202210/20221001_03.md; /Users/digoal/blog/202211/20221116_03.md | Confidence: high]` |
| Product/strategy operationalization | He repeatedly applies `五看三定四配` to community and product planning: look at industry/customer/opponents/self/policy or technology, set goals/strategy/methods, then match organization/talent/funds/tools. | Strategy is expected to land in operating resources and measurable action. | `[Primary with borrowed framework context: /Users/digoal/blog/202103/20210329_01.md; /Users/digoal/blog/202210/20221001_03.md | Confidence: high for repeated use, medium for originality]` |
| Ecosystem incentives | Community and open-source essays ask who benefits, who contributes, what each actor wants, what makes collaboration durable, and how licenses/cloud/support vendors reshape PG incentives. | He reasons through stakeholder alignment and the durability of positive-sum loops. | `[Primary: /Users/digoal/blog/202003/20200321_01.md; /Users/digoal/blog/202004/20200426_01.md; /Users/digoal/blog/202007/20200727_04.md | Confidence: high]` |
| "Dao and tools" | The `开慧社` announcement contrasts open source as visible code/`术` with open wisdom as logic/`道`, and says development needs both. "公理体系" also distinguishes skill from logic/`道`. | Do not model him as only a tool expert; he explicitly searches for the logic that governs tool choice and learning. | `[Primary: /Users/digoal/blog/202106/20210618_01.md; /Users/digoal/blog/202206/20220610_01.md | Confidence: high]` |
| Scenario-first technical teaching | "大象十八摸" extracts PG use scenarios for architects/developers. "如来神掌" groups years of PG/Greenplum work into cases, diagnostics, principles, selection, development, backup, security, and DBA practice. "数据库筑基课" remaps core database knowledge around what application developers must understand to store and fetch data correctly and quickly. | Technical competence is narrated as a scenario map and curriculum, not as isolated feature trivia. | `[Primary: /Users/digoal/blog/201702/20170209_01.md; /Users/digoal/blog/201706/20170601_02.md; /Users/digoal/blog/202409/20240914_01.md | Confidence: high]` |
| Legacy and formation | The "人生最重要的事" sequence names love/dedication, positioning, axioms/logic, ecology/product thinking,知行合一,成象, goals, threshold-breaking, and inheritance. The 2025 summary explicitly treats `德说`, especially this sequence, as something to leave to later readers. | Personal writing is not detached inspiration; it tries to form a transmissible curriculum for judgment and action. | `[Primary: /Users/digoal/blog/202505/20250529_01.md; /Users/digoal/blog/202108/20210818_02.md | Confidence: high]` |

### Terms And Series Worth Carrying Forward

| Term/series | Evidence and note | Originality caution |
|---|---|---|
| `德说` | Long-running self-branded index; by May 2026 the root index and `德说` index show it spanning database, open source, AI, macro/finance, career, society, classics, and personal advice. The name is tied in the index to "德者, 人之所得, 使万物各得其所欲." | Self-branded series. Treat each dated post as primary, but do not assume every claim in it is settled fact. `[Primary: /Users/digoal/blog/202108/20210818_02.md; /Users/digoal/blog/me/readme.md | Confidence: high]` |
| `开慧` / `show me your logic` | Paired with `开源` / `show me your code`: open wisdom is the invisible logic layer that should complement visible code. | Strong local naming signal. Background material in that post also borrows external `哲科思维` discussion. `[Primary: /Users/digoal/blog/202106/20210618_01.md | Confidence: high]` |
| `供需连` | Compact shorthand for supply, demand, and connections across actors. | Repeated local shorthand; this research did not prove coinage. `[Primary: /Users/digoal/blog/202210/20221001_03.md; /Users/digoal/blog/202211/20221116_03.md; /Users/digoal/blog/202108/20210818_02.md | Confidence: high for recurrence, low for coinage]` |
| `成象能力` | Turn a complex text/system into a picture of components, relations, energy/value flows, assumptions, and validation. | The post mixes modern system modeling with Chinese-classics metaphors; preserve that blend instead of sanitizing it away. `[Primary: /Users/digoal/blog/202211/20221116_03.md | Confidence: high]` |
| `大象十八摸`, `如来神掌` | Martial-arts/PG metaphors for broad scenario and best-practice maps. | Clearly his packaging of technical compendia in the sampled posts. `[Primary: /Users/digoal/blog/201702/20170209_01.md; /Users/digoal/blog/201706/20170601_02.md | Confidence: high]` |
| `数据库筑基课`, `思维筑基课` | Newer course-style indexes decompose a domain into foundations, axioms, maps, and applications. | Strong current series signal; verify which posts are hand-written, AI-assisted, or skill-generated before treating expression style as pure author voice. `数据库筑基课` explicitly labels some later links as skill-generated. `[Primary: /Users/digoal/blog/202409/20240914_01.md; /Users/digoal/blog/202605/20260519_57.md | Confidence: high for series existence, medium for voice attribution]` |

### Writing Evidence Relevant To Perspective Extraction

- **Default lens:** find the underlying system, then ask which base assumption, demand, actor, resource, metric, and loop controls it. This is an inference from the repeated community/product/personal method posts, not a direct quote. `[Inference from primary: /Users/digoal/blog/202003/20200321_01.md; /Users/digoal/blog/202004/20200426_01.md; /Users/digoal/blog/202206/20220610_01.md; /Users/digoal/blog/202210/20221001_03.md | Confidence: high]`
- **Default writing construction:** state a problem or sharp question, widen to framework, enumerate actors/conditions, then compress into a reusable title, table, list, or named method. `[Inference from primary: /Users/digoal/blog/201702/20170209_01.md; /Users/digoal/blog/202003/20200321_01.md; /Users/digoal/blog/202103/20210329_01.md; /Users/digoal/blog/202409/20240914_01.md | Confidence: high]`
- **Preferred test for insight:** does it travel? The same models are moved from PG community to products, careers, AI, classics, and teams. `[Inference from primary: /Users/digoal/blog/202108/20210818_02.md; /Users/digoal/blog/202210/20221001_03.md; /Users/digoal/blog/202211/20221116_03.md | Confidence: high]`
- **Audience posture:** technical writing often addresses architects, application developers, DBAs, product/community operators, or future learners directly. Personal writing shifts toward formation, inheritance, and "what matters" without abandoning frameworks. `[Inference from primary: /Users/digoal/blog/201702/20170209_01.md; /Users/digoal/blog/201706/20170601_02.md; /Users/digoal/blog/202409/20240914_01.md; /Users/digoal/blog/202505/20250529_01.md | Confidence: high]`

### Tensions And Contradictions To Preserve

1. **Empirical ranking vs axiom ambition.** He explicitly ranks data/cases over logic/ideals when supporting a decision, yet also pushes readers to build axioms and reason from base assumptions. A good skill should express both: use axioms to orient and evidence to constrain. `[Primary: /Users/digoal/blog/202104/20210414_04.md; /Users/digoal/blog/202206/20220610_01.md | Confidence: high]`
2. **Public-good language vs commercial-operating realism.** Community values include openness, fairness, persistence, public benefit, and not becoming a money slave; the same community writing spends substantial space on monetization, traffic, recruitment, buyer reach, metrics, and partner incentives. This is not necessarily hypocrisy; it is a durable tension in his ecosystem reasoning. `[Primary: /Users/digoal/blog/202103/20210329_01.md; /Users/digoal/blog/202004/20200426_01.md | Confidence: high]`
3. **Hard technical specificity vs expansive metaphysical analogy.** The technical corpus is dense with SQL/index/plugin/scenario detail. `德说` and method posts also draw from religion, classics, energy/entropy metaphors, philosophy, and civilizational narratives. Flattening either side would lose the author pattern. `[Primary: /Users/digoal/blog/201706/20170601_02.md; /Users/digoal/blog/202108/20210818_02.md; /Users/digoal/blog/202211/20221116_03.md | Confidence: high]`
4. **Borrowed lenses vs local recombination.** `哲科思维`, first-principles discussion, `五看三定四配`, classical citations, and various book-derived models are often acknowledged or linked to outside sources. The distinctive writing evidence is less "invented every concept" and more "recombine a model into PG/community/product/personal operating guidance." `[Primary: /Users/digoal/blog/202103/20210329_01.md; /Users/digoal/blog/202103/20210329_02.md; /Users/digoal/blog/202106/20210618_01.md; /Users/digoal/blog/202206/20220610_01.md | Confidence: high]`

### Candidate Mental Models For Later Skill Synthesis

| Candidate | Evidence basis | Confidence |
|---|---|---|
| **Axiom and premise ladder**: surface phenomenon -> base assumption -> logic -> data/case check -> premise update | Explicit in `20220610_01`; reinforced by the decision evidence ladder and newer axiom courses. | High |
| **Supply-demand-link ecosystem map**: list actors, needs, contributions, links, metrics, and durability of the loop | Explicit in `20221001_03`; operationalized in community/product essays. | High |
| **Scenario-to-curriculum compression**: turn experience into a named map learners and operators can traverse | Repeated in "大象十八摸", "如来神掌", `数据库筑基课`, root README learning indexes. | High |
| **Open wisdom with open code**: use code sharing plus logic sharing to build talent/ecosystem growth | Explicit in `开慧社` announcement and profile/index emphasis on community education. | Medium-high |
| **Formation over hot takes**: personal writing aims at inheritable judgment, not only topical commentary | Explicit in "人生最重要的事" summary; visible across `德说` series design. | Medium-high |

### Research Boundary Notes

- The sampled `202102/20210214_01.md` "哲科思维 与 思维模型" is marked `转载`; it is useful context for vocabulary later reused by digoal but should not be treated as primary evidence of his original long-form argument.
- The sampled `202103/20210329_01.md` starts with an external `五看三定四配` explanation and then applies it to PG community construction. Use the application as direct evidence; treat framework origin claims cautiously.
- The public Aliyun "传说中的德哥" page is useful as a secondary corroborating profile for his columns and public teaching role, but the local blog is the stronger primary writing corpus. `[Secondary: https://developer.aliyun.com/group/dege/ | Confidence: medium]`

## Sources

### Primary Local Corpus

| Path | Why sampled | Confidence |
|---|---|---|
| `/Users/digoal/blog/me/readme.md` | Self-profile; points to `德说` and recent thinking indexes; records writing/public-teaching scope. | High |
| `/Users/digoal/blog/README.md` | Root corpus index across technical curricula, reading notes, `德说`, AI, DuckDB, and newer course series. | High |
| `/Users/digoal/blog/class/35.md` | Curated `思维精进` index for product, community, strategy, cognition, and open-source essays. | High |
| `/Users/digoal/blog/202108/20210818_02.md` | `德说` index and breadth signal. | High |
| `/Users/digoal/blog/201702/20170209_01.md` | Scenario extraction in "大象十八摸". | High |
| `/Users/digoal/blog/201706/20170601_02.md` | Best-practice compendium and technical curriculum in "如来神掌". | High |
| `/Users/digoal/blog/202003/20200321_01.md` | Question-chain ecosystem reasoning about enterprise PG participation. | High |
| `/Users/digoal/blog/202004/20200426_01.md` | Community diagnosis with actors, metrics, strategy, and monetization loop. | High |
| `/Users/digoal/blog/202007/20200727_04.md` | Incentive analysis of PG open APIs, extensions, licenses, cloud/support vendors. | High for the author reasoning; claims about market outcome need later verification if reused. |
| `/Users/digoal/blog/202103/20210329_01.md` | `五看三定` applied to PG community planning. | High for application; medium for framework originality. |
| `/Users/digoal/blog/202103/20210329_02.md` | Explicit method-over-isolated-skill statement. | High |
| `/Users/digoal/blog/202104/20210414_04.md` | Compact evidence ladder for decisions and viewpoints. | High |
| `/Users/digoal/blog/202106/20210618_01.md` | `开慧`, open code/open logic, `道`/`术` pairing. | High |
| `/Users/digoal/blog/202206/20220610_01.md` | Explicit axiom system/base-assumption/logic post. | High |
| `/Users/digoal/blog/202210/20221001_03.md` | Explicit `供需连`, ecology thinking, product thinking, result orientation. | High |
| `/Users/digoal/blog/202211/20221116_03.md` | `成象能力`; cross-domain systems imaging. | High |
| `/Users/digoal/blog/202409/20240914_01.md` | Newer database foundations curriculum for application developers. | High |
| `/Users/digoal/blog/202505/20250529_01.md` | Personal legacy framing and `人生最重要的事` sequence. | High |
| `/Users/digoal/blog/202605/20260519_57.md` | Current `思维筑基课` axiom-course pattern in AI writing. | Medium-high; retain the note that newer posts may be tool/AI assisted unless verified. |

### Public Supplements

| URL | Source type | Use | Confidence |
|---|---|---|---|
| `https://github.com/digoal/blog` | Primary public repository page | Public corroboration of the local repository scope and identity. | High |
| `https://developer.aliyun.com/group/dege/` | Secondary public profile/index | Corroborates public teaching/column context such as `德说`, open-source/database focus, and training role. | Medium |

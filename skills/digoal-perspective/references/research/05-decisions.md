# Digoal Research 05: Decisions

## Scope

- Focus: visible career moves, open-source/community choices, publishing strategy, and repeated action patterns.
- Source policy: prefer dated public evidence over speculation.
- Evidence policy for this pass: prioritize digoal's own dated blog/profile records, GitHub profile/repositories/issues, and direct public source pages. Exclude Zhihu, WeChat public-account pages, Baidu Baike, and Baidu Zhidao as evidence.

## Findings

### Readout

- The most visible decision arc is not a sequence of unrelated job titles. The dated self-profile moves from operational database work and a PostgreSQL bet at SkyMobi, to Alibaba Cloud architecture, to product ownership, to PolarDB/open-source ecosystem work, and in April 2026 to an open-source database alliance role. That sequence is evidence of a repeated choice to scale PostgreSQL and database impact through larger leverage surfaces.
- Digoal repeatedly turns adoption problems into public mechanisms: training series, experiment manuals, GitHub issues for feature requests or scenario contributions, public courses, ecosystem maps, and AI skills. His actions are more diagnostic than "content creator" alone.
- AI/Skills is an action shift, not only a topic shift. The public trail includes a 2025 AI-assisted kernel-learning course, a January 2026 reflection on skill memory and reuse, a February 2026 PostgreSQL inspection skill released as code, and 2026 posts that describe distilling his own blog into a skill and treating skill writing as a basic AI capability.

### 1. Career Moves Show A Search For Leverage

**Evidence**

- **2005.7-2008.5**: the self-profile says the qware period was pre-sales work on public-sector projects and that he self-studied Oracle while sharing via live education. This is the earliest visible pattern of learning while teaching. Source: `/Users/digoal/blog/me/readme.md`. Confidence: high for the self-reported chronology; medium for the pattern interpretation.
- **2008.5-2015.7**: at SkyMobi the profile says he joined during startup growth, built database/storage/OS/multi-IDC foundations, led standardization, and moved core systems "from Oracle to PG" before listing. This is a concrete early technology bet under production pressure, not only later PostgreSQL advocacy. Source: `/Users/digoal/blog/me/readme.md`. Confidence: high that digoal reports this; medium for details not independently checked here.
- **2015.7**: the profile says he joined Alibaba Cloud's database kernel group for RDS PostgreSQL and HybridDB for PostgreSQL architecture and customer/internal solution work. Source: `/Users/digoal/blog/me/readme.md`. Confidence: high.
- **2018.10 and 2019.10**: the same profile says he moved into the Alibaba Cloud database product team in October 2018 for PostgreSQL product planning, design, and ecosystem work, then in October 2019 focused fully on the PostgreSQL vertical product. It also states the joining intent as taking PostgreSQL to more enterprises. Source: `/Users/digoal/blog/me/readme.md`. Confidence: high for stated dates and motive as self-report.
- **2021.8-2023.10**: the profile places him in architecture/open-source product and operations work, including "PolarDB open-source community framework" and explicit ecosystem collaboration mechanisms. **2023.10-2026.4** is labeled operations/brand plus PolarDB open-source cooperation and commercial promotion. Source: `/Users/digoal/blog/me/readme.md`. Confidence: high.
- **2026.4 onward**: the profile lists a Database Open Source Development Alliance/COSDA council role and dates the alliance establishment event to **2026-04-27**. Source: `/Users/digoal/blog/me/readme.md`; direct public GitHub rendering of the same profile: `https://github.com/digoal/blog/blob/master/me/readme.md`. Confidence: high for the self-published current record.

**Inference**

- The career decisions repeatedly move closer to distribution and coordination: system builder -> cloud architecture -> product -> community/ecosystem operations -> alliance. This suggests a judgment that technical merit alone does not make a database win; adoption channels, talent, cases, ecosystem, and institutional coordination matter. Confidence: medium-high because the direction is visible in dated roles and repeated writings, while internal alternatives considered are not public.
- The SkyMobi PostgreSQL migration plus the stated Alibaba Cloud joining intent make his PostgreSQL advocacy action-backed. This should be treated as stronger evidence than later slogans alone. Confidence: medium-high.

### 2. Community And Product Choices Turn Users Into Ecosystem Inputs

**Evidence**

- On **2020-08-21** he opened GitHub issue #76 as a PostgreSQL feature "wish wall" with a structured template for industry, desired function, solved problem, urgency, company/scale, business logic, and pain points; the issue says requests will be passed to kernel hackers and database vendors. Source: `https://github.com/digoal/blog/issues/76`. Confidence: high.
- In the **2021-2023** role description he frames open-source work as aligning business parties and ecosystem co-builders on value, goals, paths, and collaboration mechanisms, not merely publishing code. Source: `/Users/digoal/blog/me/readme.md`. Confidence: high for the stated responsibility.
- The **2023-08-22** immersive PostgreSQL/PolarDB learning overview invites application developers to contribute scenarios in a GitHub issue and pairs the material with cloud labs and Docker images. Source: `/Users/digoal/blog/202308/20230822_02.md`. Confidence: high.
- The **2023-10-30** public-course outline deliberately spans application scenarios, PostgreSQL and PolarDB open-source content, ecosystem products, commercial features, open-source collaboration, training/certification, contests, and contribution paths such as issues, code review, bug fixes, and independent projects. Source: `/Users/digoal/blog/202310/20231030_02.md`. Confidence: high.

**Inference**

- His ecosystem judgment is to reduce friction on both sides of adoption: users get cases, labs, images, curricula, and answer channels; maintainers/product teams get structured feedback, contributors, ecosystem partners, and talent. Confidence: high because the public artifacts implement those loops.
- Product and community are not separated in his public work. The PolarDB course mixes community version knowledge, commercial-version knowledge, ecology, certification, and contribution behavior. That mix is a deliberate bridge if read charitably, and a commercial/community tension if read critically. Preserve both readings. Confidence: high for the mix; medium for intent.

### 3. Publishing Strategy Is Serial, Indexed, And Audience-Aware

**Evidence**

- The blog README leads with categorized learning videos, learning materials, thought/community pieces, classification tables, and then an all-documents index. It explicitly welcomes reposting with attribution and asks readers to discuss errors through issues or direct contact. Source: `/Users/digoal/blog/README.md`. Confidence: high.
- The self-profile says he has long written across product use, cases, development practice, kernel practice, management, and tuning, has given recurring public PostgreSQL training, built a PostgreSQL discussion group, and connected to database newsletters for PostgreSQL news/trend reporting. Source: `/Users/digoal/blog/me/readme.md`. Confidence: high for self-report.
- The public course and immersive-learning posts are index pages for many linked parts rather than isolated essays. The AI-assisted kernel-learning post on **2025-02-18** also starts as a curriculum/index and lists its own rolling series. Sources: `/Users/digoal/blog/202310/20231030_02.md`, `/Users/digoal/blog/202308/20230822_02.md`, `/Users/digoal/blog/202502/20250218_03.md`. Confidence: high.

**Inference**

- He publishes to create a navigable corpus and adoption funnel, not only to log discoveries. Repeated index pages, audience labels, exercises, videos, Docker/lab choices, and calls for contribution support that. Confidence: high.
- The publishing unit often becomes a reusable route: scenario -> experiment -> course -> community feedback -> product/ecosystem adoption. That is a useful Digoal perspective heuristic to test elsewhere in the corpus. Confidence: medium-high.

### 4. AI And Skills Adoption Moves From Experiment To Reusable Asset

**Evidence**

- On **2025-02-18** he says he wants to lower the barrier for database-kernel self-learning and has already started using AI to build a PolarDB/PostgreSQL kernel-learning course. The post lists a growing AI-assisted series and links the effort to contributor/talent growth. Source: `/Users/digoal/blog/202502/20250218_03.md`. Confidence: high.
- On **2026-01-19** he writes about Agent Skills as planning, memory, tooling, and action; he describes using Gemini CLI and Qwen Coder for repeated document workflows and identifies the missing piece as experience reuse. Source: `/Users/digoal/blog/202601/20260119_01.md`. Confidence: high.
- On **2026-02-04** he says he used Gemini and OpenCode to make a PostgreSQL daily-inspection Agent Skill, released the code at `https://github.com/digoal/postgres_skill/`, tested it on PostgreSQL 18, and planned further skill iteration. The GitHub repository README exposes PostgreSQL and PolarDB daily-check skills plus a PostgreSQL BI analysis skill. Sources: `/Users/digoal/blog/202602/20260204_01.md`, `https://github.com/digoal/postgres_skill`. Confidence: high.
- On **2026-04-15** he describes adding a `digoal` skill made with Codex Skill Creator by distilling decades of his blog, and on **2026-05-15** he links "my SKILL" and says skill writing is a basic capability for controlling AI tools. Sources: `/Users/digoal/blog/202604/20260415_05.md`, `/Users/digoal/blog/202605/20260515_01.md`. Confidence: high.
- The GitHub profile currently pins `blog` and `postgres_skill`; the profile bio points back to the blog and frames public work with "公益是一辈子的事". Source: `https://github.com/digoal`. Confidence: high as a current public profile snapshot checked on 2026-05-22.

**Inference**

- His AI judgment is practical: adopt AI when it can lower expertise acquisition cost or package expert procedure into portable assets. He moves from AI-assisted learning content to skill repos and self-distillation of the blog. Confidence: high.
- The "skill" move fits his earlier publishing pattern. A course lowers reading friction; a Docker/lab asset lowers experiment friction; a skill lowers execution/reuse friction. Confidence: medium-high.

### 5. Open-Source Work Uses GitHub As A Knowledge And Feedback Surface

**Evidence**

- The GitHub profile currently shows the `blog` repository as a pinned public repository with an OpenSource/Database/AI/Business/Minds description and also pins `postgres_skill`. Source: `https://github.com/digoal`. Confidence: high as checked on 2026-05-22.
- The blog README is a public index with issues/discussion affordances, while issue #76 is a long-lived structured request channel for PostgreSQL functions. Sources: `/Users/digoal/blog/README.md`, `https://github.com/digoal/blog/issues/76`. Confidence: high.
- The **2023-08-22** learning-material post asks developers to contribute business scenarios through another GitHub issue, and the **2026-02-04** skill post publishes runnable skill code for others to take and iterate. Sources: `/Users/digoal/blog/202308/20230822_02.md`, `/Users/digoal/blog/202602/20260204_01.md`. Confidence: high.

**Inference**

- GitHub is used as a public operating surface: archive, index, feedback queue, contribution prompt, and code/artifact distribution. Treating his open-source work only as upstream database code contributions would miss the visible ecosystem labor. Confidence: high.

### 6. Action Patterns Worth Carrying Into The Perspective Skill

| Pattern | Visible action evidence | Judgment revealed | Confidence |
| --- | --- | --- | --- |
| Bet on open PostgreSQL leverage early | SkyMobi "Oracle to PG" account; Alibaba Cloud PostgreSQL roles | Prefer an extensible open database base that compounds through adoption | Medium-high |
| Scale from solving to enabling | Public training, videos, audience-specific course indexes, experiment manuals | A solution gains more value when users can learn and repeat it | High |
| Make feedback structured | GitHub feature wish issue with fields; scenario-contribution issue | Pain points become product/community inputs when captured in a usable format | High |
| Bridge product and ecosystem | PolarDB product/open-source/commercial role trail; public course scope | Adoption needs product, ecosystem, talent, and commercial mechanisms together | High |
| Convert new tools into artifacts fast | AI-assisted kernel course, `postgres_skill`, blog-distilled skill | New tools matter when they reduce learning or execution friction for others | High |
| Prefer low-friction hands-on paths | Docker images, free cloud labs, "poor man's" PolarDB RAC series | Lower cost and local reproducibility are adoption strategy, not an afterthought | Medium-high |

### 7. Contradictions And Cautions To Preserve

- The current profile text is internally mixed on employment status. Its short introduction says "曾就职于阿里云(至今)" while the title block includes "曾任阿里云数据库首席专家团队成员" and the work-history chronology lists **2026.4 ~ 数据库开源发展联盟** after **2023.10 ~ 2026.4 阿里云**. Do not flatten this into a definitive current-employer claim without a fresher direct confirmation. Source: `/Users/digoal/blog/me/readme.md`. Confidence: high that the conflict exists.
- Public-interest language and commercial ecosystem work coexist. The GitHub/profile motto and public-training records emphasize public benefit, while the profile and PolarDB course materials also include product planning, commercial promotion, and cloud-service links. The evidence supports a blended product-community operator; it does not justify reducing him to either a purely altruistic volunteer or a pure product marketer. Sources: `/Users/digoal/blog/me/readme.md`, `/Users/digoal/blog/202310/20231030_02.md`, `https://github.com/digoal`. Confidence: high.
- Many career metrics and internal outcomes in the self-profile are redacted or self-reported. Use them as persona evidence, not as independently verified business performance. Source: `/Users/digoal/blog/me/readme.md`. Confidence: high.
- Recent AI-heavy blog output is evidence of topic selection, workflow experiments, and asset release. It is not by itself evidence that every published paragraph was manually authored in the same way as older blog material. Confidence: medium.

## Sources

- `/Users/digoal/blog/me/readme.md` - self-profile, dated work chronology, roles, public-training and writing claims.
- `/Users/digoal/blog/README.md` - blog navigation strategy, course/material indexes, contribution/discussion affordances.
- `/Users/digoal/blog/202308/20230822_02.md` - immersive PostgreSQL/PolarDB learning material and scenario-contribution invitation.
- `/Users/digoal/blog/202310/20231030_02.md` - PolarDB/PostgreSQL public-course scope across product, open source, ecosystem, and contribution.
- `/Users/digoal/blog/202501/20250114_01.md` - low-cost PolarDB RAC hands-on series index.
- `/Users/digoal/blog/202502/20250218_03.md` - AI-assisted kernel-learning course decision and talent-barrier framing.
- `/Users/digoal/blog/202601/20260119_01.md` - Skills reuse/memory argument and Gemini/Qwen Coder workflow observation.
- `/Users/digoal/blog/202602/20260204_01.md` - public release of PostgreSQL daily-inspection skill and iteration intent.
- `/Users/digoal/blog/202604/20260415_05.md` - blog-to-skill self-distillation via Codex Skill Creator.
- `/Users/digoal/blog/202605/20260515_01.md` - "my SKILL" workflow and skill-writing-as-capability statement.
- `https://github.com/digoal` - current public GitHub profile snapshot, pinned repositories, public motto.
- `https://github.com/digoal/postgres_skill` - released Agent Skill repository for PostgreSQL/PolarDB workflows.
- `https://github.com/digoal/blog/issues/76` - dated PostgreSQL feature wish issue and structured feedback template.

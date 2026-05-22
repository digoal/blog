# Digoal Research 02: Conversations

## Scope

- Focus: talks, interviews, AMAs, long-form video or audio, and live Q&A behavior.
- Source policy: prefer original recordings, transcripts, and first-party event pages.
- Research date: 2026-05-22.
- Search exclusions used here: Zhihu, WeChat public-account pages, Baidu Baike, and Baidu Zhidao. A few local blog pages link to excluded pages; those links were not used as evidence below.

## Evidence Labels

- **Primary**: digoal's own blog notes, his own question outlines, direct replay links from those notes, public talk transcript text, public event pages, or a published interview carrying his direct answers.
- **Secondary**: third-party summary or report about a talk/conversation. Secondary sources below are used only to find or cross-check primary material.
- **Inference**: a behavioral hypothesis drawn from source structure or repeated answer patterns. Keep it separate from direct observation.

## Source Map

| Source | Type | Confidence | Why it matters |
| --- | --- | --- | --- |
| `/Users/digoal/blog/class/36.md` | Primary local replay index | High for appearance catalog; low for live behavior | Points to training videos, `Ask 德哥`, live replays, event interviews, and topic series. |
| `/Users/digoal/blog/201911/20191104_01.md` | Primary local live-Q&A note + Aliyun replay link | High | `Ask 德哥` #1 says the format is one central topic plus online interaction and preserves audience questions. |
| `/Users/digoal/blog/201911/20191106_01.md` | Primary local live-Q&A note + Aliyun replay link | High | `Ask 德哥` #2 preserves optimization, vacuum freeze, and cost-factor questions plus follow-up references. |
| `/Users/digoal/blog/201911/20191111_01.md` | Primary local live-talk note + Aliyun replay link | High | Shows that an `Ask` slot can become lecture-only when there is "本周无ask". |
| `/Users/digoal/blog/202109/20210928_01.md` and `/Users/digoal/blog/202109/20210927_01.md` | Primary local ASK index and written answer | High | The 2021 ASK index links older sessions; #4 preserves a concise operational answer to a concrete DDL question. |
| `/Users/digoal/blog/202109/20210924_03.md` | Primary local talk/Q&A note + Bilibili replay link | High for prepared questions and written answers; medium for live delivery | `德说` #33 records pre-collected youth/career questions and seven answer blocks. |
| `/Users/digoal/blog/202106/20210625_04.md`, `/Users/digoal/blog/202106/20210623_01.md`, `/Users/digoal/blog/202107/20210704_01.md` | Primary local host outlines + Bilibili replay links | High for interview question design; medium for turn-taking without transcript | Representative `开慧社` interviews with an entrepreneur, a vector-database founder, and a PG community chair. |
| `/Users/digoal/blog/202106/20210618_01.md` and `/Users/digoal/blog/202306/20230613_01.md` | Primary local explanation of `开慧社` | High | Explains the series goal as opening up "logic" and thought, and later notes that the series stayed limited. |
| `/Users/digoal/blog/202108/20210823_05.md` and `/Users/digoal/blog/202108/20210823_07.md` | Primary local talk-series index and representative episode | High for talk scaffold; low for dialogue | `DB吐槽大会` uses a fixed seven-part critique format and links direct video replays. |
| `https://developer.aliyun.com/article/60153` | Primary, published/edited talk transcript | Medium-high | Edited transcript of a 2016 talk, "从Oracle DBA到PostgreSQL布道者"; useful for prepared speaking structure. |
| `https://www.modb.pro/db/1810518356244578304` | Primary, published/edited interview Q&A | Medium-high | 2024 PG ACE interview publishes direct answers about PostgreSQL, performance, learning path, community, and advice. Host editing is possible. |
| `https://wiki.postgresql.org/wiki/Pg_envent_cn_oct_hangzhou` and `https://wiki.postgresql.org/wiki/Pgconf_cn2013` | Primary official event pages | High for speaker/event occurrence; low for behavior | Official PostgreSQL wiki pages place digoal on public conference programs in 2013 and 2017. |

## Corpus Shape

### Strongest Conversation Evidence

1. **Live ASK notes**: `Ask 德哥` #1, #2, and #4.
   - [Primary] #1 and #2 explicitly describe "聊一个中心内容，另外在线解答互动".
   - [Primary] The saved question lists are practical rather than ceremonial: HA architecture, PostGIS upgrade version choice, orafce on Windows, memory scheduling, optimization steps, vacuum freeze, scripts, and cost calibration.
   - [Primary] #4 preserves both the question and the complete written answer, so it is the cleanest Q&A sample in the local corpus.
2. **Talk followed by Q&A**: `德说` #33, "知鱼之乐".
   - [Primary] The page says questions were collected before the talk and saves the Q&A section with answers.
   - [Primary] The questions move from expression ability and age anxiety to Oracle motivation, learning habits, career planning, database learning route, and business understanding.
3. **Published interview answer text**: 2024 PG ACE interview.
   - [Primary, published/edited] It is closer to an asynchronous interview than a raw conversation, but it gives first-person answers under questions from another party.

### Useful but Weaker Conversation Evidence

1. **Host mode**: `开慧社`.
   - [Primary] The local pages preserve question sequences and direct Bilibili replay links.
   - [Inference] Without a transcript or reviewed recording, the pages support question design more strongly than live turn-taking, interruptions, listening cues, or follow-up timing.
2. **Prepared talk mode**: 2016 Aliyun talk transcript and `DB吐槽大会`.
   - [Primary] These show how he packages an explanation for an audience.
   - [Inference] They should shape a perspective skill's explanation pattern, but they are weaker evidence for spontaneous dialogue.

## Findings

### 1. Q&A Starts From the Concrete Question, Then Expands to Mechanism and Action

- [Primary] `Ask 德哥` #4 answers "PG增大字段长度会锁表吗" with a direct numbered verdict: DDL locks the table, some DDL is metadata-only while some rewrites the table, and a waiting exclusive lock can block later DML and reads.
- [Primary] The same answer immediately moves to operational advice: assess DDL time, use low-traffic windows, clear blockers when needed, and set `lock_timeout` before the DDL.
- [Inference] This is the best compact template for his technical answer behavior: **verdict -> mechanism -> failure chain -> mitigation -> deeper link**. It is more faithful than a generic "PostgreSQL is powerful" evangelist voice.

### 2. He Uses Audience Questions as a Teaching Router

- [Primary] `Ask 德哥` #1 and #2 do not keep answers isolated from the knowledge base. The saved pages attach references after the questions: checkpoint analysis, orafce on Windows, Oracle-to-PG migration material, cost-factor calibration, optimization videos, and freeze prediction/background.
- [Primary] `德说` #33 similarly answers career questions by pointing to older notes or related talks on team choice, comfort zones, 5Why, 5So, learning route, and industry trends.
- [Inference] In conversation he often treats a question as an entry point into a larger learning graph. A synthesized skill should answer the immediate question first, then offer one or two next pieces of evidence or learning paths.

### 3. Narrow Prompts May Be Reframed Around Purpose, Business Fit, or Development Stage

- [Primary] In `德说` #33, the answer to "数据库除了原理和调优还要掌握什么" is a short return question: "技术是为什么服务的?".
- [Primary] In the PG ACE interview, performance discussion is framed around fit rather than an absolute winner: "There is no best, only the most suitable" is the answer's governing idea before it discusses how application characteristics and business needs decide the database choice.
- [Primary] The PG ACE learning-path answer also connects low-level source reading to front-end product/business understanding and cross-domain knowledge.
- [Inference] His conversational move is often to pull an overly local technical question back to the system it serves. Use that move when the question is underspecified or optimization is being mistaken for the goal.

### 4. His Public Q&A Can Widen Abruptly Beyond the Asked Domain

- [Primary] In `德说` #33, a motivation question about whether Oracle is still worth learning becomes a discussion of why a technology's position depends on broader industry and geopolitical cycles.
- [Primary] In the same Q&A, age anxiety becomes a discussion of marginal returns and leaving an experience comfort zone rather than a narrow job-title recommendation.
- [Inference] This produces a "look behind the local symptom" style. It is distinctive, but a perspective skill should not imitate the widening move unless it can connect the wider model back to the user's decision.

### 5. As an Interview Host, He Presses for Logic, Incentives, and Hard Parts

- [Primary] `开慧社` states its banner as "show me your logic".
- [Primary] The first entrepreneurship episode asks pointedly about financial freedom, whether effort matters, how to find opportunity points, how success is measured, and why investment was refused.
- [Primary] The Zilliz episode asks why the vector-database track was chosen, who competes there, why the guest can win, how a USD 53 million raise was calculated, how an open-source product monetizes, what company management looks like, the hardest period, and advice for founders.
- [Primary] The PG community-chair episode asks about PostgreSQL's endurance, why products fork from it, community organization, committee incentives, hard problems after taking over, and the year's goals.
- [Inference] His host mode favors causal and incentive questions over biography-only prompts: **why this track, why you, how do you measure it, what broke, how do you survive, what does the system reward**.

### 6. Prepared Speaking Is Highly Scaffolded and Case-Driven

- [Primary] The 2016 Aliyun transcript starts with identity/context, declares the topic, then tells the Oracle-to-PostgreSQL route through personal experience, capabilities, deployment cases, tools, and learning advice.
- [Primary] `DB吐槽大会` makes the scaffold explicit for each episode: product problem, underlying principle, affected scenarios, consequences, business avoidance, tradeoffs/new problems, and future product fix.
- [Primary] The representative MVCC episode fills that scaffold with failure conditions, workloads such as location updates, vacuum causes, operational costs, and candidate storage-engine directions.
- [Inference] Even when a conversation is free-form, a Digoal-like explanation should tend toward cases, tradeoffs, and "what breaks in production" rather than remaining at definition level.

### 7. Public Interaction Is More Teacher-Operator Than Celebrity Interview

- [Primary] The strongest local evidence is training, live ASK, technical replay indexes, topic-series critiques, and host-designed interviews.
- [Primary] Official PostgreSQL wiki event pages show repeated conference speaking appearances by 2013 and 2017; the local replay index then shows a dense later catalog.
- [Inference] The perspective skill should default to an expert who shares operational judgment in public, organizes knowledge, and asks peers to reveal logic. There is not yet enough evidence for a chatty podcast persona, adversarial-debate persona, or confessional long-interview persona.

## Conversational Traits Safe to Reuse

| Trait | Evidence level | Skill implication |
| --- | --- | --- |
| Direct answer before explanation on a concrete technical risk | Primary | Say whether the risk exists first; then explain why. |
| Numbered decomposition | Primary | Use short numbered facts, conditions, or steps when complexity grows. |
| Production failure chain | Primary | Include lock queues, maintenance effects, tradeoffs, business consequences, or operational cost. |
| Question as gateway to a learning path | Primary + inference | Link the immediate answer to the next concept only after handling the question. |
| Purpose/business-fit reframing | Primary | Ask what the technology serves when local optimization is mistaken for the objective. |
| Logic-revealing host questions | Primary for outlines; inference for live manner | Ask "why this", "how measured", "what incentive", "what hard period", "what advice after evidence". |

## Missing Evidence and Cautions

- I did not find a reliable long-form podcast/audio interview corpus for digoal in the searched public results. Search results often returned other people with similar names or lecture videos instead.
- Most local Bilibili/Aliyun pages are replay links with agenda notes, not word-for-word transcripts. They prove appearance and topic structure more strongly than prosody, interruption handling, humor timing, disagreement behavior, or how he changes his mind live.
- The 2024 PG ACE interview and 2016 Aliyun transcript are published/edited texts. Treat them as direct-answer evidence, not raw-turn transcripts.
- `开慧社` gives strong question design evidence, but its replay recordings should be transcribed or reviewed before asserting speaking pace, follow-up style, rapport, or listening behavior.
- `DB吐槽大会` is valuable for explanation shape and criticism discipline, but it is not an AMA by itself.

## Sources

- Primary local corpus:
  - `/Users/digoal/blog/class/36.md`
  - `/Users/digoal/blog/201911/20191104_01.md`
  - `/Users/digoal/blog/201911/20191106_01.md`
  - `/Users/digoal/blog/201911/20191111_01.md`
  - `/Users/digoal/blog/202109/20210928_01.md`
  - `/Users/digoal/blog/202109/20210927_01.md`
  - `/Users/digoal/blog/202109/20210924_03.md`
  - `/Users/digoal/blog/202106/20210618_01.md`
  - `/Users/digoal/blog/202106/20210625_04.md`
  - `/Users/digoal/blog/202106/20210623_01.md`
  - `/Users/digoal/blog/202107/20210704_01.md`
  - `/Users/digoal/blog/202306/20230613_01.md`
  - `/Users/digoal/blog/202108/20210823_05.md`
  - `/Users/digoal/blog/202108/20210823_07.md`
- Public primary supplements with possible publisher editing:
  - `https://developer.aliyun.com/article/60153`
  - `https://www.modb.pro/db/1810518356244578304`
  - `https://wiki.postgresql.org/wiki/Pg_envent_cn_oct_hangzhou`
  - `https://wiki.postgresql.org/wiki/Pgconf_cn2013`
- Secondary discovery only:
  - Search results on 2026-05-22 surfaced media summaries and mirrors, but none added stronger conversation evidence than the local corpus and the public supplements above.

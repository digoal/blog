# Digoal Research 04: External Views

## Scope

- Focus: public biographies, event introductions, peer descriptions, criticism, and reputation signals.
- Source policy: distinguish third-party claims from primary self-description.
- Exclusions applied: Zhihu, WeChat public-account pages, Baidu Baike, and Baidu Zhidao.

## Evidence Handling

- `Primary/self-description`: digoal's own public profile, own repositories, own talk text, or local corpus that summarizes those materials.
- `External view`: an event page, community directory, media item, peer description, or public signal emitted by another actor/platform.
- `Inference`: synthesis from multiple screened sources. Treat these as hypotheses for skill design, not biography facts.
- Local corpus boundary: the bundled local `digoal` skill describes him from his own blog corpus as a practical PostgreSQL/PolarDB expert and community builder. I used that only to avoid misclassifying self-positioning as outside judgment; the findings below are grounded in public outside-facing sources unless marked otherwise.

## Findings

### 1. Dated external records show a practitioner-to-organizer arc

| Observation | Evidence type | Support | Confidence | Notes |
| --- | --- | --- | --- | --- |
| In the earliest screened conference record, digoal appears as an invited Sky-mobi DBA leader speaking on PostgreSQL introduction and enterprise use. | External view | PostgreSQL Conference China 2011 page says the event invited Sky-mobi DBA lead Zhou Zhengzhong and lists his talks on PostgreSQL introduction and enterprise practice. URL: <https://wiki.postgresql.org/wiki/Pgconchina2011> | High | Official PostgreSQL wiki conference page; dated July 2011. |
| By 2012, conference copy still frames him first as an operator with wide platform exposure and a large PostgreSQL estate. | External view | PostgreSQL Conference China 2012 bio calls him Sky-mobi DBA supervisor, lists Oracle/PostgreSQL/EnterpriseDB/Greenplum/MongoDB plus OS/storage familiarity, and says he managed a system with more than 300 PostgreSQL nodes. URL: <https://wiki.postgresql.org/wiki/Pgconfchina2012> | High | Event bio may have been supplied by the speaker, but it is published by the conference page and is specific enough to preserve. |
| In 2013, the external record expands from speaker to community organizer. | External view | PostgreSQL Conference China 2013 page names Zhou Zhengzhong as organizer responsible for agenda, guest contact, venue, registration, gifts, and conference organization; it also lists him on PostgreSQL 9.3/new-feature and tracing talks. URL: <https://wiki.postgresql.org/wiki/Pgconf_cn2013> | High | This is stronger evidence of visible organizing work than a generic bio claim. |
| A Chinese PostgreSQL community directory presents him as an ACE Director and ecosystem-facing leader, not only a DBA. | External view with likely edited-bio content | China PostgreSQL ACE directory labels him `PostgreSQL ACE Director`, `阿里云 高级产品专家`, PolarDB open-source community lead, PostgreSQL China co-initiator, long-term article author, Alibaba `麒麟布道师`, and 2018 OSCAR honoree. URL: <https://www.postgresqlchina.com/eco/ace/acelist?type=3> | Medium-high | The directory is authoritative for ACE listing, but the prose looks like a profile bio and includes time-sensitive employment text. |
| The latest screened event copy changes his employment wording to `former Alibaba Cloud database senior expert`. | External view | HOW 2026 event overview from IvorySQL lists `德哥（周正中）` as an IvorySQL expert adviser, PostgreSQL ACED, former Alibaba Cloud database senior expert, and producer of a PostgreSQL 18/new-features forum. URL: <https://www.cnblogs.com/ivorysql/p/19903303> | Medium-high | Dated April 2026 event copy. It conflicts with the older ACE directory's present-tense Alibaba role. |

**Inference:** outside-facing records repeatedly move him from "large-production PostgreSQL operator" to "conference organizer / trainer / ecosystem signal amplifier." That arc is useful for the perspective skill because the external image is not just "database specialist"; it is "practitioner who turns field experience into community adoption." Confidence: medium-high.

### 2. Public profiles and peer signals point to unusual reach inside the Chinese PostgreSQL niche

| Signal | Evidence type | Support | Confidence | Notes |
| --- | --- | --- | --- | --- |
| His public GitHub footprint is large for a personal technical knowledge base. | Platform-generated signal plus self-description | GitHub profile shows 3.3k followers and a pinned `digoal/blog` repository with 8.5k stars at research time; the profile slogan and bio text are self-description. URL: <https://github.com/digoal> | High for counts at capture time; low for interpreting motive | Use follower/star counts as reach signals only. Do not treat the slogan as an outside view. |
| Employers and practitioners route requests through him as a distribution node. | Peer/community signal | A 2017 PostgreSQL Chinese mailing-list message forwards a Hellobike recruiter's request for him to circulate a PostgreSQL DBA role and includes the recruiter's statement that he is a leading figure in the domestic PG technical circle. URL: <https://www.postgresql.org/message-id/605edb6c.c198.15af5ddd312.Coremail.digoal%40126.com> | Medium | The praise is from one requester and is surfaced by digoal's forwarded mail, so it is a narrow signal, not a survey. The routing request itself is observable. |
| Recent peer commentary treats him as a recognizable face of PostgreSQL evangelism in China and at Alibaba Cloud. | Peer commentary | Pigsty founder Feng Ruohang's April 2026 article says Chinese PostgreSQL practitioners know `德哥`, credits him and Xiao Shaocong with much of Alibaba Cloud RDS PostgreSQL evangelism/community work, and points to years of high-volume blogging and public trust. URL: <https://vonng.com/cloud/digoal-leave-aliyun/> | Medium | Strong peer signal from someone inside the PostgreSQL ecosystem; it is opinionated commentary, not neutral institutional biography. |
| Reputable or event-adjacent media commonly introduce him through PostgreSQL community and evangelism titles. | External description, secondary | IT168's 2016 DTCC schedule lists Zhou Zhengzhong of Alibaba Cloud on `从Oracle DBA到PostgreSQL布道者`; Qilu's 2025 IvorySQL coverage calls him PostgreSQL ACE Director and PG Chinese community co-initiator. URLs: <https://www.it168.com/redian/16DTCC/>, <https://news.iqilu.com/shandong/shandonggedi/20250701/5828180.shtml> | Medium | These reinforce the role label, but neither source is a deep independent profile. |

**Inference:** the external reputation signal is stronger for knowledge distribution, education, production cases, and community coordination than for celebrity outside the database field. Confidence: medium.

### 3. Criticism, limits, and contradictions

1. **Current-role contradiction should stay visible.** The China PostgreSQL ACE directory still says `阿里云` and `高级产品专家`, while HOW 2026 event copy says `前阿里云数据库高级专家`; Feng Ruohang's April 2026 peer article also treats the Alibaba departure as current news. Prefer the dated 2026 event wording for a current-role statement, but keep the stale-directory conflict in research notes rather than silently normalizing it.
2. **The screened corpus is praise-heavy.** Conference bios, ACE directories, partner event pages, and community pieces have promotional incentives. They are useful for titles, responsibilities, and visibility, but weak for measuring technical depth or disagreement.
3. **The strongest screened criticism is about dependence and context, not a well-sourced personal indictment.** Feng Ruohang's 2026 commentary argues that digoal became a face of Alibaba Cloud PostgreSQL and that his departure has signal value; the same article's critical edge is aimed largely at Alibaba Cloud PostgreSQL strategy and ecosystem positioning. It should not be rewritten as proof that digoal himself is technically weak or uniquely responsible for product outcomes.
4. **No robust independent negative profile surfaced in the screened source set.** That is a research gap, not evidence that criticism does not exist. A future pass could check conference Q&A, public technical disputes, issue threads, or peer interviews if a limitation model is needed.
5. **Coverage emphasis is itself a limitation.** The external sources checked emphasize production practice, writing, training, product/community roles, and event work. They provide less outside evidence about upstream PostgreSQL core contribution style, management behavior, or private decision-making. Do not infer those dimensions from evangelism reputation alone.

### 4. Synthesis candidates for the perspective skill

| Candidate pattern | Label | Why it matters | Confidence |
| --- | --- | --- | --- |
| Field credibility first: outside bios repeatedly start with DBA/operator experience before evangelism labels. | Inference | A digoal perspective should sound grounded in deployment, operations, cases, and enablement, not abstract advocacy. | High |
| Community as distribution infrastructure: conference organizing, recruiting relay, writing reach, and ACE/event roles recur. | Inference | Skill outputs can model him as someone who converts expertise into courses, articles, events, and ecosystem adoption paths. | Medium-high |
| Identity tied to PostgreSQL-in-China bridge work. | Inference | External records frame him as a translator between PostgreSQL capability and Chinese enterprise/user adoption. | Medium-high |
| Avoid overclaiming "neutral authority." | Inference | Much outside coverage comes from community/event/vendor contexts and is positive by design. | High |

## Sources

| Source | Source class | Used for | Confidence and caveat |
| --- | --- | --- | --- |
| <https://wiki.postgresql.org/wiki/Pgconchina2011> | External event record | 2011 invited-speaker and talk framing | High; official PostgreSQL wiki event page. |
| <https://wiki.postgresql.org/wiki/Pgconfchina2012> | External event bio | Sky-mobi DBA/operator description and 300+ node claim | High for published bio; speaker-supplied bio remains possible. |
| <https://wiki.postgresql.org/wiki/Pgconf_cn2013> | External event record | Organizer duties and talk topics | High; concrete event responsibilities. |
| <https://www.postgresqlchina.com/eco/ace/acelist?type=3> | Community directory | ACE Director listing, titles, ecosystem/publication summary | Medium-high; role prose may be edited/stale. |
| <https://www.cnblogs.com/ivorysql/p/19903303> | Event introduction | HOW 2026 role wording and forum producer slot | Medium-high; dated event copy, hosted by IvorySQL on Blog Garden. |
| <https://github.com/digoal> | Public profile | Platform reach signals and self-description boundary | High for visible counts when checked; profile bio is self-description. |
| <https://www.postgresql.org/message-id/605edb6c.c198.15af5ddd312.Coremail.digoal%40126.com> | Peer/community signal | Recruitment-routing request and one peer praise statement | Medium; narrow signal forwarded by digoal. |
| <https://vonng.com/cloud/digoal-leave-aliyun/> | Peer commentary | Recent reputation framing, Alibaba departure signal, critique context | Medium; informed and opinionated peer view. |
| <https://www.it168.com/redian/16DTCC/> | Tech event/media page | 2016 DTCC evangelist talk label | Medium; schedule-level description only. |
| <https://news.iqilu.com/shandong/shandonggedi/20250701/5828180.shtml> | Regional news/event coverage | 2025 media role label | Medium; event coverage, not a full profile. |
| Local reference: `/Users/digoal/.codex/skills/digoal/references/repo-map.md` | Primary/self-description boundary | Separating blog-corpus self-positioning from outside descriptions | Not used as external evidence. |

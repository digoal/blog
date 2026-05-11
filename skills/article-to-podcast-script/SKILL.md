---
name: article-to-podcast-script
description: Convert a Markdown article into a natural podcast dialogue script for 1 to 4 speakers and save it as a .txt file under the current project's markdown directory. Default to Chinese output unless the user explicitly specifies another language, while preserving English terms that appear in the article. Use when the user provides an article Markdown file and a podcast speaker count, asks for a VibeVoice-style podcast script, dialogue rewrite, narrated audio script, multi-host conversation, or solo podcast monologue based on an article.
---

# Article To Podcast Script

## Workflow

1. Read the input Markdown article and identify its title, thesis, key sections, facts, examples, and conclusion.
2. Confirm the requested speaker count is an integer from 1 to 4. If it is missing or outside this range, ask for a valid count before writing the script.
3. Write a podcast-ready Chinese dialogue script by default, using only labels in the form `Speaker N:` where `N` is from `1` to the requested count. If the user explicitly specifies another language, write the script in that language instead. Write from the host's first-person perspective, as if the host personally read, thought about, and is now explaining the article.
4. Save the result as a `.txt` file in the current project's `markdown` directory. Create that directory if needed.
5. Report the output path and any important assumptions.

Use `scripts/save_podcast_script.py` to write the final text:

```bash
python3 /path/to/article-to-podcast-script/scripts/save_podcast_script.py ARTICLE.md SPEAKER_COUNT < draft.txt
```

The script validates the speaker count, creates `./markdown`, builds a stable output filename from the article name, and writes stdin to the `.txt` file.

## Script Requirements

- Start directly with `Speaker 1:`. Do not add a title block, cast list, markdown formatting, stage directions, or bullets.
- Default to natural spoken Chinese for the dialogue content unless the user requests another language. Keep the `Speaker N:` labels in English exactly as shown.
- Preserve English terms that appear in the article, including acronyms, product names, model names, paper titles, project names, protocol names, company names, and technical terms. Do not translate them into Chinese unless the article itself already provides an established Chinese rendering.
- Keep every line as one speaker turn:

```text
Speaker 1: 大家好，欢迎收听本期节目。今天我们来聊一篇很有意思的文章...
Speaker 2: 没错，这篇文章的核心其实不是标题里的新闻，而是背后的传导链条...
```

- Use exactly the requested number of speaker labels across the script. For one person, use only `Speaker 1:`.
- Rotate speakers naturally for 2 to 4 people; do not force equal length if the conversation would sound unnatural.
- Preserve the article's core claims and important evidence. Do not invent facts, names, numbers, or citations.
- Convert dense exposition into spoken language: short sentences, natural transitions, reactions, clarifying questions, and concise analogies.
- Make the script self-contained for listeners who have not read the article.
- Avoid excessive filler, repeated greetings, ads, music cues, timestamps, sound effects, and production notes.
- Avoid any AI-generated trace, meta-writing, or research-process disclosure. Do not mention "资料边界", "公开资料显示", "不是基于全文精读", "我作为AI", "本文/这篇读书笔记", "评论者认为", "根据材料", or similar phrases unless they are essential content in the article itself.
- Put the host inside the author's ability range and point of view. The host may say "我读完最有感触的是", "我自己的判断是", "我会这样用", but must not pretend to have experiences, authority, interviews, fieldwork, proprietary data, or personal relationships that are not in the article.
- Rewrite source-boundary paragraphs into natural first-person caveats or omit them when they do not help listeners. For example, instead of saying "这本书的公开资料边界也要先讲清楚...", say "我更愿意把它当成一套思考复杂问题的框架，而不是照搬案例的操作手册。"
- Keep the voice like a real human host preparing a thoughtful episode: specific, opinionated within the article's evidence, and free of template-like transitions.

## Diction Polish

- Match verbs to the source object. For books, articles, reports, and notes, prefer "最值得看", "最值得读", "读到这里", "我读完..." instead of "最值得听", unless referring to the podcast episode itself.
- Attribute ideas in a more authored, reflective way. Prefer "作者透过这本书要表达的核心观点是..." over flatter lines like "作者的核心判断是...".
- Use precise synthesis verbs. Prefer "收敛到三个问题", "归结为一个判断", "落到一个方法" instead of generic "收束成..." when closing an argument.
- Before saving, do one final wording pass for Chinese texture: replace stiff, generic, or assistant-like phrases with more deliberate first-person phrasing while keeping facts unchanged.

## Speaker Patterns

- **1 speaker**: Write a solo host monologue in first person, with rhetorical questions, clear signposting, and periodic recap phrases.
- **2 speakers**: Use host plus co-host. Let Speaker 1 guide the structure and Speaker 2 clarify, challenge, summarize, or add examples.
- **3 speakers**: Use host plus two panelists. Give one speaker the explanatory role and one the skeptical or practical role.
- **4 speakers**: Use a roundtable. Keep turns shorter so all voices remain present without becoming chaotic.

## Structure

Follow this shape unless the article clearly calls for another:

1. Opening hook and topic setup.
2. Article thesis in plain language, framed as the host's own takeaway.
3. Main points in article order, with each point turned into discussion.
4. Tensions, tradeoffs, limitations, or counterpoints if present in the article.
5. Practical takeaway or closing synthesis.

Match length to the article and user request. If no duration is specified, produce enough script to cover the article's substance without padding.

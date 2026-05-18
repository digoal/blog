这些 skill 的生成方式: [《如何创建 SKILL》](../202604/20260421_02.md)  
  
## skill 介绍
- `daily-finance`：每日联网采集并校验高质量财经新闻、市场数据和关键事件，生成可直接发布的公众号财经日报，并作为后续深度分析的事实底稿。  
  
- `finance-core-analysis`：基于 `daily-finance` 的事实底稿，再联网复核关键数据，用流动性、利率、风险偏好、资金流、政策和资产负债表模型生成可发布的深度财经分析。  
  
- `finance-explosive-article`：基于前两份财经文档和最新外部数据校验，用“第一性原理 + 反直觉 + 系统模型”的德哥风格生成公众号爆款财经文章。  
  
- `finance-beginner-explainer`: 基于 `finance-explosive-article` 的文案, 面向小白进行更细致的解读, 必要时会用到 `daily-finance` 和 `finance-core-analysis` 增加证据链完整性.  
  
- `finance-weekly-outlook`: 根据daily-finance , finance-core-analysis , finance-explosive-article的产出, 再综合搜索其他相关的关键且权威的高质量数据. 分析未来一周极大概率看涨以及看空的行业和股票.  
  
- `buffett`: 巴菲特思想解读股票代码. 来自 https://github.com/agi-now/buffett-skills  
   其他相关项目获文档  
   - [《把 MiniMax 接入 Claude, 给 TradingAgents 添加 MiniMax 模型供应商支持 玩转股票深度分析》](../202603/20260330_07.md)  
   - [《TradingAgents: 多 Agent 股票分析与交易决策系统试用》](../202603/20260327_03.md)  
   - [《AI论文解读 | TradingAgents: Multi-Agents LLM Financial Trading Framework》](../202603/20260325_01.md)  
  
- `digoal`：基于 digoal/德哥博客沉淀，面向 PostgreSQL、AI+数据库、开源生态、技术文章和架构判断，输出证据驱动、场景优先、可验证的德哥式分析与方案。  
  
- `github-weekly-trending`: 输入从 `https://github.com/trending?since=weekly&spoken_language_code=` 拷贝的内容, 编写本周热门开源项目文章, 输出到当前项目 markdown 目录中.   
  
- `open-source-project-article`: 输入开源项目地址, 深度分析该开源项目, 输出到当前项目 markdown 目录中.  
  
- `marketing-wechat-operator`: `微信公众号运营`, 编写爆款文章.  

- `postgres-commit-history-article`: 先进入 postgres 项目目录, 输入 `commitid1 commitid2` , 分析并解读这两个 commitid 中间的所有提交 (也包括这两个 commit), 输出到当前项目 markdown 目录中.
  
- `paper-interpretation`: 输入论文 PDF 或论文 URL , 通俗易懂解读论文. 例如用于解读 AI 论文 https://arxiv.org/abs/2604.14141 https://arxiv.org/abs/2508.02739 
  ````
  AI 论文:    
  - https://huggingface.co/papers/trending
  - https://huggingface.co/papers    
  - https://github.com/tensorchord/Awesome-LLMOps    
      
  数据库 论文:    
  - https://github.com/lonng/db-papers    
      
  AI4DB 论文:    
  - https://github.com/LumingSun/ML4DB-paper-list
  ````
  
- `pgfaq`: clone https://github.com/postgres/postgres 源码, 将其作为项目目录. 输入 PostgreSQL 相关的问题, 将回答结果保存到项目目录的 markdown 子目录中. 回答时会参考代码、文档和deepwiki, 并对回答内容正确性进行校验.  
  
- `database-foundation-course-writer`: 数据库筑基课 写作 skill, 输入数据库筑基课的文章标题 以及 相关的参考资料(通常是该篇数据库筑基课相关的技术文档、产品手册、开源项目地址、deepwiki地址、论文地址等). 输出最终 markdown 文件并保存到当前项目 markdown 文件夹中. 例如  `“数据库筑基课 - 索引之 rum” , 参考资料 https://github.com/postgrespro/rum https://deepwiki.com/postgrespro/rum`  
  
- `article-to-podcast-script`: 将文章转换成播客脚本. 输入为文章的 markdown 文件 以及 播客人数(1到4人).  例如: `$article-to-podcast-script 根据 markdown/finance-beginner-explainer-2026-04-22.md 文章, 生成 2 人播客脚本, 字数限定在1000字内, 如果无法完成限定, 请在结尾时引导听众阅读“digoal德哥”公众号发布的文字稿.` . 生成完之后还可以调整文件, 或者生成是告知风格(如犀利、金句频出等) . 然后用这篇文章介绍的方法, 生成播客语音. [《Mac本地生成 播客配音, 想要谁的声音都行, 还能带BGM》](../202604/20260422_02.md)  (非常耗内存, 如果你的播客很长, 建议剪成几篇分开生成, 或者升级内存) 
  
- `financial-report-analysis`: 财报分析, 输入公司财报文件或URL, 输出专业的财报解读文章.  
  
- `industry-chain-investment-analysis`: 输入一个行业或产业名称, 根据这个行业产业链条的各个节点, 列出各个节点中具有代表性的上市公司, 分析这些企业的商业模式、上下游、核心竞争力, 护城河、风险揭露、竞争情况等. 图文并茂(svg/mermaid/ascii text等图形)的输出markdown格式文件, 保存到当前项目 markdown 目录中. 
  
- `opensourcefaq`: 解答与开源产品有关的问题. 
  ```
  输入: 
    问题,
    问题涉及的所有开源项目的源码目录, 
    deepwiki reponame. 
  输出内容以 markdown 格式保存到当前项目 markdown 目录中. 
  ```
  
  使用例子
  ```
  # 先下载代码, 构建代码框架
  git clone --depth 1 https://github.com/postgis/postgis
  cd postgis
  claude 
  /init
  
  git clone --depth 1 https://github.com/postgres/postgres
  cd postgres
  claude 
  /init
    
  问题:
  
  如何使用 postgis 做伴随分析, 更确切的说, 数据库里有车辆轨迹, 每个人的轨迹数据, 根据A的轨迹, 如何找出打车的同行人. 
  开源项目地址 : 
    /Users/digoal/pgrepo/postgis 
    /Users/digoal/pgrepo/postgres
  deepwiki reponame : 
    postgis/postgis 
    postgres/postgres
  ```
  
- `douban-book-notes`: 输入豆瓣链接, 生成读书笔记.  
  
- `axiom-explainer`: 输入公理/定理/观点, 输出把“观点 / 公理 / 定理 / 理论系统”生成面向学生的中文 Markdown 文章. 参考 [《德说-第100期, 人生最重要的事3: 建立公理体系和逻辑能力》](../202206/20220610_01.md)  
  
- `future-planning-advisor`: 基于提问者提供的背景、资源等信息. 编写符合提问者的未来规划与建议书. 以 markdown 格式保存到当前项目的 markdown 目录中.  
  
- `enterprise-future-planning-advisor`: 基于用户提供的企业名、企业简介、公司网站等信息, 给这家企业编写未来规划与建议书. 以 markdown 格式保存到当前项目的 markdown 目录中. 
  
- `higher-order-article-writer`: 给出 url 或文章内容, 仔细阅读并消化后, 写一篇更高层次的博弈文章. 
  
- `product-tech-influence-article`: 输入某个产品名称, 将近期新闻整理成文章, 以 markdown 格式保存到当前项目 markdown 目录中. 
  
- `industry-news-insight`: 输入某个行业名称, 将近期新闻整理成文章, 以 markdown 格式保存到当前项目 markdown 目录中. 
  
## only for claude web
`skills_for_claude_web` 目录中的 skill 仅用于 Claude web 版.
  
`.skill` 是 claude web skill 的压缩包.  

### skills
  
- `daily-finance`: 每日联网采集并校验高质量财经新闻、市场数据和关键事件，生成可直接发布的公众号财经日报，并作为后续深度分析的事实底稿。  
  
- `finance-core-analysis`: 基于 `daily-finance` 的事实底稿，再联网复核关键数据，用流动性、利率、风险偏好、资金流、政策和资产负债表模型生成可发布的深度财经分析。  
  
- `finance-explosive-article`: 基于前两份财经文档和最新外部数据校验，用“第一性原理 + 反直觉 + 系统模型”的德哥风格生成公众号爆款财经文章。  
  
- `finance-beginner-explainer`: 基于 `finance-explosive-article` 的文案, 面向小白进行更细致的解读, 必要时会用到 `daily-finance` 和 `finance-core-analysis` 增加证据链完整性.  
  
- `finance-weekly-outlook`: 根据daily-finance , finance-core-analysis的产出, 再综合搜索其他相关的关键且权威的高质量数据. 分析未来一周极大概率看涨以及看空的行业和股票.  
  
- `paper-interpreter`: 输入论文 PDF 或论文 URL , 通俗易懂解读论文.   
  
- `db-foundation-course`: 数据库筑基课 写作 skill, 输入数据库筑基课的文章标题 以及 相关的参考资料(通常是该篇数据库筑基课相关的技术文档、产品手册、开源项目地址、deepwiki地址、论文地址等). 输出最终 markdown 文件.   
  
- `financial-report-analyst`: 财报分析, 输入公司财报文件或URL, 输出专业的财报解读文章.  
  
- `industry-chain-analyst`: 输入一个行业或产业名称, 根据这个行业产业链条的各个节点, 列出各个节点中具有代表性的上市公司, 分析这些企业的商业模式、上下游、核心竞争力, 护城河、风险揭露、竞争情况等. 图文并茂(svg/mermaid/ascii text等图形)的输出markdown格式文件, 保存到当前项目 markdown 目录中.  
  
- `opensourcefaq`: 解答与开源产品有关的问题.
  ```
  输入:
    问题,
    问题涉及的所有开源项目的源码目录,
    deepwiki reponame.
  输出内容以 markdown 格式保存到当前项目 markdown 目录中.
  ```
  
- `book-note-writer`: 输入豆瓣链接, 生成读书笔记.

- `axiom-explainer`: 输入公理/定理/观点, 输出把“观点 / 公理 / 定理 / 理论系统”生成面向学生的中文 Markdown 文章. 参考 [《德说-第100期, 人生最重要的事3: 建立公理体系和逻辑能力》](../202206/20220610_01.md)
    
- `personal-planner`: 基于提问者提供的背景、资源等信息. 编写符合提问者的未来规划与建议书. 以 markdown 格式保存到当前项目的 markdown 目录中.  
  
- `enterprise-planner`: 基于用户提供的企业名、企业简介、公司网站等信息, 给这家企业编写未来规划与建议书. 以 markdown 格式保存到当前项目的 markdown 目录中. 
  
- `product-neutral-advisor`: 输入某个产品名称, 将近期新闻整理成文章, 以 markdown 格式保存到当前项目 markdown 目录中  
  
- `industry-insight-writer`: 输入某个行业名称, 将近期新闻整理成文章, 以 markdown 格式保存到当前项目 markdown 目录中
  
- `podcast-script`: 将文章转换成播客脚本. 输入为文章的 markdown 文件 以及 播客人数(1到4人).  
  
## 依赖  
1、  
  
```bash  
pip3 install pymupdf pypdf pdfplumber pdfminer.six  
```  
  
对应关系：  
  
- `pymupdf`：提供 `fitz`，用于 PDF 文本和图片提取  
- `pypdf`：`PyMuPDF` 不可用时的文本提取 fallback  
- `pdfplumber`：表格候选提取  
- `pdfminer.six`：`skills_for_claude_web/paper-interpreter` 中明确写了 `pip install pdfminer.six`  
  
  
2、  
  
PDF/OCR fallback 工具，`skills/paper-interpretation` 提到扫描 PDF 时可用 OCR 或本地 PDF/image 工具，建议装：  
  
```bash  
brew install poppler tesseract  
```  
  
说明：  
  
- `poppler` 提供 `pdftotext`、`pdfinfo`、`pdfimages`  
- `tesseract` 用于 OCR 扫描型 PDF/图片  
  
3、  
  
DeepWiki MCP / Node 工具  
  
`open-source-project-article` 和 `pgfaq` 依赖 DeepWiki MCP。若本地没有配置，可安装/运行对应 MCP 包：  
  
```bash  
npx --yes @seflless/deepwiki  
```  
  
如果要把它加入 Codex MCP，需要用你当前环境对应的 MCP 配置命令；从技能内容本身看，只能确定它需要 DeepWiki MCP 能力，不能确定唯一安装方式。  
  

# Diagram Patterns

Step 5 出图时加载本参考。原则: **优先 mermaid 内嵌, 复杂拓扑落地为外部 svg**。

## 1. mermaid 模板

### 1.1 因果链 (最常用)

```mermaid
flowchart LR
    A[新闻事件<br/>XX 上调关税 25%] --> B[出口商品价格 ↑]
    B --> C[美国终端需求 ↓]
    C --> D[对美出口企业<br/>订单 / 毛利 ↓]
    D --> E[受益: 国产替代<br/>承压: 出口型公司]
```

- 节点文字不超过 2 行, 必要时用 `<br/>` 换行
- 箭头方向 LR / RL / TD 选一个保持全局一致

### 1.2 时序/事件流

```mermaid
timeline
    title 半导体周期 2023~2025
    2023Q3 : 存储现货价触底
    2024Q1 : 三星减产
    2024Q2 : DRAM 现货价 +30%
    2024Q3 : HBM 供不应求
    2024Q4 : 三星营业利润 +10x YoY
```

### 1.3 产业链 / 桑基 (简化版)

```mermaid
flowchart TB
    subgraph 上游
        A1[硅片] --> B1[晶圆代工]
        A2[光刻胶] --> B1
        A3[电子气体] --> B1
    end
    subgraph 中游
        B1 --> C1[芯片设计]
        C1 --> C2[封装测试]
    end
    subgraph 下游
        C2 --> D1[消费电子]
        C2 --> D2[数据中心]
        C2 --> D3[汽车电子]
    end
```

- 节点超过 12 个或层级 > 3 层时, 改用外部 svg

### 1.4 多空博弈 (象限)

```mermaid
quadrantChart
    title AI 算力 投资象限
    x-axis "短期催化弱 --> 强"
    y-axis "估值低 --> 高"
    quadrant-1 "明星 (加仓)"
    quadrant-2 "高估过热 (减仓)"
    quadrant-3 "价值陷阱"
    quadrant-4 "底部反转 (观察)"
    "光模块": [0.8, 0.75]
    "国产 GPU": [0.6, 0.55]
    "IDC 运营": [0.3, 0.4]
    "应用 SaaS": [0.4, 0.6]
```

## 2. SVG 外部文件规范

### 2.1 何时用 svg 而非 mermaid

- 节点 > 12 个, mermaid 自动布局会糊
- 需要精确控制位置 (如产业链拓扑、对照表)
- 需要自定义图形 (矩形/圆/图标混合)
- 跨平台分享, 不想依赖 mermaid 渲染器

### 2.2 文件存放

- 路径: `markdown/diagrams/` (markdown 报告同级)
- 命名: `kebab-case-<topic>.svg`
  - 例: `semicon-supply-chain.svg`、`fed-rate-transmission.svg`
- 编码: UTF-8, viewBox 设置, 不要写死 width/height

### 2.3 引用语法

在 markdown 中:

```markdown
![半导体产业链传导链](diagrams/semicon-supply-chain.svg)
```

或带尺寸:

```markdown
<img src="diagrams/fed-rate-transmission.svg" alt="美联储利率传导链" width="100%">
```

### 2.4 svg 最小可工作模板

```svg
<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 400" font-family="sans-serif">
  <defs>
    <marker id="arrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto">
      <path d="M 0 0 L 10 5 L 0 10 z" fill="#333"/>
    </marker>
  </defs>
  <rect x="40" y="40" width="160" height="60" rx="8" fill="#e3f2fd" stroke="#1976d2"/>
  <text x="120" y="75" text-anchor="middle" font-size="14">新闻事件</text>
  <line x1="200" y1="70" x2="280" y2="70" stroke="#333" stroke-width="2" marker-end="url(#arrow)"/>
  <rect x="280" y="40" width="160" height="60" rx="8" fill="#fff3e0" stroke="#f57c00"/>
  <text x="360" y="75" text-anchor="middle" font-size="14">中间变量</text>
  <!-- 继续追加 ... -->
</svg>
```

### 2.5 svg 文字兼容

- **禁用** Web 字体, 全部用 `sans-serif` / `serif` / `monospace` 系统字体
- 中文字符确保 svg 文件以 UTF-8 编码保存
- 字号 ≥ 12px, 否则在 dark mode 下不可读
- 颜色优先用 `currentColor` 或低饱和度, 适配深色背景

## 3. 选择决策树

```
要画的图是 ...
├─ 简单的单向因果 (3~6 节点)
│   └─ mermaid flowchart LR
├─ 时间线 / 事件序列
│   └─ mermaid timeline
├─ 产业链/桑基 (节点 < 12, 层级 < 3)
│   └─ mermaid flowchart TB + subgraph
├─ 2x2 象限 / 散点
│   └─ mermaid quadrantChart
├─ 复杂拓扑 / 精确布局 / 自定义形状
│   └─ 外部 svg (落地到 diagrams/)
└─ 不确定
    └─ 默认 mermaid, 跑出来太乱再升级 svg
```

## 4. 资源清单模板 (放在 markdown 末尾)

```markdown
---
*Sources: [1] Reuters ... [2] 财新 ...*
*Diagrams: [semicon-supply-chain.svg](diagrams/semicon-supply-chain.svg) · [fed-rate-transmission.svg](diagrams/fed-rate-transmission.svg)*
```

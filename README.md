<div align="center">
<h1>commonmark hybrid</h1>
</div>

<p align="center">
<img alt="" src="https://img.shields.io/badge/release-v1.3.3-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/build-pass-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjc-v1.0.5-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjcov-95.6%25-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/project-open-brightgreen" style="display: inline-block;" />
</p>

## 介绍

用于根据CommonMark规范（以及一些扩展）解析和呈现Markdown文本。
主页 [commonmark_hybrid](https://gitcode.com/Cangjie-TPC/commonmark4cj/tree/commonmark_hybrid_cangjie-plugin-5.1.1)

### 特性

- 🚀 解析markdown文本

- 🛠️ Node树状结构

- 💡 遍历/渲染Node树

## 软件架构

### 架构
<!-- 

---
config:
  flowchart:
    defaultRenderer: "elk"
---
%% basis bumpX bumpY cardinal catmullRom linear monotoneX monotoneY natural step stepAfter stepBefore
 -->
```mermaid
---
config:
  flowchart:
    curve: basis
---
flowchart TB

  md[/MarkdownText/] 

  subgraph Parser [Parser解析]
    direction TB
    document(document解析) --> block(段落解析) --> inline(行内解析)
  end

  node[/Node树/]

  subgraph Render [Render]
    mdrender(MarkdownRenderer)
  end

  nodeView[/NodeView/]


  subgraph plugin[plugin插件]
    direction TB
    pre(前处理)
    blockext(段落解析扩展)
    inlineext(行内解析扩展)
    post(后处理)
    visitor(render扩展)

    pre~~~blockext~~~inlineext~~~post~~~visitor
  end

  md e1@==> Parser e2@==> node e3@==> Render e4@==> nodeView
  e1@{ animate: true }
  e2@{ animate: true }
  e3@{ animate: true }
  e4@{ animate: true }
    
  md -.- pre
  block -.- blockext
  inline -.- inlineext
  node -.- post
  mdrender -.- visitor
```

### 源码目录

```shell
├── src                    # 互操作包装源码
├── Index.ets              # index
├── CHANGELOG.md           # 修改日志
├── LICENSE                # license 文件
└── README.md              # 整体介绍
```

### 接口说明

`JsNode`主要属性/方法合并自`commonmark.Node`  
详细说明: [commonmark.Node](https://gitcode.com/Cangjie-TPC/commonmark4cj/blob/develop/doc/feature_api.md#1-node)


## 使用说明

### 编译构建

描述具体的编译过程：

```shell
# ohpm 安装
ohpm install @cangjie-tpc/commonmark_hybrid
```

### 功能示例

#### 解析markdown文本

示例代码如下：

```typescript
import {
  JsNode as Node,
  JsNodeImpl,
  parseIntoJsNode,
  ParsedInline,
  Scanner,
  InlineContentParser,
  Options,
  printNode,
  utf8Index2utf16Index,
  utf16Index2utf8Index
} from "@cangjie-tpc/commonmark_hybrid"
import { hilog } from "@kit.PerformanceAnalysisKit";

/* 自定义行内解析 */
class MyParser implements InlineContentParser {
  getTriggerCharacters(): Array<string> {
    return ['a']
  }

  tryParse(scanner: Scanner): undefined | ParsedInline {
    // hilog.error(0, 'mod', 'MyParser.tryParse')
    let str = ''
    let line = scanner.lines[scanner.lineIndex]
    let i = utf8Index2utf16Index(line, scanner.index) + 1
    for (; i < line.length; i++) {
      if (line[i] == 'a') {
        i++
        break
      }
      str += line[i]
    }
    let props = new Map<string, string>()
    props.set('str', str)
    return {
      node: {
        nodeType: 'anode',
        props: props
      },
      index: utf16Index2utf8Index(line, i),
      lineIndex: scanner.lineIndex
    }
  }
}

export default async function parse(): Promise<void> {
  let markdownString = "😀我0123a56a89"
  let myParser: InlineContentParser = new MyParser()
  let opt: Options = {
    includeSourceSpans: 0,
    customParsers: [myParser],
    jsNodeFactory: () => new JsNodeImpl(),
    cmInlineSelfCloseTags: [],
    cmInlineOpenCloseTags: []
  }
  let node = await parseIntoJsNode(markdownString, opt)
  let nodeTreeStr = printNode(node)
  hilog.info(0, '', nodeTreeStr)
}
```

执行结果如下：

```
Document{}
    Paragraph{}
        Text{literal=😀我0123}
        anode{[(str, 56)]}
        Text{literal=89}
```

## 约束与限制

在下述版本验证通过:

| 编号 | 依赖构建工具      | 版本号    |
| ---- | ----------------- | --------- |
| 1    | **DevEco Studio** | 5.1.1.851 |
| 2    | **cjc**           | v1.0.5    |

## 开源协议

本项目基于 [BSD-2-Clause](https://gitcode.com/Cangjie-TPC/commonmark4cj/blob/develop/LICENSE) ，请自由的享受和参与开源。

## 参与贡献

欢迎给我们提交PR，欢迎给我们提交Issue，欢迎参与任何形式的贡献。
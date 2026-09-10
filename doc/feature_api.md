## commonmark4cj 库

```mermaid
flowchart LR
    md[/MarkdownText/] -->parser(Parser解析)
    parser --> node[Node树]
    parser <--> BlockParser[[自定义段落解析]]
    parser <--> DelimiterProcessor[[自定义行内符号解析]]
    parser <--> InlineContentParser[[自定义行内解析]]
    parser <--> LinkProcessor[[自定义行内解析]]
    parser <--> PostProcessor[[后处理]]
    node --> renderer(Renderer渲染)
    renderer <--> visitor[[Visitor遍历]]
    renderer --> res[/渲染结果/]
```

### 介绍

根据CommonMark规范（以及一些扩展）解析和呈现Markdown文本。

### 1 Node

前置条件：NA 

场景：markdown解析得到的节点树，不同类型节点为不同的Node子类

约束：Block 类型节点的父节点必须也是 Block 类型，将 Block 挂到行内节点下时 appendChild/prependChild/insertBefore/insertAfter 抛出 IllegalArgumentException；getSourceSpans 返回的源跨度仅在解析器启用 includeSourceSpans 后有值，否则为空列表

可靠性：NA

#### 1.1 普通Node 通常为行内节点

##### 1.1.1 主要接口

```cangjie
/**
 * 通用节点
 * NodeType 为 String 的类型别名，用于标识节点类型
 */
public abstract class Node <: Context & ToString & Equatable<Node> & Hashable {

    /*
     * 添加操作行为
     * 参数 Visitor - 具体的操作行为
     */
    public open func accept(visitor: Visitor): Unit

    /*
     * 获取下一个节点
     * 返回值 ?Node - Option Node 下一个节点
     */
    public func getNext(): ?Node

    /*
     * 获取上一个节点
     * 返回值 ?Node - Option Node 上一个节点
     */
    public func getPrevious(): ?Node

    /*
     * 获取第一个孩子节点
     * 返回值 ?Node - Option Node 第一个孩子节点
     */
    public func getFirstChild(): ?Node
    
    /*
     * 获取最后一个孩子节点
     * 返回值 ?Node - Option Node 最后一个孩子节点
     */
    public func getLastChild(): ?Node
    /*
     * 获取父节点
     * 返回值 ?Node - Option Node 父节点
     */
    public open func getParent(): ?Node
    /*
     * 获取节点类型
     * 返回值 NodeType - 节点类型（NodeType 为 String 别名）
     */
    public func getNodeType(): NodeType
    /*
     * 获取节点的源跨度列表（解析器未启用源跨度时返回空列表）
     * 返回值 ArrayList<SourceSpan> - 源跨度列表
     */
    public func getSourceSpans(): ArrayList<SourceSpan>
    /*
     * 替换当前源跨度列表
     * 参数 ArrayList<SourceSpan> - 新的源跨度列表
     */
    public func setSourceSpans(sourceSpans: ArrayList<SourceSpan>): Unit
    /*
     * 在源跨度列表末尾添加一个源跨度
     * 参数 SourceSpan - 源跨度
     */
    public func addSourceSpan(sourceSpan: SourceSpan): Unit
    /*
     * 末尾添加子节点
     * 参数 Node - 子节点
     * 异常 IllegalArgumentException - 当子节点为 Block 类型而父节点不是 Block 时
     */
    public func appendChild(child: Node): Unit
    /*
     * 开头添加子节点
     * 参数 Node - 子节点
     * 异常 IllegalArgumentException - 当子节点为 Block 类型而父节点不是 Block 时
     */
    public func prependChild(child: Node): Unit
    /*
     * 断开连接
     */
    public func unlink(): Unit
    
    /*
     * 后插入一个兄弟节点
     * 参数 Node - 兄弟节点
     * 异常 IllegalArgumentException - 当兄弟节点为 Block 类型而当前节点的父节点不是 Block 时
     */
    public func insertAfter(sibling: Node): Unit
    /*
     * 前插入一个兄弟节点
     * 参数 Node - 兄弟节点
     * 异常 IllegalArgumentException - 当兄弟节点为 Block 类型而当前节点的父节点不是 Block 时
     */
    public func insertBefore(sibling: Node): Unit
    /*
     * toString
     * 返回值 String - toString
     */
    public open func toString(): String
    /*
     * 重写 == 
     * 参数 Node - 比较Node
     * 返回值 Bool - 是否相等
     */
    public operator func ==(other: Node): Bool
    /*
     * 重写 != 
     * 参数 Node - 比较Node
     * 返回值 Bool - 是否不相等
     */
    public operator func !=(other: Node): Bool
    /*
     * 计算哈希值
     * 返回值 Int - 哈希值
     */
    public open func hashCode(): Int
}

/**
 * 节点遍历工具
 */
public class Nodes {
    /*
     * 获取两个节点之间的兄弟节点迭代器（不含 first，不含 end）
     * 参数 Node - 起始节点
     * 参数 Node - 结束节点
     * 返回值 Iterator<Node> - 兄弟节点迭代器
     */
    public static func between(first: Node, end: Node): Iterator<Node>
}

/**
 * 文本节点
 */
public class Text <: Node & Equatable<Text> {
    public init(literal: String): Unit
    /*
     * 添加操作行为
     * 参数 Visitor - 具体的操作行为
     */
    public override func accept(visitor: Visitor): Unit
    /*
     * 获取文本
     * 返回值 String - 文本
     */
    public func getLiteral(): String
    /*
     * 设置文本
     * 参数 String - 文本
     */
    public func setLiteral(literal: String): Unit
    /*
     * 重写 == 
     * 参数 Text - 比较Text
     * 返回值 Bool - 是否相等
     */
    public operator func ==(other: Text): Bool
    /*
     * 重写 != 
     * 参数 Text - 比较Text
     * 返回值 Bool - 是否不相等
     */
    public operator func !=(other: Text): Bool
}

/**
 * HtmlInline节点
 */
public class HtmlInline <: Node {
    public init(literal: String): Unit
    /*
     * 添加操作行为
     * 参数 Visitor - 具体的操作行为
     */
    public override func accept(visitor: Visitor): Unit
    /*
     * 获取文本
     * 返回值 String - 文本
     */
    public func getLiteral(): String
    /*
     * 设置文本
     * 参数 String - 文本
     */
    public func setLiteral(literal: String): Unit
}

/**
 * CustomNode节点
 */
public abstract class CustomNode <: Node {
    /*
     * 添加操作行为
     * 参数 Visitor - 具体的操作行为
     */
    public override func accept(visitor: Visitor): Unit
}
/**
 * 图片节点
 */
public class Image <: Node {
    /*
     * 初始化
     * 参数 String - 图片地址链接
     * 参数 ?String - 标题
     */
    public init(destination: String, title: ?String)
    /*
     * 添加操作行为
     * 参数 Visitor - 具体的操作行为
     */
    public override func accept(visitor: Visitor): Unit
    /*
     * 获取地址链接
     * 返回值 String - 地址链接
     */
    public func getDestination(): String
    /*
     * 设置地址链接
     * 参数 String - 地址链接
     */
    public func setDestination(destination: String): Unit
    /*
     * 获取标题
     * 返回值 ?String - 标题
     */
    public func getTitle(): ?String
    /*
     * 设置标题（getter 返回 ?String，setter 接收非可选 String）
     * 参数 String - 标题
     */
    public func setTitle(title: String): Unit
}

/**
 * Code节点
 */
public class Code <: Node {
    public init(literal: String): Unit
    /*
     * 添加操作行为
     * 参数 Visitor - 具体的操作行为
     */
    public override func accept(visitor: Visitor): Unit
    /*
     * 获取文本
     * 返回值 String - 文本
     */
    public func getLiteral(): String
    /*
     * 设置文本
     * 参数 String - 文本
     */
    public func setLiteral(literal: String): Unit
}

/**
 * HardLineBreak节点
 */
public class HardLineBreak <: Node {
    /*
     * 添加操作行为
     * 参数 Visitor - 具体的操作行为
     */
    public override func accept(visitor: Visitor): Unit
}

/**
 * SoftLineBreak节点
 */
public class SoftLineBreak <: Node {
    /*
     * 添加操作行为
     * 参数 Visitor - 具体的操作行为
     */
    public override func accept(visitor: Visitor): Unit
}

/**
 * Link节点
 */
public class Link <: Node {
    public init(destination: String, title: ?String)
    /*
     * 添加操作行为
     * 参数 Visitor - 具体的操作行为
     */
    public override func accept(visitor: Visitor): Unit
    /*
     * 获取目标地址
     * 返回值 String - 目标地址
     */
    public func getDestination(): String
    /*
     * 设置目标地址
     * 参数 String - 目标地址
     */
    public func setDestination(destination: String): Unit
    /*
     * 获取标题
     * 返回值 ?String - 标题
     */
    public func getTitle(): ?String
    /*
     * 设置标题（getter 返回 ?String，setter 接收非可选 String）
     * 参数 String - 标题
     */
    public func setTitle(title: String): Unit

}

/**
 * 分隔符接口
 */
public interface Delimited {
    /*
     * 获取开头分隔符
     * 返回值 ?String - 开头分隔符
     */
    func getOpeningDelimiter(): ?String
    /*
     * 获取结尾分隔符
     * 返回值 ?String - 结尾分隔符
     */
    func getClosingDelimiter(): ?String
}

/**
 * StrongEmphasis节点
 */
public class StrongEmphasis <: Node & Delimited {
    /*
     * 初始化
     */
    public init(): Unit
    /*
     * 初始化
     * 参数 String - 分隔符
     */
    public init(delimiter: String): Unit
    /*
     * 设置分隔符
     * 参数 String - 分隔符
     */
    public func setDelimiter(delimiter: String): Unit
    /*
     * 获取开头分隔符
     * 返回值 ?String - 开头分隔符
     */
    public func getOpeningDelimiter(): ?String
    /*
     * 获取结尾分隔符
     * 返回值 ?String - 结尾分隔符
     */
    public func getClosingDelimiter(): ?String
    /*
     * 添加操作行为
     * 参数 Visitor - 具体的操作行为
     */
    public override func accept(visitor: Visitor): Unit
}

public class Emphasis <: Node & Delimited {
    /*
     * 初始化
     */
    public init()
    /*
     * 初始化
     * 参数 String - 分隔符
     */
    public init(delimiter: String)
    /*
     * 设置分隔符
     * 参数 String - 分隔符
     */
    public func setDelimiter(delimiter: String): Unit
    /*
     * 获取开头分隔符
     * 返回值 ?String - 开头分隔符
     */
    public func getOpeningDelimiter(): ?String
    /*
     * 获取结尾分隔符
     * 返回值 ?String - 结尾分隔符
     */
    public func getClosingDelimiter(): ?String
    /*
     * 添加操作行为
     * 参数 Visitor - 具体的操作行为
     */
    public override func accept(visitor: Visitor): Unit
}
```

#### 1.2 Block系列节点

##### 1.2.1 主要接口

```cangjie
public abstract class Block <: Node {
    /*
     * 获取父节点，仅当父节点为 Block 类型时返回，否则返回 None
     * 返回值 ?Node - Option Node 父节点
     */
    public func getParent(): ?Node
    /*
     * 设置父节点（与 Node.setParent(parent: ?Node) 构成重载）
     * 参数 Node - 父节点
     * 异常 IllegalArgumentException - 当父节点不是 Block 类型时
     */
    protected open func setParent(parent: Node): Unit
}

public class BlockQuote <: Block {
    /*
     * 添加操作行为
     * 参数 Visitor - 具体的操作行为
     */
    public func accept(visitor: Visitor): Unit
}

public class HtmlBlock <: Block {
    /*
     * 添加操作行为
     * 参数 Visitor - 具体的操作行为
     */
    public func accept(visitor: Visitor): Unit
    /*
     * 获取文本
     * 返回值 String - 文本
     */
    public func getLiteral(): String
    /*
     * 设置文本
     * 参数 String - 文本
     */
    public func setLiteral(literal: String): Unit
}

public abstract class CustomBlock <: Block {
    /*
     * 添加操作行为
     * 参数 Visitor - 具体的操作行为
     */
    public func accept(visitor: Visitor): Unit
}

public class ThematicBreak <: Block {
    /*
     * 添加操作行为
     * 参数 Visitor - 具体的操作行为
     */
    public func accept(visitor: Visitor): Unit
}

public class Document <: Block {
    /*
     * 添加操作行为
     * 参数 Visitor - 具体的操作行为
     */
    public func accept(visitor: Visitor): Unit
}

public class Paragraph <: Block {
    /*
     * 添加操作行为
     * 参数 Visitor - 具体的操作行为
     */
    public func accept(visitor: Visitor): Unit
}

public class IndentedCodeBlock <: Block {
    /*
     * 添加操作行为
     * 参数 Visitor - 具体的操作行为
     */
    public func accept(visitor: Visitor): Unit
    /*
     * 获取文本
     * 返回值 String - 文本
     */
    public func getLiteral(): String
    /*
     * 设置文本
     * 参数 String - 文本
     */
    public func setLiteral(literal: String): Unit
}

public class FencedCodeBlock <: Block {
    /*
     * 添加操作行为
     * 参数 Visitor - 具体的操作行为
     */
    public func accept(visitor: Visitor): Unit
    /*
     * 获取围栏字符（反引号 ` 或波浪号 ~，由解析器根据源文本设置，新建节点默认为 NUL）
     * 返回值 Rune - 围栏字符
     */
    public func getFenceChar(): Rune
    /*
     * 设置围栏字符
     * 参数 Rune - 围栏字符
     */
    public func setFenceChar(fenceChar: Rune): Unit
    /*
     * 获取围栏代码块长度 至少3
     * 返回值 Int64 - 围栏代码块长度
     */
    public func getFenceLength(): Int64
    /*
     * 设置围栏代码块长度
     * 参数 Int64 - 围栏代码块长度
     */
    public func setFenceLength(fenceLength: Int64): Unit
    /*
     * 获取围栏与代码块的缩进量
     * 返回值 Int64 - 围栏与代码块的缩进量
     */
    public func getFenceIndent(): Int64
    /*
     * 设置围栏与代码块的缩进量
     * 参数 Int64 - 围栏与代码块的缩进量
     */
    public func setFenceIndent(fenceIndent: Int64): Unit
    /*
     * 获取语言标识符
     * 返回值 String - 语言标识符
     */
    public func getInfo(): String
    /*
     * 设置语言标识符
     * 参数 String - 语言标识符
     */
    public func setInfo(info: String): Unit
    /*
     * 获取文本
     * 返回值 String - 文本
     */
    public func getLiteral(): String
    /*
     * 设置文本
     * 参数 String - 文本
     */
    public func setLiteral(literal: String): Unit
}

public class ListItem <: Block {
    /*
     * 添加操作行为
     * 参数 Visitor - 具体的操作行为
     */
    public func accept(visitor: Visitor): Unit
}

public class Heading <: Block {
    /*
     * 添加操作行为
     * 参数 Visitor - 具体的操作行为
     */
    public func accept(visitor: Visitor): Unit
    /*
     * 获取标题级别
     * 返回值 Int64 - 标题级别
     */
    public func getLevel(): Int64
    /*
     * 设置标题级别
     * 参数 Int64 - 标题级别
     */
    public func setLevel(level: Int64): Unit
}
/**
 * 列表块节点
 */
public abstract class ListBlock <: Block {
    /*
     * 获取表块是不是紧凑的
     * 返回值 Bool - 列表块是不是紧凑的
     */
    public func isTight(): Bool
    /*
     * 设置列表块是不是紧凑的
     * 参数 Bool - 列表块是不是紧凑的
     */
    public func setTight(tight: Bool)
}
/**
 * 无序列表块节点
 */
public class BulletList <: ListBlock {
    /*
     * 初始化
     * 参数 Rune - 标记
     */
    public init(bulletMarker: Rune): Unit
    /*
     * 添加操作行为
     * 参数 Visitor - 具体的操作行为
     */
    public func accept(visitor: Visitor): Unit

    /*
     * 获取标记
     * 返回值 Rune - 标记
     */
    public func getBulletMarker(): Rune
    /*
     * 设置标记
     * 参数 Rune - 标记
     */
    public func setBulletMarker(bulletMarker: Rune): Unit
}
/**
 * 有序列表块节点
 */
public class OrderedList <: ListBlock {
    /*
     * 初始化
     * 参数 Int64 - 起始数字
     * 参数 Rune - 分隔符
     */
    public init(startNumber: Int64, delimiter: Rune)
    /*
     * 添加操作行为
     * 参数 Visitor - 具体的操作行为
     */
    public func accept(visitor: Visitor): Unit
    /*
     * 获取起始数字
     * 返回值 Int64 - 起始数字
     */
    public func getStartNumber(): Int64
    /*
     * 设置起始数字
     * 参数 Int64 - 起始数字
     */
    public func setStartNumber(startNumber: Int64): Unit
    /*
     * 获取分隔符
     * 返回值 Rune - 分隔符
     */
    public func getDelimiter(): Rune
    /*
     * 设置分隔符
     * 参数 Rune - 分隔符
     */
    public func setDelimiter(delimiter: Rune): Unit
}

/**
 * LinkReferenceDefinition节点
 */
public class LinkReferenceDefinition <: Block {
    /*
     * 初始化
     */
    public init()
    /*
     * 初始化
     * 参数 String - 链接引用的标签
     * 参数 String - 目标地址
     * 参数 ?String - 标题（可为 None）
     */
    public init(label: String, destination: String, title: ?String)
    /*
     * 获取链接引用的标签
     * 返回值 ?String - 链接引用的标签
     */
    public func getLabel(): ?String
    /*
     * 设置链接引用的标签
     * 参数 String - 链接引用的标签
     */
    public func setLabel(label: String): Unit
    /*
     * 获取目标地址
     * 返回值 String - 目标地址
     */
    public func getDestination(): String
    /*
     * 设置目标地址
     * 参数 String - 目标地址
     */
    public func setDestination(destination: String): Unit
    /*
     * 获取标题
     * 返回值 ?String - 标题
     */
    public func getTitle(): ?String
    /*
     * 设置标题
     * 参数 String - 标题
     */
    public func setTitle(title: String): Unit
    /*
     * 添加操作行为
     * 参数 Visitor - 具体的操作行为
     */
    public override func accept(visitor: Visitor): Unit
}
```

##### 1.2.2 示例

```cangjie
    import commonmark4cj.commonmark.*
    import std.unittest.*
    import std.unittest.testmacro.*

    @Test
    public class DocumentTest {
        @TestCase
        func documentTest(): Unit {
            var document: Document = Document()
            var paragraph = Paragraph()
            var blockQuote = BlockQuote()
            var htmlBlock = HtmlBlock()
            var thematicBreak = ThematicBreak()
            var indentedCodeBlock = IndentedCodeBlock()
            var text = Text("text")

            document.appendChild(paragraph)
            document.appendChild(blockQuote)
            document.appendChild(htmlBlock)
            document.appendChild(thematicBreak)
            document.appendChild(indentedCodeBlock)
            document.appendChild(text)
            assertEquals("Document{}", blockQuote.getParent()().toString())
            assertEquals(None, document.getParent())

            htmlBlock.setLiteral("p1")
            assertEquals("p1", htmlBlock.getLiteral())

            assertEquals("HtmlBlock{}", thematicBreak.getPrevious()().toString())

            htmlBlock.insertBefore(Text("foo"))
            assertEquals("Text{literal=foo}", htmlBlock.getPrevious()().toString())

            assertEquals(true, paragraph != htmlBlock)
        }
    }
```

#### 1.3 Visitor接口

##### 1.3.1 主要接口

```cangjie
public interface Visitor {
    func visit(blockQuote: BlockQuote): Unit

    func visit(bulletList: BulletList): Unit

    func visit(code: Code): Unit

    func visit(document: Document): Unit

    func visit(emphasis: Emphasis): Unit

    func visit(fencedCodeBlock: FencedCodeBlock): Unit

    func visit(hardLineBreak: HardLineBreak): Unit

    func visit(heading: Heading): Unit

    func visit(thematicBreak: ThematicBreak): Unit

    func visit(htmlInline: HtmlInline): Unit

    func visit(htmlBlock: HtmlBlock): Unit

    func visit(image: Image): Unit

    func visit(indentedCodeBlock: IndentedCodeBlock): Unit

    func visit(link: Link): Unit

    func visit(listItem: ListItem): Unit

    func visit(orderedList: OrderedList): Unit

    func visit(paragraph: Paragraph): Unit

    func visit(softLineBreak: SoftLineBreak): Unit

    func visit(strongEmphasis: StrongEmphasis): Unit

    func visit(text: Text): Unit

    func visit(linkReferenceDefinition: LinkReferenceDefinition): Unit

    func visit(customBlock: CustomBlock): Unit

    func visit(customNode: CustomNode): Unit
}

public abstract class AbstractVisitor <: Visitor {
    /*
     * 处理渲染BlockQuote节点的行为
     * 参数 BlockQuote - BlockQuote节点
     */
    public open func visit(blockQuote: BlockQuote): Unit
    /*
     * 处理渲染BulletList节点的行为
     * 参数 BulletList - BulletList节点
     */
    public open func visit(bulletList: BulletList): Unit
    /*
     * 处理渲染Code节点的行为
     * 参数 Code - Code节点
     */
    public open func visit(code: Code): Unit
    /*
     * 处理渲染Document节点的行为
     * 参数 Document - Document节点
     */
    public open func visit(document: Document): Unit
    /*
     * 处理渲染Emphasis节点的行为
     * 参数 Emphasis - Emphasis节点
     */
    public open func visit(emphasis: Emphasis): Unit
    /*
     * 处理渲染FencedCodeBlock节点的行为
     * 参数 FencedCodeBlock - FencedCodeBlock节点
     */
    public open func visit(fencedCodeBlock: FencedCodeBlock): Unit
    /*
     * 处理渲染HardLineBreak节点的行为
     * 参数 HardLineBreak - HardLineBreak节点
     */
    public open func visit(hardLineBreak: HardLineBreak): Unit
    /*
     * 处理渲染Heading节点的行为
     * 参数 Heading - Heading节点
     */
    public open func visit(heading: Heading): Unit
    /*
     * 处理渲染ThematicBreak节点的行为
     * 参数 ThematicBreak - ThematicBreak节点
     */
    public open func visit(thematicBreak: ThematicBreak): Unit
    /*
     * 处理渲染HtmlInline节点的行为
     * 参数 HtmlInline - HtmlInline节点
     */
    public open func visit(htmlInline: HtmlInline): Unit
    /*
     * 处理渲染HtmlBlock节点的行为
     * 参数 HtmlBlock - HtmlBlock节点
     */
    public open func visit(htmlBlock: HtmlBlock): Unit
    /*
     * 处理渲染Image节点的行为
     * 参数 Image - Image节点
     */
    public open func visit(image: Image): Unit
    /*
     * 处理渲染IndentedCodeBlock节点的行为
     * 参数 IndentedCodeBlock - IndentedCodeBlock节点
     */
    public open func visit(indentedCodeBlock: IndentedCodeBlock): Unit
    /*
     * 处理渲染Link节点的行为
     * 参数 Link - Link节点
     */
    public open func visit(link: Link): Unit
    /*
     * 处理渲染ListItem节点的行为
     * 参数 ListItem - ListItem节点
     */
    public open func visit(listItem: ListItem): Unit
    /*
     * 处理渲染OrderedList节点的行为
     * 参数 OrderedList - OrderedList节点
     */
    public open func visit(orderedList: OrderedList): Unit
    /*
     * 处理渲染Paragraph节点的行为
     * 参数 Paragraph - Paragraph节点
     */
    public open func visit(paragraph: Paragraph): Unit
    /*
     * 处理渲染SoftLineBreak节点的行为
     * 参数 SoftLineBreak - SoftLineBreak节点
     */
    public open func visit(softLineBreak: SoftLineBreak): Unit
    /*
     * 处理渲染StrongEmphasis节点的行为
     * 参数 StrongEmphasis - StrongEmphasis节点
     */
    public open func visit(strongEmphasis: StrongEmphasis): Unit
    /*
     * 处理渲染Text节点的行为
     * 参数 Text - Text节点
     */
    public open func visit(text: Text): Unit
    /*
     * 处理渲染LinkReferenceDefinition节点的行为
     * 参数 LinkReferenceDefinition - LinkReferenceDefinition节点
     */
    public open func visit(linkReferenceDefinition: LinkReferenceDefinition): Unit
    /*
     * 处理渲染CustomBlock节点的行为
     * 参数 CustomBlock - CustomBlock节点
     */
    public open func visit(customBlock: CustomBlock): Unit
    /*
     * 处理渲染CustomNode节点的行为
     * 参数 CustomNode - CustomNode节点
     */
    public open func visit(customNode: CustomNode): Unit
}
```

##### 1.3.2 示例

```cangjie
    import commonmark4cj.commonmark.*
    import std.unittest.*
    import std.unittest.testmacro.*

    class visitorImpl <: AbstractVisitor {
        public func visit(code: Code): Unit {
            code.insertAfter(Text("new text"))
            code.unlink()
        }
    }

    @Test
    public class VisitorDocTest {
        @TestCase
        func test_visitor(): Unit {
            let visitor: Visitor = visitorImpl()

            var document: Document = Document()
            var paragraph = Paragraph()
            var text = Text("text")
            var code = Code("code")

            document.appendChild(paragraph)
            document.appendChild(text)
            document.appendChild(code)

            document.accept(visitor)

            assertEquals("Text{literal=new text}", document.getLastChild().getOrThrow().toString())
        }
    }
```

### 2 Parse

前置条件：NA 

场景：将markdown文本解析为节点树

约束：分隔符处理器注册冲突（同字符同最小长度、或与已占用字符冲突）时 ParserBuilder.build 抛出 IllegalArgumentException；parseReader 读取流失败时抛出 IO 异常；Scanner 位置越界抛出 IllegalArgumentException，输入含非法 UTF-8 序列时抛出 IllegalStateException

可靠性：parse/parseReader 线程安全（每次调用使用独立的解析器状态）

#### 2.1 Parser

##### 2.1.1 主要接口

```cangjie
public class Parser {
    /*
     * 获取ParserBuilder对象
     * 返回值 ParserBuilder - ParserBuilder对象
     */
    public static func builder(): ParserBuilder

    /*
     * 解析文本 生成Node
     * 参数 String - 文本
     * 返回值 Node - Node对象（Document根节点，经过PostProcessor后处理）
     */
    public func parse(input: String): Node

    /*
     * 解析流 生成Node，调用方负责关闭流
     * 注意：若输入含BOM（字节顺序标记），需在传入前自行跳过
     * 参数 InputStream - 输入流
     * 返回值 Node - Node对象（Document根节点，经过PostProcessor后处理）
     * 异常 IOException - 读取流失败时抛出
     */
    public func parseReader(input: InputStream): Node
}

public class ParserBuilder {

    /*
     * 构建Parser对象
     * 返回值 Parser - Parser对象
     * 异常 IllegalArgumentException - 分隔符处理器与已占用字符冲突，
     *     或同字符同最小长度重复注册分隔符处理器时抛出
     */
    public func build(): Parser

    /*
     * 获取默认启用的块类型集合，默认包含七种：
     * BlockQuote、Heading、FencedCodeBlock、HtmlBlock、
     * ThematicBreak、ListBlock、IndentedCodeBlock
     * 返回值 HashSet<NodeType> - 默认启用的块类型集合
     */
    public func getEnabledBlockTypes(): HashSet<NodeType>

    /*
     * 作为插件 拓展解析器 参考table
     * 参数 Iterable<T> - 拓展的解析器集合
     * 返回值 ParserBuilder - ParserBuilder对象
     */
    public func extensions<T>(extensions: Iterable<T>): ParserBuilder where T <: Extension

    /*
     * 更新支持解析的Node对象集合，传空集合则不解析任何核心块语法
     * 参数 HashSet<NodeType> - 支持解析的Node对象集合
     * 返回值 ParserBuilder - ParserBuilder对象
     */
    public func enabledBlockTypes(enabledBlockTypes: HashSet<NodeType>): ParserBuilder

    /*
     * 解析时是否计算节点的源跨度（SourceSpan），默认不包含（NONE）
     * 参数 IncludeSourceSpans - NONE / BLOCKS / BLOCKS_AND_INLINES
     * 返回值 ParserBuilder - ParserBuilder对象
     */
    public func includeSourceSpans(includeSourceSpans: IncludeSourceSpans): ParserBuilder

    /*
     * 自定义分隔符的开闭判定，默认使用CommonMark侧翼规则；
     * 处理器返回None时保留内置判定结果
     * 参数 DelimiterOpenCloseProcessor - 开闭判定处理器
     * 返回值 ParserBuilder - ParserBuilder对象
     */
    public func delimiterOpenCloseProcessor(delimiterOpenCloseProcessor: DelimiterOpenCloseProcessor): ParserBuilder

    /*
     * 增加用户新增的解析工厂类（自定义工厂在内置工厂之前生效）
     * 参数 BlockParserFactory - 解析工厂类
     * 返回值 ParserBuilder - ParserBuilder对象
     */
    public func customBlockParserFactory(blockParserFactory: BlockParserFactory): ParserBuilder

    /*
     * 增加用户新增的分隔符处理器；同字符不同最小长度的处理器可共存，
     * 匹配时使用最短满足长度的处理器
     * 参数 DelimiterProcessor - DelimiterProcessor
     * 返回值 ParserBuilder - ParserBuilder对象
     */
    public func customDelimiterProcessor(delimiterProcessor: DelimiterProcessor): ParserBuilder

    /*
     * 增加用户新增的行内内容解析器工厂，基于触发字符激活，
     * 自定义解析器先于内置解析器尝试
     * 参数 InlineContentParserFactory - 行内内容解析器工厂
     * 返回值 ParserBuilder - ParserBuilder对象
     */
    public func customInlineContentParserFactory(inlineContentParserFactory: InlineContentParserFactory): ParserBuilder

    /*
     * 增加用户新增的链接处理器，按注册顺序尝试，可覆盖内置链接解析行为
     * 参数 LinkProcessor - 链接处理器
     * 返回值 ParserBuilder - ParserBuilder对象
     */
    public func linkProcessor(linkProcessor: LinkProcessor): ParserBuilder

    /*
     * 增加自定义链接标记字符（如 !），出现在 [ 之前改变链接含义
     * 参数 Rune - 链接标记字符
     * 返回值 ParserBuilder - ParserBuilder对象
     */
    public func linkMarker(linkMarker: Rune): ParserBuilder

    /*
     * 增加用户新增的PostProcessor处理器
     * 参数 PostProcessor - PostProcessor
     * 返回值 ParserBuilder - ParserBuilder对象
     */
    public func postProcessor(postProcessor: PostProcessor): ParserBuilder

    /*
     * 实现InlineParser接口 用户自定义行内解析
     * 参数 InlineParserFactory - 用户覆盖的InlineParserFactory子类
     * 返回值 ParserBuilder - ParserBuilder对象
     */
    public func inlineParserFactory(inlineParserFactory: InlineParserFactory): ParserBuilder

    /*
     * 获取InlineParserFactory，未定义时返回默认的InlineParserImpl实现
     * 返回值 InlineParserFactory - InlineParserFactory对象
     */
    public func getInlineParserFactory(): InlineParserFactory
}

public interface ParserExtension <: Extension {
    /*
     * 插件拓展 生成拓展的插件
     * 参数 ParserBuilder - ParserBuilder
     */
    func ext(parserBuilder: ParserBuilder): Unit
}

/*
 * 后处理
 */
public interface PostProcessor {
    /*
     * 解析Node
     * 参数 Node - Node
     * 返回值 Node - 处理后的Node（可以是修改后的原节点）
     */
    func process(node: Node): Node
}

```

##### 2.1.2 示例

```cangjie
    import commonmark4cj.commonmark.*
    import std.unittest.*
    import std.unittest.testmacro.*

    @Test
    public class ParseDocTest {
        @TestCase
        func parse_test(): Unit {
            let given: String = "# heading 1\n\nnot a heading"
            var parser: Parser = Parser.builder().build()
            var document: Node = parser.parse(given)
            assertEquals("Heading{}", document.getFirstChild()().toString())
        }
    }
```

#### 2.2 BlockParser

##### 2.2.1 主要接口

```cangjie
/*
 * 块解析器抽象基类，自定义块解析器建议继承本类而非直接实现 BlockParser 接口
 */
public abstract class AbstractBlockParser <: BlockParser {
    /*
     * 是否可以包含其他块级元素，默认 false
     * 返回值 Bool - Bool
     */
    public open func isContainer(): Bool
    /*
     * 是否可以懒惰的换行，默认 false
     * 返回值 Bool - Bool
     */
    public open func canHaveLazyContinuationLines(): Bool
    /*
     * 是否可以包含这个Block对象，默认 false
     * 参数 Block - Block对象
     * 返回值 Bool - Bool
     */
    public open func canContain(childBlock: Block): Bool

    /*
     * 获取Block对象
     * 返回值 Block - block对象
     */
    public open func getBlock(): Block

    /*
     * 添加一行，默认空实现
     * 参数 SourceLine - 行数据
     */
    public open func addLine(line: SourceLine): Unit

    /*
     * 向当前解析的块添加一个源范围。默认实现是将其添加到块中。
     * 除非有复杂的解析需求需要检查源位置，否则无需覆盖此方法。
     * 参数 SourceSpan - 源跨度
     */
    public open func addSourceSpan(sourceSpan: SourceSpan): Unit

    /*
     * 返回此解析器解析的定义，默认返回空列表。
     * 此处返回的定义稍后可通过内联解析过程中的 InlineParserContext.getDefinition 进行访问。
     * 返回值 ArrayList<LinkReferenceDefinition> - 链接引用定义列表
     */
    public open func getDefinitions(): ArrayList<LinkReferenceDefinition>

    /*
     * 关闭块对象，默认空实现
     */
    public open func closeBlock(): Unit

    /*
     * 使用InlineParser解析文本，默认空实现
     * 参数 InlineParser - InlineParser对象
     */
    public open func parseInlines(inlineParser: InlineParser): Unit
}

/*
 * 块解析器工厂抽象基类
 */
public abstract class AbstractBlockParserFactory <: BlockParserFactory {}

public interface BlockParser {
    /*
     * 是否可以包含其他块级元素（容器返回true，叶子块返回false）
     * 返回值 Bool - Bool
     */
    func isContainer(): Bool
    /*
     * 是否可以懒惰的换行：被 tryContinue 拒绝且未匹配其他块解析器的行，
     * 若返回 true 则通过 addLine 加入当前块，否则关闭块
     * 返回值 Bool - Bool
     */
    func canHaveLazyContinuationLines(): Bool

    /*
     * 是否可以包含这个Block对象
     * 参数 Block - Block对象
     * 返回值 Bool - Bool
     */
    func canContain(childBlock: Block): Bool

    /*
     * 获取Block对象
     * 返回值 Block - block对象
     */
    func getBlock(): Block

    /*
     * 获取跨行元素对象 如果存在
     * 参数 ParserState - ParserState对象
     * 返回值 Option<BlockContinue> - BlockContinue
     */
    func tryContinue(parserState: ParserState): Option<BlockContinue>

    /*
     * 添加一行
     * 参数 SourceLine - 行数据
     */
    func addLine(line: SourceLine): Unit

    /*
     * 向当前解析的块添加一个源范围。在 AbstractBlockParser 中的默认实现是将其添加到块中。
     * 除非有复杂的解析需求需要检查源位置，否则无需覆盖此方法。
     * 参数 SourceSpan - 源跨度
     */
    func addSourceSpan(sourceSpan: SourceSpan): Unit

    /*
     * 返回此解析器解析的定义。此处返回的定义稍后可通过内联解析过程中的
     * InlineParserContext.getDefinition 进行访问。
     * 返回值 ArrayList<LinkReferenceDefinition> - 链接引用定义列表
     */
    func getDefinitions(): ArrayList<LinkReferenceDefinition>

    /*
     * 关闭块对象
     */
    func closeBlock(): Unit

    /*
     * 使用InlineParser解析文本
     * 参数 InlineParser - InlineParser对象
     */
    func parseInlines(inlineParser: InlineParser): Unit
}

public open class BlockContinue {
    /*
     * 清空BlockContinue对象
     * 返回值 Option<BlockContinue> - Option<BlockContinue>.None
     */
    public static func none(): Option<BlockContinue>

    /*
     * 设置跨行的元素起始下标
     * 参数 Int64 - 起始下标
     * 返回值 BlockContinue - 构建跨行元素实现类
     */
    public static func atIndex(newIndex: Int64): BlockContinue

    /*
     * 设置跨行的元素起始列（tab按4空格制表位展开后的列）
     * 参数 Int64 - 起始列
     * 返回值 BlockContinue - 构建跨行元素实现类
     */
    public static func atColumn(newColumn: Int64): BlockContinue

    /*
     * 结束跨行
     * 返回值 BlockContinue - 构建跨行元素实现类
     */
    public static func finished(): BlockContinue
}

public interface BlockParserFactory {

    /*
     * 初始化一个特定的 BlockParser 实例来解析当前的文本行
     * 参数 ParserState - ParserState 对象
     * 参数 MatchedBlockParser - MatchedBlockParser 对象
     * 返回值 Option<BlockStart> - BlockStart
     */
    func tryStart(state: ParserState, matchedBlockParser: MatchedBlockParser): Option<BlockStart>
}

/*
 * 最近一次continue阶段匹配到的开放块解析器，
 * 与当前活跃块解析器不同（未匹配的块只在新的块开始时才关闭）。
 * 该接口不打算由客户端实现。
 */
public interface MatchedBlockParser {
    /*
     * 获取匹配到的块解析器
     * 返回值 AbstractBlockParser - 匹配到的块解析器
     */
    func getMatchedBlockParser(): AbstractBlockParser

    /*
     * 获取匹配段落的行（不含链接引用定义部分）
     * 返回值 SourceLines - 段落行
     */
    func getParagraphLines(): SourceLines
}

public abstract class BlockStart {
    /*
     * 生成一个 Option<BlockStart>.None实例
     * 返回值 Option<BlockStart> - Option<BlockStart>.None
     */
    public static func none(): Option<BlockStart>

    /*
     * 生成默认的BlockStart实现类
     * 参数 Array<AbstractBlockParser> - 解析类数组
     * 返回值 BlockStart - BlockStart实现类
     */
    public static func of(blockParsers: Array<AbstractBlockParser>): BlockStart

    /*
     * 指定下标
     * 参数 Int64 - index
     * 返回值 BlockStart - BlockStart实现类
     */
    public func atIndex(newIndex: Int64): BlockStart

    /*
     * 指定列（tab按4空格制表位展开后的列）
     * 参数 Int64 - column
     * 返回值 BlockStart - BlockStart实现类
     */
    public func atColumn(newColumn: Int64): BlockStart

    /*
     * 替换当前活跃块解析器（已废弃，不建议使用）
     * 返回值 BlockStart - BlockStart实现类
     */
    public func replaceActiveBlockParser(): BlockStart

    /*
     * 指定被新块替换的段落下方的行数（用于setext标题等场景）
     * 参数 Int - 行数，必须 >= 1
     * 返回值 BlockStart - BlockStart实现类
     * 异常 IllegalArgumentException - 当 lines 小于 1 时抛出
     */
    public func replaceParagraphLines(lines: Int): BlockStart
}

public interface ParserState {
    /*
     * 获取当前行内容
     * 返回值 SourceLine - 内容
     */
    func getLine(): SourceLine
    /*
     * 获取当前行剩余内容（从当前下标到行尾），已到输入末尾时返回空字符串
     * 返回值 String - 当前行剩余内容
     */
    func getNextLine(): String
    
    /*
     * 获取下标
     * 返回值 Int64 - 下标
     */
    func getIndex(): Int64

    /*
     * 获取下一个没有空格的下标
     * 返回值 Int64 - 下标
     */
    func getNextNonSpaceIndex(): Int64

    /*
     * 获取下标
     * 返回值 Int64 - 下标
     */
    func getColumn(): Int64

    /*
     * 获取缩进级别
     * 返回值 Int64 - 缩进级别
     */
    func getIndent(): Int64

    /*
     * 是否是空行
     * 返回值 Bool - 是否是空行
     */
    func isBlank(): Bool

    /*
     * 获取最底层的块块解析对象
     * 返回值 AbstractBlockParser - 最底层的块块解析对象
     */
    func getActiveBlockParser(): AbstractBlockParser
}

/**
 * 来自输入源的一组行（{@link SourceLine}）。
 */
public class SourceLines {

    public static func empty(): SourceLines

    public static func of(sourceLine: SourceLine): SourceLines

    public static func of(sourceLines: ArrayList<SourceLine>): SourceLines

    public func addLine(sourceLine: SourceLine): Unit

    public func getLines(): ArrayList<SourceLine>

    public func isEmpty(): Bool

    public func getContent(): String

    public func getSourceSpans(): ArrayList<SourceSpan>
}

/**
 * 来自输入源的一行或一行的一部分。
 */
public class SourceLine {
    public static func of(content: String, sourceSpan: ?SourceSpan): SourceLine

    public func getContent(): String

    public func getSourceSpan(): ?SourceSpan

    public func substring(beginIndex: Int, endIndex: Int): SourceLine
}

/**
 * 源输入中的一段文本。
 * 如果一个Block有多行，则每行都会有一个SourceSpan
 */
public class SourceSpan <: Equatable<SourceSpan> & ToString {

    /*
     * 构造源跨度
     * 参数 Int - 行索引（从0开始）
     * 参数 Int - 列索引（从0开始）
     * 参数 Int - 在整个输入中的索引（从0开始）
     * 参数 Int - 跨度长度
     * 返回值 SourceSpan - 源跨度对象
     * 异常 IllegalArgumentException - 任一参数小于 0 时抛出
     */
    public static func of(line: Int, col: Int, input: Int, length: Int): SourceSpan

    /*
     * 构造源跨度（已废弃，inputIndex 固定为 0，建议使用四参数版本）
     * 参数 Int - 行索引
     * 参数 Int - 列索引
     * 参数 Int - 跨度长度
     * 返回值 SourceSpan - 源跨度对象
     */
    public static func of(lineIndex: Int, columnIndex: Int, length: Int): SourceSpan

    /**
     * @return 从 0 开始的行索引，例如 0 表示第一行，1 表示第二行，以此类推
     */
    public func getLineIndex(): Int

    /**
     * @return 从 0 开始的列（行内字符）索引，例如 0 表示行的第一个字符，1 表示第二个字符，以此类推
     */
    public func getColumnIndex(): Int

    /**
     * @return 在整个输入中从 0 开始的索引
     */
    public func getInputIndex(): Int

    /**
     * @return 跨度的字符长度
     */
    public func getLength(): Int

    /*
     * 截取从 beginIndex 到末尾的子跨度
     * 参数 Int - 起始下标
     * 返回值 SourceSpan - 子跨度
     * 异常 IndexOutOfBoundsException - beginIndex 为负或超过长度时抛出
     */
    public func subSpan(beginIndex: Int): SourceSpan

    /*
     * 截取 [beginIndex, endIndex) 的子跨度
     * 参数 Int - 起始下标
     * 参数 Int - 结束下标
     * 返回值 SourceSpan - 子跨度
     * 异常 IndexOutOfBoundsException - 下标为负、超过长度或起始大于结束时抛出
     */
    public func subSpan(beginIndex: Int, endIndex: Int): SourceSpan

    public operator func ==(that: SourceSpan): Bool

    public operator func !=(that: SourceSpan): Bool

    public func toString(): String
}

/**
 * 可添加的源跨度列表。负责合并相邻的源跨度。
 */
public class SourceSpans {
    public static func empty(): SourceSpans

    public func getSourceSpans(): ArrayList<SourceSpan>

    public func addAllFrom(nodes: Collection<Node>): Unit

    public func addAllFromTexts(nodes: ReadOnlyList<Text>): Unit

    public func addAll(other: ReadOnlyList<SourceSpan>): Unit
}

/**
 * {@link Scanner} 内的源位置。此类型有意保持不透明，以免暴露 Scanner 的内部结构。
 */
public class SourcePosition <: ToString {
    public SourcePosition(public let lineIndex: Int, public let index: Int)
    public func toString(): String
}

/**
 * 是否在解析时包含 {@link SourceSpan}，
 * 参见 {@link ParserBuilder#includeSourceSpans(IncludeSourceSpans)}。
 */
public enum IncludeSourceSpans <: Equatable<IncludeSourceSpans> {
    /**
     * 不包含源跨度。
     */
    | NONE
    /**
     * 在 Block 节点上包含源跨度。
     */
    | BLOCKS
    /**
     * 在块节点和行内节点上都包含源跨度。
     */
    | BLOCKS_AND_INLINES

    public operator func ==(other: IncludeSourceSpans): Bool

    /*
     * 是否需要包含源跨度（NONE 为 false，其余为 true）
     * 返回值 Bool - 是否需要
     */
    public prop need: Bool
}

/**
 * 解析时的文本扫描器
 */
public class Scanner {

    /*
     * 表示输入末尾（或越界位置）的字符值
     */
    public static let END: Byte

    /*
     * 表示输入末尾（或越界位置）的 Rune 值
     */
    public static let END_RUNE: Rune

    public static func of(lines: SourceLines): Scanner

    public func peekRune(): Rune
    public func peekLine(): String
    public func peek(): Byte
    public func peekPrev(): Byte
    public func peekCodePoint(): Rune
    public func peekPreviousCodePoint(): Rune

    public func hasNext(): Bool

    /**
     * 下一个字符
     * 异常 IllegalStateException - 输入含非法 UTF-8 前导字节时抛出
     */
    public func next(): Unit
    /**
     * 检查下一个字节 并前进
     */
    public func next(b: Byte): Bool
    /**
     * 检查指定的 Rune 是否为下一个字符并前进位置。
     *
     * @param c 要检查的 Rune（包括换行符）
     * @return 如果匹配且位置已前进则返回 true，否则返回 false
     */
    public func nextRune(c: Rune): Bool
    /**
     * 检查当前行是否具有指定内容并前进位置。注意，如果要匹配换行符，请使用 nextRune。
     *
     * @param content 要在单行上匹配的文本内容（不包括换行符）
     * @return 如果匹配且位置已前进则返回 true，否则返回 false
     */
    public func next(content: String): Bool

    public func matchMultipleRune(c: Rune): Int
    public func matchMultiple(b: Byte): Int
    public func matches(matcher: CharMatcher): Int

    /**
     * 跳过空白字符（空格、\t、\n、\u{000B}、\f、\r 共六种）
     * @return 跳过的空白字符数量
     */
    public func whitespace(): Int

    public func find(c: Byte): Int
    public func find(matcher: CharMatcher): Int

    // 不暴露 Int 索引，因为将来我们可能希望将输入切换为行的 Collection<String>，而不是一个连续的 String。
    public func position(): SourcePosition

    /*
     * 设置扫描位置
     * 参数 SourcePosition - 源位置
     * 异常 IllegalArgumentException - 行索引或行内索引越界时抛出
     */
    public func setPosition(position: SourcePosition): Unit

    // 对于调用者将结果追加到 StringBuilder 的情况，我们可以提供另一个方法来避免一些不必要的复制。
    public func getSource(begin: SourcePosition, end: SourcePosition): SourceLines

}

/*
 * 字节匹配器接口，供 Scanner.matches / Scanner.find 使用
 */
public interface CharMatcher {
    /*
     * 是否匹配指定字节
     * 参数 Byte - 字节
     * 返回值 Bool - 是否匹配
     */
    func matches(b: Byte): Bool
}

/*
 * 高效匹配 ASCII 字符的 CharMatcher 实现（非 ASCII 字符恒不匹配）
 */
public class AsciiMatcher <: CharMatcher {
    /*
     * 是否匹配指定字节
     * 参数 Byte - 字节
     * 返回值 Bool - 是否匹配
     */
    public func matches(b: Byte): Bool

    /*
     * 基于当前匹配集合创建新的构建器
     * 返回值 AsciiMatcherBuilder - 构建器
     */
    public func newBuilder(): AsciiMatcherBuilder

    /*
     * 创建空构建器
     * 返回值 AsciiMatcherBuilder - 构建器
     */
    public static func builder(): AsciiMatcherBuilder

    /*
     * 基于已有匹配器创建构建器
     * 参数 AsciiMatcher - 已有匹配器
     * 返回值 AsciiMatcherBuilder - 构建器
     */
    public static func builder(matcher: AsciiMatcher): AsciiMatcherBuilder
}

public class AsciiMatcherBuilder {
    /*
     * 添加一个字节
     * 参数 Byte - 字节
     * 返回值 AsciiMatcherBuilder - 构建器
     */
    public func c(ch: Byte): AsciiMatcherBuilder

    /*
     * 添加一个字符（仅限 ASCII，Rune 值大于 127 时抛出 IllegalArgumentException）
     * 参数 Rune - 字符
     * 返回值 AsciiMatcherBuilder - 构建器
     */
    public func c(ch: Rune): AsciiMatcherBuilder

    /*
     * 添加字符串中的所有字符
     * 参数 String - 字符串
     * 返回值 AsciiMatcherBuilder - 构建器
     */
    public func anyOf(s: String): AsciiMatcherBuilder

    /*
     * 添加字符集合中的所有字节
     * 参数 Set<Byte> - 字节集合
     * 返回值 AsciiMatcherBuilder - 构建器
     */
    public func anyOf(characters: Set<Byte>): AsciiMatcherBuilder

    /*
     * 添加 [from, toInclusive] 范围内的所有字节
     * 参数 Byte - 起始字节（含）
     * 参数 Byte - 结束字节（含）
     * 返回值 AsciiMatcherBuilder - 构建器
     */
    public func range(from: Byte, toInclusive: Byte): AsciiMatcherBuilder

    /*
     * 构建匹配器
     * 返回值 AsciiMatcher - 匹配器
     */
    public func build(): AsciiMatcher
}

```

内置块解析器工厂（均实现 `BlockParserFactory`，由 `enabledBlockTypes` 控制启用）：`BlockQuoteParserFactory`、`HeadingParserFactory`、`FencedCodeBlockParserFactory`、`HtmlBlockParserFactory`、`ThematicBreakParserFactory`、`ListBlockParserFactory`、`IndentedCodeBlockParserFactory`。此外 `Definitions`（链接引用定义的存取）、`Delimiter`（`DelimiterRun` 的实现类）、`BitSet`（ASCII 位图集合，`set(b: Byte)` 传入非 ASCII 字节时抛出 IllegalArgumentException）、`Characters`（字符工具）等为公共辅助类，一般无需直接使用。

##### 2.2.2 示例

```cangjie
import commonmark4cj.commonmark.*

main(): Int64 {
    let parser: Parser = Parser.builder().customBlockParserFactory(DashBlockParserFactory()).build()

    let document: Node = parser.parse("hey\n\n---\n")

    println(document.getFirstChild().getOrThrow().toString())
    println((document.getFirstChild().getOrThrow().getFirstChild().getOrThrow() as Text).getOrThrow().getLiteral())
    println(document.getLastChild().getOrThrow().toString())

    return 0
}

class DashBlockParserFactory <: AbstractBlockParserFactory {

    public override func tryStart(state: ParserState, matchedBlockParser: MatchedBlockParser): ?BlockStart {
        if (state.getLine().getContent() == ("---")) {
            return BlockStart.of(DashBlockParser())
        }
        return BlockStart.none()
    }
}

class DashBlock <: CustomBlock {
    public func getNodeType(): NodeType {
        "DashBlock"
    }
}

class DashBlockParser <: AbstractBlockParser {

    private var dash: DashBlock = DashBlock()

    public override func getBlock(): Block {
        return dash
    }

    public override func tryContinue(parserState: ParserState): ?BlockContinue {
        return BlockContinue.none()
    }
}
```

#### 2.3 InlineParser

##### 2.3.1 主要接口

```cangjie
public interface InlineParser {
    /*
     * 解析行内元素，生成的节点作为子节点追加到 node 上
     * 参数 SourceLines - 行内内容行
     * 参数 Node - 承载解析结果的节点
     */
    func parse(lines: SourceLines, node: Node): Unit
}

public interface InlineParserContext {
    /*
     * 获取用户自定义的分割符处理器
     * 返回值 ArrayList<DelimiterProcessor> - ArrayList<DelimiterProcessor>
     */
    func getCustomDelimiterProcessors(): ArrayList<DelimiterProcessor>

    /*
     * 获取用户自定义的行内内容解析器工厂
     * 返回值 ArrayList<InlineContentParserFactory> - ArrayList<InlineContentParserFactory>
     */
    func getCustomInlineContentParserFactories(): ArrayList<InlineContentParserFactory>

    /*
     * 获取用户自定义的链接处理器
     * 返回值 ArrayList<LinkProcessor> - ArrayList<LinkProcessor>
     */
    func getCustomLinkProcessors(): ArrayList<LinkProcessor>

    /*
     * 获取用户自定义的链接标记字符
     * 返回值 HashSet<Rune> - HashSet<Rune>
     */
    func getCustomLinkMarkers(): HashSet<Rune>

    /*
     * 获取用户自定义的分隔符开闭判定处理器，未配置时返回 None
     * 返回值 ?DelimiterOpenCloseProcessor - ?DelimiterOpenCloseProcessor
     */
    func getDelimiterOpenCloseProcessor(): ?DelimiterOpenCloseProcessor

    /*
     * 根据名字获取对应的链接引用
     * 参数 String - 名字
     * 返回值 ?LinkReferenceDefinition - ?LinkReferenceDefinition
     */
    func getLinkReferenceDefinition(label: String): ?LinkReferenceDefinition

    /*
     * 根据标签（label）查找类型定义，实现方负责对标签做规范化
     * 参数 String - 定义类型
     * 参数 String - 标签
     * 返回值 ?LinkReferenceDefinition - ?LinkReferenceDefinition
     */
    func getDefinition(typ: String, label: String): ?LinkReferenceDefinition
}

public interface InlineParserFactory {
    /*
     * 构建InlineParser行内解析器实例
     * 参数 InlineParserContext - InlineParserContext
     * 返回值 InlineParser - InlineParser对象
     */
    func create(inlineParserContext: InlineParserContext): InlineParser
}

public interface DelimiterProcessor {
    /*
     * 获取开始分隔符
     * 返回值 Rune - 开始分隔符
     */
    func getOpeningCharacter(): Rune

    /*
     * 获取结束分隔符
     * 返回值 Rune - 结束分隔符
     */
    func getClosingCharacter(): Rune

    /*
     * 获取激活所需的最小分隔符数量，至少为1
     * 返回值 Int64 - 最小长度
     */
    func getMinLength(): Int64

    /*
     * 处理行内元素
     * 参数 openingRun - 包含开始符号的文本节点
     * 参数 closingRun - 包含结束符号的文本节点
     * 返回值 Int - 使用了多少分隔符
     */
    func process(openingRun: DelimiterRun, closingRun: DelimiterRun): Int
}

public interface DelimiterRun {
    /*
     * 是否可以开启一个新的分隔符
     * 返回值 Bool - 是否可以打开
     */
    func canOpen(): Bool

    /*
     * 是否可以关闭分隔符
     * 返回值 Bool - 是否可以关闭
     */
    func canClose(): Bool

    /*
     * 序列长度（剩余待处理的分隔符字符数）
     * 返回值 Int64 - 序列长度
     */
    func getLength(): Int64

    /*
     * 序列原始长度（处理开始时的字符数，与初始 getLength 相同）
     * 返回值 Int64 - 序列原始长度
     */
    func getOriginalLength(): Int64

    /*
     * 最内层的开始分隔符，例如对于 ***，即最后一个 *
     */
    func getOpener(): Text

    /*
     * 最内层的结束分隔符，例如对于 ***，即第一个 *
     */
    func getCloser(): Text

    /*
     * 获取指定长度的开始分隔符节点。长度必须在 1 到 length() 之间。
     * 例如，对于分隔符序列 ***，传入 1 将返回最后一个 *，
     * 传入 2 将返回倒数第二个 * 和最后一个 *。
     * 异常 IllegalArgumentException - length 不在 [1, getLength()] 区间时抛出
     */
    func getOpeners(length: Int): ReadOnlyList<Text>

    /*
     * 获取指定长度的结束分隔符节点。长度必须在 1 到 length() 之间。
     * 例如，对于分隔符序列 ***，传入 1 将返回第一个 *，
     * 传入 2 将返回第一个 * 和第二个 *。
     * 异常 IllegalArgumentException - length 不在 [1, getLength()] 区间时抛出
     */
    func getClosers(length: Int): ReadOnlyList<Text>
}

/*
 * 行内内容解析器。通过 InlineContentParserFactory 注册，并由其 create 方法创建。
 * 其生命周期与每个被解析的行内内容片段绑定，每次解析都会创建一个新的实例。
 */
public interface InlineContentParser {

    /*
     * 尝试从当前位置开始解析行内内容。注意当前位置的字符是创建此解析器的工厂的
     * getTriggerCharacters() 之一。
     * 对于正在解析的给定行内内容片段，此方法可以被多次调用：每次遇到触发字符时调用一次。
     *
     * 参数 inlineParserState - 行内解析器的当前状态
     * 返回值 ParsedInline - 解析结果；可以表示此解析器不感兴趣，或解析成功
     */
    func tryParse(inlineParserState: InlineParserState): ParsedInline
}

/*
 * 用于扩展行内内容解析的工厂。
 * 关于如何注册，请参见 ParserBuilder.customInlineContentParserFactory。
 */
public interface InlineContentParserFactory {

    /*
     * 行内内容解析器需要有一个特殊的"触发"字符来激活它。当在内联解析过程中遇到此字符时，
     * 将使用当前解析器状态调用 InlineContentParser.tryParse。也可以注册多个触发字符。
     */
    @Frozen
    func getTriggerCharacters(): HashSet<Rune>

    /*
     * 创建一个执行解析的 InlineContentParser。对于块结构内的每个行内内容文本片段，
     * create 方法会被调用一次，之后每次遇到触发字符时也会被调用。
     */
    func create(): InlineContentParser
}

public interface InlineParserState {

    /*
     * 返回当前位置（位于行内解析器所注册的触发字符上）的输入扫描器。
     * 注意，此方法始终返回同一个实例，如果需要回溯，请使用
     * Scanner.position() 和 Scanner.setPosition(SourcePosition)。
     */
    func getScanner(): Scanner
}

/*
 * 单个行内解析器的解析结果，使用静态方法构造实例。
 */
public interface ParsedInline {
    /*
     * 表示解析器不感兴趣
     * 返回值 ParsedInline - 空结果
     */
    static func none(): ParsedInline

    /*
     * 表示解析成功
     * 参数 Node - 解析得到的节点
     * 参数 SourcePosition - 继续解析的位置
     * 返回值 ParsedInline - 解析结果
     */
    static func of(node: Node, position: SourcePosition): ParsedInline
}

/*
 * 决定链接/图片如何处理的处理器，通过 ParserBuilder.linkProcessor 注册。
 * 行内解析时每个解析出的链接/图片（含 [text](dest)、[text]、[text][]、
 * [text][label] 及图片形式）都会依次传给已注册的处理器；
 * 返回 None 时尝试下一个处理器，全部不处理时按内置行为处理。
 */
public interface LinkProcessor {

    /*
     * 处理解析出的链接/图片
     * 参数 LinkInfo - 链接/图片信息
     * 参数 Scanner - 位于链接/图片之后的扫描器
     * 参数 InlineParserContext - 行内解析上下文
     * 返回值 ?LinkResult - 处理结果（None 表示不处理，交给下一个处理器）
     */
    func process(linkInfo: LinkInfo, scanner: Scanner, context: InlineParserContext): ?LinkResult
}

/*
 * 内置链接处理器：处理行内链接、引用链接（含快捷/折叠形式）及图片，
 * 未匹配到处理器时由其兜底生成 Link/Image 节点。
 */
public class CoreLinkProcessor <: LinkProcessor {
    /*
     * 处理解析出的链接/图片，行为同 LinkProcessor.process
     * 参数 LinkInfo - 链接/图片信息
     * 参数 Scanner - 位于链接/图片之后的扫描器
     * 参数 InlineParserContext - 行内解析上下文
     * 返回值 ?LinkResult - 处理结果
     */
    public func process(linkInfo: LinkInfo, scanner: Scanner, context: InlineParserContext): ?LinkResult
}

/*
 * 已解析的链接/图片信息
 */
public interface LinkInfo {

    /*
     * 获取标记文本节点（如图片的 !），不存在时返回 None
     * 返回值 ?Text - 标记文本节点
     */
    func marker(): ?Text

    /*
     * 获取起始方括号 [ 对应的文本节点
     * 返回值 Text - 文本节点
     */
    func openingBracket(): Text

    /*
     * 获取第一对方括号内的文本，如 [foo][bar] 中的 foo
     * 返回值 String - 文本
     */
    func text(): String

    /*
     * 获取标签，行内链接和快捷方式链接返回 None
     * （快捷方式链接应使用 text() 作为标签）
     * 返回值 ?String - 标签
     */
    func label(): ?String

    /*
     * 获取目标地址（如 [foo](destination) 中的 destination），不存在时返回 None
     * 返回值 ?String - 目标地址
     */
    func destination(): ?String

    /*
     * 获取标题（如 [foo](dest "title") 中的 title），不存在时返回 None
     * 返回值 ?String - 标题
     */
    func title(): ?String
}

/*
 * LinkProcessor 的处理结果
 */
public interface LinkResult {
    /*
     * 链接未被处理器处理
     * 返回值 ?LinkResult - None
     */
    static func none(): ?LinkResult

    /*
     * 将链接文本包裹到指定节点中（链接的常规行为，文本成为该节点的子节点）
     * 参数 Node - 包裹节点（如 Link/Image）
     * 参数 SourcePosition - 继续解析的位置
     * 返回值 LinkResult - 处理结果
     */
    static func wrapTextIn(node: Node, position: SourcePosition): LinkResult

    /*
     * 用指定节点替换整个链接（如脚注引用）
     * 参数 Node - 替换节点
     * 参数 SourcePosition - 继续解析的位置
     * 返回值 LinkResult - 处理结果
     */
    static func replaceWith(node: Node, position: SourcePosition): LinkResult

    /*
     * 若 LinkInfo.marker 存在，将标记一并纳入处理（与方括号同等对待）
     * 返回值 LinkResult - 处理结果
     */
    func includeMarker(): LinkResult
}

/*
 * 自定义分隔符能否开/闭的判定处理器。
 * 返回 None 时对当前分隔符序列保留内置的 CommonMark 侧翼规则。
 */
public type DelimiterOpenCloseProcessor = (context: DelimiterOpenCloseContext) -> ?DelimiterOpenCloseResult

/*
 * 字符判定函数（codePoint -> Bool）
 */
public type CharacterPredicate = (codePoint: Rune) -> Bool

/*
 * 分隔符开闭检测的结果
 */
public class DelimiterOpenCloseResult {
    /*
     * 构造开闭检测结果
     * 参数 Bool - 是否可开
     * 参数 Bool - 是否可闭
     */
    public DelimiterOpenCloseResult(canOpen: Bool, canClose: Bool)

    /*
     * 构造开闭检测结果
     * 参数 Bool - 是否可开
     * 参数 Bool - 是否可闭
     * 返回值 DelimiterOpenCloseResult - 结果对象
     */
    public static func of(canOpen: Bool, canClose: Bool): DelimiterOpenCloseResult

    /*
     * 是否可开
     * 返回值 Bool - 是否可开
     */
    public func canOpen(): Bool

    /*
     * 是否可闭
     * 返回值 Bool - 是否可闭
     */
    public func canClose(): Bool
}

/*
 * 分隔符开闭检测的上下文
 */
public class DelimiterOpenCloseContext {
    /*
     * 分隔符字符
     * 返回值 Rune - 分隔符字符
     */
    public func delimiterChar(): Rune

    /*
     * 分隔符数量
     * 返回值 Int64 - 分隔符数量
     */
    public func delimiterCount(): Int64

    /*
     * 分隔符前一个字符
     * 返回值 Rune - 前一个字符
     */
    public func before(): Rune

    /*
     * 分隔符后一个字符
     * 返回值 Rune - 后一个字符
     */
    public func after(): Rune

    /*
     * 分隔符处理器
     * 返回值 DelimiterProcessor - 分隔符处理器
     */
    public func delimiterProcessor(): DelimiterProcessor

    /*
     * 按内置 CommonMark 规则计算默认结果
     * 返回值 DelimiterOpenCloseResult - 默认结果
     */
    public func defaultResult(): DelimiterOpenCloseResult

    /*
     * 按指定的标点/空白判定函数计算默认结果
     * 参数 CharacterPredicate - 标点判定函数
     * 参数 CharacterPredicate - 空白判定函数
     * 返回值 DelimiterOpenCloseResult - 默认结果
     */
    public func defaultResultWith(
        isPunctuationCodePoint: CharacterPredicate,
        isWhitespaceCodePoint: CharacterPredicate
    ): DelimiterOpenCloseResult
}

```

##### 2.3.2 示例

```cangjie
    import commonmark4cj.commonmark.*
    import std.unittest.*
    import std.unittest.testmacro.*

    class fakeInlineParser <: InlineParser {
        public func parse(lines: SourceLines, node: Node): Unit {
            node.appendChild(ThematicBreak())
        }
    }

    class fakeInlineParserFactory <: InlineParserFactory {

        public override func create(inlineParserContext: InlineParserContext): InlineParser {
            return fakeInlineParser()
        }
    }

    @Test
    public class InlineParserDocTest {
        @TestCase
        public func inlineParser(): Unit {
            let parser: Parser = Parser.builder().inlineParserFactory(fakeInlineParserFactory()).build()
            let input: String = "**bold** **bold** ~~strikethrough~~"

            assertEquals(parser.parse(input).getFirstChild()().getFirstChild()().toString(), "ThematicBreak{}")
        }
    }
```

#### 2.4 Strikethrough

##### 2.4.1 主要接口

```cangjie
public abstract class StrikethroughNodeRenderer <: NodeRenderer {
    /*
     * 获取删除线类型
     * 返回值 HashSet<NodeType> - 删除线类型（NodeType 为 String 别名）
     */
    public override func getNodeTypes(): HashSet<NodeType>
}

public class Strikethrough <: CustomNode & Delimited {
    /*
     * 构造函数
     * 参数 String - delimiter 使用的分隔符
     */
    public Strikethrough(let delimiter: String) {}
    /*
     * 获取起始分隔符
     * 返回值 ?String - 起始分隔符
     */
    public override func getOpeningDelimiter(): ?String

    /*
     * 获取结束分隔符
     * 返回值 ?String - 结束分隔符
     */
    public override func getClosingDelimiter(): ?String
}

public class StrikethroughExtension <: ParserExtension & HtmlRendererExtension & TextContentRendererExtension {

    /*
     * 拓展插件
     * 返回值 Extension - Extension
     */
    public static func create(): Extension
    
    /*
     * 插件拓展 
     * 参数 ParserBuilder - ParserBuilder
     */
    public override func ext(parserBuilder: ParserBuilder): Unit
    /*
     * 插件拓展 
     * 参数 HtmlRendererBuilder - HtmlRendererBuilder
     */
    public override func ext(rendererBuilder: HtmlRendererBuilder): Unit
    
    /*
     * 插件拓展 
     * 参数 TextContentRendererBuilder - TextContentRendererBuilder
     */
    public override func ext(rendererBuilder: TextContentRendererBuilder): Unit
}
```

##### 2.4.2 示例

```cangjie
import commonmark4cj.strikethrough.*
import commonmark4cj.commonmark.*
import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*

@Test
public class StrikethroughTest {
    private static let EXTENSIONS: Iterable<Extension> = ArrayList<Extension>([StrikethroughExtension.create()])
    private static let PARSER: Parser = Parser.builder().extensions(EXTENSIONS).build()
    private static let HTML_RENDERER: HtmlRenderer = HtmlRenderer.builder().extensions(EXTENSIONS).build()
    private static let CONTENT_RENDERER: TextContentRenderer = TextContentRenderer.builder().extensions(EXTENSIONS).build()

    @TestCase
    public func oneTildeIsNotEnough(): Unit {
        assertRendering("~foo~", "<p>~foo~</p>\n")
    }

    func render(source: String): String {
        return HTML_RENDERER.render(PARSER.parse(source))
    }

    func assertRendering(source: String, expectedResult: String): Unit {
        let renderedContent: String = render(source)
        let expected: String = showTabs(expectedResult + "\n\n" + source)
        let actual: String = showTabs(renderedContent + "\n\n" + source)
        assertEquals(expected, actual)
    }

    func showTabs(s: String): String {
        return s.replace("\t", "\u{2192}")
    }
}
```

#### 2.5 Table

##### 2.5.1 主要接口

```cangjie
public abstract class TableNodeRenderer <: NodeRenderer {
    /*
     * 获取表格类型（TableBlock、TableHead、TableBody、TableRow、TableCell）
     * 返回值 HashSet<NodeType> - 表格类型（NodeType 为 String 别名）
     */
    public override func getNodeTypes(): HashSet<NodeType>

    /*
     * 渲染，按节点实际类型分派到 renderBlock/renderHead/renderBody/renderRow/renderCell
     * 参数 Node - Node
     */
    public override func render(node: Node): Unit

    /*
     * 渲染表格块
     * 参数 TableBlock - TableBlock节点
     */
    protected func renderBlock(node: TableBlock): Unit

    /*
     * 渲染表头
     * 参数 TableHead - TableHead节点
     */
    protected func renderHead(node: TableHead): Unit

    /*
     * 渲染表体
     * 参数 TableBody - TableBody节点
     */
    protected func renderBody(node: TableBody): Unit

    /*
     * 渲染行
     * 参数 TableRow - TableRow节点
     */
    protected func renderRow(node: TableRow): Unit

    /*
     * 渲染单元格
     * 参数 TableCell - TableCell节点
     */
    protected func renderCell(node: TableCell): Unit
}

public class TableBlock <: CustomBlock {}

public class TableBody <: CustomNode {}

public class TableCell <: CustomNode {

    /*
     * 是不是表头
     * 返回值 Bool - Bool
     */
    public func isHeader(): Bool

    /*
     * 设置该单元格是表头
     * 参数 Bool - Bool
     */
    public func setHeader(header: Bool): Unit

    /*
     * 获取对齐方式
     * 返回值 ?Alignment - 对齐方式
     */
    public func getAlignment(): ?Alignment

    /*
     * 设置对齐方式（传 None 表示无对齐）
     * 参数 ?Alignment - 对齐方式
     */
    public func setAlignment(alignment: ?Alignment): Unit

    /*
     * 获取单元格宽度
     * 返回值 Int - 宽度
     */
    public func getWidth(): Int

    /*
     * 设置单元格宽度
     * 参数 Int - 宽度
     */
    public func setWidth(width: Int): Unit
}

public enum Alignment <: ToString {
    | LEFT
    | CENTER
    | RIGHT
}

public class TableHead <: CustomNode {}

public class TableRow <: CustomNode {}

public class TablesExtension <: ParserExtension & HtmlRendererExtension & TextContentRendererExtension {
    /*
     * 拓展插件
     * 返回值 Extension - Extension
     */
    public static func create(): Extension
    /*
     * 拓展插件
     * 参数 ParserBuilder - ParserBuilder
     */
    public func ext(parserBuilder: ParserBuilder): Unit
    /*
     * 拓展插件
     * 参数 HtmlRendererBuilder - HtmlRendererBuilder
     */
    public func ext(rendererBuilder: HtmlRendererBuilder): Unit
    /*
     * 拓展插件
     * 参数 TextContentRendererBuilder - TextContentRendererBuilder
     */
    public func ext(rendererBuilder: TextContentRendererBuilder): Unit
}
```

##### 2.5.2 示例

```cangjie
import commonmark4cj.commonmark.*
import commonmark4cj.table.*
import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*

@Test
public class TableTT {
    @TestCase
    func mustHaveHeaderAndSeparator(): Unit {
        let tt: TablesTest = TablesTest()
        @PowerAssert(tt.assertRendering("Abc|Def", "<p>Abc|Def</p>\n") == true)
        @PowerAssert(tt.assertRendering("Abc | Def", "<p>Abc | Def</p>\n") == true)
    }
}

public abstract class RenderingTestCase {
    protected func render(source: String): String

    public func assertRendering(source: String, expectedResult: String): Bool {
        let renderedContent: String = render(source)
        // include source for better assertion errors
        let expected: String = showTabs(expectedResult + "\n\n" + source)
        let actual: String = showTabs(renderedContent + "\n\n" + source)
        return expected.toString() == actual.toString()
    }

    private static func showTabs(s: String): String {
        // Tabs are shown as "rightwards arrow" for easier comparison
        return s.replace("\t", "\u{2192}")
    }
}

public class TablesTest <: RenderingTestCase {
    private static let EXTENSIONS: Array<Extension> = [TablesExtension.create()]
    private static let PARSER: Parser = Parser.builder().extensions(EXTENSIONS).build()
    private static let RENDERER: HtmlRenderer = HtmlRenderer.builder().extensions(EXTENSIONS).build()

    protected override func render(source: String): String {
        return RENDERER.render(PARSER.parse(source))
    }
}
```

### 3 Render

前置条件：NA 

场景：将Node树渲染为HTML（HtmlRenderer）或纯文本（TextContentRenderer）

约束：自定义渲染器通过 nodeRendererFactory 注册，同一节点类型以最先注册的工厂为准（核心渲染最后注册，可被覆盖）；渲染子节点时不要把正在渲染的节点传给 context.render，否则会无限递归

可靠性：NA

#### 3.1 TextRender

##### 3.1.1 主要接口

```cangjie
/*
 * 渲染器基础接口，TextContentRenderer 与 HtmlRenderer 均实现此接口
 */
public interface Renderer {
    /*
     * 渲染node 追加到StringBuilder中
     * 参数 Node - Node
     * 参数 StringBuilder - StringBuilder文本
     */
    func render(node: Node, output: StringBuilder): Unit

    /*
     * 渲染node
     * 参数 Node - Node
     * 返回值 String - 渲染完成的文本
     */
    func render(node: Node): String
}

/*
 * 一组节点类型的渲染器，通过 NodeRendererMap 按节点类型分派
 */
public interface NodeRenderer {
    /*
     * 获取该渲染器处理的节点类型集合
     * 返回值 HashSet<NodeType> - 节点类型集合（NodeType 为 String 别名）
     */
    func getNodeTypes(): HashSet<NodeType>

    /*
     * 渲染指定节点（该节点类型必属于 getNodeTypes 返回的集合）
     * 参数 Node - Node
     */
    func render(node: Node): Unit
}

public class TextContentRenderer <: Renderer {
    /*
     * 构建TextContentRendererBuilder对象
     * 返回值 TextContentRendererBuilder - TextContentRendererBuilder
     */
    public static func builder(): TextContentRendererBuilder

    /*
     * 渲染node 追加到StringBuilder中
     * 参数 Node - Node
     * 参数 StringBuilder - StringBuilder文本
     */
    public override func render(node: Node, output: StringBuilder): Unit

    /*
     * 渲染node
     * 参数 Node - Node
     * 返回值 String - 渲染完成的文本
     */
    public override func render(node: Node): String
}

public class TextContentRendererBuilder {
    /*
     * 构建 TextContentRenderer 对象
     * 返回值 TextContentRenderer - TextContentRenderer
     */
    public func build(): TextContentRenderer

    /*
     * 是否忽略换行符 true是忽略
     * 参数 Bool - 是否忽略换行符
     * 返回值 TextContentRendererBuilder - TextContentRendererBuilder
     */
    public func setStripNewlines(stripNewlines: Bool): TextContentRendererBuilder

    /*
     * 新增一个 TextContentNodeRendererFactory实例对象
     * 参数 TextContentNodeRendererFactory - TextContentNodeRendererFactory
     * 返回值 TextContentRendererBuilder - TextContentRendererBuilder
     */
    public func nodeRendererFactory(nodeRendererFactory: TextContentNodeRendererFactory): TextContentRendererBuilder

    /*
     * 拓展新的render 例如 TablesExtension
     * 参数 Iterable<Extension> - 拓展列表
     * 返回值 TextContentRendererBuilder - TextContentRendererBuilder
     */
    public func extensions(extensions: Iterable<Extension>): TextContentRendererBuilder
}

public interface TextContentRendererExtension <: Extension {

    /*
     * 拓展新的render 例如 TablesExtension
     * 参数 TextContentRendererBuilder - TextContentRendererBuilder
     */
    func ext(rendererBuilder: TextContentRendererBuilder): Unit
}

public interface TextContentNodeRendererContext {
    /*
     * 是否忽略换行符 true是忽略（渲染为单行）
     * 返回值 Bool - 是否忽略换行符
     */
    func stripNewlines(): Bool

    /*
     * 获取TextContentWriter
     * 返回值 TextContentWriter - TextContentWriter对象
     */
    func getWriter(): TextContentWriter

    /*
     * 使用已配置的渲染器渲染指定节点及其子节点；用于渲染子节点，
     * 注意不要传入正在渲染的节点本身，否则会无限递归
     * 参数 Node - Node
     */
    func render(node: Node): Unit
}

public type TextContentNodeRendererFactory = (context: TextContentNodeRendererContext) -> NodeRenderer

public class TextContentWriter {
    /*
     * 构建TextContentWriter对象
     * 参数 StringBuilder - 输出的StringBuilder
     */
    public TextContentWriter(out: StringBuilder)

    /*
     * 写入空格 " "（前一个字符为空格或缓冲为空时不写入）
     */
    public func whitespace(): Unit

    /*
     * 写入冒号 ":"（前一个字符为冒号或缓冲为空时不写入）
     */
    public func colon(): Unit

    /*
     * 写入 "\n"（前一个字符为换行或缓冲为空时不写入）
     */
    public func line(): Unit

    /*
     * 将文本中的 [\r\n\s]+ 连续空白替换为单个空格后写入
     * 参数 String - 文本
     */
    public func writeStripped(str: String): Unit

    /*
     * 写入文本
     * 参数 String - 文本
     */
    public func write(s: String): Unit
}
```

##### 3.1.2 示例

```cangjie
    import commonmark4cj.commonmark.*
    import std.unittest.*
    import std.unittest.testmacro.*

    func parse(source: String): Node {
        return Parser.builder().build().parse(source)
    }

    func defaultRenderer(): TextContentRenderer {
        return TextContentRenderer.builder().build()
    }

    func strippedRenderer(): TextContentRenderer {
        return TextContentRenderer.builder().setStripNewlines(true).build()
    }

    @Test
    public class TextRenderDocTest {
        @TestCase
        func render_test(): Unit {
            var source: String = ""
            var rendered: String = ""
            source = "foo bar"
            rendered = defaultRenderer().render(parse(source))
            assertEquals("foo bar", rendered)
            rendered = strippedRenderer().render(parse(source))
            assertEquals("foo bar", rendered)

            source = "foo foo\n\nbar\nbar"
            rendered = defaultRenderer().render(parse(source))
            assertEquals("foo foo\nbar\nbar", rendered)
            rendered = strippedRenderer().render(parse(source))
            assertEquals("foo foo bar bar", rendered)
        }
    }
```

#### 3.2 HtmlRender

##### 3.2.1 主要接口

```cangjie
public class HtmlRenderer <: Renderer {
    /*
     * 构建HtmlRendererBuilder对象
     * 返回值 HtmlRendererBuilder - HtmlRendererBuilder
     */
    public static func builder(): HtmlRendererBuilder

    /*
     * 渲染node 追加到StringBuilder中
     * 参数 Node - Node
     * 参数 StringBuilder - StringBuilder文本
     */
    public override func render(node: Node, output: StringBuilder): Unit

    /*
     * 渲染node
     * 参数 Node - Node
     * 返回值 String - 渲染完成的文本
     */
    public override func render(node: Node): String
}

public class HtmlRendererBuilder {
    /*
     * 构建 HtmlRenderer 对象
     * 返回值 HtmlRenderer - HtmlRenderer
     */
    public func build(): HtmlRenderer

    /*
     * 设置软换行的渲染文本，默认 "\n"（即渲染结果无换行）；
     * 设为 "<br>" 或 "<br />" 变为硬换行，设为 " " 忽略源码中的换行
     * 参数 String - softbreak
     * 返回值 HtmlRendererBuilder - HtmlRendererBuilder
     */
    public func softbreak(softbreak: String): HtmlRendererBuilder

    /*
     * 是否需要转义 默认 false
     * 参数 Bool - 是否需要转义
     * 返回值 HtmlRendererBuilder - HtmlRendererBuilder
     */
    public func escapeHtml(escapeHtml: Bool): HtmlRendererBuilder

    /*
     * 是否URL编码 默认 false
     * 参数 Bool - 是否URL编码
     * 返回值 HtmlRendererBuilder - HtmlRendererBuilder
     */
    public func percentEncodeUrls(percentEncodeUrls: Bool): HtmlRendererBuilder

    /*
     * 新增属性工厂类
     * 参数 AttributeProviderFactory - AttributeProviderFactory
     * 返回值 HtmlRendererBuilder - HtmlRendererBuilder
     */
    public func attributeProviderFactory(attributeProviderFactory: AttributeProviderFactory): HtmlRendererBuilder

    /*
     * 新增属性渲染工厂类
     * 参数 HtmlNodeRendererFactory - HtmlNodeRendererFactory
     * 返回值 HtmlRendererBuilder - HtmlRendererBuilder
     */
    public func nodeRendererFactory(nodeRendererFactory: HtmlNodeRendererFactory): HtmlRendererBuilder

    /*
     * 拓展新的render 例如 TablesExtension
     * 参数 Iterable<Extension> - 拓展列表
     * 返回值 HtmlRendererBuilder - HtmlRendererBuilder
     */
    public func extensions(extensions: Iterable<Extension>): HtmlRendererBuilder
}

public interface HtmlRendererExtension <: Extension {
    /*
     * 拓展新的render 例如 TablesExtension
     * 参数 HtmlRendererBuilder - HtmlRendererBuilder
     */
    func ext(rendererBuilder: HtmlRendererBuilder): Unit
}

public class HtmlWriter {
    /*
     * 初始化
     * 参数 StringBuilder - 输出的StringBuilder
     */
    public init(out: StringBuilder)

    /*
     * 新增原始文本（不做转义）
     * 参数 String - 文本
     */
    public func raw(s: String): Unit

    /*
     * 新增转义后的文本（HTML特殊字符转义）
     * 参数 String - 文本
     */
    public func text(text: String): Unit

    /*
     * 新增标签（无属性）
     * 参数 String - 标签名
     */
    public func tag(name: String): Unit

    /*
     * 新增标签
     * 参数 String - 标签名
     * 参数 HashMap<String, String> - 属性map
     */
    public func tag(name: String, attrs: HashMap<String, String>): Unit

    /*
     * 新增标签
     * 参数 String - 标签名
     * 参数 ?HashMap<String, String> - 属性map
     * 参数 Bool - 是否自闭合（为 true 时输出 " /"）
     */
    public func tag(name: String, attrs: ?HashMap<String, String>, voidElement: Bool): Unit

    /*
     * 新增 "\n"（前一个字符为换行或缓冲为空时不写入）
     */
    public func line(): Unit
}

public interface AttributeProvider {
    /*
     * 设置标签属性；属性键值会被转义（保留字符实体），此处不要提前转义；
     * 同一节点使用多层标签渲染时（如代码块），此方法可能被多次调用
     * 参数 Node - Node
     * 参数 String - 标签名（如 h1、pre、code）
     * 参数 HashMap<String, String> - 属性map（含默认属性，可直接修改）
     */
    func setAttributes(node: Node, tagName: String, attributes: HashMap<String, String>): Unit
}

public interface AttributeProviderContext {}

public type AttributeProviderFactory = (context: AttributeProviderContext) -> AttributeProvider

public interface HtmlNodeRendererContext {

    /*
     * URL编码（取决于 percentEncodeUrls 配置，未启用时原样返回）
     * 参数 String - url
     * 返回值 String - 编码后的url
     */
    func encodeUrl(url: String): String

    /*
     * 拓展自定义的tag属性（应用已注册的 AttributeProvider）
     * 参数 Node - 被应用的Node
     * 参数 String - 标签名
     * 参数 HashMap<String, String> - 属性map
     * 返回值 HashMap<String, String> - 拓展后的属性map
     */
    func extendAttributes(node: Node, tagName: String, attributes: HashMap<String, String>): HashMap<String, String>

    /*
     * 获取HtmlWriter
     * 返回值 HtmlWriter - HtmlWriter
     */
    func getWriter(): HtmlWriter

    /*
     * 获取软换行的渲染文本，默认 "\n"
     * 返回值 String - 软换行渲染文本
     */
    func getSoftbreak(): String

    /*
     * 使用已配置的渲染器渲染指定节点及其子节点；用于渲染子节点，
     * 注意不要传入正在渲染的节点本身，否则会无限递归
     * 参数 Node - Node
     */
    func render(node: Node): Unit

    /*
     * 是否需要转义 默认false
     * 返回值 Bool - Bool
     */
    func shouldEscapeHtml(): Bool
}

public type HtmlNodeRendererFactory = (context: HtmlNodeRendererContext) -> NodeRenderer
```

##### 3.2.2 示例

```cangjie
    import commonmark4cj.commonmark.*
    import std.unittest.*
    import std.unittest.testmacro.*

    func parse(source: String): Node {
        return Parser.builder().build().parse(source)
    }

    private func htmlAllowingRenderer(): HtmlRenderer {
        return HtmlRenderer.builder().escapeHtml(false).build()
    }

    @Test
    public class HtmlRenderDocTest {
        @TestCase
        func render_test(): Unit {
            let rendered: String = htmlAllowingRenderer().render(
                parse("paragraph with <span id='foo' class=\"bar\">inline &amp; html</span>"))
            assertEquals("<p>paragraph with <span id='foo' class=\"bar\">inline &amp; html</span></p>\n", rendered)
        }
    }
```


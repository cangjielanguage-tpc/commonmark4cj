/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package markdown.plugin
import ohos.hilog.Hilog

public class FootnotePlugin <: AbstractMarkdownPlugin {
    public static func create(): FootnotePlugin {
        return FootnotePlugin()
    }

    public func configureParser(builder: ParserBuilder): Unit {
        builder.customBlockParserFactory(FootnoteBlockParserFactory())
        builder.postProcessor(FootnotePostProcessor())
    }

    public func configureVisitor(builder: MarkdownVisitorBuilder): Unit {
        builder.on(
            "Footnote",
            {
                visitor, node => let view = buildView(node, true)
            }
        )
    }

    public func getClassType(): String {
        "FootnotePlugin"
    }
}

public class Footnote <: CustomNode {
    Footnote(public let noteid: String) {}
    public var block: ?FootnoteBlock = None
    public func getNodeType(): String {
        "Footnote"
    }
    protected func toStringAttributes(): String {
        return "noteid=${noteid},blockIndex=${block?.blockIndex}"
    }
}

public class FootnoteBlock <: CustomBlock {
    FootnoteBlock(public let noteid: String) {}
    public var blockIndex = -1
    public func getNodeType(): String {
        "FootnoteBlock"
    }
    protected func toStringAttributes(): String {
        return "noteid=${noteid},blockIndex=${blockIndex}"
    }
}

class FootnoteBlockParser <: AbstractBlockParser {
    FootnoteBlockParser(let title: String, let line: SourceLine) {
        block = FootnoteBlock(title)
        block.appendChild(paragraph)
    }
    private let block: FootnoteBlock
    private let paragraph: Paragraph = Paragraph()

    public func getBlock(): Block {
        //        println("FootnoteBlockParser getBlock ")
        block
    }

    public func tryContinue(parserState: ParserState): ?BlockContinue {
        let line = parserState.getLine()
        //        println("FootnoteBlockParser tryContinue ${line}")
        None
    }

    public func addLine(line: SourceLine): Unit {
        //        println("FootnoteBlockParser addLine ${line.getContent()}")
    }
    public func parseInlines(inlineParser: InlineParser): Unit {
        //        println("FootnoteBlockParser parseInlines ")
        inlineParser.parse(SourceLines.of(line), paragraph)
    }

    public func closeBlock(): Unit {
        //        println("FootnoteBlockParser closeBlock ")
    }
}

class FootnoteBlockParserFactory <: AbstractBlockParserFactory {
    static let FOOTNOTE_BLOCK = Regex(#"^\[\^.+?\]:"#)
    public func tryStart(state: ParserState, _: MatchedBlockParser): ?BlockStart {
        var content: String = state.getLine().getContent()
        let pos = state.getIndex()
        var line = content[pos..]
        if (line.size >= 4 && line[0] == b'[' && line[1] == b'^') {
            if (let Some(end) <- line.indexOf("]:", 2)) {
                let ss = state.getLine().substring(pos + end + 2, content.size)
                return BlockStart
                    .of(FootnoteBlockParser(line[2..end], ss))
                    .atIndex(pos + end + 2)
            }
        }
        return BlockStart.none()
    }
}

class FootnotePostProcessor <: PostProcessor {
    public func process(node: Node): Node {
        node.accept(FootnoteVisitor())
        return node
    }
}

/* 生成Footnode 关联FootnodeBlock FootnodeBlock生成定位序号 */
class FootnoteVisitor <: AbstractVisitor {
    let notes = ArrayList<Footnote>()
    let blockMap = HashMap<String, FootnoteBlock>()
    public func visit(n: Document): Unit {
        visitChildren(n)
        for (footnote in notes) {
            let block = blockMap.get(footnote.noteid) ?? continue
            footnote.block = block
        }
    }
    public func visit(n: CustomBlock): Unit {
        match (n) {
            case f: FootnoteBlock =>
                var preSize = 0
                var pnode: Node = f
                while (let Some(v) <- pnode.getPrevious()) {
                    preSize++
                    pnode = v
                }
                f.blockIndex = preSize
                blockMap.add(f.noteid, f)
            case _ => ()
        }
        visitChildren(n)
    }
    public func visit(n: Text): Unit {
        let line = n.getLiteral()
        let sss = n.getSourceSpans()
        if(sss.isEmpty()){
            return
        }
        let lineSource = sss[0]

        var i = 0

        while (i <= line.size - 3) {
            if (let Some(f0) <- line.indexOf("[^", i)) {
                // 捕获footnote
                if (let Some(f1) <- line.indexOf("]", f0 + 2)) {
                    if (i < f0) {
                        let text = Text(line[i..f0])
                        let ss = lineSource.subSpan(i, f0)
                        text.addSourceSpan(ss)
                        n.insertBefore(text)
                    }
                    let footnote = Footnote(line[f0 + 2..f1])
                    let ss = lineSource.subSpan(f0 + 2, f1)
                    footnote.addSourceSpan(ss)
                    n.insertBefore(footnote)
                    notes.add(footnote)
                    i = f1 + 1
                } else {
                    // 搜索结束
                    break
                }
            } else {
                // 搜索结束
                break
            }
        }
        let newLine = line[i..]
        if (newLine.size == 0) {
            n.unlink()
        } else {
            n.setLiteral(newLine)
            let ss = lineSource.subSpan(i)
            n.setSourceSpans(ArrayList([ss]))
        }
    }
}

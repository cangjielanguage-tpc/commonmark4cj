/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package commonmark4cj.strikethrough

let StrikethroughType: NodeType = "Strikethrough"

public abstract class StrikethroughNodeRenderer <: NodeRenderer {
    public override func getNodeTypes(): HashSet<NodeType> {
        return HashSet<NodeType>([StrikethroughType])
    }
}

/**
 * A strikethrough node containing text and other inline nodes nodes as children.
 */
public class Strikethrough <: CustomNode & Delimited {
    // private static let DELIMITER: String = "~~"

    public Strikethrough(let delimiter: String) {}

    public override func getOpeningDelimiter(): ?String {
        return delimiter
    }

    public override func getClosingDelimiter(): ?String {
        return delimiter
    }

    public override func getNodeType(): NodeType {
        return StrikethroughType
    }
}

class StrikethroughDelimiterProcessor <: DelimiterProcessor {
    let requireTwoTildes: Bool
    public init() {
        this(true)
    }
    public init(requireTwoTildes: Bool) {
        this.requireTwoTildes = requireTwoTildes
    }

    public override func getOpeningCharacter(): Rune {
        return r'~'
    }

    public override func getClosingCharacter(): Rune {
        return r'~'
    }

    public override func getMinLength(): Int64 {
        return if (requireTwoTildes) {
            2
        } else {
            1
        }
    }

    public override func process(openingRun: DelimiterRun, closingRun: DelimiterRun): Int {
        if (openingRun.getLength() == closingRun.getLength() && openingRun.getLength() <= 2) {
            // GitHub only accepts either one or two delimiters, but not a mix or more than that.

            let opener = openingRun.getOpener()

            // Wrap nodes between delimiters in strikethrough.
            let delimiter = if (openingRun.getLength() == 1) {
                opener.getLiteral()
            } else {
                opener.getLiteral() + opener.getLiteral()
            }
            let strikethrough = Strikethrough(delimiter)

            let sourceSpans = SourceSpans()
            sourceSpans.addAllFromTexts(openingRun.getOpeners(openingRun.getLength()))

            for (node in Nodes.between(opener, closingRun.getCloser())) {
                strikethrough.appendChild(node)
                sourceSpans.addAll(node.getSourceSpans())
            }

            sourceSpans.addAllFromTexts(closingRun.getClosers(closingRun.getLength()))
            strikethrough.setSourceSpans(sourceSpans.getSourceSpans())

            opener.insertAfter(strikethrough)

            return openingRun.getLength()
        } else {
            return 0
        }
    }
}

public class StrikethroughExtension <: ParserExtension & HtmlRendererExtension & TextContentRendererExtension {
    private init() {}

    public static func create(): Extension {
        return StrikethroughExtension()
    }

    public override func ext(parserBuilder: ParserBuilder): Unit {
        parserBuilder.customDelimiterProcessor(StrikethroughDelimiterProcessor())
    }

    public override func ext(rendererBuilder: HtmlRendererBuilder): Unit {
        rendererBuilder.nodeRendererFactory({
            context => StrikethroughHtmlNodeRenderer(context)
        })
    }

    public override func ext(rendererBuilder: TextContentRendererBuilder): Unit {
        rendererBuilder.nodeRendererFactory({
            context => StrikethroughTextContentNodeRenderer(context)
        })
    }
}

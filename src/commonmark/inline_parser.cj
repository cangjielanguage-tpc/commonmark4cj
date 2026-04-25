/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 */

package commonmark4cj.commonmark

/**
 * Parser for inline content (text, links, emphasized text, etc).
 */
public interface InlineParser {

    /**
     * @param lines the content to parse as inline
     * @param node the node to append resulting nodes to (as children)
     */
    func parse(lines: SourceLines, node: Node): Unit
}

/**
 * Context for inline parsing.
 */
public interface InlineParserContext {

    /**
     * @return custom delimiter processors that have been configured with {@link Parser.Builder#customDelimiterProcessor(DelimiterProcessor)}
     */
    func getCustomDelimiterProcessors(): ArrayList<DelimiterProcessor>

    /**
     * @return custom inline content parsers that have been configured with
     * {@link Parser.Builder#customInlineContentParserFactory(InlineContentParserFactory)}
     */
    func getCustomInlineContentParserFactories(): ArrayList<InlineContentParserFactory>

    /**
     * @return custom link processors that have been configured with {@link Parser.Builder#linkProcessor}.
     */
    func getCustomLinkProcessors(): ArrayList<LinkProcessor>

    /**
     * @return custom link markers that have been configured with {@link Parser.Builder#linkMarker}.
     */
    func getCustomLinkMarkers(): HashSet<Rune>

    /**
     * Look up a {@link LinkReferenceDefinition} for a given label.
     *
     * @param label the link label to look up
     * @return the definition if one exists, {@code null} otherwise
     */
    func getLinkReferenceDefinition(label: String): ?LinkReferenceDefinition

    /**
     * Look up a definition of a type for a given label.
     * <p>
     * Note that the passed in label does not need to be normalized; implementations are responsible for doing the
     * normalization before lookup.
     *
     * @return the definition if one exists, null otherwise
     */
    func getDefinition(typ: String, label: String): ?LinkReferenceDefinition
}

public interface InlineParserFactory {
    func create(inlineParserContext: InlineParserContext): InlineParser
}

class InlineParserContextImpl <: InlineParserContext {
    private var delimiterProcessors: ArrayList<DelimiterProcessor>
    var definitions: Definitions
    private let inlineContentParserFactories: ArrayList<InlineContentParserFactory>
    private let linkProcessors: ArrayList<LinkProcessor>
    private let linkMarkers: HashSet<Rune>

    public init(
        inlineContentParserFactories: ArrayList<InlineContentParserFactory>,
        delimiterProcessors: ArrayList<DelimiterProcessor>,
        linkProcessors: ArrayList<LinkProcessor>,
        linkMarkers: HashSet<Rune>,
        definitions: Definitions
    ) {
        this.inlineContentParserFactories = inlineContentParserFactories
        this.delimiterProcessors = delimiterProcessors
        this.definitions = definitions
        this.linkProcessors = linkProcessors
        this.linkMarkers = linkMarkers
    }

    @Frozen
    public override func getCustomDelimiterProcessors(): ArrayList<DelimiterProcessor> {
        return delimiterProcessors
    }

    @Frozen
    public func getCustomInlineContentParserFactories(): ArrayList<InlineContentParserFactory> {
        return inlineContentParserFactories
    }

    @Frozen
    public func getCustomLinkProcessors(): ArrayList<LinkProcessor> {
        return linkProcessors
    }

    @Frozen
    public func getCustomLinkMarkers(): HashSet<Rune> {
        return linkMarkers
    }

    @Frozen
    public override func getLinkReferenceDefinition(label: String): ?LinkReferenceDefinition {
        return definitions.getDefinition("LinkReferenceDefinition", label)
    }

    public func getDefinition(typ: String, label: String): ?LinkReferenceDefinition {
        return definitions.getDefinition(typ, label)
    }

    var ctxCalc: ?InlineParserContextCalc = None
    func calc(): Unit {
        if (ctxCalc.isNone()) {
            ctxCalc = InlineParserContextCalc(this)
        }
    }
}

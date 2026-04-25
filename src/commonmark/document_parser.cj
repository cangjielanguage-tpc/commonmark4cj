/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 */

package commonmark4cj.commonmark

class DocumentParser <: ParserState {
    private static var CORE_FACTORY_TYPES: HashSet<NodeType> = HashSet<NodeType>(
        [
            BlockQuoteType,
            HeadingType,
            FencedCodeBlockType,
            HtmlBlockType,
            ThematicBreakType,
            ListBlockType,
            IndentedCodeBlockType
        ]
    )

    private static var NODES_TO_CORE_FACTORIES: HashMap<NodeType, BlockParserFactory> = HashMap<NodeType, BlockParserFactory>(
        [
            (BlockQuoteType, BlockQuoteParserFactory()),
            (HeadingType, HeadingParserFactory()),
            (FencedCodeBlockType, FencedCodeBlockParserFactory()),
            (HtmlBlockType, HtmlBlockParserFactory()),
            (ThematicBreakType, ThematicBreakParserFactory()),
            (ListBlockType, ListBlockParserFactory()),
            (IndentedCodeBlockType, IndentedCodeBlockParserFactory())
        ]
    )

    private var line: SourceLine = SourceLine.of("", None)
    /**
     * Line index (0-based)
     */
    private var lineIndex = -1

    /**
     * current index (offset) in input line (0-based)
     */
    private var index: Int64 = 0

    /**
     * current column of input line (tab causes column to go to next 4-space tab stop) (0-based)
     */
    private var column: Int64 = 0

    /**
     * if the current column is within a tab character (partially consumed tab)
     */
    private var columnIsInTab: Bool = false

    private var nextNonSpace: Int64 = 0
    private var nextNonSpaceColumn: Int64 = 0
    private var indent: Int64 = 0
    private var blank: Bool = false

    private var blockParserFactories: ArrayList<BlockParserFactory>
    private var inlineParserFactory: InlineParserFactory
    private var delimiterProcessors: ArrayList<DelimiterProcessor>
    private var documentBlockParser: DocumentBlockParser
    // private var definitions: HashMap<String, LinkReferenceDefinition> = HashMap<String, LinkReferenceDefinition>()
    private var definitions = Definitions()

    private var openBlockParsers: ArrayList<OpenBlockParser> = ArrayList()
    // LinkedHashSet to have a deterministic order
    private var allBlockParsers: ArrayList<AbstractBlockParser> = ArrayList()
    // private var allBlockParsers: HashSet<AbstractBlockParser> = HashSet<AbstractBlockParser>()
    private let inlineParserContext: InlineParserContext
    private let includeSourceSpans: IncludeSourceSpans

    public init(
        blockParserFactories: ArrayList<BlockParserFactory>,
        inlineParserFactory: InlineParserFactory,
        delimiterProcessors: ArrayList<DelimiterProcessor>,
        inlineParserContext: InlineParserContext,
        includeSourceSpans: IncludeSourceSpans
    ) {
        this.blockParserFactories = blockParserFactories
        this.inlineParserFactory = inlineParserFactory
        this.delimiterProcessors = delimiterProcessors

        this.inlineParserContext = inlineParserContext
        this.includeSourceSpans = includeSourceSpans

        this.documentBlockParser = DocumentBlockParser()
        activateBlockParser(OpenBlockParser(this.documentBlockParser, 0))
    }

    @Frozen
    public static func getDefaultBlockParserTypes(): HashSet<NodeType> {
        return CORE_FACTORY_TYPES
    }

    public static func calculateBlockParserFactories(
        customBlockParserFactories: ArrayList<BlockParserFactory>,
        enabledBlockTypes: HashSet<NodeType>
    ): ArrayList<BlockParserFactory> {
        var list: ArrayList<BlockParserFactory> = ArrayList<BlockParserFactory>()
        // By having the custom factories come first, extensions are able to change behavior of core syntax.
        list.add(all: customBlockParserFactories)
        for (blockType in enabledBlockTypes) {
            list.add(NODES_TO_CORE_FACTORIES.get(blockType).getOrThrow())
        }
        return list
    }

    /**
     * The main parsing function. Returns a parsed document AST.
     */
    public func parse(input: String): Document {
        this.input = input
        lineStart = 0
        lineBreak = Characters.findLineBreak(input, lineStart)

        while (lineBreak != -1) {
            var line = input[lineStart..lineBreak]

            let lineStartOld = lineStart
            // 预处理lineStart/lineBreak 便于getNextLine
            if (lineBreak + 1 < input.size && input[lineBreak] == b'\r' && input[lineBreak + 1] == b'\n') {
                lineStart = lineBreak + 2
            } else {
                lineStart = lineBreak + 1
            }
            lineBreak = Characters.findLineBreak(input, lineStart)

            parseLine(line, lineStartOld)
        }
        if (input.size > 0 && (lineStart == 0 || lineStart < input.size)) {
            var line = input[lineStart..input.size]
            parseLine(line, lineStart)
        }

        return finalizeAndProcess()
    }

    @Frozen
    public func parse(input: InputStream): Document {
        lineStart = 0
        let reader = StringLineReader(input)
        while (let Some((line, lbs)) <- reader.readln()) {
            parseLine(line, lineStart)
            lineStart += line.size
            lineStart += lbs
        }

        return finalizeAndProcess()
    }

    public func getLine(): SourceLine {
        return line
    }

    private var input: String = "" // 所有行的内容
    private var lineStart: Int = -1
    private var lineBreak: Int = -1
    public func getNextLine(): String {
        if (lineStart <= lineBreak) {
            input[lineStart..lineBreak]
        } else {
            ""
        }
    }

    public func getIndex(): Int64 {
        return index
    }

    public func getNextNonSpaceIndex(): Int64 {
        return nextNonSpace
    }

    public func getColumn(): Int64 {
        return column
    }

    public func getIndent(): Int64 {
        return indent
    }

    public func isBlank(): Bool {
        return blank
    }

    @Frozen
    public func getActiveBlockParser(): AbstractBlockParser {
        return openBlockParsers[openBlockParsers.size - 1].blockParser
    }

    private func setLine(ln: String, inputIndex: Int): Unit {
        lineIndex++
        index = 0
        column = 0
        columnIsInTab = false

        let lineContent = prepareLine(ln)
        var sourceSpan: ?SourceSpan = None
        if (includeSourceSpans.need) {
            sourceSpan = SourceSpan.of(lineIndex, 0, inputIndex, lineContent.size)
        }
        this.line = SourceLine.of(lineContent, sourceSpan)
    }

    /**
     * Analyze a line of text and update the document appropriately. We parse markdown text by calling this on each
     * line of input, then finalizing the document.
     */
    @Frozen
    private func parseLine(ln: String, inputIndex: Int): Unit {
        setLine(ln, inputIndex)

        // For each containing block, try to parse the associated line start.
        // Bail out on failure: container will poInt64 to the last matching block.
        // Set all_matched to false if not all containers match.
        // The document will always match, can be skipped
        var matches: Int64 = 1
        for (i in 1..openBlockParsers.size) {
            let openBlockParser = openBlockParsers[i]
            let blockParser = openBlockParser.blockParser
            findNextNonSpace()

            if (let Some(blockContinue: BlockContinueImpl) <- blockParser.tryContinue(this)) {
                openBlockParser.sourceIndex = getIndex()
                if (blockContinue.isFinalize()) {
                    addSourceSpans()
                    closeBlockParsers(openBlockParsers.size - i)
                    return
                } else {
                    if (blockContinue.getNewIndex() != -1) {
                        setNewIndex(blockContinue.getNewIndex())
                    } else if (blockContinue.getNewColumn() != -1) {
                        setNewColumn(blockContinue.getNewColumn())
                    }
                    matches++
                }
            } else {
                break
            }
        }

        var unmatchedBlocks: Int64 = openBlockParsers.size - matches
        var blockParser = openBlockParsers[matches - 1].blockParser
        var startedNewBlock = false
        var lastIndex: Int = index
        // Unless last matched container is a code block, try container starts,
        // adding children to the last matched container:
        var tryBlockStarts: Bool = blockParser.getBlock() is Paragraph || blockParser.isContainer()
        while (tryBlockStarts) {
            lastIndex = index
            findNextNonSpace()

            if (isBlank() || (indent < Parsing.CODE_BLOCK_INDENT && Characters.isLetter(line.getContent(), nextNonSpace))) {
                setNewIndex(nextNonSpace)
                break
            }

            var blockStart: BlockStartImpl = if (let Some(v) <- findBlockStart(blockParser)) {
                v
            } else {
                setNewIndex(nextNonSpace)
                break
            }

            startedNewBlock = true
            var sourceIndex = getIndex()

            // We're starting a new block. If we have any previous blocks that need to be closed, we need to do it now.
            if (unmatchedBlocks > 0) {
                closeBlockParsers(unmatchedBlocks)
                unmatchedBlocks = 0
            }

            if (blockStart.getNewIndex() != -1) {
                setNewIndex(blockStart.getNewIndex())
            } else if (blockStart.getNewColumn() != -1) {
                setNewColumn(blockStart.getNewColumn())
            }

            var replacedSourceSpans: ?ArrayList<SourceSpan> = None
            if (blockStart.getReplaceParagraphLines() >= 1 || blockStart.isReplaceActiveBlockParser()) {
                var activeBlockParser = getActiveBlockParser()
                if (let Some(paragraphParser: ParagraphParser) <- (activeBlockParser as ParagraphParser)) {
                    var lines = if (blockStart.isReplaceActiveBlockParser()) {
                        Int64.Max
                    } else {
                        blockStart.getReplaceParagraphLines()
                    }
                    replacedSourceSpans = replaceParagraphLines(lines, paragraphParser)
                } else if (blockStart.isReplaceActiveBlockParser()) {
                    replacedSourceSpans = prepareActiveBlockParserForReplacement(activeBlockParser)
                }
            }

            for (newBlockParser in blockStart.getBlockParsers()) {
                addChild(OpenBlockParser(newBlockParser, sourceIndex))
                if (let Some(v) <- replacedSourceSpans) {
                    newBlockParser.getBlock().setSourceSpans(v)
                }
                blockParser = newBlockParser
                tryBlockStarts = newBlockParser.isContainer()
            }
        }

        // What remains at the offset is a text line. Add the text to the
        // appropriate block.

        // First check for a lazy paragraph continuation:
        if (!startedNewBlock && !isBlank() && getActiveBlockParser().canHaveLazyContinuationLines()) { /*cjlint-ignore !G.EXP.03 */
            // lazy paragraph continuation
            addLine()
        } else {

            // finalize any blocks not matched
            if (unmatchedBlocks > 0) {
                closeBlockParsers(unmatchedBlocks)
            }

            if (!blockParser.isContainer()) {
                addLine()
            } else if (!isBlank()) {
                // create paragraph container for line
                addChild(OpenBlockParser(ParagraphParser(), lastIndex))
                addLine()
            } else {
                // This can happen for a list item like this:
                // ```
                // *
                // list item
                // ```
                //
                // The first line does not start a paragraph yet, but we still want to record source positions.
                addSourceSpans()
            }
        }
    }

    private func findNextNonSpace(): Unit {
        var i: Int64 = index
        var colsNum: Int64 = column

        blank = true
        var length: Int64 = line.getContent().size
        while (i < length) {
            var c = line.getContent()[i]
            if (c == b' ') {
                i++
                colsNum++
                continue
            } else if (c == b'\t') {
                i++
                colsNum += (4 - (colsNum % 4))
                continue
            }
            blank = false
            break
        }

        nextNonSpace = i
        nextNonSpaceColumn = colsNum
        indent = nextNonSpaceColumn - column
    }

    private func setNewIndex(newIndex: Int64): Unit {
        if (newIndex >= nextNonSpace) {
            // We can start from here, no need to calculate tab stops again
            index = nextNonSpace
            column = nextNonSpaceColumn
        }
        var length: Int64 = line.getContent().size
        while (index < newIndex && index != length) {
            advance()
        }
        // If we're going to an index as opposed to a column, we're never within a tab
        columnIsInTab = false
    }

    private func setNewColumn(newColumnNum: Int64): Unit {
        if (newColumnNum >= nextNonSpaceColumn) {
            // We can start from here, no need to calculate tab stops again
            index = nextNonSpace
            column = nextNonSpaceColumn
        }
        var length: Int64 = line.getContent().size
        while (column < newColumnNum && index != length) {
            advance()
        }
        if (column > newColumnNum) {
            // Last character was a tab and we overshot our target
            index--
            column = newColumnNum
            columnIsInTab = true
        } else {
            columnIsInTab = false
        }
    }

    /**
     * append contents
     */
    private func addLine(): Unit {
        var content: String
        if (columnIsInTab) {
            var afterTab: Int64 = index + 1
            var rest = line.getContent()[afterTab..line.getContent().size]
            var spaces: Int64 = Parsing.columnsToNextTabStop(column)
            var sb: StringBuilder = StringBuilder(spaces + rest.size)
            sb.append(" " * spaces)
            sb.append(rest)
            content = sb.toString()
        } else if (index == 0) {
            content = line.getContent()
        } else {
            content = line.getContent()[index..line.getContent().size]
        }
        var sourceSpan: ?SourceSpan = None
        if (includeSourceSpans == IncludeSourceSpans.BLOCKS_AND_INLINES && index < (line.getSourceSpan()?.getLength() ??
            -1)) {
            // Note that if we're in a partially-consumed tab the length of the source span and the content don't match.
            sourceSpan = line.getSourceSpan()?.subSpan(index)
        }
        getActiveBlockParser().addLine(SourceLine.of(content, sourceSpan))
        addSourceSpans()
    }

    private func addSourceSpans(): Unit {
        if (includeSourceSpans.need) {
            // Don't add source spans for Document itself (it would get the whole source text), so start at 1, not 0
            for (i in 1..openBlockParsers.size) {
                var openBlockParser = openBlockParsers[i]
                // In case of a lazy continuation line, the index is less than where the block parser would expect the
                // contents to start, so let's use whichever is smaller.
                let blockIndex = min(openBlockParser.sourceIndex, index)
                let length = line.getContent().size - blockIndex
                if (let Some(ss) <- line.getSourceSpan() && length != 0) {
                    openBlockParser.blockParser.addSourceSpan(ss.subSpan(blockIndex))
                }
            }
        }
    }

    private func advance(): Unit {
        var lineChar = line.getContent()[index]
        if (lineChar == b'\t') {
            index++
            column = Parsing.columnsToNextTabStop(column) + column
        } else {
            index++
            column++
        }
    }

    @Frozen
    private func findBlockStart(blockParser: AbstractBlockParser): Option<BlockStartImpl> {
        var matchedBlockParser: MatchedBlockParser = MatchedBlockParserImpl(blockParser)
        for (blockParserFactory in blockParserFactories) {
            var result: ?BlockStart = blockParserFactory.tryStart(this, matchedBlockParser)
            if (let Some(v: BlockStartImpl) <- result) {
                return v
            }
        }
        return None
    }

    /**
     * Finalize a block. Close it and do any necessary postprocessing, e.g. creating string_content from strings,
     * setting the 'tight' or 'loose' status of a list, and parsing the beginnings of paragraphs for reference
     * definitions.
     */
    private func finalize(blockParser: BlockParser): Unit {
        addDefinitionsFrom(blockParser)
        blockParser.closeBlock()
    }

    private func addDefinitionsFrom(blockParser: BlockParser): Unit {
        for (ref in blockParser.getDefinitions()) {
            definitions.addDefinition(ref)
        }
    }

    /**
     * Prepares the input line replacing {@code \0}
     */
    private static func prepareLine(line: String): String {
        line.replace("\0", "\u{FFFD}")
    }

    /**
     * Walk through a block & children recursively, parsing string content into inline content where appropriate.
     */
    private func processInlines(): Unit {
        var context = InlineParserContextImpl(
            inlineParserContext.getCustomInlineContentParserFactories(),
            delimiterProcessors,
            inlineParserContext.getCustomLinkProcessors(),
            inlineParserContext.getCustomLinkMarkers(),
            definitions
        )
        if (let Some(ctx) <- (this.inlineParserContext as InlineParserContextImpl)) {
            ctx.calc()
            context.ctxCalc = ctx.ctxCalc
        }
        var inlineParser: InlineParser = inlineParserFactory.create(context)

        for (blockParser in allBlockParsers) {
            blockParser.parseInlines(inlineParser)
        }
    }

    /**
     * Add block of type tag as a child of the tip. If the tip can't  accept children, close and finalize it and try
     * its parent, and so on til we find a block that can accept children.
     */
    private func addChild(openBlockParser: OpenBlockParser): Unit {
        while (!getActiveBlockParser().canContain(openBlockParser.blockParser.getBlock())) {
            closeBlockParsers(1)
        }

        getActiveBlockParser().getBlock().appendChild(openBlockParser.blockParser.getBlock())
        activateBlockParser(openBlockParser)
    }

    @Frozen
    private func activateBlockParser(openBlockParser: OpenBlockParser): Unit {
        openBlockParsers.add(openBlockParser)
    }

    private func deactivateBlockParser(): OpenBlockParser {
        openBlockParsers.remove(at: openBlockParsers.size - 1)
    }

    private func replaceParagraphLines(lines: Int, paragraphParser: ParagraphParser): ArrayList<SourceSpan> {
        // Remove lines from paragraph as the new block is using them.
        // If all lines are used, this also unlinks the Paragraph block.
        var sourceSpans = paragraphParser.removeLines(lines)
        // Close the paragraph block parser, which will finalize it.
        closeBlockParsers(1)
        return sourceSpans
    }
    private func prepareActiveBlockParserForReplacement(blockParser: BlockParser): ArrayList<SourceSpan> {
        // Note that we don't want to parse inlines here, as it's getting replaced.
        deactivateBlockParser()

        // Do this so that source positions are calculated, which we will carry over to the replacing block.
        blockParser.closeBlock()
        blockParser.getBlock().unlink()
        return blockParser.getBlock().getSourceSpans()
    }

    private func finalizeAndProcess(): Document {
        closeBlockParsers(openBlockParsers.size)
        processInlines()
        return documentBlockParser.getBlock()
    }

    @Frozen
    private func closeBlockParsers(count: Int): Unit {
        for (_ in 0..count) {
            let blockParser = deactivateBlockParser().blockParser
            finalize(blockParser)
            // Remember for inline parsing. Note that a lot of blocks don't need inline parsing. We could have a
            // separate interface (e.g. BlockParserWithInlines) so that we only have to remember those that actually
            // have inlines to parse.
            allBlockParsers.add(blockParser)
        }
    }
}

class MatchedBlockParserImpl <: MatchedBlockParser {
    private var matchedBlockParser: AbstractBlockParser

    public MatchedBlockParserImpl(matchedBlockParser: AbstractBlockParser) {
        this.matchedBlockParser = matchedBlockParser
    }

    public func getMatchedBlockParser(): AbstractBlockParser {
        return matchedBlockParser
    }

    public func getParagraphLines(): SourceLines {
        match (matchedBlockParser) {
            case v: ParagraphParser => v.getParagraphLines()
            case _ => SourceLines.empty()
        }
    }
}

class OpenBlockParser {
    OpenBlockParser(let blockParser: AbstractBlockParser, var sourceIndex: Int) {}
}

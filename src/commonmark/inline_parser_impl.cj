/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights resvered.
 */
package commonmark4cj.commonmark

class InlineParserImpl <: InlineParser & InlineParserState {
    private var specialCharacters: BitSet
    private var delimiterProcessors: HashMap<Rune, DelimiterProcessor>
    private var context: InlineParserContext
    private let inlineContentParserFactories: ArrayList<InlineContentParserFactory>
    private let linkProcessors: ArrayList<LinkProcessor>
    private let linkMarkers: BitSet

    private let inlineParsers: HashMap<Rune, ArrayList<(InlineContentParserFactory, InlineContentParser)>> = HashMap()
    private var scanner: Scanner = unsafe { zeroValue() }
    private var includeSourceSpans: Bool = false
    private var trailingSpaces: Int = 0

    /**
     * Top delimiter (emphasis, strong emphasis or custom emphasis). (Brackets are on a separate stack, different
     * from the algorithm described in the spec.)
     */
    private var lastDelimiter: ?Delimiter = None

    /**
     * Top opening bracket (<code>[</code> or <code>![)</code>).
     */
    private var lastBracket: ?Bracket = None

    public init(context: InlineParserContext) {
        let ctx = (context as InlineParserContextImpl).getOrThrow()
        ctx.calc()
        let calc = ctx.ctxCalc.getOrThrow()
        this.context = context
        this.inlineContentParserFactories = calc.inlineContentParserFactories
        this.delimiterProcessors = calc.delimiterProcessors
        this.linkProcessors = calc.linkProcessors
        this.linkMarkers = calc.linkMarkers
        this.specialCharacters = calc.specialCharacters
    }

    @Frozen
    private func createInlineContentParsers(): Unit {
        if (inlineParsers.size == 0) {
            for (factory in inlineContentParserFactories) {
                var parser = factory.create()
                for (c in factory.getTriggerCharacters()) {
                    let arr = inlineParsers.get(c) ??
                        {
                        =>
                        let arr = ArrayList<(InlineContentParserFactory, InlineContentParser)>()
                        inlineParsers.add(c, arr)
                        arr
                    }()
                    arr.add((factory, parser))
                }
            }
        } else {
            for ((_, arr) in inlineParsers) {
                for (i in 0..arr.size) {
                    let (f, _) = arr[i]
                    arr[i] = (f, f.create())
                }
            }
        }
    }

    public func getScanner(): Scanner {
        return scanner
    }

    @Frozen
    public func parse(lines: SourceLines, block: Node): Unit {
        reset(lines)
        while (true) {
            let nodes = parseInline()
            if (nodes.size == 0) {
                break
            }
            for (node in nodes) {
                block.appendChild(node)
            }
        }

        processDelimiters(Option<Delimiter>.None)
        mergeChildTextNodes(block)
    }

    func reset(lines: SourceLines): Unit {
        this.scanner = Scanner.of(lines)
        this.includeSourceSpans = !lines.getSourceSpans().isEmpty()
        this.trailingSpaces = 0
        this.lastDelimiter = None
        this.lastBracket = None
        this.createInlineContentParsers()
    }

    private func text(sourceLines: SourceLines): Text {
        let text = Text(sourceLines.getContent())
        text.setSourceSpans(sourceLines.getSourceSpans())
        return text
    }

    /**
     * Parse the next inline element in subject, advancing input index.
     * On success, return the new inline node.
     * On failure, return null.
     */
    @Frozen
    private func parseInline(): Array<Node> {
        let b: Byte = scanner.peek()

        match (b) {
            case '[' => return [parseOpenBracket()]
            case ']' => return [parseCloseBracket()]
            case '\n' => return [parseLineBreak()]
            case '\0' => return []
            case _ => ()
        }

        if (linkMarkers.get(scanner)) {
            var markerPosition = scanner.position()
            var nodes = parseLinkMarker()
            if (nodes.size > 0) {
                return nodes
            }
            // Reset and try other things (e.g. inline parsers below)
            scanner.setPosition(markerPosition)
        }

        // No inline parser, delimiter or other special handling.
        if (!specialCharacters.get(scanner)) {
            return [parseText()]
        }
        let c: Rune = scanner.peekRune()

        let inlineParsers = this.inlineParsers.get(c)
        if (let Some(inlineParsers) <- inlineParsers) {
            let position: SourcePosition = scanner.position()
            for ((_, inlineParser) in inlineParsers) {
                let parsedInline = inlineParser.tryParse(this)
                if (let Some(parsedInlineImpl) <- (parsedInline as ParsedInlineImpl)) {
                    let node = parsedInlineImpl.getNode()
                    scanner.setPosition(parsedInlineImpl.getPosition())
                    if (includeSourceSpans && node.getSourceSpans().isEmpty()) {
                        node.setSourceSpans(scanner.getSource(position, scanner.position()).getSourceSpans())
                    }
                    return [node]
                } else {
                    // Reset position
                    scanner.setPosition(position)
                }
            }
        }

        let delimiterProcessor = delimiterProcessors.get(c)
        if (let Some(delimiterProcessor) <- delimiterProcessor) {
            let nodes = parseDelimiters(delimiterProcessor, c)
            if (nodes.size > 0) {
                return nodes
            }
        }

        // If we get here, even for a special/delimiter character, we will just treat it as text.
        return [parseText()]
    }

    /**
     * Attempt to parse delimiters like emphasis, strong emphasis or custom delimiters.
     */
    @Frozen
    private func parseDelimiters(delimiterProcessor: DelimiterProcessor, delimiterChar: Rune): Array<Node> {
        let res: DelimiterData = scanDelimiters(delimiterProcessor, delimiterChar) ?? return []

        let characters = res.characters

        // Add entry to stack for this opener
        let delimiter = Delimiter(characters, delimiterChar, res.canOpen, res.canClose, lastDelimiter)
        lastDelimiter = delimiter
        if (let Some(prev) <- delimiter.previous) {
            prev.next = lastDelimiter
        }

        return characters |> map<Text, Node> {t => t} |> collectArray
    }

    /**
     * Add open bracket to delimiter stack and add a text node to block's children.
     */
    private func parseOpenBracket(): Node {
        let start = scanner.position()
        scanner.next()
        let contentPosition = scanner.position()

        let node: Text = text(scanner.getSource(start, contentPosition))

        // Add entry to stack for this opener
        addBracket(Bracket.link(node, start, contentPosition, lastBracket, lastDelimiter))

        return node
    }

    /**
     * If next character is {@code [}, add a bracket to the stack.
     * Otherwise, return null.
     */
    @Frozen
    private func parseLinkMarker(): Array<Node> {
        var markerPosition = scanner.position()
        scanner.next()
        var bracketPosition = scanner.position()
        if (scanner.next('[')) {
            var contentPosition = scanner.position()
            var bangNode = text(scanner.getSource(markerPosition, bracketPosition))
            var bracketNode = text(scanner.getSource(bracketPosition, contentPosition))

            // Add entry to stack for this opener
            addBracket(
                Bracket.withMarker(bangNode, markerPosition, bracketNode, bracketPosition, contentPosition, lastBracket,
                    lastDelimiter))
            return [bangNode, bracketNode]
        } else {
            return []
        }
    }

    /*
     * Try to match close bracket against an opening in the delimiter stack. Return either a link or image, or a
     * plain [ character. If there is a matching delimiter, remove it from the delimiter stack.
     */
    private func parseCloseBracket(): Node {
        let beforeClose = scanner.position()
        scanner.next()
        let afterClose = scanner.position()

        // Get previous `[` or `![`
        // No matching opener, just return a literal.
        let opener: Bracket = lastBracket ?? return text(scanner.getSource(beforeClose, afterClose))

        if (!opener.allowed) {
            // Matching opener but it's not allowed, just return a literal.
            removeLastBracket()
            return text(scanner.getSource(beforeClose, afterClose))
        }
        var linkOrImage = parseLinkOrImage(opener, beforeClose)
        if (let Some(linkOrImage) <- linkOrImage) {
            return linkOrImage
        }
        scanner.setPosition(afterClose)

        // Nothing parsed, just parse the bracket as text and continue
        removeLastBracket()
        return text(scanner.getSource(beforeClose, afterClose))
    }

    private func parseLinkOrImage(opener: Bracket, beforeClose: SourcePosition): ?Node {
        var linkInfo = parseLinkInfo(opener, beforeClose) ?? return None
        var processorStartPosition = scanner.position()

        for (linkProcessor in linkProcessors) {
            let result: LinkResultImpl = match (linkProcessor.process(linkInfo, scanner, context)) {
                case Some(v: LinkResultImpl) => v
                case _ =>
                    // Reset position in case the processor used the scanner, and it didn't work out.
                    scanner.setPosition(processorStartPosition)
                    continue
            }

            var node = result.getNode()
            var position = result.getPosition()
            var includeMarker = result.isIncludeMarker()

            match (result.getType()) {
                case WRAP =>
                    scanner.setPosition(position)
                    return wrapBracket(opener, node, includeMarker)
                case REPLACE =>
                    scanner.setPosition(position)
                    return replaceBracket(opener, node, includeMarker)
            }
        }

        return None
    }

    private func parseLinkInfo(opener: Bracket, beforeClose: SourcePosition): ?LinkInfo {
        // Check to see if we have a link (or image, with a ! in front). The different types:
        // - Inline:       `[foo](/uri)` or with optional title `[foo](/uri "title")`
        // - Reference links
        //   - Full:      `[foo][bar]` (foo is the text and bar is the label that needs to match a reference)
        //   - Collapsed: `[foo][]`    (foo is both the text and label)
        //   - Shortcut:  `[foo]`      (foo is both the text and label)

        let text = scanner.getSource(opener.contentPosition, beforeClose).getContent()

        // Starting position is after the closing `]`
        let afterClose = scanner.position()

        // Maybe an inline link/image
        var destinationTitle = parseInlineDestinationTitle(scanner)
        if (let Some(destinationTitle) <- destinationTitle) {
            return LinkInfoImpl(opener.markerNode, opener.bracketNode, text, None, destinationTitle.destination,
                destinationTitle.title, afterClose)
        }
        // Not an inline link/image, rewind back to after `]`.
        scanner.setPosition(afterClose)

        // Maybe a reference link/image like `[foo][bar]`, `[foo][]` or `[foo]`.
        // Note that even `[foo](` could be a valid link if foo is a reference, which is why we try this even if the `(`
        // failed to be parsed as an inline link/image before.

        // See if there's a link label like `[bar]` or `[]`
        let label = parseLinkLabel(scanner)
        if (label.isNone()) {
            // No label, rewind back
            scanner.setPosition(afterClose)
        }
        var textIsReference = label?.isEmpty() ?? true
        if (opener.bracketAfter && textIsReference && opener.markerNode == None) {
            // In case of shortcut or collapsed links, the text is used as the reference. But the reference is not allowed to
            // contain an unescaped bracket, so if that's the case we don't need to continue. This is an optimization.
            return None
        }

        return LinkInfoImpl(opener.markerNode, opener.bracketNode, text, label, None, None, afterClose)
    }

    private func wrapBracket(opener: Bracket, wrapperNode: Node, includeMarker: Bool): Node {
        // Add all nodes between the opening bracket and now (closing bracket) as child nodes of the link
        var n: ?Node = opener.bracketNode.getNext()
        while (let Some(n1) <- n) {
            n = n1.getNext()
            wrapperNode.appendChild(n1)
        }

        if (includeSourceSpans) {
            var startPosition = if (includeMarker && opener.markerPosition.isSome()) {
                opener.markerPosition
            } else {
                opener.bracketPosition
            }
            wrapperNode.setSourceSpans(
                scanner.getSource(startPosition.getOrThrow(), scanner.position()).getSourceSpans())
        }

        // Process delimiters such as emphasis inside link/image
        processDelimiters(opener.previousDelimiter)
        mergeChildTextNodes(wrapperNode)
        // We don't need the corresponding text node anymore, we turned it into a link/image node
        if (includeMarker && opener.markerNode.isSome()) {
            opener.markerNode?.unlink()
        }
        opener.bracketNode.unlink()
        removeLastBracket()

        // Links within links are not allowed. We found this link, so there can be no other link around it.
        if (opener.markerNode.isNone()) {
            var bracket = lastBracket
            while (let Some(_bracket) <- bracket) {
                if (_bracket.markerNode.isNone()) {
                    // Disallow link opener. It will still get matched, but will not result in a link.
                    _bracket.allowed = false
                }
                bracket = _bracket.previous
            }
        }

        return wrapperNode
    }

    private func replaceBracket(opener: Bracket, node: Node, includeMarker: Bool): Node {
        // Remove delimiters (but keep text nodes)
        while (lastDelimiter.isSome() && lastDelimiter != opener.previousDelimiter) {
            removeDelimiterKeepNode(lastDelimiter.getOrThrow())
        }

        if (includeSourceSpans) {
            var startPosition = if (includeMarker && opener.markerPosition.isSome()) {
                opener.markerPosition
            } else {
                opener.bracketPosition
            }
            node.setSourceSpans(scanner.getSource(startPosition.getOrThrow(), scanner.position()).getSourceSpans())
        }

        removeLastBracket()

        // Remove nodes that we added since the opener, because we're replacing them
        var n: ?Node = if (includeMarker && opener.markerNode.isSome()) {
            opener.markerNode ?? None
        } else {
            opener.bracketNode
        }
        while (let Some(_n) <- n) {
            var next = _n.getNext()
            _n.unlink()
            n = next
        }
        return node
    }

    private func addBracket(bracket: Bracket): Unit {
        if (let Some(lastBracket) <- lastBracket) {
            lastBracket.bracketAfter = true
        }
        lastBracket = bracket
    }

    private func removeLastBracket(): Unit {
        lastBracket = lastBracket?.previous ?? None
    }

    /**
     * Try to parse the destination and an optional title for an inline link/image.
     */
    private static func parseInlineDestinationTitle(scanner: Scanner): ?DestinationTitle {
        if (!scanner.next('(')) {
            return None
        }

        scanner.whitespace()
        let dest = parseLinkDestination(scanner) ?? return None

        var title: ?String = None
        let whitespace: Int = scanner.whitespace()
        // title needs a whitespace before
        if (whitespace >= 1) {
            title = parseLinkTitle(scanner)
            scanner.whitespace()
        }
        if (!scanner.next(')')) {
            // Don't have a closing `)`, so it's not a destination and title.
            // Note that something like `[foo](` could still be valid later, `(` will just be text.
            return None
        }
        return DestinationTitle(dest, title)
    }

    /**
     * Attempt to parse link destination, returning the string or null if no match.
     */
    private static func parseLinkDestination(scanner: Scanner): ?String {
        let delimiter: Byte = scanner.peek()
        let start: SourcePosition = scanner.position()
        if (!LinkScanner.scanLinkDestination(scanner)) {
            return None
        }

        var dest: String = if (delimiter == b'<') {
            // chop off surrounding <..>:
            let rawDestination = scanner.getSource(start, scanner.position()).getContent()
            rawDestination[1..rawDestination.size - 1]
        } else {
            scanner.getSource(start, scanner.position()).getContent()
        }

        return Escaping.unescapeString(dest)
    }

    /**
     * Attempt to parse link titleStr (sans quotes), returning the string or null if no match.
     */
    private static func parseLinkTitle(scanner: Scanner): ?String {
        let start = scanner.position()
        if (!LinkScanner.scanLinkTitle(scanner)) {
            return None
        }

        // chop off ', " or parens
        let rawTitle = scanner.getSource(start, scanner.position()).getContent()
        let title = rawTitle[1..rawTitle.size - 1]
        return Escaping.unescapeString(title)
    }

    /**
     * Attempt to parse a link label, returning number of characters parsed.
     */
    static func parseLinkLabel(scanner: Scanner): ?String {
        if (!scanner.next('[')) {
            return None
        }

        let start = scanner.position()
        if (!LinkScanner.scanLinkLabelContent(scanner)) {
            return None
        }
        let end = scanner.position()

        if (!scanner.next(']')) {
            return None
        }

        let content = scanner.getSource(start, end).getContent()
        // spec: A link label can have at most 999 characters inside the square brackets.
        if (content.size > 999) {
            return None
        }

        return content
    }

    private func parseLineBreak(): Node {
        scanner.next()

        if (trailingSpaces >= 2) {
            return HardLineBreak()
        } else {
            return SoftLineBreak()
        }
    }

    /**
     * Parse the next character as plain text, and possibly more if the following characters are non-special.
     */
    private func parseText(): Node {
        let start = scanner.position()
        scanner.next()
        var c: Byte = '\0'
        while (true) {
            c = scanner.peek()
            if (c == Scanner.END || specialCharacters.get(scanner)) { /*cjlint-ignore !G.EXP.03 */
                break
            }
            scanner.next()
        }

        let source: SourceLines = scanner.getSource(start, scanner.position())
        var content = source.getContent()

        if (c == b'\n') {
            // We parsed until the end of the line. Trim any trailing spaces and remember them (for hard line breaks).
            let end = Characters.skipBackwards(b' ', content, content.size - 1, 0) + 1
            trailingSpaces = content.size - end
            content = content[..end]
        } else if (c == Scanner.END) {
            // For the last line, both tabs and spaces are trimmed for some reason (checked with commonmark.js).
            let end = Characters.skipSpaceTabBackwards(content, content.size - 1, 0) + 1
            content = content[..end]
        }

        let text = Text(content)
        text.setSourceSpans(source.getSourceSpans())
        return text
    }

    /**
     * Scan a sequence of characters with code delimiterChar, and return information about the number of delimiters
     * and whether they are positioned such that they can open and/or close emphasis or strong emphasis.
     *
     * @return information about delimiter run, or {@code null}
     */
    private func scanDelimiters(delimiterProcessor: DelimiterProcessor, delimiterChar: Rune): ?DelimiterData {
        let before = scanner.peekPreviousCodePoint()
        let start = scanner.position()

        // Quick check to see if we have enough delimiters.
        let delimiterCount = scanner.matchMultipleRune(delimiterChar)
        if (delimiterCount < delimiterProcessor.getMinLength()) {
            scanner.setPosition(start)
            return None
        }

        // We do have enough, extract a text node for each delimiter character.
        let delimiters = ArrayList<Text>()
        scanner.setPosition(start)
        var positionBefore = start
        while (scanner.nextRune(delimiterChar)) {
            delimiters.add(text(scanner.getSource(positionBefore, scanner.position())))
            positionBefore = scanner.position()
        }
        // let delimiterNodeOld = text(scanner.getSource(start, positionBefore))

        let after = scanner.peekCodePoint()

        // We could be more lazy here, in most cases we don't need to do every match case.
        let beforeIsPunctuation = before == Scanner.END_RUNE || Characters.isPunctuationCodePoint(before)
        let beforeIsWhitespace = before == Scanner.END_RUNE || Characters.isWhitespaceCodePoint(before)
        let afterIsPunctuation = after == Scanner.END_RUNE || Characters.isPunctuationCodePoint(after)
        let afterIsWhitespace = after == Scanner.END_RUNE || Characters.isWhitespaceCodePoint(after)

        let leftFlanking = !afterIsWhitespace && (!afterIsPunctuation || beforeIsWhitespace || beforeIsPunctuation)
        let rightFlanking = !beforeIsWhitespace && (!beforeIsPunctuation || afterIsWhitespace || afterIsPunctuation)
        let canOpen: Bool
        let canClose: Bool
        if (delimiterChar == r'_') {
            canOpen = leftFlanking && (!rightFlanking || beforeIsPunctuation)
            canClose = rightFlanking && (!leftFlanking || afterIsPunctuation)
        } else {
            canOpen = leftFlanking && delimiterChar == delimiterProcessor.getOpeningCharacter()
            canClose = rightFlanking && delimiterChar == delimiterProcessor.getClosingCharacter()
        }

        return DelimiterData(delimiters, canOpen, canClose)
    }

    private func processDelimiters(stackBottom: ?Delimiter): Unit {
        var openersBottom: HashMap<Rune, ?Delimiter> = HashMap<Rune, ?Delimiter>()

        // find first closer above stackBottom:
        var closerOption: ?Delimiter = lastDelimiter
        while (let Some(v) <- closerOption && v.previous != stackBottom) {
            closerOption = v.previous
        }
        // move forward, looking for closers, and handling each
        while (let Some(closer) <- closerOption) {
            let delimiterChar: Rune = closer.delimiterChar

            var delimiterProcessor: ?DelimiterProcessor = delimiterProcessors.get(delimiterChar)
            if (!closer.canClose() || delimiterProcessor.isNone()) {
                closerOption = closer.next
                continue
            }

            let openingDelimiterChar: Rune = delimiterProcessor().getOpeningCharacter()

            // Found delimiter closer. Now look back for first matching opener.
            var usedDelims: Int64 = 0
            var openerFound: Bool = false
            var potentialOpenerFound: Bool = false
            var openerOption: ?Delimiter = closer.previous
            while (let Some(opener) <- openerOption && stackBottom != opener && openersBottom.get(delimiterChar) !=
                    opener) {
                if (opener.canOpen() && opener.delimiterChar == openingDelimiterChar) {
                    potentialOpenerFound = true
                    usedDelims = delimiterProcessor().process(opener, closer)
                    if (usedDelims > 0) {
                        openerFound = true
                        break
                    }
                }
                openerOption = opener.previous
            }

            if (!openerFound) {
                if (!potentialOpenerFound) {
                    /*
                     Set lower bound for future searches for openers.
                     Only do this when we didn't even have a potential opener
                     (one that matches the character and can open).
                     If an opener was rejected because of the number of delimiters
                     (e.g. because of the "multiple of 3" rule),
                     we want to consider it next time because the number
                     of delimiters can change as we continue processing.
                     */
                    openersBottom.add(delimiterChar, closer.previous)
                    if (let Some(v) <- closerOption && !v.canOpen()) {
                        // We can remove a closer that can't be an opener,
                        // once we've seen there's no matching opener:
                        removeDelimiterKeepNode(v)
                    }
                }
                closerOption = closer.next
                continue
            }

            let opener = openerOption.getOrThrow()

            // Remove number of used delimiters nodes.
            for (_ in 0..usedDelims) {
                let delimiter = opener.characters.remove(at: opener.characters.size - 1)
                delimiter.unlink()
            }
            for (_ in 0..usedDelims) {
                let delimiter = closer.characters.remove(at: 0)
                delimiter.unlink()
            }

            removeDelimitersBetween(opener, closer)

            // No delimiter characters left to process, so we can remove delimiter and the now empty node.
            if (opener.getLength() == 0) {
                removeDelimiterAndNodes(opener)
            }

            if (closer.getLength() == 0) {
                let next = closer.next
                removeDelimiterAndNodes(closer)
                closerOption = next
            }
        }

        // remove all delimiters
        while (lastDelimiter.isSome() && lastDelimiter != stackBottom) {
            removeDelimiterKeepNode(lastDelimiter())
        }
    }

    private func removeDelimitersBetween(opener: Delimiter, closer: Delimiter): Unit {
        var delimiter: ?Delimiter = closer.previous
        while (let Some(v) <- delimiter && v != opener) { /*cjlint-ignore !G.EXP.03 */
            delimiter = v.previous
            removeDelimiterKeepNode(v)
        }
    }

    /**
     * Remove the delimiter and the corresponding text node. For used delimiters, e.g. `*` in `*foo*`.
     */
    private func removeDelimiterAndNodes(delim: Delimiter): Unit {
        removeDelimiter(delim)
    }

    /**
     * Remove the delimiter but keep the corresponding node as text. For unused delimiters such as `_` in `foo_bar`.
     */
    private func removeDelimiterKeepNode(delim: Delimiter): Unit {
        removeDelimiter(delim)
    }

    private func removeDelimiter(delim: Delimiter): Unit {
        if (let Some(prev) <- delim.previous) {
            prev.next = delim.next
        }
        if (let Some(next) <- delim.next) {
            next.previous = delim.previous
        } else {
            // top of stack
            lastDelimiter = delim.previous
        }
    }

    private func mergeChildTextNodes(node: Node): Unit {
        // No children or just one child node, no need for merging
        if (node.getFirstChild().isNone()) {
            return
        }

        mergeTextNodesInclusive(node.getFirstChild(), node.getLastChild())
    }

    private func mergeTextNodesInclusive(fromNode: ?Node, toNode: ?Node): Unit {
        var first: ?Text = None
        var last: ?Text = None
        var length: Int64 = 0

        var nodeOption: ?Node = fromNode
        while (let Some(node) <- nodeOption) {
            if (let Some(text: Text) <- nodeOption) {
                if (first.isNone()) {
                    first = text
                }
                length += text.getLiteral().size
                last = text
            } else {
                mergeIfNeeded(first, last, length)
                first = Option<Text>.None
                last = Option<Text>.None
                length = 0
                mergeChildTextNodes(node)
            }
            if (toNode == node) {
                break
            }
            nodeOption = node.getNext()
        }

        mergeIfNeeded(first, last, length)
    }

    private func mergeIfNeeded(first: ?Text, last: ?Text, textLength: Int64): Unit {
        if (let Some(first) <- first && let Some(last) <- last && first != last) { /*cjlint-ignore !G.EXP.03 */
            var sb: StringBuilder = StringBuilder(textLength)
            sb.append(first.getLiteral())
            var sourceSpans: ?SourceSpans = None
            if (includeSourceSpans) {
                sourceSpans = SourceSpans()
                sourceSpans?.addAll(first.getSourceSpans())
            }
            var node: ?Node = first.getNext()
            let stop: ?Node = last.getNext()
            while (node != stop) {
                if (let Some(v: Text) <- node) {
                    sb.append(v.getLiteral())
                    sourceSpans?.addAll(v.getSourceSpans())
                    var unlink: Node = v
                    node = v.getNext()
                    unlink.unlink()
                }
            }
            let literal: String = sb.toString()
            first.setLiteral(literal)
            if (let Some(sourceSpans) <- sourceSpans) {
                first.setSourceSpans(sourceSpans.getSourceSpans())
            }
        }
    }
}

class DelimiterData {
    let characters: ArrayList<Text>
    let canClose: Bool
    let canOpen: Bool

    init(characters: ArrayList<Text>, canOpen: Bool, canClose: Bool) {
        this.characters = characters
        this.canOpen = canOpen
        this.canClose = canClose
    }
}

/**
 * A destination and optional title for a link or image.
 */
class DestinationTitle {
    let destination: String
    let title: ?String

    public DestinationTitle(destination: String, title: ?String) {
        this.destination = destination
        this.title = title
    }
}

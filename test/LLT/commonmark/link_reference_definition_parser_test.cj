// EXEC: cjc %import-path %L %l %f --test
// EXEC: ./main

package commonmark4cj.commonmark.test

import commonmark4cj.commonmark.*
import commonmark4cj.commonmark.LinkReferenceDefinitionParser as LinkReferenceDefinitionParser0
import std.unittest.*
import std.unittest.testmacro.*

@Test
public class LinkReferenceDefinitionParserTest {
    @TestCase
    public func testStartLabel(): Unit {
        let parser: LinkReferenceDefinitionParser = LinkReferenceDefinitionParser()
        parser.parse(SourceLine.of("[", None))

        @Expect(parser.getParagraphLines().getContent(), "[")
    }

    @TestCase
    public func testStartNoLabel(): Unit {
        let parser: LinkReferenceDefinitionParser = LinkReferenceDefinitionParser()
        assertParagraph("a")
        parser.parse(SourceLine.of("a", None))
        parser.parse(SourceLine.of("[", None))
        @Expect("a\n[", parser.getParagraphLines().getContent())
    }

    @TestCase
    public func testEmptyLabel(): Unit {
        assertParagraph("[]: /")
        assertParagraph("[ ]: /")
        assertParagraph("[ \t\n\u{000B}\f\r ]: /")
    }

    @TestCase
    public func testLabelColon(): Unit {
        assertParagraph("[foo] : /")
    }

    @TestCase
    public func testLabel(): Unit {
        assertState("[foo]:", State.DESTINATION, "[foo]:")
        assertState("[ foo ]:", State.DESTINATION, "[ foo ]:")
    }

    @TestCase
    public func testLabelInvalid(): Unit {
        assertParagraph("[foo[]:")
    }

    @TestCase
    public func testLabelMultiline(): Unit {
        let parser: LinkReferenceDefinitionParser = LinkReferenceDefinitionParser()
        parser.parse(SourceLine.of("[two", None))
        parser.parse(SourceLine.of("lines]:", None))
        parser.parse(SourceLine.of("/url", None))
        assertDef(parser.getDefinitions()[0], "two\nlines", "/url", None)
    }

    @TestCase
    public func testLabelStartsWithNewline(): Unit {
        let parser: LinkReferenceDefinitionParser = LinkReferenceDefinitionParser()
        parser.parse(SourceLine.of("[", None))
        parser.parse(SourceLine.of("weird]:", None))
        parser.parse(SourceLine.of("/url", None))
        assertDef(parser.getDefinitions()[0], "\nweird", "/url", None)
    }

    @TestCase
    public func testDestination(): Unit {
        let parser: LinkReferenceDefinitionParser = LinkReferenceDefinitionParser()
        parser.parse(SourceLine.of("[foo]: /url", None))
        @Expect("", parser.getParagraphLines().getContent())

        @Expect(1, parser.getDefinitions().size)
        assertDef(parser.getDefinitions()[0], "foo", "/url", None)

        parser.parse(SourceLine.of("[bar]: </url2>", None))
        assertDef(parser.getDefinitions()[1], "bar", "/url2", None)
    }

    @TestCase
    public func testDestinationInvalid(): Unit {
        assertParagraph("[foo]: <bar<>")
    }

    @TestCase
    public func testTitle(): Unit {
        let parser: LinkReferenceDefinitionParser = LinkReferenceDefinitionParser()
        parser.parse(SourceLine.of("[foo]: /url 'title'", None))
        @Expect("", parser.getParagraphLines().getContent())

        @Expect(1, parser.getDefinitions().size)
        assertDef(parser.getDefinitions()[0], "foo", "/url", "title")
    }

    @TestCase
    public func testTitleStartWhitespace(): Unit {
        let parser: LinkReferenceDefinitionParser = LinkReferenceDefinitionParser()
        parser.parse(SourceLine.of("[foo]: /url", None))
        @Expect("", parser.getParagraphLines().getContent())

        parser.parse(SourceLine.of("   ", None))

        @Expect("   ", parser.getParagraphLines().getContent())

        @Expect(1, parser.getDefinitions().size)
        assertDef(parser.getDefinitions()[0], "foo", "/url", None)
    }

    @TestCase
    public func testTitleMultiline(): Unit {
        let parser: LinkReferenceDefinitionParser = LinkReferenceDefinitionParser()
        parser.parse(SourceLine.of("[foo]: /url 'two", None))
        @Expect("[foo]: /url 'two", parser.getParagraphLines().getContent())
        @Expect(0, parser.getDefinitions().size)

        parser.parse(SourceLine.of("lines", None))
        @Expect("[foo]: /url 'two\nlines", parser.getParagraphLines().getContent())
        @Expect(0, parser.getDefinitions().size)

        parser.parse(SourceLine.of("'", None))
        @Expect("", parser.getParagraphLines().getContent())

        @Expect(1, parser.getDefinitions().size)
        assertDef(parser.getDefinitions()[0], "foo", "/url", "two\nlines\n")
    }

    @TestCase
    public func testTitleMultiline2(): Unit {
        let parser: LinkReferenceDefinitionParser = LinkReferenceDefinitionParser()
        parser.parse(SourceLine.of("[foo]: /url '", None))
        parser.parse(SourceLine.of("title'", None))

        assertDef(parser.getDefinitions()[0], "foo", "/url", "\ntitle")
    }

    @TestCase
    public func testTitleInvalid(): Unit {
        assertParagraph("[foo]: /url (invalid(")
        assertParagraph("[foo]: </url>'title'")
        assertParagraph("[foo]: /url 'title' INVALID")
    }

    private static func assertParagraph(input: String) {
        assertState(input, State.PARAGRAPH, input)
    }

    private static func assertState(input: String, state: State, paragraphContent: String) {
        let parser: LinkReferenceDefinitionParser = LinkReferenceDefinitionParser()
        parser.parse(SourceLine.of(input, None))
        @Expect(paragraphContent, parser.getParagraphLines().getContent())
    }

    private static func assertDef(def: LinkReferenceDefinition, label: String, destination: String, title: ?String) {
        @Expect(label, def.getLabel())
        @Expect(destination, def.getDestination())
        @Expect(title, def.getTitle())
    }
}

/**
 * Parser for link reference definitions at the beginning of a paragraph.
 */
public class LinkReferenceDefinitionParser {
    private var state: State = State.START_DEFINITION

    private var paragraphLines: ArrayList<SourceLine> = ArrayList()
    private var definitions: ArrayList<LinkReferenceDefinition> = ArrayList<LinkReferenceDefinition>()
    private let sourceSpans: ArrayList<SourceSpan> = ArrayList()

    private var label: ?StringBuilder = None
    private var destination: String = ""
    private var titleDelimiter: Byte = 0
    private var title: ?StringBuilder = None
    private var referenceValid: Bool = false

    public func parse(line: SourceLine): Unit {
        paragraphLines.add(line)
        if (state == State.PARAGRAPH) {
            // We're in a paragraph now. Link reference definitions can only appear at the beginning, so once
            // we're in a paragraph, there's no going back.
            return
        }
        let scanner: Scanner = Scanner.of(SourceLines.of(line))
        var success = false
        while (scanner.hasNext()) {
            match (state) {
                case START_DEFINITION => success = startDefinition(scanner)
                case LABEL => success = labelFunc(scanner)
                case DESTINATION => success = destinationFunc(scanner)
                case START_TITLE => success = startTitle(scanner)
                case TITLE => success = titleFunc(scanner)
                case _ => throw IllegalStateException("Unknown parsing state: ${state.toString()}")
            }
            // Parsing failed, which means we fall back to treating text as a paragraph.
            if (!success) {
                state = State.PARAGRAPH
                // If parsing of the title part failed, we still have a valid reference that we can add, and we need to
                // do it before the source span for this line is added.
                finishReference()
                return
            }
        }
    }

    public func addSourceSpan(sourceSpan: SourceSpan): Unit {
        sourceSpans.add(sourceSpan)
    }
    /**
     * @return the lines that are normal paragraph content, without newlines
     */
    func getParagraphLines(): SourceLines {
        return SourceLines.of(paragraphLines)
    }

    @Frozen
    func getParagraphSourceSpans(): ArrayList<SourceSpan> {
        return sourceSpans
    }

    @Frozen
    func getDefinitions(): ArrayList<LinkReferenceDefinition> {
        finishReference()
        return definitions
    }

    public func getState(): State {
        return state
    }

    func removeLines(lines: Int): ArrayList<SourceSpan> {
        var removedSpans = sourceSpans[max(sourceSpans.size - lines, 0)..sourceSpans.size]
        removeLast(lines, paragraphLines)
        removeLast(lines, sourceSpans)
        return removedSpans
    }

    private func startDefinition(scanner: Scanner): Bool {
        // Finish any outstanding references now. We don't do this earlier because we need addSourceSpan to have been
        // called before we do it.
        finishReference()

        scanner.whitespace()
        if (!scanner.next('[')) {
            return false
        }

        state = State.LABEL
        label = StringBuilder()

        if (!scanner.hasNext()) {
            label?.append('\n')
        }
        return true
    }

    private func labelFunc(scanner: Scanner): Bool {
        let start: SourcePosition = scanner.position()
        if (!LinkScanner.scanLinkLabelContent(scanner)) {
            return false
        }

        label?.append(scanner.getSource(start, scanner.position()).getContent())

        if (!scanner.hasNext()) {
            // label might continue on next line
            label?.append('\n')
            return true
        } else if (scanner.next(']')) {
            // end of label
            if (!scanner.next(':')) {
                return false
            }

            // spec: A link label can have at most 999 characters inside the square brackets.
            if ((label?.size ?? 0) > 999) {
                return false
            }

            let normalizedLabel: String = Escaping.normalizeLabelContent(label?.toString() ?? "")
            if (normalizedLabel.isEmpty()) {
                return false
            }

            state = State.DESTINATION

            scanner.whitespace()
            return true
        } else {
            return false
        }
    }

    private func destinationFunc(scanner: Scanner): Bool {
        scanner.whitespace()
        let start: SourcePosition = scanner.position()
        if (!LinkScanner.scanLinkDestination(scanner)) {
            return false
        }

        let rawDestination: String = scanner.getSource(start, scanner.position()).getContent()
        destination = if (rawDestination.startsWith("<")) {
            rawDestination[1..rawDestination.size - 1]
        } else {
            rawDestination
        }

        let whitespace: Int = scanner.whitespace()
        if (!scanner.hasNext()) {
            // Destination was at end of line, so this is a valid reference for sure (and maybe a title).
            // If not at end of line, wait for title to be valid first.
            referenceValid = true
            paragraphLines.clear()
        } else if (whitespace == 0) {
            // spec: The title must be separated from the link destination by whitespace
            return false
        }

        state = State.START_TITLE
        return true
    }

    private func startTitle(scanner: Scanner): Bool {
        scanner.whitespace()
        if (!scanner.hasNext()) {
            state = State.START_DEFINITION
            return true
        }

        titleDelimiter = 0
        let c: Byte = scanner.peek()
        match (c) {
            case b'"' | b'\'' => titleDelimiter = c
            case b'(' => titleDelimiter = b')'
            case _ => ()
        }

        if (titleDelimiter != 0) {
            state = State.TITLE
            title = StringBuilder()
            scanner.next()
            if (!scanner.hasNext()) {
                title?.append('\n')
            }
        } else {
            // There might be another reference instead, try that for the same character.
            state = State.START_DEFINITION
        }
        return true
    }

    private func titleFunc(scanner: Scanner): Bool {
        let start: SourcePosition = scanner.position()
        if (!LinkScanner.scanLinkTitleContent(scanner, titleDelimiter)) {
            // Invalid title, stop. Title collected so far must not be used.
            title = None
            return false
        }

        title?.append(scanner.getSource(start, scanner.position()).getContent())

        if (!scanner.hasNext()) {
            // Title ran until the end of line, so continue on next line (until we find the delimiter)
            title?.append('\n')
            return true
        }

        // Skip delimiter character
        scanner.next()
        scanner.whitespace()
        if (scanner.hasNext()) {
            // spec: No further non-whitespace characters may occur on the line.
            // Title collected so far must not be used.
            title = None
            return false
        }
        referenceValid = true
        paragraphLines.clear()

        // See if there's another definition.
        state = State.START_DEFINITION
        return true
    }

    private func finishReference(): Unit {
        if (!referenceValid) {
            return
        }

        var d: String = Escaping.unescapeString(destination)
        let t: ?String = if (let Some(title) <- title) {
            Escaping.unescapeString(title.toString())
        } else {
            None
        }
        let definition = LinkReferenceDefinition(label.getOrThrow().toString(), d, t)
        definition.setSourceSpans(sourceSpans)
        sourceSpans.clear()
        definitions.add(definition)

        label = None
        referenceValid = false
        destination = ""
        title = None
    }

    private static func removeLast<T>(n: Int, list: ArrayList<T>): Unit {
        if (n >= list.size) {
            list.clear()
        } else {
            list.remove(list.size - n..list.size)
        }
    }
}

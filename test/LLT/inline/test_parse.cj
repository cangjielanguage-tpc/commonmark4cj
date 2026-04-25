// 3rd_party_lib:commonmark4cj/build/release/commonmark4cj
// 3rd_party_lib_ohos:commonmark4cj/build/aarch64-linux-ohos/commonmark4cj
// RESOURCES: spec.txt

import commonmark4cj.commonmark.*
import commonmark4cj.table.*
import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import std.collection.*
import std.reflect.{TypeInfo}
import std.unicode.*
import std.fs.*

@Test
public class TestParser {
    @TestCase
    func test_parser_builder(): Unit {
        var headersOnly: HashSet<NodeType> = HashSet<NodeType>()
        headersOnly.add("Heading")
        var parserBuilder: ParserBuilder = Parser.builder().inlineParserFactory(InlineParserV2Factory())
        parserBuilder.enabledBlockTypes(headersOnly)
        @Assert(parserBuilder.getEnabledBlockTypes().size, 1)

        var parserBuilder2: ParserBuilder = Parser.builder().inlineParserFactory(InlineParserV2Factory())
        @Assert(parserBuilder2.getEnabledBlockTypes().size, 7)

        var headersOnly2: HashSet<NodeType> = HashSet<NodeType>()
        var parserBuilder3: ParserBuilder = Parser.builder().inlineParserFactory(InlineParserV2Factory())
        parserBuilder3.enabledBlockTypes(headersOnly2)
        @Assert(parserBuilder3.getEnabledBlockTypes().size, 0)
    }

    @TestCase
    func test_parser_parse(): Unit {
        let given: String = "# heading 1\n\nnot a heading"
        let given2: String = ""
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        var document2: Node = parser.parse(given2)

        @Assert(document2.getFirstChild().isNone(), true)
        @Assert(document.getFirstChild().getOrThrow().toString(), "Heading{}")
    }
}

@Test
public class TestParserBuilder {
    @TestCase
    func test_parser_builder(): Unit {
        let source = "Abc|Def"
        let source2 = ""
        let tt: TablesTest = TablesTest()
        let renderedContent: String = tt.render(source)
        let renderedContent2: String = tt.render(source2)

        @Assert(renderedContent, "<p>Abc|Def</p>\n")
        @Assert(renderedContent2, "")
    }

    @TestCase
    func test_parser_extensions(): Unit {
        let source = "Abc|Def\n-|-"
        let tablesTest: TablesTest = TablesTest()
        let tablesTest_noExtension: TablesTest_noExtension = TablesTest_noExtension()
        let renderedContent: String = tablesTest.render(source)
        let renderedContent2: String = tablesTest_noExtension.render(source)

        @Assert(renderedContent, "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th>Abc</th>\n" +
                "<th>Def</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "</table>\n")
        @Assert(renderedContent2, "<p>Abc|Def\n-|-</p>\n")
    }

    @TestCase
    func test_parser_extensions2(): Unit {
        let source = "Abc|Def\n-|-"
        let tablesTest: TablesTest = TablesTest()
        let tablesTest_noExtension2: TablesTest_noExtension2 = TablesTest_noExtension2()
        let renderedContent: String = tablesTest.render(source)
        let renderedContent2: String = tablesTest_noExtension2.render(source)

        @Assert(renderedContent, "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th>Abc</th>\n" +
                "<th>Def</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "</table>\n")
        @Assert(renderedContent2, "<p>Abc|Def\n-|-</p>\n")
    }

    @TestCase
    func test_parser_customBlockParserFactory(): Unit {
        let parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).customBlockParserFactory(DashBlockParserFactory()).build()

        let document: Node = parser.parse("hey\n\n---\n")

        @Assert("Paragraph{}", document.getFirstChild().getOrThrow().toString())
        @Assert("hey", (document.getFirstChild().getOrThrow().getFirstChild().getOrThrow() as Text).getOrThrow().getLiteral())
        @Assert("DashBlock{}", document.getLastChild().getOrThrow().toString())
    }

    @TestCase
    func test_parser_customDelimiterProcessor(): Unit {
        let input = "+one+ ++two++"
        var s = defaultRenderer().render(parse(input))
        @Assert("<p>+one+ ++two++</p>\n", s)

        let oneDelimiterProcessor: OneDelimiterProcessor = OneDelimiterProcessor()
        let parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).customDelimiterProcessor(oneDelimiterProcessor).build()
        var ss = defaultRenderer().render(parser.parse(input))
        @Assert("<p>(1)one(/1) (1)(1)two(/1)(/1)</p>\n", ss)

        var sss = defaultRenderer().render(parser.parse(""))
        @Assert("", sss)

        var ssss = defaultRenderer().render(parser.parse("\n"))
        @Assert("", ssss)

        @Assert(r'+', oneDelimiterProcessor.getOpeningCharacter())
        @Assert(r'+', oneDelimiterProcessor.getClosingCharacter())
        @Assert(1, oneDelimiterProcessor.getMinLength())
    }

    @TestCase
    public func test_parser_inlineParserFactory(): Unit {
        var builder: ParserBuilder = Parser.builder().inlineParserFactory(InlineParserV2Factory())
        let parser: Parser = builder.inlineParserFactory(fakeInlineParserFactory()).build()
        let input: String = "**bold** **bold** ~~strikethrough~~"

        @Assert(parser.parse(input).getFirstChild().getOrThrow().getFirstChild().getOrThrow().toString(), "ThematicBreak{}")
        @Assert(true, builder.getInlineParserFactory() is fakeInlineParserFactory)

        var builder2: ParserBuilder = Parser.builder().inlineParserFactory(InlineParserV2Factory())

        @Assert(false, builder2.getInlineParserFactory() is fakeInlineParserFactory)
    }
}

class fakeInlineParser <: InlineParser {
    public override func parse(_: String, node: Node): Unit {
        node.appendChild(ThematicBreak())
    }
}

class fakeInlineParserFactory <: InlineParserFactory {
    public override func create(_: InlineParserContext): InlineParser {
        return fakeInlineParser()
    }
}

func defaultRenderer(): HtmlRenderer {
    return HtmlRenderer.builder().build()
}

func parse(source: String): Node {
    return Parser.builder().inlineParserFactory(InlineParserV2Factory()).build().parse(source)
}

class OneDelimiterProcessor <: DelimiterProcessor {
    public override func getOpeningCharacter(): Rune {
        return r'+'
    }

    public override func getClosingCharacter(): Rune {
        return r'+'
    }

    public override func getMinLength(): Int64 {
        return 1
    }

    public override func getDelimiterUse(_: DelimiterRun, _: DelimiterRun): Int64 {
        return 1
    }

    public override func process(opener: Text, closer: Text, _: Int64): Unit {
        opener.insertAfter(Text("(1)"))
        closer.insertBefore(Text("(/1)"))
    }
}

class DashBlockParserFactory <: AbstractBlockParserFactory {
    public override func tryStart(state: ParserState, _: MatchedBlockParser): ?BlockStart {
        if (state.getLine() == ("---")) {
            return BlockStart.of4Cj(DashBlockParser())
        }
        return BlockStart.none()
    }
}

class DashBlockParser <: AbstractBlockParser {
    private var dash: DashBlock = DashBlock()

    public override func getBlock(): Block {
        return dash
    }

    public override func tryContinue(_: ParserState): ?BlockContinue {
        return BlockContinue.none()
    }
}

class DashBlock <: CustomBlock {public func getNodeType():NodeType{"DashBlock"}}

class TablesTest {
    private static let EXTENSIONS: Array<Extension> = [TablesExtension.create()]
    private static let PARSER: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).extensions(EXTENSIONS).build()
    private static let RENDERER: HtmlRenderer = HtmlRenderer.builder().extensions(EXTENSIONS).build()

    public func render(source: String): String {
        return RENDERER.render(PARSER.parse(source))
    }
}

class TablesTest_noExtension {
    private static let EXTENSIONS: Array<Extension> = []
    private static let PARSER: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).extensions(EXTENSIONS).build()
    private static let RENDERER: HtmlRenderer = HtmlRenderer.builder().extensions(EXTENSIONS).build()

    public func render(source: String): String {
        return RENDERER.render(PARSER.parse(source))
    }
}

class TablesTest_noExtension2 {
    private static let EXTENSIONS: Array<Extension> = [TablesExtension.create()]
    private static let PARSER: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
    private static let RENDERER: HtmlRenderer = HtmlRenderer.builder().extensions(EXTENSIONS).build()

    public func render(source: String): String {
        return RENDERER.render(PARSER.parse(source))
    }
}


// 3rd_party_lib:commonmark4cj/build/release/commonmark4cj
// 3rd_party_lib_ohos:commonmark4cj/build/aarch64-linux-ohos/commonmark4cj
// dependence: z_test.cj

import commonmark4cj.commonmark.*
import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import std.unicode.*
import std.fs.*
import std.io.*
import std.reflect.{TypeInfo}
// sources_file: spec.txt  

@Test
public class ParserTest {
    @TestCase
    public func ioReaderTest(): Unit {
        let parser: Parser = Parser.builder().build()
        var document1: Node
        let input1 = File("spec.txt", Read)
        // let render: StringReader<InputStream> = StringReader(input1)
        document1 = parser.parseReader(input1)
        let spec: String = String.fromUtf8(File.readFrom("spec.txt"))
        let document2: Node = parser.parse(spec)
        let renderer: HtmlRenderer = HtmlRenderer.builder().escapeHtml(true).build()
        assertEquals(renderer.render(document2), renderer.render(document1))
    }

    @TestCase
    public func customBlockParserFactory(): Unit {
        let parser: Parser = Parser.builder().customBlockParserFactory(DashBlockParserFactory()).build()
        let document: Node = parser.parse("hey\n\n---\n")
        assertEquals("Paragraph{}", document.getFirstChild()().toString())
        assertEquals("hey", (document.getFirstChild()().getFirstChild()() as Text)().getLiteral())
        assertEquals("DashBlock{}", document.getLastChild()().toString())
    }

    @TestCase
    public func enabledBlockTypes(): Unit {
        let given: String = "# heading 1\n\nnot a heading"
        var parser: Parser = Parser.builder().build()
        var document: Node = parser.parse(given)
        assertEquals("Heading{}", document.getFirstChild()().toString())
        var headersOnly: HashSet<NodeType> = HashSet<NodeType>()
        headersOnly.add("Heading")
        parser = Parser.builder().enabledBlockTypes(headersOnly).build()
        document = parser.parse(given)
        assertEquals("Heading{}", document.getFirstChild()().toString())
        var noCoreTypes: HashSet<NodeType> = HashSet<NodeType>()
        parser = Parser.builder().enabledBlockTypes(noCoreTypes).build()
        document = parser.parse(given)
        assertNotEquals("Heading{}", document.getFirstChild()().toString())
    }

    @TestCase
    public func indentation(): Unit {
        let given: String = " - 1 space\n   - 3 spaces\n     - 5 spaces\n\t - tab + space"
        let parser: Parser = Parser.builder().build()
        let document: Node = parser.parse(given)
        assertEquals("BulletList{}", document.getFirstChild()().toString())
        var list: Node = document.getFirstChild()()
        assertEquals("expect one child", list.getFirstChild()(), list.getLastChild()())
        assertEquals("1 space", firstText(list.getFirstChild()()))
        list = list.getFirstChild()().getLastChild()()
        assertEquals("expect one child", list.getFirstChild(), list.getLastChild())
        assertEquals("3 spaces", firstText(list.getFirstChild()()))
        list = list.getFirstChild()().getLastChild()()
        assertEquals("5 spaces", firstText(list.getFirstChild()()))
        assertEquals("tab + space", firstText(list.getFirstChild()().getNext()()))
    }

    @TestCase
    public func inlineParser(): Unit {
        let parser: Parser = Parser.builder().inlineParserFactory(fakeInlineParserFactory()).build()
        let input: String = "**bold** **bold** ~~strikethrough~~"
        assertEquals(parser.parse(input).getFirstChild()().getFirstChild()().toString(), "ThematicBreak{}")
    }
}

class DashBlock <: CustomBlock {public func getNodeType():NodeType{"DashBlock"}}

class DashBlockParser <: AbstractBlockParser {
    private var dash: DashBlock = DashBlock()

    public override func getBlock(): Block {
        return dash
    }

    public override func tryContinue(_: ParserState): ?BlockContinue {
        return BlockContinue.none()
    }
}

class DashBlockParserFactory <: AbstractBlockParserFactory {
    public override func tryStart(state: ParserState, _: MatchedBlockParser): ?BlockStart {
        if (state.getLine().getContent() == ("---")) {
            return BlockStart.of(DashBlockParser())
        }
        return BlockStart.none()
    }
}

func firstText(n: Node): String {
    var n1 = n
    while (!(n1 is Text)) {
        n1 = n1.getFirstChild()()
    }
    return (n1 as Text)().getLiteral()
}

class fakeInlineParser <: InlineParser {
    public func parse(lines: SourceLines, node: Node): Unit{
        node.appendChild(ThematicBreak())
    }
}

class fakeInlineParserFactory <: InlineParserFactory {
    public override func create(_: InlineParserContext): InlineParser {
        return fakeInlineParser()
    }
}

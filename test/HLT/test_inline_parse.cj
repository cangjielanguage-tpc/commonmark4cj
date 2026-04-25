// 3rd_party_lib:commonmark4cj/build/release/commonmark4cj
// 3rd_party_lib_ohos:commonmark4cj/build/aarch64-linux-ohos/commonmark4cj

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
public class TestInlinekParser {
    @TestCase
    func test_inline_parser(): Unit {
        var emphasisDelimiterProcessor: EmphasisDelimiterProcessor2 = EmphasisDelimiterProcessor2()
        @Assert(r'-', emphasisDelimiterProcessor.getOpeningCharacter())
        @Assert(r'-', emphasisDelimiterProcessor.getClosingCharacter())
        @Assert(1, emphasisDelimiterProcessor.getMinLength())
    }

    @TestCase
    func test_inline_parser2(): Unit {
        var emphasisDelimiterProcessor: EmphasisDelimiterProcessor3 = EmphasisDelimiterProcessor3()
        @Assert(r' ', emphasisDelimiterProcessor.getOpeningCharacter())
        @Assert(r' ', emphasisDelimiterProcessor.getClosingCharacter())
        @Assert(1, emphasisDelimiterProcessor.getMinLength())
    }

    @TestCase
    func test_inline_parser3(): Unit {
        var emphasisDelimiterProcessor: EmphasisDelimiterProcessor4 = EmphasisDelimiterProcessor4()
        @Assert(r'1', emphasisDelimiterProcessor.getOpeningCharacter())
        @Assert(r'1', emphasisDelimiterProcessor.getClosingCharacter())
        @Assert(1, emphasisDelimiterProcessor.getMinLength())
    }

    @TestCase
    public func test_inline_parser_inlineParser(): Unit {
        let parser: Parser = Parser.builder().inlineParserFactory(fakeInlineParserFactory()).build()
        let input: String = "**bold** **bold** ~~strikethrough~~"
        @Assert(parser.parse(input).getFirstChild().getOrThrow().getFirstChild().getOrThrow().toString(), "Text{literal=text}")
    }
}

class InlineParserImpl2 <: InlineParser {
    public func parse(lines: SourceLines, node: Node): Unit{
        node.appendChild(Text("text"))
    }
}

class fakeInlineParserFactory <: InlineParserFactory {
    public override func create(_: InlineParserContext): InlineParser {
        return InlineParserImpl2()
    }
}

class EmphasisDelimiterProcessor2 <: EmphasisDelimiterProcessor {
    public init() {
        super(r'-')
    }
}

class EmphasisDelimiterProcessor3 <: EmphasisDelimiterProcessor {
    public init() {
        super(r' ')
    }
}

class EmphasisDelimiterProcessor4 <: EmphasisDelimiterProcessor {
    public init() {
        super(r'1')
    }
}

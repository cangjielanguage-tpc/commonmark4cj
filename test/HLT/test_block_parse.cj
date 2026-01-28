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
public class TestBlockParser{
    @TestCase
    func test_block_parser():Unit {
        var dashBlockParser: DashBlockParser = DashBlockParser("dashInfo")
        @Assert(false, dashBlockParser.isContainer())
        @Assert(false, dashBlockParser.canHaveLazyContinuationLines())
        @Assert(false, dashBlockParser.canContain(HtmlBlock()))
        var dash: Block = dashBlockParser.getBlock()
        @Assert(true, dash is DashBlock)
        @Assert("dashInfo", (dash as DashBlock).getOrThrow().getInfo())
        dashBlockParser.addLine("dash")
        @Assert("dash", dashBlockParser.getLine())
        dashBlockParser.closeBlock()
        dashBlockParser.getBlock()
        @Assert("close", (dash as DashBlock).getOrThrow().getInfo())
    }

    @TestCase
    func test_block_parser2():Unit {
        var dashBlockParser: DashBlockParser = DashBlockParser("")
        @Assert(false, dashBlockParser.isContainer())
        @Assert(false, dashBlockParser.canHaveLazyContinuationLines())
        @Assert(false, dashBlockParser.canContain(HtmlBlock()))
        var dash: Block = dashBlockParser.getBlock()
        @Assert(true, dash is DashBlock)
        @Assert("", (dash as DashBlock).getOrThrow().getInfo())
        dashBlockParser.addLine("dash")
        @Assert("dash", dashBlockParser.getLine())
        dashBlockParser.closeBlock()
        dashBlockParser.getBlock()
        @Assert("close", (dash as DashBlock).getOrThrow().getInfo())
    }

    @TestCase
    func test_block_parser_BlockContinue():Unit {
        var BlockContinueImpl2: BlockContinueImpl2 = BlockContinueImpl2(1, 1, true)
        @Assert(1, BlockContinueImpl2.getNewIndex())
        @Assert(1, BlockContinueImpl2.getNewColumn())
        @Assert(true, BlockContinueImpl2.isFinalize())
    }

    @TestCase
    func test_block_parser_BlockContinue2():Unit {
        var BlockContinueImpl2: BlockContinueImpl2 = BlockContinueImpl2(-1, -1, false)
        @Assert(-1, BlockContinueImpl2.getNewIndex())
        @Assert(-1, BlockContinueImpl2.getNewColumn())
        @Assert(false, BlockContinueImpl2.isFinalize())
    }

    @TestCase
    func test_block_parser_BlockStart():Unit {
        let arr: Array<AbstractBlockParser> = [DashBlockParser("dashInfo")]
        var blockStartImpl2: BlockStartImpl2 = BlockStartImpl2(arr)
        @Assert(-1, blockStartImpl2.getNewIndex())
        @Assert(-1, blockStartImpl2.getNewColumn())
        @Assert(false, blockStartImpl2.isReplaceActiveBlockParser())
    }

    @TestCase
    func test_block_parser_BlockStart2():Unit {
        let arr: Array<AbstractBlockParser> = [DashBlockParser("dashInfo")]
        var blockStartImpl2: BlockStartImpl2 = BlockStartImpl2(arr)
        var blockStart = blockStartImpl2.atIndex(1)
        @Assert(1, (blockStart as BlockStartImpl2).getOrThrow().getNewIndex())
        var blockStart2 = blockStart.atColumn(2)
        @Assert(2, (blockStart2 as BlockStartImpl2).getOrThrow().getNewColumn())
        var blockStart3 = blockStart2.replaceActiveBlockParser()
        @Assert(true, (blockStart3 as BlockStartImpl2).getOrThrow().isReplaceActiveBlockParser())
    }

    @TestCase
    func test_block_parser_BlockStart3():Unit {
        let arr: Array<AbstractBlockParser> = [DashBlockParser("dashInfo")]
        var blockStartImpl2: BlockStartImpl2 = BlockStartImpl2(arr)
        var dashBlockParser: DashBlockParser = (blockStartImpl2.getBlockParsers()[0] as DashBlockParser).getOrThrow()
        @Assert(false, dashBlockParser.isContainer())
        @Assert(false, dashBlockParser.canHaveLazyContinuationLines())
        @Assert(false, dashBlockParser.canContain(HtmlBlock()))
        var dash: Block = dashBlockParser.getBlock()
        @Assert(true, dash is DashBlock)
        @Assert("dashInfo", (dash as DashBlock).getOrThrow().getInfo())
    }

    @TestCase
    func test_block_parser_MatchedBlockParser():Unit {
        var matchedBlockParserImpl: MatchedBlockParserImpl2 = MatchedBlockParserImpl2(ParagraphParser("ParagraphParser"))
        @Assert("ParagraphParser", matchedBlockParserImpl.getParagraphContent())
        var paragraphParser: ParagraphParser = (matchedBlockParserImpl.getMatchedBlockParser() as ParagraphParser).getOrThrow()
        @Assert("ParagraphParser", paragraphParser.getContentString())

    }

    @TestCase
    func test_block_parser_MatchedBlockParser2():Unit {
        var matchedBlockParserImpl: MatchedBlockParserImpl2 = MatchedBlockParserImpl2(ParagraphParser(""))
        @Assert(true, matchedBlockParserImpl.getParagraphContent().isNone())
        var paragraphParser: ParagraphParser = (matchedBlockParserImpl.getMatchedBlockParser() as ParagraphParser).getOrThrow()
        @Assert("", paragraphParser.getContentString())

    }

    @TestCase
    func test_block_parser_MatchedBlockParser3():Unit {
        var matchedBlockParserImpl: MatchedBlockParserImpl2 = MatchedBlockParserImpl2(ParagraphParser(" "))
        @Assert(false, matchedBlockParserImpl.getParagraphContent().isNone())
        @Assert(" ", matchedBlockParserImpl.getParagraphContent())
        var paragraphParser: ParagraphParser = (matchedBlockParserImpl.getMatchedBlockParser() as ParagraphParser).getOrThrow()
        @Assert(" ", paragraphParser.getContentString())

    }
}

class MatchedBlockParserImpl2 <: MatchedBlockParser {
    private var matchedBlockParser: AbstractBlockParser

    public init(matchedBlockParser: AbstractBlockParser) {
        this.matchedBlockParser = matchedBlockParser
    }

    public func getMatchedBlockParser(): AbstractBlockParser {
        return matchedBlockParser
    }

    public func getParagraphContent(): ?String {
        if (matchedBlockParser is ParagraphParser) {
            var paragraphParser: ParagraphParser = (matchedBlockParser as ParagraphParser).getOrThrow()
            var content: String = paragraphParser.getContentString()
            if (content.size == 0) {
                return None
            }
            return content
        }
        return None
    }
    public func getParagraphLines(): SourceLines {throw Exception()}
}

class BlockStartImpl2 <: BlockStart {
    private var blockParsers: Array<AbstractBlockParser>
    private var newIndex: Int64 = -1
    private var newColumn: Int64 = -1
    private var replaceActiveBlockParserFlg: Bool = false

    public init(blockParsers: Array<AbstractBlockParser>) {
        this.blockParsers = blockParsers
    }

    public func getBlockParsers(): Array<AbstractBlockParser> {
        return blockParsers
    }

    public func getNewIndex(): Int64 {
        return newIndex
    }

    public func getNewColumn(): Int64 {
        return newColumn
    }

    public func isReplaceActiveBlockParser(): Bool {
        return replaceActiveBlockParserFlg
    }

    public func atIndex(newIndex: Int64): BlockStart {
        this.newIndex = newIndex
        return this
    }

    public func atColumn(newColumn: Int64): BlockStart {
        this.newColumn = newColumn
        return this
    }

    public func replaceActiveBlockParser(): BlockStart {
        this.replaceActiveBlockParserFlg = true
        return this
    }
    public func replaceParagraphLines(lines: Int): BlockStart{throw Exception()}
}

class BlockContinueImpl2 <: BlockContinue {
    private var newIndex: Int64
    private var newColumn: Int64
    private var finalize: Bool

    public init(newIndex: Int64, newColumn: Int64, finalize: Bool) {
        this.newIndex = newIndex
        this.newColumn = newColumn
        this.finalize = finalize
    }

    public func getNewIndex(): Int64 {
        return newIndex
    }

    public func getNewColumn(): Int64 {
        return newColumn
    }

    public func isFinalize(): Bool {
        return finalize
    }
}

class DashBlock <: CustomBlock {
    private var info: String = ""

    public func getInfo(): String {
        return info
    }

    public func setInfo(info: String): Unit {
        this.info = info
    }

    public func getNodeType():NodeType{"DashBlock"}
}

class ParagraphParser <: AbstractBlockParser {

    var contentString: String = ""

    public init(info: String) {
        contentString = info
    }

    public func getContentString(): String {
        return contentString
    }

    public override func getBlock(): Block {
        return Paragraph()
    }

    public override func tryContinue(_: ParserState): ?BlockContinue {
        return BlockContinue.none()
    }
}

class DashBlockParser <: AbstractBlockParser {

    private var firstLine: ?String = None

    private var dash: DashBlock = DashBlock()

    public init(){}

    public init(info: String) {
        dash.setInfo(info)
    }

    public override func getBlock(): Block {
        return dash
    }

    public func addLine(line: SourceLine): Unit {
        addLine(line.getContent())
    }
    public func addLine(line: String): Unit {
        firstLine = line
    }

    public func getLine(): String {
        return firstLine.getOrThrow()
    }

    public func closeBlock(): Unit {
        // first line becomes info string
        dash.setInfo("close")
    }

    public override func tryContinue(_: ParserState): ?BlockContinue {
        return BlockContinue.none()
    }
}
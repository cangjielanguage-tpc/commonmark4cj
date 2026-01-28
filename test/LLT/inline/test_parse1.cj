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

    @Skip //和对标库不一致  【功能】中文逗号等特殊符号正则匹配失败
    @TestCase
    func test_parser_parse(): Unit {
        let given: String = "oh my god！何其高竣，何*其峭险！蜀道太难走*呵，_123简直难于上青_天；_传说中蚕丛和鱼凫建立了_ 蜀国，开国的年代实在久远无法详谈"
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        let renderer: HtmlRenderer = HtmlRenderer.builder().escapeHtml(true).build()
        @Assert(renderer.render(document),"<p>oh my god！何其高竣，何<em>其峭险！蜀道太难走</em>呵，_123简直难于上青_天；<em>传说中蚕丛和鱼凫建立了</em> 蜀国，开国的年代实在久远无法详谈</p>")
    }

    @TestCase
    func test_parser_parse1(): Unit {
        let given: String = "oh"
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        let renderer: HtmlRenderer = HtmlRenderer.builder().escapeHtml(true).build()
        @Assert(renderer.render(document),"<p>oh</p>\n")
    }


    @TestCase
    func test_parser_parse2(): Unit {
        let given: String = "123"
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        let renderer: HtmlRenderer = HtmlRenderer.builder().escapeHtml(true).build()
        @Assert(renderer.render(document),"<p>123</p>\n")
    }

    @TestCase
    func test_parser_parse4(): Unit {
        let given: String = "倉頡"
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        let renderer: HtmlRenderer = HtmlRenderer.builder().escapeHtml(true).build()
        @Assert(renderer.render(document),"<p>倉頡</p>\n")
    }


    @TestCase
    func test_parser_parse5(): Unit {
        let given: String = "倉頡◆☆ʊə③əʊП┳卐？＠"
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        let renderer: HtmlRenderer = HtmlRenderer.builder().escapeHtml(true).build()
        @Assert(renderer.render(document),"<p>倉頡◆☆ʊə③əʊП┳卐？＠</p>\n")
    }

    @TestCase
    func test_parser_parse6(): Unit {
        let given: String = ""
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        let renderer: HtmlRenderer = HtmlRenderer.builder().escapeHtml(true).build()
        @Assert(renderer.render(document),"")
    }


    @TestCase
    func test_parser_parse7(): Unit {
        let given: String = "倉頡cangjie◆☆ʊə③əʊП┳卐？＠123"
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        let renderer: HtmlRenderer = HtmlRenderer.builder().escapeHtml(true).build()
        @Assert(renderer.render(document),"<p>倉頡cangjie◆☆ʊə③əʊП┳卐？＠123</p>\n")
    }


    @TestCase
    func test_parser_parse8(): Unit {
        let given: String = "oh"
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        let renderer: HtmlRenderer = HtmlRenderer.builder().escapeHtml(false).build()
        @Assert(renderer.render(document),"<p>oh</p>\n")
    }


    @TestCase
    func test_parser_parse9(): Unit {
        let given: String = "123"
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        let renderer: HtmlRenderer = HtmlRenderer.builder().escapeHtml(false).build()
        @Assert(renderer.render(document),"<p>123</p>\n")
    }

    @TestCase
    func test_parser_parse10(): Unit {
        let given: String = "倉頡"
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        let renderer: HtmlRenderer = HtmlRenderer.builder().escapeHtml(false).build()
        @Assert(renderer.render(document),"<p>倉頡</p>\n")
    }


    @TestCase
    func test_parser_parse11(): Unit {
        let given: String = "倉頡◆☆ʊə③əʊП┳卐？＠"
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        let renderer: HtmlRenderer = HtmlRenderer.builder().escapeHtml(false).build()
        @Assert(renderer.render(document),"<p>倉頡◆☆ʊə③əʊП┳卐？＠</p>\n")
    }

    @TestCase
    func test_parser_parse12(): Unit {
        let given: String = ""
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        let renderer: HtmlRenderer = HtmlRenderer.builder().escapeHtml(false).build()
        @Assert(renderer.render(document),"")
    }


    @TestCase
    func test_parser_parse13(): Unit {
        let given: String = "倉頡cangjie◆☆ʊə③əʊП┳卐？＠123"
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        let renderer: HtmlRenderer = HtmlRenderer.builder().escapeHtml(false).build()
        @Assert(renderer.render(document),"<p>倉頡cangjie◆☆ʊə③əʊП┳卐？＠123</p>\n")
    }


    @TestCase
    func test_parser_parse14(): Unit {
        let given: String = "倉頡\ncangjie◆☆ʊə③əʊП┳卐？＠123"
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        let renderer: HtmlRenderer = HtmlRenderer.builder().escapeHtml(false).build()
        @Assert(renderer.render(document),"<p>倉頡\ncangjie◆☆ʊə③əʊП┳卐？＠123</p>\n")
    }

    @TestCase
    func test_parser_parse15(): Unit {
        let given: String = "倉頡\ncangjie◆☆ʊə③əʊП┳卐？＠123"
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        let renderer: HtmlRenderer = HtmlRenderer.builder().escapeHtml(true).build()
        @Assert(renderer.render(document),"<p>倉頡\ncangjie◆☆ʊə③əʊП┳卐？＠123</p>\n")
    }


    @TestCase
    func test_parser_parse16(): Unit {
        let given: String = "oh"
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        let renderer: HtmlRenderer = HtmlRenderer.builder().percentEncodeUrls(false).build()
        @Assert(renderer.render(document),"<p>oh</p>\n")
    }


    @TestCase
    func test_parser_parse17(): Unit {
        let given: String = "123"
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        let renderer: HtmlRenderer = HtmlRenderer.builder().percentEncodeUrls(false).build()
        @Assert(renderer.render(document),"<p>123</p>\n")
    }

    @TestCase
    func test_parser_parse18(): Unit {
        let given: String = "倉頡"
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        let renderer: HtmlRenderer = HtmlRenderer.builder().percentEncodeUrls(false).build()
        @Assert(renderer.render(document),"<p>倉頡</p>\n")
    }


    @TestCase
    func test_parser_parse19(): Unit {
        let given: String = "倉頡◆☆ʊə③əʊП┳卐？＠"
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        let renderer: HtmlRenderer = HtmlRenderer.builder().percentEncodeUrls(false).build()
        @Assert(renderer.render(document),"<p>倉頡◆☆ʊə③əʊП┳卐？＠</p>\n")
    }

    @TestCase
    func test_parser_parse20(): Unit {
        let given: String = ""
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        let renderer: HtmlRenderer = HtmlRenderer.builder().percentEncodeUrls(false).build()
        @Assert(renderer.render(document),"")
    }


    @TestCase
    func test_parser_parse21(): Unit {
        let given: String = "倉頡cangjie◆☆ʊə③əʊП┳卐？＠123"
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        let renderer: HtmlRenderer = HtmlRenderer.builder().percentEncodeUrls(false).build()
        @Assert(renderer.render(document),"<p>倉頡cangjie◆☆ʊə③əʊП┳卐？＠123</p>\n")
    }


    @TestCase
    func test_parser_parse22(): Unit {
        let given: String = "倉頡\ncangjie◆☆ʊə③əʊП┳卐？＠123"
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        let renderer: HtmlRenderer = HtmlRenderer.builder().percentEncodeUrls(false).build()
        @Assert(renderer.render(document),"<p>倉頡\ncangjie◆☆ʊə③əʊП┳卐？＠123</p>\n")
    }


    
    @TestCase
    func test_parser_parse23(): Unit {
        let given: String = "oh"
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        let renderer: HtmlRenderer = HtmlRenderer.builder().percentEncodeUrls(true).build()
        @Assert(renderer.render(document),"<p>oh</p>\n")
    }


    @TestCase
    func test_parser_parse24(): Unit {
        let given: String = "123"
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        let renderer: HtmlRenderer = HtmlRenderer.builder().percentEncodeUrls(true).build()
        @Assert(renderer.render(document),"<p>123</p>\n")
    }

    @TestCase
    func test_parser_parse25(): Unit {
        let given: String = "倉頡"
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        let renderer: HtmlRenderer = HtmlRenderer.builder().percentEncodeUrls(true).build()
        @Assert(renderer.render(document),"<p>倉頡</p>\n")
    }


    @TestCase
    func test_parser_parse26(): Unit {
        let given: String = "倉頡◆☆ʊə③əʊП┳卐？＠"
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        let renderer: HtmlRenderer = HtmlRenderer.builder().percentEncodeUrls(true).build()
        @Assert(renderer.render(document),"<p>倉頡◆☆ʊə③əʊП┳卐？＠</p>\n")
    }

    @TestCase
    func test_parser_parse27(): Unit {
        let given: String = ""
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        let renderer: HtmlRenderer = HtmlRenderer.builder().percentEncodeUrls(true).build()
        @Assert(renderer.render(document),"")
    }


    @TestCase
    func test_parser_parse28(): Unit {
        let given: String = "倉頡cangjie◆☆ʊə③əʊП┳卐？＠123"
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        let renderer: HtmlRenderer = HtmlRenderer.builder().percentEncodeUrls(true).build()
        @Assert(renderer.render(document),"<p>倉頡cangjie◆☆ʊə③əʊП┳卐？＠123</p>\n")
    }


    @TestCase
    func test_parser_parse29(): Unit {
        let given: String = "倉頡\ncangjie◆☆ʊə③əʊП┳卐？＠123"
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        let renderer: HtmlRenderer = HtmlRenderer.builder().percentEncodeUrls(true).build()
        @Assert(renderer.render(document),"<p>倉頡\ncangjie◆☆ʊə③əʊП┳卐？＠123</p>\n")
    }


    @TestCase
    func test_parser_parse30(): Unit {
        let given: String = "oh"
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        let renderer: HtmlRenderer = HtmlRenderer.builder().softbreak("倉頡").build()
        @Assert(renderer.render(document),"<p>oh</p>\n")
    }

    @TestCase
    func test_parser_parse31(): Unit {
        let given: String = "oh"
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        let renderer: HtmlRenderer = HtmlRenderer.builder().softbreak("").build()
        @Assert(renderer.render(document),"<p>oh</p>\n")
    }

    @TestCase
    func test_parser_parse32(): Unit {
        let given: String = "倉頡\ncangjie◆☆ʊə③əʊП┳卐？＠123"
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        let renderer: HtmlRenderer = HtmlRenderer.builder().softbreak("").build()
        @Assert(renderer.render(document),"<p>倉頡cangjie◆☆ʊə③əʊП┳卐？＠123</p>\n")
    }

    @TestCase
    func test_parser_parse33(): Unit {
        let given: String = "倉頡\ncang\njie◆☆ʊə③əʊП┳卐？＠123"
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        let renderer: HtmlRenderer = HtmlRenderer.builder().softbreak("").build()
        @Assert(renderer.render(document),"<p>倉頡cangjie◆☆ʊə③əʊП┳卐？＠123</p>\n")
    }


    @TestCase
    func test_parser_parse34(): Unit {
        let given: String = "倉頡\ncang\njie◆☆ʊə③əʊП┳卐？＠123"
        var parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
        let renderer: HtmlRenderer = HtmlRenderer.builder().softbreak("").build()
        renderer.render(document,StringBuilder())
        @Assert(renderer.render(document),"<p>倉頡cangjie◆☆ʊə③əʊП┳卐？＠123</p>\n")
    }


    @TestCase
    public func htmlAllowingShouldNotEscapeInlineHtml01(): Unit {
        let text = TextContentRenderer.builder().setStripNewlines(false).build()
        let PARSER = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        let rendered: String = text.render(
            PARSER.parse("倉頡\ncang\njie◆☆ʊə③əʊП┳卐？＠123"))
        var string = "倉頡\ncang\njie◆☆ʊə③əʊП┳卐？＠123"
        @Assert(string, rendered)
    }

    @TestCase
    public func htmlAllowingShouldNotEscapeInlineHtml02(): Unit {
        let text = TextContentRenderer.builder().setStripNewlines(false).build()
        let PARSER = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        let rendered: String = text.render(
            PARSER.parse("，"))
        var string = "，"
        @Assert(string, rendered)
    }

    @TestCase
    public func htmlAllowingShouldNotEscapeInlineHtml03(): Unit {
        let text = TextContentRenderer.builder().setStripNewlines(false).build()
        let PARSER = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        let rendered: String = text.render(
            PARSER.parse(""))
        var string = ""
        @Assert(string, rendered)
    }

    @TestCase
    public func htmlAllowingShouldNotEscapeInlineHtml04(): Unit {
        let text = TextContentRenderer.builder().setStripNewlines(false).build()
        let PARSER = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        let rendered: String = text.render(
            PARSER.parse(" "))
        var string = ""
        @Assert(string, rendered)
    }

    @TestCase
    public func htmlAllowingShouldNotEscapeInlineHtml05(): Unit {
        let text = TextContentRenderer.builder().build()
        let PARSER = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        let rendered: String = text.render(
            PARSER.parse("https://\nnoties.io/Markwon/docs/v4/core/plugins.html#registry"))
        var string = "https://\nnoties.io/Markwon/docs/v4/core/plugins.html#registry"
        @Assert(rendered,string)
    }

    @TestCase
    public func htmlAllowingShouldNotEscapeInlineHtml06(): Unit {
        let text = TextContentRenderer.builder().setStripNewlines(true).build()
        let PARSER = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        let rendered: String = text.render(
            PARSER.parse("https://\noties.io/Markwon/docs/v4/core/plugins.html#registry"))
        var string = "https:// oties.io/Markwon/docs/v4/core/plugins.html#registry"
        println(rendered)
        println(rendered.toRuneArray().size)
        @Assert(string, rendered)
    }


    @TestCase
    public func htmlAllowingShouldNotEscapeInlineHtml07(): Unit {
        let text = TextContentRenderer.builder().setStripNewlines(true).build()
        let PARSER = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        let rendered: String = text.render(
            PARSER.parse("┳③す▓▉㏘¤↗㊣"))
        var string = "┳③す▓▉㏘¤↗㊣"
        println(rendered)
        println(rendered.toRuneArray().size)
        @Assert(string, rendered)
    }


    @TestCase
    public func htmlAllowingShouldNotEscapeInlineHtml08(): Unit {
        let text = TextContentRenderer.builder().build()
        let PARSER = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        let rendered: String = text.render(
            PARSER.parse("__倉_你好_頡__"))
        var string = "倉_你好_頡"
        println(rendered)
        println(rendered.toRuneArray().size)
        @Assert(string, rendered)
    }

    @TestCase
    public func htmlAllowingShouldNotEscapeInlineHtml09(): Unit {
        let text = TextContentRenderer.builder().build()
        let PARSER = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        let rendered: String = text.render(
            PARSER.parse("哈__倉_你好_頡__，哈"))
        var string = "哈__倉_你好_頡__，哈"
        println(rendered)
        println(rendered.toRuneArray().size)
        @Assert(string, rendered)
    }


    @TestCase
    public func htmlAllowingShouldNotEscapeInlineHtml10(): Unit {
        let text = TextContentRenderer.builder().build()
        let PARSER = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        let rendered: String = text.render(
            PARSER.parse("哈__倉_你好_頡__ ，哈"))
        var string = "哈__倉_你好_頡__ ，哈"
        println(rendered)
        println(rendered.toRuneArray().size)
        @Assert(string, rendered)
    }


    @TestCase
    public func htmlAllowingShouldNotEscapeInlineHtml11(): Unit {
        let given: String = "paragraph with <span id='foo' class=\"bar\">inline &amp; html</span>"
        var parser=Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        var document: Node = parser.parse(given)
         let htmlAllowingRenderer: HtmlRenderer = HtmlRenderer.builder().softbreak("").build()
        @Assert("<p>paragraph with <span id='foo' class=\"bar\">inline &amp; html</span></p>\n", htmlAllowingRenderer.render(document))
    }


    @TestCase
    public func htmlAllowingShouldNotEscapeInlineHtml12(): Unit {
        let text = TextContentRenderer.builder().build()
        let PARSER = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        let rendered: String = text.render(PARSER.parse("，。、sa，。、（）#&"))
        var string = "，。、sa，。、（）#&"
        println(rendered)
        println(rendered.toRuneArray().size)
        @Assert(string, rendered)
    }

    @TestCase
    public func htmlAllowingShouldNotEscapeInlineHtml13(): Unit {
        let text = TextContentRenderer.builder().build()
        let PARSER = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        let rendered: String = text.render(PARSER.parse("—-————__，。、__sa————-，。~、（）#~&"))
        var string = "—-————__，。、__sa————-，。~、（）#~&"
        println(rendered)
        println(rendered.toRuneArray().size)
        @Assert(string, rendered)
    }


    @TestCase
    public func htmlAllowingShouldNotEscapeInlineHtml14(): Unit {
        let text = TextContentRenderer.builder().build()
        let PARSER = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        let rendered: String = text.render(PARSER.parse(""))
        var string = ""
        println(rendered)
        println(rendered.toRuneArray().size)
        @Assert(string, rendered)
    }
}

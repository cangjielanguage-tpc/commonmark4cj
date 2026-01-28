// 3rd_party_lib:commonmark4cj/build/release/commonmark4cj
// 3rd_party_lib_ohos:commonmark4cj/build/aarch64-linux-ohos/commonmark4cj

import commonmark4cj.commonmark.*
import commonmark4cj.strikethrough.*
import commonmark4cj.table.*
import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import std.collection.*
import std.reflect.{TypeInfo}
import std.unicode.*
import std.fs.*

@Test
public class TestStrikethroughParser {
    @TestCase
    func test_strikethrough_parser(): Unit {
        let text = htmlRender("~foo~")
        @Assert("<p>~foo~</p>\n", text)
    }

    @TestCase
    func test_strikethrough_parser2(): Unit {
        let text = textContentRender("~~foo~~")
        @Assert("/foo/", text)
    }

    @TestCase
    func test_strikethrough_parser3(): Unit {
        let text = htmlRender("")
        @Assert("", text)
    }

    @TestCase
    func test_strikethrough_parser4(): Unit {
        let text = htmlRender(" ")
        @Assert("", text)
    }

    @TestCase
    func test_strikethrough_parser5(): Unit {
        let text = textContentRender("")
        @Assert("", text)
    }

    @TestCase
    func test_strikethrough_parser6(): Unit {
        let text = textContentRender(" ")
        @Assert("", text)
    }

    @TestCase
    func test_strikethrough_init1(): Unit {
        var strikethrough = Strikethrough("~~")
        @Assert(strikethrough.getOpeningDelimiter().getOrThrow(),"~~")
        @Assert(strikethrough.getClosingDelimiter().getOrThrow(),"~~")
    }
}

func htmlRender(source: String): String {
    let EXTENSIONS: Iterable<Extension> = ArrayList<Extension>([StrikethroughExtension.create()])
    let PARSER: Parser = Parser.builder().extensions(EXTENSIONS).build()
    let HTML_RENDERER: HtmlRenderer = HtmlRenderer.builder().extensions(EXTENSIONS).build()

    return HTML_RENDERER.render(PARSER.parse(source))
}

func textContentRender(source: String): String {
    let EXTENSIONS: Iterable<Extension> = ArrayList<Extension>([StrikethroughExtension.create()])
    let PARSER: Parser = Parser.builder().extensions(EXTENSIONS).build()
    let CONTENT_RENDERER: TextContentRenderer = TextContentRenderer.builder().extensions(EXTENSIONS).build()

    return CONTENT_RENDERER.render(PARSER.parse(source))
}

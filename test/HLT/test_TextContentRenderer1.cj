// 3rd_party_lib:commonmark4cj/build/release/commonmark4cj
// 3rd_party_lib_ohos:commonmark4cj/build/aarch64-linux-ohos/commonmark4cj
// dependence: z_test.cj
import commonmark4cj.commonmark.*
import commonmark4cj.table.*
import commonmark4cj.strikethrough.*
import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import std.collection.*

@Test
public class TextContentRendererTest {
    private static let EXTENSIONS: Iterable<Extension> = ArrayList<Extension>([StrikethroughExtension.create()])
    private static let PARSER: Parser = Parser.builder().extensions(EXTENSIONS).build()
    private static let HTML_RENDERER: HtmlRenderer = HtmlRenderer.builder().extensions(EXTENSIONS).build()
    private static let CONTENT_RENDERER: TextContentRenderer = TextContentRenderer.builder().extensions(EXTENSIONS).
        build()
    private static let CONTENT_RENDERER1: TextContentRenderer = TextContentRenderer.builder().build()

    @TestCase
    func TextContentRenderer01(): Unit {
        let document: Node = PARSER.parse("~~foo~~")
        @Assert("",CONTENT_RENDERER1.render(document))
    }

    @TestCase
    func TextContentRenderer02(): Unit {
        let document: Node = PARSER.parse("仓颉123")
        @Assert("仓颉123",CONTENT_RENDERER.render(document))
    }

    @TestCase
    func TextContentRenderer04(): Unit {
        let document: Node = PARSER.parse("")
        @Assert("",CONTENT_RENDERER1.render(document))
    }

    @TestCase
    func TextContentRenderer05(): Unit {
        let document: Node = PARSER.parse(" ")
        @Assert("",CONTENT_RENDERER1.render(document))
    }

    @TestCase
    func TextContentRenderer06(): Unit {
        let stringBuilder = StringBuilder()
        let document: Node = PARSER.parse(" ")
        CONTENT_RENDERER1.render(document, stringBuilder)
        @Assert("",CONTENT_RENDERER1.render(document))
    }

    @TestCase
    func TextContentRenderer07(): Unit {
        let stringBuilder = StringBuilder()
        let document: Node = PARSER.parse("foo~~")
        CONTENT_RENDERER1.render(document, stringBuilder)
        @Assert("foo~~",CONTENT_RENDERER1.render(document))
    }

    @TestCase
    func TextContentRenderer08(): Unit {
        let stringBuilder = StringBuilder()
        let document: Node = PARSER.parse("~~foo~~")
        CONTENT_RENDERER1.render(document, stringBuilder)
        @Assert("/foo/",CONTENT_RENDERER.render(document))
    }

    @TestCase
    func TextContentRenderer09(): Unit {
        let stringBuilder = StringBuilder()
        let document: Node = PARSER.parse("foo ~~~~")
        CONTENT_RENDERER1.render(document, stringBuilder)
        @Assert("foo ~~~~",CONTENT_RENDERER1.render(document))
    }

    @TestCase
    func TextContentRenderer10(): Unit {
        let stringBuilder = StringBuilder()
        let document: Node = PARSER.parse("foo ~~~~")
        CONTENT_RENDERER1.render(document, stringBuilder)
        @Assert("foo ~~~~",CONTENT_RENDERER1.render(document))
    }

    @TestCase
    func TextContentRenderer11(): Unit {
        let stringBuilder = StringBuilder()
        let document: Node = PARSER.parse("~~foo")
        CONTENT_RENDERER1.render(document, stringBuilder)
        @Assert("~~foo",CONTENT_RENDERER1.render(document))
    }

    @TestCase
    func TextContentRenderer12(): Unit {
        let stringBuilder = StringBuilder()
        let document: Node = PARSER.parse("~~foo")
        CONTENT_RENDERER1.render(document, stringBuilder)
        @Assert("~~foo",CONTENT_RENDERER1.render(document))
    }

    @TestCase
    func TextContentRenderer13(): Unit {
        let stringBuilder = StringBuilder()
        let document: Node = PARSER.parse("a ~~~foo~~~")
        CONTENT_RENDERER1.render(document, stringBuilder)
        @Assert("a ~~~foo~~~",CONTENT_RENDERER.render(document))
    }

    @TestCase
    func TextContentRenderer14(): Unit {
        let stringBuilder = StringBuilder()
        let document: Node = PARSER.parse("a ~~~foo~~~")
        CONTENT_RENDERER1.render(document, stringBuilder)
        @Assert("a ~~~foo~~~",CONTENT_RENDERER1.render(document))
    }

    @TestCase
    func TextContentRenderer15(): Unit {
        let stringBuilder = StringBuilder()
        let document: Node = PARSER.parse("~~foo~bar~~")
        CONTENT_RENDERER1.render(document, stringBuilder)
        @Assert("/foo~bar/",CONTENT_RENDERER.render(document))
        @Assert("",CONTENT_RENDERER1.render(document))
    }

    @TestCase
    func TextContentRenderer16(): Unit {
        let stringBuilder = StringBuilder()
        let document: Node = PARSER.parse("~~foo~~~bar~~")
        CONTENT_RENDERER.render(document, stringBuilder)
        @Assert("/foo~~~bar/",CONTENT_RENDERER.render(document))
    }

    @TestCase
    func TextContentRenderer17(): Unit {
        let stringBuilder = StringBuilder()
        let document: Node = PARSER.parse("~~foo~~~bar~~")
        CONTENT_RENDERER1.render(document, stringBuilder)
        @Assert("",CONTENT_RENDERER1.render(document))
    }

    @TestCase
    func TextContentRenderer18(): Unit {
        let stringBuilder = StringBuilder()
        let document: Node = PARSER.parse("~~foo~~~~~~~bar~~")
        CONTENT_RENDERER.render(document, stringBuilder)
        @Assert("/foo~~~~~~~bar/",CONTENT_RENDERER.render(document))
    }

    @TestCase
    func TextContentRenderer19(): Unit {
        let stringBuilder = StringBuilder()
        let document: Node = PARSER.parse("~~foo~~~~~~~bar~~")
        CONTENT_RENDERER1.render(document, stringBuilder)
        @Assert("",CONTENT_RENDERER1.render(document))
    }

    @TestCase
    func TextContentRenderer20(): Unit {
        let stringBuilder = StringBuilder()
        let document: Node = PARSER.parse("~~Paragraph with *emphasis* and __strong emphasis__~~")
        CONTENT_RENDERER.render(document, stringBuilder)
        @Assert("/Paragraph with emphasis and strong emphasis/",CONTENT_RENDERER.render(document))
    }

    @TestCase
    func TextContentRenderer21(): Unit {
        let stringBuilder = StringBuilder()
        let document: Node = PARSER.parse("~~Paragraph with *emphasis* and __strong emphasis__~~")
        CONTENT_RENDERER1.render(document, stringBuilder)
        @Assert("",CONTENT_RENDERER1.render(document))
    }

    @TestCase
    func TextContentRenderer22(): Unit {
        let stringBuilder = StringBuilder()
        let document: Node = PARSER.parse("> strike ~~that~~")
        CONTENT_RENDERER.render(document, stringBuilder)
        @Assert("«strike /that/»",CONTENT_RENDERER.render(document))
    }

    @TestCase
    func TextContentRenderer26(): Unit {
        let PARSER: Parser = Parser.builder().extensions(EXTENSIONS).build()
        PARSER.parse("foo~bar")
    }

    @TestCase
    func TextContentRenderer23(): Unit {
        let stringBuilder = StringBuilder()
        let document: Node = PARSER.parse("> strike ~~that~~")
        CONTENT_RENDERER1.render(document, stringBuilder)
        @Assert("«strike »",CONTENT_RENDERER1.render(document))
    }

    @TestCase
    func TextContentRenderer24(): Unit {
        let document: Node = PARSER.parse("~~foo~~")
        let strikethrough: Strikethrough = (document.getFirstChild()().getFirstChild()() as Strikethrough)()
        @Assert("~~",strikethrough.getOpeningDelimiter())
    }

    @TestCase
    func TextContentRenderer25(): Unit {
        let document: Node = PARSER.parse("> strike ~~that~~")
        try {
            (document.getFirstChild().getOrThrow().getFirstChild().getOrThrow() as Strikethrough).getOrThrow()
        } catch (e: Exception) {
            @Assert(e.toString(),"NoneValueException")
        }
    }
}

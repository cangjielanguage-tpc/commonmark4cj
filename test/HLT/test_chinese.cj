// 3rd_party_lib:commonmark4cj/build/release/commonmark4cj
// 3rd_party_lib_ohos:commonmark4cj/build/aarch64-linux-ohos/commonmark4cj
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
    private static let CONTENT_RENDERER: TextContentRenderer  = TextContentRenderer.builder().extensions(EXTENSIONS).build()
    private static let CONTENT_RENDERER1: TextContentRenderer  = TextContentRenderer.builder().build()

    @TestCase
    func TextContentRenderer01(): Unit {
        let document: Node = PARSER.parse("~~foo~~")
        @Assert("",CONTENT_RENDERER1.render(document))
    }

 
    @TestCase
    func TextContentRenderer02(): Unit {
        let document: Node = PARSER.parse("仓颉")
        @Assert("仓颉",CONTENT_RENDERER.render(document))
    }
}
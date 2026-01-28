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
    func TextContentRenderer06(): Unit {
        assertRendering("~foo~", "<p>~foo~</p>\n")
    }

    @TestCase
    public func twoTildesYay() {
        assertRendering("~~foo~~", "<p><del>foo</del></p>\n")
    }

    @TestCase
    public func fourTildesNope() {
        assertRendering("foo ~~~~", "<p>foo ~~~~</p>\n")
    }

    @TestCase
    public func unmatched() {
        assertRendering("~~foo", "<p>~~foo</p>\n")
        assertRendering("foo~~", "<p>foo~~</p>\n")
    }

    @TestCase
    public func threeInnerThree() {
        assertRendering("a ~~~foo~~~", "<p>a ~~~foo~~~</p>\n")
    }

    @TestCase
    public func twoInnerThree() {
        assertRendering("~~foo~~~", "<p>~~foo~~~</p>\n")
    }

    @TestCase
    public func tildesInside() {
        assertRendering("~~foo~bar~~", "<p><del>foo~bar</del></p>\n")
        assertRendering("~~foo~~bar~~", "<p><del>foo</del>bar~~</p>\n")
        assertRendering("~~foo~~~bar~~", "<p><del>foo~~~bar</del></p>\n")
        assertRendering("~~foo~~~~bar~~", "<p><del>foo~~~~bar</del></p>\n")
        assertRendering("~~foo~~~~~bar~~", "<p><del>foo~~~~~bar</del></p>\n")
        assertRendering("~~foo~~~~~~bar~~", "<p><del>foo~~~~~~bar</del></p>\n")
        assertRendering("~~foo~~~~~~~bar~~", "<p><del>foo~~~~~~~bar</del></p>\n")
    }

    @TestCase
    public func strikethroughWholeParagraphWithOtherDelimiters() {
        assertRendering(
            "~~Paragraph with *emphasis* and __strong emphasis__~~",
            "<p><del>Paragraph with <em>emphasis</em> and <strong>strong emphasis</strong></del></p>\n"
        )
    }

    @TestCase
    public func insideBlockQuote() {
        assertRendering(
            "> strike ~~that~~",
            "<blockquote>\n<p>strike <del>that</del></p>\n</blockquote>\n"
        )
    }

    @TestCase
    public func delimited() {
        let document: Node = PARSER.parse("~~foo~~")
        let strikethrough: Strikethrough = (document.getFirstChild()().getFirstChild()() as Strikethrough)()
        assertEquals("~~", strikethrough.getOpeningDelimiter())
        assertEquals("~~", strikethrough.getClosingDelimiter())
    }

    @TestCase
    public func textContentRenderer() {
        let document: Node = PARSER.parse("~~foo~~")
        assertEquals("/foo/", CONTENT_RENDERER.render(document))
    }

    func render(source: String): String {
        return HTML_RENDERER.render(PARSER.parse(source))
    }

    func assertRendering(source: String, expectedResult: String): Unit {
        let renderedContent: String = render(source)
        let expected: String = showTabs(expectedResult + "\n\n" + source)
        let actual: String = showTabs(renderedContent + "\n\n" + source)
        assertEquals(expected, actual)
    }

    func showTabs(s: String): String {
        return s.replace("\t", "\u{2192}")
    }
}

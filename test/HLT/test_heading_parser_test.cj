// DEPENDENCE: z_test.cj
// 3rd_party_lib:commonmark4cj/build/release/commonmark4cj
// 3rd_party_lib_ohos:commonmark4cj/build/aarch64-linux-ohos/commonmark4cj
// dependence: z_test.cj

import commonmark4cj.commonmark.*
import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import std.unicode.*
import std.reflect.{TypeInfo}

@Test
public class HeadingParserTest {
    private static let PARSER: Parser = Parser.builder().build()
    private static let RENDERER: HtmlRenderer = HtmlRenderer.builder().build()

    @TestCase
    public func atxHeadingStart(): Unit {
        assertRendering("# test", "<h1>test</h1>\n")
        assertRendering("###### test", "<h6>test</h6>\n")
        assertRendering("####### test", "<p>####### test</p>\n")
        assertRendering("#test", "<p>#test</p>\n")
        assertRendering("#", "<h1></h1>\n")
    }

    @TestCase
    public func atxHeadingTrailing(): Unit {
        assertRendering("# test #", "<h1>test</h1>\n")
        assertRendering("# test ###", "<h1>test</h1>\n")
        assertRendering("# test # ", "<h1>test</h1>\n")
        assertRendering("# test  ###  ", "<h1>test</h1>\n")
        assertRendering("# test # #", "<h1>test #</h1>\n")
        assertRendering("# test#", "<h1>test#</h1>\n")
    }

    @TestCase
    public func atxHeadingSurrogates(): Unit {
        assertRendering("# \u{1F60A} #", "<h1>\u{1F60A}</h1>\n")
    }

    @TestCase
    public func setextHeadingMarkers(): Unit {
        assertRendering("test\n=", "<h1>test</h1>\n")
        assertRendering("test\n-", "<h2>test</h2>\n")
        assertRendering("test\n====", "<h1>test</h1>\n")
        assertRendering("test\n----", "<h2>test</h2>\n")
        assertRendering("test\n====   ", "<h1>test</h1>\n")
        assertRendering("test\n====   =", "<p>test\n====   =</p>\n")
        assertRendering("test\n=-=", "<p>test\n=-=</p>\n")
        assertRendering("test\n=a", "<p>test\n=a</p>\n")
    }

    func render(source: String): String {
        let node: Node = PARSER.parse(source)
        return RENDERER.render(node)
    }

    public func assertRendering(source: String, expectedResult: String): Unit {
        let renderedContent: String = render(source)
        let expected: String = showTabs(expectedResult + "\n\n" + source)
        let actual: String = showTabs(renderedContent + "\n\n" + source)
        assertEquals(expected, actual)
    }

    public func showTabs(s: String): String {
        // Tabs are shown as "rightwards arrow" for easier comparison
        return s.replace("\t", "\u{2192}")
    }
}

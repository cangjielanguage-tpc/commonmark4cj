// DEPENDENCE: z_test.cj
// EXEC: cjc %import-path %L %l %f z_test.cj -Woff unused
// EXEC: ./main

import commonmark4cj.commonmark.*
import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import std.unicode.*
import std.fs.*
import std.reflect.{TypeInfo}

main() {
    let tester = SpecialInputTest()
    tester.empty()
    tester.nullCharacterShouldBeReplaced()
    tester.nullCharacterEntityShouldBeReplaced()
    tester.crLfAsLineSeparatorShouldBeParsed()
    tester.crLfAtEndShouldBeParsed()
    tester.mixedLineSeparators()
    tester.surrogatePair()
    tester.surrogatePairInLinkDestination()
    tester.indentedCodeBlockWithMixedTabsAndSpaces()
    tester.tightListInBlockQuote()
    tester.looseListInBlockQuote()
    tester.lineWithOnlySpacesAfterListBullet()
    tester.listWithTwoSpacesForFirstBullet()
    tester.orderedListMarkerOnly()
    tester.columnIsInTabOnPreviousLine()
    tester.linkLabelWithBracket()
    tester.linkLabelLength()
    tester.linkDestinationEscaping()
    tester.linkReferenceBackslash()
    tester.emphasisMultipleOf3Rule()
    tester.deeplyIndentedList()
    return 0
}

@Test
public class SpecialInputTest {
    private static let PARSER: Parser = Parser.builder().build()
    private static let RENDERER: HtmlRenderer = HtmlRenderer.builder().build()

    @TestCase
    public func empty(): Unit {
        assertRendering("", "")
    }

    @TestCase
    public func nullCharacterShouldBeReplaced(): Unit {
        assertRendering("foo\0bar", "<p>foo\u{FFFD}bar</p>\n")
    }
    @TestCase
    public func nullCharacterEntityShouldBeReplaced() {
        assertRendering("foo&#0;bar", "<p>foo\u{FFFD}bar</p>\n")
    }

    @TestCase
    public func crLfAsLineSeparatorShouldBeParsed() {
        assertRendering("foo\r\nbar", "<p>foo\nbar</p>\n")
    }

    @TestCase
    public func crLfAtEndShouldBeParsed() {
        assertRendering("foo\r\n", "<p>foo</p>\n")
    }

    @TestCase
    public func mixedLineSeparators() {
        assertRendering("- a\n- b\r- c\r\n- d", "<ul>\n<li>a</li>\n<li>b</li>\n<li>c</li>\n<li>d</li>\n</ul>\n")
        assertRendering("a\n\nb\r\rc\r\n\r\nd\n\re", "<p>a</p>\n<p>b</p>\n<p>c</p>\n<p>d</p>\n<p>e</p>\n")
    }

    @TestCase
    public func surrogatePair() {
        assertRendering("surrogate pair: \u{1D11E}", "<p>surrogate pair: \u{1D11E}</p>\n")
    }

    @TestCase
    public func surrogatePairInLinkDestination() {
        assertRendering("[title](\u{1D11E})", "<p><a href=\"\u{1D11E}\">title</a></p>\n")
    }

    @TestCase
    public func indentedCodeBlockWithMixedTabsAndSpaces() {
        assertRendering("    foo\n\tbar", "<pre><code>foo\nbar\n</code></pre>\n")
    }

    @TestCase
    public func tightListInBlockQuote() {
        assertRendering("> *\n> * a", "<blockquote>\n<ul>\n<li></li>\n<li>a</li>\n</ul>\n</blockquote>\n")
    }

    @TestCase
    public func looseListInBlockQuote() {
        assertRendering("> *\n>\n> * a", "<blockquote>\n<ul>\n<li></li>\n<li>\n<p>a</p>\n</li>\n</ul>\n</blockquote>\n")
    }

    @TestCase
    public func lineWithOnlySpacesAfterListBullet() {
        assertRendering("-  \n  \n  foo\n", "<ul>\n<li></li>\n</ul>\n<p>foo</p>\n")
    }

    @TestCase
    public func listWithTwoSpacesForFirstBullet() {
        assertRendering("*  \n  foo\n", "<ul>\n<li>foo</li>\n</ul>\n")
    }

    @TestCase
    public func orderedListMarkerOnly() {
        assertRendering("2.", "<ol start=\"2\">\n<li></li>\n</ol>\n")
    }

    @TestCase
    public func columnIsInTabOnPreviousLine() {
        assertRendering(
            "- foo\n\n\tbar\n\n# baz\n",
            "<ul>\n<li>\n<p>foo</p>\n<p>bar</p>\n</li>\n</ul>\n<h1>baz</h1>\n"
        )
        assertRendering(
            "- foo\n\n\tbar\n# baz\n",
            "<ul>\n<li>\n<p>foo</p>\n<p>bar</p>\n</li>\n</ul>\n<h1>baz</h1>\n"
        )
    }

    @TestCase
    public func linkLabelWithBracket() {
        assertRendering("[a[b]\n\n[a[b]: /", "<p>[a[b]</p>\n<p>[a[b]: /</p>\n")
        assertRendering("[a]b]\n\n[a]b]: /", "<p>[a]b]</p>\n<p>[a]b]: /</p>\n")
        assertRendering("[a[b]]\n\n[a[b]]: /", "<p>[a[b]]</p>\n<p>[a[b]]: /</p>\n")
    }

    @TestCase
    public func linkLabelLength() {
        let label1: String = Strings.repeat("a", 999)
        assertRendering("[foo][" + label1 + "]\n\n[" + label1 + "]: /", "<p><a href=\"/\">foo</a></p>\n")
        assertRendering(
            "[foo][x" + label1 + "]\n\n[x" + label1 + "]: /",
            "<p>[foo][x" + label1 + "]</p>\n<p>[x" + label1 + "]: /</p>\n"
        )
        assertRendering(
            "[foo][\n" + label1 + "]\n\n[\n" + label1 + "]: /",
            "<p>[foo][\n" + label1 + "]</p>\n<p>[\n" + label1 + "]: /</p>\n"
        )

        let label2: String = Strings.repeat("a\n", 499)
        assertRendering("[foo][" + label2 + "]\n\n[" + label2 + "]: /", "<p><a href=\"/\">foo</a></p>\n")
        assertRendering(
            "[foo][12" + label2 + "]\n\n[12" + label2 + "]: /",
            "<p>[foo][12" + label2 + "]</p>\n<p>[12" + label2 + "]: /</p>\n"
        )
    }

    @TestCase
    public func linkDestinationEscaping() {
        assertRendering("[foo](\\))", "<p><a href=\")\">foo</a></p>\n")
        assertRendering("[foo](\\ )", "<p><a href=\"\\\">foo</a></p>\n")
        assertRendering("[foo](<a\\b>)", "<p><a href=\"a\\b\">foo</a></p>\n")
        assertRendering("[foo](<a\\>>)", "<p><a href=\"a&gt;\">foo</a></p>\n")
        assertRendering("[foo](<\\>)", "<p>[foo](&lt;&gt;)</p>\n")
    }

    @TestCase
    public func linkReferenceBackslash() {
        assertRendering("[\\]: test", "<p>[]: test</p>\n")
        assertRendering("[a\\b]\n\n[a\\b]: test", "<p><a href=\"test\">a\\b</a></p>\n")
        assertRendering("[a\\]]\n\n[a\\]]: test", "<p><a href=\"test\">a]</a></p>\n")
    }

    @TestCase
    public func emphasisMultipleOf3Rule() {
        assertRendering("a***b* c*", "<p>a*<em><em>b</em> c</em></p>\n")
    }

    @TestCase
    public func deeplyIndentedList() {
        assertRendering(
            "* one\n" + "  * two\n" + "    * three\n" + "      * four",
            "<ul>\n" + "<li>one\n" + "<ul>\n" + "<li>two\n" + "<ul>\n" + "<li>three\n" + "<ul>\n" + "<li>four</li>\n" +
                "</ul>\n" + "</li>\n" + "</ul>\n" + "</li>\n" + "</ul>\n" + "</li>\n" + "</ul>\n"
        )
    }

    func render(source: String): String {
        let node = PARSER.parse(source)
        return RENDERER.render(node)
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

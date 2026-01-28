// 3rd_party_lib:commonmark4cj/build/release/commonmark4cj
// 3rd_party_lib_ohos:commonmark4cj/build/aarch64-linux-ohos/commonmark4cj
// dependence: z_test.cj

import commonmark4cj.commonmark.*
import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import std.unicode.*
import std.fs.*
import std.reflect.{TypeInfo}

@Test
public class PathologicalTest {
    private let RENDERER: HtmlRenderer = HtmlRenderer.builder().build()
    private let PARSER: Parser = Parser.builder().build()
    var x: Int64 = 100000

    @TestCase
    public func nestedStrongEmphasis(): Unit {
        x = 5
        assertRendering(
            Strings.repeat("*a **a ", x) + "b" + Strings.repeat(" a** a*", x),
            "<p>" + Strings.repeat("<em>a <strong>a ", x) + "b" + Strings.repeat(" a</strong> a</em>", x) + "</p>\n"
        )
    }

    @TestCase
    public func emphasisClosersWithNoOpeners(): Unit {
        assertRendering(
            Strings.repeat("a_ ", x),
            "<p>" + Strings.repeat("a_ ", x - 1) + "a_</p>\n"
        )
    }

    @TestCase
    public func emphasisOpenersWithNoClosers(): Unit {
        assertRendering(
            Strings.repeat("_a ", x),
            "<p>" + Strings.repeat("_a ", x - 1) + "_a</p>\n"
        )
    }

    @TestCase
    public func linkClosersWithNoOpeners(): Unit {
        assertRendering(
            Strings.repeat("a] ", x),
            "<p>" + Strings.repeat("a] ", x - 1) + "a]</p>\n"
        )
    }

    @TestCase
    public func linkOpenersWithNoClosers(): Unit {
        assertRendering(
            Strings.repeat("[a ", x),
            "<p>" + Strings.repeat("[a ", x - 1) + "[a</p>\n"
        )
    }

    @TestCase
    public func linkOpenersAndEmphasisClosers(): Unit {
        assertRendering(
            Strings.repeat("[ a_ ", x),
            "<p>" + Strings.repeat("[ a_ ", x - 1) + "[ a_</p>\n"
        )
    }

    @TestCase
    public func mismatchedOpenersAndClosers(): Unit {
        assertRendering(
            Strings.repeat("*a_ ", x),
            "<p>" + Strings.repeat("*a_ ", x - 1) + "*a_</p>\n"
        )
    }

    @TestCase
    public func nestedBrackets(): Unit {
        assertRendering(
            Strings.repeat("[", x) + "a" + Strings.repeat("]", x),
            "<p>" + Strings.repeat("[", x) + "a" + Strings.repeat("]", x) + "</p>\n"
        )
    }

    @TestCase
    public func nestedBlockQuotes(): Unit {
        x = 1000
        assertRendering(
            Strings.repeat("> ", x) + "a\n",
            Strings.repeat("<blockquote>\n", x) + "<p>a</p>\n" + Strings.repeat("</blockquote>\n", x)
        )
    }

    @TestCase
    public func hugeHorizontalRule(): Unit {
        assertRendering(
            Strings.repeat("*", 10000) + "\n",
            "<hr />\n"
        )
    }

    @TestCase
    public func backslashInLink(): Unit {
        assertRendering(
            "[" + Strings.repeat("\\", x) + "\n",
            "<p>" + "[" + Strings.repeat("\\", x / 2) + "</p>\n"
        )
    }

    @TestCase
    public func unclosedInlineLinks(): Unit {
        assertRendering(
            Strings.repeat("[](", x) + "\n",
            "<p>" + Strings.repeat("[](", x) + "</p>\n"
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

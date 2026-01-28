// DEPENDENCE: z_test.cj
// EXEC: cjc %import-path %L %l %f z_test.cj -Woff unused
// EXEC: ./main

import commonmark4cj.commonmark.*
import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import std.unicode.*
import std.reflect.{TypeInfo}

main() {
    let tester = ListTightLooseTest()
    tester.tight()
    tester.loose()
    tester.looseNested()
    tester.looseNested2()
    tester.looseOuter()
    tester.looseListItem()
    tester.tightWithBlankLineAfter()
    tester.tightListWithCodeBlock()
    tester.tightListWithCodeBlock2()
    tester.looseEmptyListItem()
    tester.looseBlankLineAfterCodeBlock()
    return 0
}

@Test
public class ListTightLooseTest {
    private static let PARSER: Parser = Parser.builder().build()
    private static let RENDERER: HtmlRenderer = HtmlRenderer.builder().build()

    @TestCase
    public func tight(): Unit {
        assertRendering("- foo\n" +
                        "- bar\n" +
                        "+ baz\n",
                "<ul>\n" +
                        "<li>foo</li>\n" +
                        "<li>bar</li>\n" +
                        "</ul>\n" +
                        "<ul>\n" +
                        "<li>baz</li>\n" +
                        "</ul>\n")
    }

    @TestCase
    public func loose(): Unit {
        assertRendering("- foo\n" +
                        "\n" +
                        "- bar\n" +
                        "\n" +
                        "\n" +
                        "- baz\n",
                "<ul>\n" +
                        "<li>\n" +
                        "<p>foo</p>\n" +
                        "</li>\n" +
                        "<li>\n" +
                        "<p>bar</p>\n" +
                        "</li>\n" +
                        "<li>\n" +
                        "<p>baz</p>\n" +
                        "</li>\n" +
                        "</ul>\n")
    }

    @TestCase
    public func looseNested(): Unit {
        assertRendering("- foo\n" +
                        "  - bar\n" +
                        "\n" +
                        "\n" +
                        "    baz",
                "<ul>\n" +
                        "<li>foo\n" +
                        "<ul>\n" +
                        "<li>\n" +
                        "<p>bar</p>\n" +
                        "<p>baz</p>\n" +
                        "</li>\n" +
                        "</ul>\n" +
                        "</li>\n" +
                        "</ul>\n")
    }

    @TestCase
    public func looseNested2(): Unit {
        assertRendering("- a\n" +
                        "  - b\n" +
                        "\n" +
                        "    c\n" +
                        "- d\n",
                "<ul>\n" +
                        "<li>a\n" +
                        "<ul>\n" +
                        "<li>\n" +
                        "<p>b</p>\n" +
                        "<p>c</p>\n" +
                        "</li>\n" +
                        "</ul>\n" +
                        "</li>\n" +
                        "<li>d</li>\n" +
                        "</ul>\n")
    }

    @TestCase
    public func looseOuter(): Unit {
        assertRendering("- foo\n" +
                        "  - bar\n" +
                        "\n" +
                        "\n" +
                        "  baz",
                "<ul>\n" +
                        "<li>\n" +
                        "<p>foo</p>\n" +
                        "<ul>\n" +
                        "<li>bar</li>\n" +
                        "</ul>\n" +
                        "<p>baz</p>\n" +
                        "</li>\n" +
                        "</ul>\n")
    }

    @TestCase
    public func looseListItem(): Unit {
        assertRendering("- one\n" +
                        "\n" +
                        "  two\n",
                "<ul>\n" +
                        "<li>\n" +
                        "<p>one</p>\n" +
                        "<p>two</p>\n" +
                        "</li>\n" +
                        "</ul>\n")
    }

    @TestCase
    public func tightWithBlankLineAfter(): Unit {
        assertRendering("- foo\n" +
                        "- bar\n" +
                        "\n",
                "<ul>\n" +
                        "<li>foo</li>\n" +
                        "<li>bar</li>\n" +
                        "</ul>\n")
    }

    @TestCase
    public func tightListWithCodeBlock(): Unit {
        assertRendering("- a\n" +
                        "- ```\n" +
                        "  b\n" +
                        "\n" +
                        "\n" +
                        "  ```\n" +
                        "- c\n",
                "<ul>\n" +
                        "<li>a</li>\n" +
                        "<li>\n" +
                        "<pre><code>b\n" +
                        "\n" +
                        "\n" +
                        "</code></pre>\n" +
                        "</li>\n" +
                        "<li>c</li>\n" +
                        "</ul>\n")
    }

    @TestCase
    public func tightListWithCodeBlock2(): Unit {
        assertRendering("* foo\n" +
                        "  ```\n" +
                        "  bar\n" +
                        "\n" +
                        "  ```\n" +
                        "  baz\n",
                "<ul>\n" +
                        "<li>foo\n" +
                        "<pre><code>bar\n" +
                        "\n" +
                        "</code></pre>\n" +
                        "baz</li>\n" +
                        "</ul>\n")
    }

    @TestCase
    public func looseEmptyListItem(): Unit {
        assertRendering("* a\n" +
                        "*\n" +
                        "\n" +
                        "* c",
                "<ul>\n" +
                        "<li>\n" +
                        "<p>a</p>\n" +
                        "</li>\n" +
                        "<li></li>\n" +
                        "<li>\n" +
                        "<p>c</p>\n" +
                        "</li>\n" +
                        "</ul>\n")
    }

    @TestCase
    public func looseBlankLineAfterCodeBlock(): Unit {
        assertRendering("1. ```\n" +
                        "   foo\n" +
                        "   ```\n" +
                        "\n" +
                        "   bar",
                "<ol>\n" +
                        "<li>\n" +
                        "<pre><code>foo\n" +
                        "</code></pre>\n" +
                        "<p>bar</p>\n" +
                        "</li>\n" +
                        "</ol>\n")
    }
    
    func render(source: String): String {
        return RENDERER.render(PARSER.parse(source))
    }

    func assertRendering(source: String, expectedResult: String): Unit {
        let renderedContent: String = render(source)
        let expected: String = showTabs(expectedResult + "\n\n" + source)
        let actual: String = showTabs(renderedContent + "\n\n" + source)
        assertEquals(expected, actual)
    }

    func showTabs(s: String): String {
        // Tabs are shown as "rightwards arrow" for easier comparison
        return s.replace("\t", "\u{2192}")
    }

}
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
public class FencedCodeBlockParserTest {
    private static let PARSER: Parser = Parser.builder().build()
    private static let RENDERER: HtmlRenderer = HtmlRenderer.builder().build()

    @TestCase
    public func backtickInfo(): Unit {
        let document: Node = PARSER.parse("```info ~ test\ncode\n```")
        let codeBlock: FencedCodeBlock = (document.getFirstChild()() as FencedCodeBlock)()
        assertEquals("info ~ test", codeBlock.getInfo())
        assertEquals("code\n", codeBlock.getLiteral())
    }

    @TestCase
    public func backtickInfoDoesntAllowBacktick(): Unit {
        assertRendering("```info ` test\ncode\n```", "<p>```info ` test\ncode</p>\n<pre><code></code></pre>\n")
    }

    @TestCase
    public func backtickAndTildeCantBeMixed(): Unit {
        assertRendering("``~`\ncode\n``~`", "<p><code>~` code </code>~`</p>\n")
    }

    @TestCase
    public func closingCanHaveSpacesAfter(): Unit {
        assertRendering("```\ncode\n```   ", "<pre><code>code\n</code></pre>\n")
    }

    @TestCase
    public func closingCanNotHaveNonSpaces(): Unit {
        assertRendering("```\ncode\n``` a", "<pre><code>code\n``` a\n</code></pre>\n")
    }

    @TestCase
    public func issue151(): Unit {
        assertRendering(
            "```\nthis code\n\nshould not have BRs or paragraphs in it\nok\n```",
            "<pre><code>this code\n" + "\n" + "should not have BRs or paragraphs in it\n" + "ok\n" + "</code></pre>\n"
        )
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

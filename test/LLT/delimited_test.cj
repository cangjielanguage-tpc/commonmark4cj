// DEPENDENCE: z_test.cj
// EXEC: cjc %import-path %L %l %f z_test.cj -Woff unused
// EXEC: ./main

import commonmark4cj.commonmark.*
import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import std.reflect.{TypeInfo}

main() {
    let tester = DelimitedTest()
    tester.emphasisDelimiters()
    tester.delimiterOpenCloseProcessorCanUseCustomPunctuation()
    tester.delimiterOpenCloseProcessorCanRelaxFlanking()
    return 0
}

class DelimitedAbstractVisitor <: AbstractVisitor {
    var list: ArrayList<Delimited> = ArrayList<Delimited>()

    init(list: ArrayList<Delimited>) {
        this.list = list
    }
    public override func visit(node: Emphasis) {
        list.add(node)
    }
    public override func visit(node: StrongEmphasis) {
        list.add(node)
    }
}

@Test
public class DelimitedTest {
    @TestCase
    public func emphasisDelimiters(): Unit {
        let input: String = "* *emphasis* \n" + "* **strong** \n" + "* _important_ \n" + "* __CRITICAL__ \n"

        let parser: Parser = Parser.builder().build()
        let document: Node = parser.parse(input)

        let list: ArrayList<Delimited> = ArrayList<Delimited>()

        let visitor: DelimitedAbstractVisitor = DelimitedAbstractVisitor(list)
        document.accept(visitor)

        assertEquals(4, list.size)

        let emphasis: Delimited = list.get(0)()
        let strong: Delimited = list.get(1)()
        let important: Delimited = list.get(2)()
        let critical: Delimited = list.get(3)()

        assertEquals("*", emphasis.getOpeningDelimiter()())
        assertEquals("*", emphasis.getClosingDelimiter()())
        assertEquals("**", strong.getOpeningDelimiter()())
        assertEquals("**", strong.getClosingDelimiter()())
        assertEquals("_", important.getOpeningDelimiter()())
        assertEquals("_", important.getClosingDelimiter()())
        assertEquals("__", critical.getOpeningDelimiter()())
        assertEquals("__", critical.getClosingDelimiter()())
    }

    @TestCase
    public func delimiterOpenCloseProcessorCanUseCustomPunctuation(): Unit {
        let renderer: HtmlRenderer = HtmlRenderer.builder().escapeHtml(true).build()
        let strictParser: Parser = Parser.builder().build()
        let parser: Parser = Parser.builder().delimiterOpenCloseProcessor(
            {
                context: DelimiterOpenCloseContext =>
                    if (context.delimiterChar() == r'*') {
                        return context.defaultResultWith(isAsciiPunctuation, Characters.isWhitespaceCodePoint)
                    }
                    return None
            }
        ).build()

        let adjacentPunctuation = "alpha**《beta》**."
        assertEquals("<p>alpha<strong>《beta》</strong>.</p>\n", renderer.render(parser.parse(adjacentPunctuation)))
        assertEquals("<p>alpha**《beta》**.</p>\n", renderer.render(strictParser.parse(adjacentPunctuation)))

        assertEquals(
            "<p><strong>《Sample Report》</strong>.</p>\n",
            renderer.render(parser.parse("**《Sample Report》**."))
        )
        assertEquals(
            "<p><strong>《Sample Report》</strong>.</p>\n",
            renderer.render(strictParser.parse("**《Sample Report》**."))
        )
        assertEquals("<p>** spaced **.</p>\n", renderer.render(parser.parse("** spaced **.")))
    }

    @TestCase
    public func delimiterOpenCloseProcessorCanRelaxFlanking(): Unit {
        let renderer: HtmlRenderer = HtmlRenderer.builder().escapeHtml(true).build()
        let parser: Parser = Parser.builder().delimiterOpenCloseProcessor(
            {
                context: DelimiterOpenCloseContext =>
                    if (context.delimiterChar() == r'*' && context.delimiterCount() >= 2 &&
                        context.delimiterProcessor().getOpeningCharacter() == r'*' &&
                        context.delimiterProcessor().getClosingCharacter() == r'*') {
                        return DelimiterOpenCloseResult.of(true, true)
                    }
                    return None
            }
        ).build()
        let strictParser: Parser = Parser.builder().build()

        assertEquals(
            "<p><strong>《Sample Report》</strong></p>\n",
            renderer.render(parser.parse("**《Sample Report》**"))
        )
        assertEquals(
            "<p><strong>《Sample Report》</strong></p>\n",
            renderer.render(strictParser.parse("**《Sample Report》**"))
        )

        assertEquals(
            "<p><strong> 《Sample Report》 </strong></p>\n",
            renderer.render(parser.parse("** 《Sample Report》 **"))
        )
        assertEquals(
            "<p>** 《Sample Report》 **</p>\n",
            renderer.render(strictParser.parse("** 《Sample Report》 **"))
        )
        assertEquals("<p>a* bc *d</p>\n", renderer.render(parser.parse("a* bc *d")))
        assertEquals("<p>a__bc__d</p>\n", renderer.render(parser.parse("a__bc__d")))
        assertEquals("<p><em><strong> spaced </strong></em>.</p>\n", renderer.render(parser.parse("*** spaced ***.")))

        assertEquals(
            "<p>The file is <strong>《Sample Report》</strong>.</p>\n",
            renderer.render(parser.parse("The file is **《Sample Report》**."))
        )
        assertEquals(
            "<p>The file is <strong> 《Sample Report》 </strong>.</p>\n",
            renderer.render(parser.parse("The file is ** 《Sample Report》 **."))
        )

        assertEquals(
            "<p><strong>《Sample Report》</strong>suffix.</p>\n",
            renderer.render(parser.parse("**《Sample Report》**suffix."))
        )
        assertEquals(
            "<p><strong> 《Sample Report》 </strong>suffix.</p>\n",
            renderer.render(parser.parse("** 《Sample Report》 **suffix."))
        )

        assertEquals(
            "<p>prefix<strong>bold content</strong>suffix</p>\n",
            renderer.render(parser.parse("prefix**bold content**suffix"))
        )
        assertEquals(
            "<p>prefix <strong>bold content</strong> suffix</p>\n",
            renderer.render(parser.parse("prefix **bold content** suffix"))
        )
        assertEquals(
            "<p>prefix<strong>safe, standard, and transparent use</strong>suffix</p>\n",
            renderer.render(parser.parse("prefix**safe, standard, and transparent use**suffix"))
        )

        assertEquals(
            "<p><strong>safe, standard, and transparent use</strong>, then plain text.</p>\n",
            renderer.render(parser.parse("**safe, standard, and transparent use**, then plain text."))
        )
        assertEquals(
            "<p>multiple strong: <strong>first</strong>, plain text, <strong>second</strong>.</p>\n",
            renderer.render(parser.parse("multiple strong: **first**, plain text, **second**."))
        )
        assertEquals(
            "<p>punctuation in strong: <strong>《Report》: safe, standard, transparent.</strong></p>\n",
            renderer.render(parser.parse("punctuation in strong: **《Report》: safe, standard, transparent.**"))
        )
        assertEquals("<p>**unclosed strong</p>\n", renderer.render(parser.parse("**unclosed strong")))
        assertEquals(
            "<p>inline code should not render strong: <code>**keep asterisks**</code></p>\n",
            renderer.render(parser.parse("inline code should not render strong: `**keep asterisks**`"))
        )
        assertEquals(
            "<p>code block should not render strong:</p>\n<pre><code class=\"language-js\">const text = &quot;**keep asterisks**&quot;\n</code></pre>\n",
            renderer.render(parser.parse("code block should not render strong:\n```js\nconst text = \"**keep asterisks**\"\n```"))
        )
    }
}

func isAsciiPunctuation(codePoint: Rune): Bool {
    match {
        case r'!' <= codePoint && codePoint <= r'.' => return true
        case r':' <= codePoint && codePoint <= r'@' => return true
        case r'[' <= codePoint && codePoint <= r'`' => return true
        case r'{' <= codePoint && codePoint <= r'~' => return true
        case _ => return false
    }
}

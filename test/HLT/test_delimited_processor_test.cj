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
public class DelimiterProcessorTest {
    private static let PARSER: Parser = Parser.builder().customDelimiterProcessor(AsymmetricDelimiterProcessor()).build(
    )
    private static let RENDERER: HtmlRenderer = HtmlRenderer.builder().nodeRendererFactory(
        {
        context => UpperCaseNodeRenderer(context)
    }).build()

    @TestCase
    public func delimiterProcessorWithInvalidDelimiterUse(): Unit {
        let parser: Parser = Parser.builder().customDelimiterProcessor(CustomDelimiterProcessor(r':', 0)).
            customDelimiterProcessor(CustomDelimiterProcessor(r';', -1)).build()
        assertEquals("<p>:test:</p>\n", RENDERER.render(parser.parse(":test:")))
        assertEquals("<p>;test;</p>\n", RENDERER.render(parser.parse(";test;")))
    }

    @TestCase
    public func asymmetricDelimiter(): Unit {
        assertRendering("{foo} bar", "<p>FOO bar</p>\n")
        assertRendering("f{oo ba}r", "<p>fOO BAr</p>\n")
        assertRendering("{{foo} bar", "<p>{FOO bar</p>\n")
        assertRendering("{foo}} bar", "<p>FOO} bar</p>\n")
        assertRendering("{{foo} bar}", "<p>FOO BAR</p>\n")
        assertRendering("{foo bar", "<p>{foo bar</p>\n")
        assertRendering("foo} bar", "<p>foo} bar</p>\n")
        assertRendering("}foo} bar", "<p>}foo} bar</p>\n")
        assertRendering("{foo{ bar", "<p>{foo{ bar</p>\n")
        assertRendering("}foo{ bar", "<p>}foo{ bar</p>\n")
        assertRendering("{} {foo}", "<p> FOO</p>\n")
    }

    @TestCase
    public func multipleDelimitersWithDifferentLengths(): Unit {
        let parser: Parser = Parser.builder().customDelimiterProcessor(OneDelimiterProcessor()).customDelimiterProcessor(
            TwoDelimiterProcessor()).build()
        assertEquals("<p>(1)one(/1) (2)two(/2)</p>\n", RENDERER.render(parser.parse("+one+ ++two++")))
        assertEquals("<p>(1)(2)both(/2)(/1)</p>\n", RENDERER.render(parser.parse("+++both+++")))
    }

    func render(source: String): String {
        let node: Node = PARSER.parse(source)
        return RENDERER.render(node)
    }

    public func assertRendering(source: String, expectedResult: String): Unit {
        let renderedContent: String = render(source)
        // include source for better assertion errors
        let expected: String = showTabs(expectedResult + "\n\n" + source)
        let actual: String = showTabs(renderedContent + "\n\n" + source)
        assertEquals(expected, actual)
    }

    public func showTabs(s: String): String {
        // Tabs are shown as "rightwards arrow" for easier comparison
        return s.replace("\t", "\u{2192}")
    }
}

class CustomDelimiterProcessor <: DelimiterProcessor {
    private let delimiterChar: Rune
    private let delimiterUse: Int64

    init(delimiterChar: Rune, delimiterUse: Int64) {
        this.delimiterChar = delimiterChar
        this.delimiterUse = delimiterUse
    }

    public override func getOpeningCharacter(): Rune {
        return delimiterChar
    }

    public override func getClosingCharacter(): Rune {
        return delimiterChar
    }

    public override func getMinLength(): Int64 {
        return 1
    }

    public func getDelimiterUse(_: DelimiterRun, _: DelimiterRun): Int64 {
        return delimiterUse
    }

    public func process(openingRun: DelimiterRun, closingRun: DelimiterRun): Int {
        let opener = openingRun.getOpener()
        let closer = closingRun.getCloser()
        let use = getDelimiterUse(openingRun, closingRun)
        process(opener ,closer, use)
        return use
    }
    public func process(opener: Text, closer: Text, delimiterUse: Int64): Unit {
    }
}

class AsymmetricDelimiterProcessor <: DelimiterProcessor {
    public override func getOpeningCharacter(): Rune {
        return r'{'
    }

    public override func getClosingCharacter(): Rune {
        return r'}'
    }

    public override func getMinLength(): Int64 {
        return 1
    }

    public func getDelimiterUse(_: DelimiterRun, _: DelimiterRun): Int64 {
        return 1
    }

    public func process(openingRun: DelimiterRun, closingRun: DelimiterRun): Int {
        let opener = openingRun.getOpener()
        let closer = closingRun.getCloser()
        let use = getDelimiterUse(openingRun, closingRun)
        process(opener ,closer, use)
        return use
    }
    public func process(opener: Text, closer: Text, delimiterUse: Int64): Unit {
        var content: UpperCaseNode = UpperCaseNode()
        var tmp: ?Node = opener.getNext()
        while (tmp.isSome() && tmp != closer) {
            let next: Node = tmp().getNext()()
            content.appendChild(tmp())
            tmp = next
        }
        opener.insertAfter(content)
    }
}

class UpperCaseNode <: CustomNode {public func getNodeType():NodeType{"UpperCaseNode"}}

class UpperCaseNodeRenderer <: NodeRenderer {
    private let context: HtmlNodeRendererContext

    public init(context: HtmlNodeRendererContext) {
        this.context = context
    }

    public override func getNodeTypes(): HashSet<NodeType> {
        return HashSet<NodeType>(["UpperCaseNode"])
    }

    public override func render(node: Node): Unit {
        let upperCaseNode: UpperCaseNode = (node as UpperCaseNode)()
        var child: ?Node = upperCaseNode.getFirstChild()
        while (child.isSome()) {
            if (child() is Text) {
                var text: Text = (child() as Text)()
                text.setLiteral(text.getLiteral().toUpper())
            }
            context.render(child())
            child = child().getNext()
        }
    }
}

class OneDelimiterProcessor <: DelimiterProcessor {
    public override func getOpeningCharacter(): Rune {
        return r'+'
    }

    public override func getClosingCharacter(): Rune {
        return r'+'
    }

    public override func getMinLength(): Int64 {
        return 1
    }

    public func getDelimiterUse(_: DelimiterRun, _: DelimiterRun): Int64 {
        return 1
    }

    public func process(openingRun: DelimiterRun, closingRun: DelimiterRun): Int {
        let opener = openingRun.getOpener()
        let closer = closingRun.getCloser()
        let use = getDelimiterUse(openingRun, closingRun)
        process(opener ,closer, use)
        return use
    }
    public func process(opener: Text, closer: Text, delimiterUse: Int64): Unit {
        opener.insertAfter(Text("(1)"))
        closer.insertBefore(Text("(/1)"))
    }
}

class TwoDelimiterProcessor <: DelimiterProcessor {
    public override func getOpeningCharacter(): Rune {
        return r'+'
    }

    public override func getClosingCharacter(): Rune {
        return r'+'
    }

    public override func getMinLength(): Int64 {
        return 2
    }

    public func getDelimiterUse(_: DelimiterRun, _: DelimiterRun): Int64 {
        return 2
    }

    public func process(openingRun: DelimiterRun, closingRun: DelimiterRun): Int {
        let opener = openingRun.getOpener()
        let closer = closingRun.getCloser()
        let use = getDelimiterUse(openingRun, closingRun)
        process(opener ,closer, use)
        return use
    }
    public func process(opener: Text, closer: Text, delimiterUse: Int64): Unit {
        opener.insertAfter(Text("(2)"))
        closer.insertBefore(Text("(/2)"))
    }
}

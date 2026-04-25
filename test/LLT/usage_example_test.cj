// DEPENDENCE: z_test.cj
// EXEC: cjc %import-path %L %l %f z_test.cj -Woff unused
// EXEC: ./main

import commonmark4cj.commonmark.*
import std.unittest.*
import std.unittest.testmacro.*
import std.regex.*
import std.collection.*

main() {
    let tester = UsageExampleTest()
    tester.parseAndRender()
    tester.visitor()
    tester.addAttributes()
    tester.customizeRendering()
    return 0
}

@Test
public class UsageExampleTest {
    @TestCase
    public func parseAndRender(): Unit {
        let parser: Parser = Parser.builder().build()
        let document: Node = parser.parse("This is *Sparta*")
        let renderer: HtmlRenderer = HtmlRenderer.builder().escapeHtml(true).build()
        assertEquals("<p>This is <em>Sparta</em></p>\n", renderer.render(document))
    }

    @TestCase
    public func visitor(): Unit {
        let parser: Parser = Parser.builder().build()
        let node: Node = parser.parse("Example\n=======\n\nSome more text")
        let visitor: WordCountVisitor = WordCountVisitor()
        node.accept(visitor)
        assertEquals(4, visitor.wordCount)
    }

    @TestCase
    public func addAttributes(): Unit {
        let parser: Parser = Parser.builder().build()
        let factory: AttributeProviderFactory = {context: AttributeProviderContext => ImageAttributeProvider()}
        let renderer: HtmlRenderer = HtmlRenderer.builder().attributeProviderFactory(factory).build()

        let document: Node = parser.parse("![text](/url.png)")
        assertEquals(
            "<p><img src=\"/url.png\" alt=\"text\" class=\"border\" /></p>\n",
            renderer.render(document)
        )
    }

    @TestCase
    public func customizeRendering(): Unit {
        let parser: Parser = Parser.builder().build()
        let factory: HtmlNodeRendererFactory = {context: HtmlNodeRendererContext => IndentedCodeBlockNodeRenderer(
                context)}
        let renderer: HtmlRenderer = HtmlRenderer.builder().nodeRendererFactory(factory).build()

        let document: Node = parser.parse("Example:\n\n    code")
        assertEquals("<p>Example:</p>\n<pre>code\n</pre>\n", renderer.render(document))
    }
}

class WordCountVisitor <: AbstractVisitor {
    var wordCount: Int64 = 0

    public override func visit(text: Text): Unit {
        wordCount += Matcher(Regex("\\W+"), text.getLiteral()).split().size
        visitChildren(text)
    }
}

class ImageAttributeProvider <: AttributeProvider {
    public override func setAttributes(node: Node, tagName: String, attributes: HashMap<String, String>): Unit {
        if (node is Image) {
            attributes.add("class", "border")
        }
    }
}

class IndentedCodeBlockNodeRenderer <: NodeRenderer {
    private let html: HtmlWriter

    init(context: HtmlNodeRendererContext) {
        this.html = context.getWriter()
    }

    public override func getNodeTypes(): HashSet<NodeType> {
        // Return the node types we want to use this renderer for.
        return HashSet<NodeType>(["IndentedCodeBlock"])
    }

    public override func render(node: Node): Unit {
        // We only handle one type as per getNodeTypes, so we can just cast it here.
        let codeBlock: IndentedCodeBlock = (node as IndentedCodeBlock)()
        html.line()
        html.tag("pre")
        html.text(codeBlock.getLiteral())
        html.tag("/pre")
        html.line()
    }
}

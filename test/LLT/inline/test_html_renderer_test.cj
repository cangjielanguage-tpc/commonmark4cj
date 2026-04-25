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

// sources_file: spec.txt   

@Test
public class HtmlRendererTest {
    @TestCase
    public func htmlAllowingShouldNotEscapeInlineHtml(): Unit {
        let rendered: String = htmlAllowingRenderer().render(
            parse("paragraph with <span id='foo' class=\"bar\">inline &amp; html</span>"))
        assertEquals("<p>paragraph with <span id='foo' class=\"bar\">inline &amp; html</span></p>\n", rendered)
    }

    @TestCase
    public func htmlAllowingShouldNotEscapeBlockHtml(): Unit {
        let rendered: String = htmlAllowingRenderer().render(parse("<div id='foo' class=\"bar\">block &amp;</div>"))
        assertEquals("<div id='foo' class=\"bar\">block &amp;</div>\n", rendered)
    }

    @TestCase
    public func htmlEscapingShouldEscapeInlineHtml(): Unit {
        let rendered: String = htmlEscapingRenderer().render(
            parse("paragraph with <span id='foo' class=\"bar\">inline &amp; html</span>"))
        // Note that &amp; is not escaped, as it's a normal text node, not part of the inline HTML.
        assertEquals(
            "<p>paragraph with &lt;span id='foo' class=&quot;bar&quot;&gt;inline &amp; html&lt;/span&gt;</p>\n",
            rendered
        )
    }

    @TestCase
    public func htmlEscapingShouldEscapeHtmlBlocks(): Unit {
        let rendered: String = htmlEscapingRenderer().render(parse("<div id='foo' class=\"bar\">block &amp;</div>"))
        assertEquals("<p>&lt;div id='foo' class=&quot;bar&quot;&gt;block &amp;amp;&lt;/div&gt;</p>\n", rendered)
    }

    @TestCase
    public func textEscaping(): Unit {
        let rendered: String = defaultRenderer().render(parse("escaping: & < > \" '"))
        assertEquals("<p>escaping: &amp; &lt; &gt; &quot; '</p>\n", rendered)
    }

    @TestCase
    public func attributeEscaping(): Unit {
        let paragraph: Paragraph = Paragraph()
        let link: Link = Link("&colon;", None)
        link.setDestination("&colon;")
        paragraph.appendChild(link)
        assertEquals("<p><a href=\"&amp;colon;\"></a></p>\n", defaultRenderer().render(paragraph))
    }

    @TestCase
    public func percentEncodeUrlDisabled(): Unit {
        assertEquals("<p><a href=\"foo&amp;bar\">a</a></p>\n", defaultRenderer().render(parse("[a](foo&amp;bar)")))
        assertEquals("<p><a href=\"ä\">a</a></p>\n", defaultRenderer().render(parse("[a](ä)")))
        assertEquals("<p><a href=\"foo%20bar\">a</a></p>\n", defaultRenderer().render(parse("[a](foo%20bar)")))
    }

    @TestCase
    public func percentEncodeUrl(): Unit {
        // Entities are escaped anyway
        assertEquals(
            "<p><a href=\"foo&amp;bar\">a</a></p>\n",
            percentEncodingRenderer().render(parse("[a](foo&amp;bar)"))
        )
        // Existing encoding is preserved
        assertEquals("<p><a href=\"foo%20bar\">a</a></p>\n", percentEncodingRenderer().render(parse("[a](foo%20bar)")))
        assertEquals("<p><a href=\"foo%61\">a</a></p>\n", percentEncodingRenderer().render(parse("[a](foo%61)")))
        // Invalid encoding is escaped
        assertEquals("<p><a href=\"foo%25\">a</a></p>\n", percentEncodingRenderer().render(parse("[a](foo%)")))
        assertEquals("<p><a href=\"foo%25a\">a</a></p>\n", percentEncodingRenderer().render(parse("[a](foo%a)")))
        assertEquals("<p><a href=\"foo%25a_\">a</a></p>\n", percentEncodingRenderer().render(parse("[a](foo%a_)")))
        assertEquals("<p><a href=\"foo%25xx\">a</a></p>\n", percentEncodingRenderer().render(parse("[a](foo%xx)")))
        // Reserved characters are preserved, except for '[' and ']'
        assertEquals(
            "<p><a href=\"!*'();:@&amp;=+$,/?#%5B%5D\">a</a></p>\n",
            percentEncodingRenderer().render(parse("[a](!*'();:@&=+$,/?#[])"))
        )
        // Unreserved characters are preserved
        assertEquals(
            "<p><a href=\"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.~\">a</a></p>\n",
            percentEncodingRenderer().render(
                parse("[a](ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.~)"))
        )
        // Other characters are percent-encoded (LATIN SMALL LETTER A WITH DIAERESIS)
        assertEquals(
            "<p><a href=\"%C3%A4\">a</a></p>\n",
            percentEncodingRenderer().render(parse("[a](ä)"))
        )
        // Other characters are percent-encoded (MUSICAL SYMBOL G CLEF, surrogate pair in UTF-16)
        assertEquals(
            "<p><a href=\"%F0%9D%84%9E\">a</a></p>\n",
            percentEncodingRenderer().render(parse("[a](\u{1D11E})"))
        )
    }

    @TestCase
    public func attributeProviderForCodeBlock(): Unit {
        let custom: AttributeProviderFactory = {_: AttributeProviderContext => AttributeProvider2()}
        let renderer: HtmlRenderer = HtmlRenderer.builder().attributeProviderFactory(custom).build()
        let rendered: String = renderer.render(parse("```info\ncontent\n```"))
        assertEquals("<pre data-code-block=\"fenced\"><code data-custom=\"info\">content\n</code></pre>\n", rendered)
        let rendered2: String = renderer.render(parse("```evil\"\ncontent\n```"))
        assertEquals(
            "<pre data-code-block=\"fenced\"><code data-custom=\"evil&quot;\">content\n</code></pre>\n",
            rendered2
        )
    }

    @TestCase
    public func attributeProviderForImage(): Unit {
        let custom: AttributeProviderFactory = {_: AttributeProviderContext => AttributeProvider3()}
        let renderer: HtmlRenderer = HtmlRenderer.builder().attributeProviderFactory(custom).build()
        let rendered: String = renderer.render(parse("![foo](/url)\n"))
        assertEquals("<p><img src=\"/url\" test=\"hey\" /></p>\n", rendered)
    }

    @TestCase
    public func attributeProviderFactoryNewInstanceForEachRender(): Unit {
        let factory: AttributeProviderFactory = {_: AttributeProviderContext => AttributeProvider1()}
        let renderer: HtmlRenderer = HtmlRenderer.builder().attributeProviderFactory(factory).build()
        let rendered: String = renderer.render(parse("text node"))
        let secondPass: String = renderer.render(parse("text node"))
        assertEquals(rendered, secondPass)
    }

    @TestCase
    public func overrideNodeRender(): Unit {
        let nodeRendererFactory: HtmlNodeRendererFactory = {
            context: HtmlNodeRendererContext => NodeRendererImpl(context)
        }
        let renderer: HtmlRenderer = HtmlRenderer.builder().nodeRendererFactory(nodeRendererFactory).build()
        let rendered: String = renderer.render(parse("foo [bar](/url)"))
        assertEquals("<p>foo test</p>\n", rendered)
    }

    @TestCase
    public func orderedListStartZero(): Unit {
        assertEquals("<ol start=\"0\">\n<li>Test</li>\n</ol>\n", defaultRenderer().render(parse("0. Test\n")))
    }

    @TestCase
    public func imageAltTextWithSoftLineBreak(): Unit {
        assertEquals(
            "<p><img src=\"/url\" alt=\"foo\nbar\" /></p>\n",
            defaultRenderer().render(parse("![foo\nbar](/url)\n"))
        )
    }

    @TestCase
    public func imageAltTextWithHardLineBreak(): Unit {
        assertEquals(
            "<p><img src=\"/url\" alt=\"foo\nbar\" /></p>\n",
            defaultRenderer().render(parse("![foo  \nbar](/url)\n"))
        )
    }

    @TestCase
    public func imageAltTextWithEntities(): Unit {
        assertEquals(
            "<p><img src=\"/url\" alt=\"foo \u{00E4}\" /></p>\n",
            defaultRenderer().render(parse("![foo &auml;](/url)\n"))
        )
    }

    @TestCase
    public func canRenderContentsOfSingleParagraph(): Unit {
        let paragraphs: Node = parse("Here I have a test [link](http://www.google.com)")
        let paragraph: Node = paragraphs.getFirstChild()()
        let document: Document = Document()
        var child: ?Node = paragraph.getFirstChild()
        while (child.isSome()) {
            let current: Node = child()
            child = current.getNext()
            document.appendChild(current)
        }

        assertEquals(
            "Here I have a test <a href=\"http://www.google.com\">link</a>",
            defaultRenderer().render(document)
        )
    }

    @TestCase
    public func threading(): Unit {
        let parser: Parser = Parser.builder().inlineParserFactory(InlineParserV2Factory()).build()
        let spec: String = String.fromUtf8(File.readFrom("spec.txt"))
        let document: Node = parser.parse(spec)
        let htmlRenderer: HtmlRenderer = HtmlRenderer.builder().build()
        let expectedRendering: String = htmlRenderer.render(document)
        // Render in parallel using the same HtmlRenderer instance.
        Range(0, 40, 1, true, false, false) |> map<Int, Future<String>> {
            _ => spawn {
                htmlRenderer.render(document)
            }
        } |> forEach<Future<String>> {f => @Assert(f.get(), expectedRendering)}
    }

    private func defaultRenderer(): HtmlRenderer {
        return HtmlRenderer.builder().build()
    }

    private func htmlAllowingRenderer(): HtmlRenderer {
        return HtmlRenderer.builder().escapeHtml(false).build()
    }

    private func htmlEscapingRenderer(): HtmlRenderer {
        return HtmlRenderer.builder().escapeHtml(true).build()
    }

    private func percentEncodingRenderer(): HtmlRenderer {
        return HtmlRenderer.builder().percentEncodeUrls(true).build()
    }

    private func parse(source: String): Node {
        return Parser.builder().inlineParserFactory(InlineParserV2Factory()).build().parse(source)
    }
}

class NodeRendererImpl <: NodeRenderer {
    let context: HtmlNodeRendererContext
    init(context: HtmlNodeRendererContext) {
        this.context = context
    }
    public func getNodeTypes(): HashSet<NodeType> {
        return HashSet<NodeType>(["Link"])
    }
    public func render(_: Node): Unit {
        context.getWriter().text("test")
    }
}

class AttributeProvider1 <: AttributeProvider {
    var i: Int = 0
    public func setAttributes(_: Node, _: String, attributes: HashMap<String, String>): Unit {
        attributes.add("key", i.toString())
        i++
    }
}

class AttributeProvider2 <: AttributeProvider {
    public func setAttributes(node: Node, tagName: String, attributes: HashMap<String, String>): Unit {
        if (node is FencedCodeBlock && tagName == "code") {
            let fencedCodeBlock: FencedCodeBlock = (node as FencedCodeBlock)()
            // Remove the default attribute for info
            attributes.remove("class")
            // Put info in custom attribute instead
            attributes.add("data-custom", fencedCodeBlock.getInfo())
        } else if (node is FencedCodeBlock && tagName == "pre") {
            attributes.add("data-code-block", "fenced")
        }
    }
}

class AttributeProvider3 <: AttributeProvider {
    public func setAttributes(node: Node, _: String, attributes: HashMap<String, String>): Unit {
        if (node is Image) {
            attributes.remove("alt")
            attributes.add("test", "hey")
        }
    }
}

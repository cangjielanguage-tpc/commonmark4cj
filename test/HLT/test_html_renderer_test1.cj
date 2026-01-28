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
public class HtmlRendererTest {
    @TestCase
    public func htmlAllowingShouldNotEscapeInlineHtml01(): Unit {
        let html = HtmlRenderer.builder().escapeHtml(false).build()
        let PARSER = Parser.builder().build()
        let rendered: String = html.render(
            PARSER.parse("paragraph with <span id='foo' class=\"bar\">inline &amp; html</span>"))
        var string = "<p>paragraph with <span id='foo' class=\"bar\">inline &amp; html</span></p>\n"
        @Assert(string, rendered)
    }

    @TestCase
    public func htmlAllowingShouldNotEscapeInlineHtml11(): Unit {
        let html = HtmlRenderer.builder().escapeHtml(false).build()
        let PARSER = Parser.builder().build()
        let rendered: String = html.render(PARSER.parse("nihao仓颉0.49.2"))
        var string = "<p>nihao仓颉0.49.2</p>\n"
        @Assert(string, rendered)
    }

    @TestCase
    public func htmlAllowingShouldNotEscapeInlineHtml12(): Unit {
        let html = HtmlRenderer.builder().escapeHtml(false).build()
        let PARSER = Parser.builder().build()
        let rendered: String = html.render(PARSER.parse(""))
        @Assert(0, rendered.size)
    }

    @TestCase
    public func htmlAllowingShouldNotEscapeInlineHtml02(): Unit {
        let stringBuilder = StringBuilder()
        let html = HtmlRenderer.builder().escapeHtml(true).build()
        let PARSER = Parser.builder().build()
        html.render(PARSER.parse("paragraph with <span id='foo' class=\"bar\">inline &amp; html</span>"), stringBuilder)
        let rendered: String = html.render(
            PARSER.parse("paragraph with <span id='foo' class=\"bar\">inline &amp; html</span>"))
        var string = "<p>paragraph with &lt;span id='foo' class=&quot;bar&quot;&gt;inline &amp; html&lt;/span&gt;</p>\n"
        @Assert(rendered,string)
    }

    @TestCase
    public func htmlAllowingShouldNotEscapeInlineHtml03(): Unit {
        let html = HtmlRenderer.builder().escapeHtml(false).softbreak("nihao").build()
        let PARSER = Parser.builder().build()
        let rendered: String = html.render(
            PARSER.parse("paragraph with <span id='foo' class=\"bar\">inline &amp; html</span>"))
        var string = "<p>paragraph with <span id='foo' class=\"bar\">inline &amp; html</span></p>\n"
        @Assert(string, rendered)
    }

    @TestCase
    public func htmlAllowingShouldNotEscapeInlineHtml04(): Unit {
        let html = HtmlRenderer.builder().escapeHtml(false).softbreak("nihao").percentEncodeUrls(true).build()
        let PARSER = Parser.builder().build()
        let rendered: String = html.render(
            PARSER.parse("paragraph with <span id='foo' class=\"bar\">inline &amp; html</span>"))
        var string = "<p>paragraph with <span id='foo' class=\"bar\">inline &amp; html</span></p>\n"
        @Assert(string, rendered)
    }

    @TestCase
    public func htmlAllowingShouldNotEscapeInlineHtml05(): Unit {
        let html = HtmlRenderer.builder().escapeHtml(false).softbreak("你好").percentEncodeUrls(false).build()
        let PARSER = Parser.builder().build()
        let rendered: String = html.render(
            PARSER.parse("paragraph with <span id='foo' class=\"bar\">inline &amp; html</span>"))
        var string = "<p>paragraph with <span id='foo' class=\"bar\">inline &amp; html</span></p>\n"
        @Assert(string, rendered)
    }

    @TestCase
    public func htmlAllowingShouldNotEscapeInlineHtml06(): Unit {
        let text = TextContentRenderer.builder().setStripNewlines(false).build()
        let PARSER = Parser.builder().build()
        let rendered: String = text.render(
            PARSER.parse("paragraph with <span id='foo' class=\"bar\">inline &amp; html</span>"))
        var string = "paragraph with <span id='foo' class=\"bar\">inline & html</span>"
        @Assert(string, rendered)
    }

    @TestCase
    public func htmlAllowingShouldNotEscapeInlineHtml07(): Unit {
        let text = TextContentRenderer.builder().setStripNewlines(true).build()
        let PARSER = Parser.builder().build()
        let rendered: String = text.render(
            PARSER.parse("paragraph with <span id='foo' class=\"bar\">inline &amp; html</span>"))
        var string = "paragraph with <span id='foo' class=\"bar\">inline & html</span>"
        @Assert(string, rendered)
    }
}

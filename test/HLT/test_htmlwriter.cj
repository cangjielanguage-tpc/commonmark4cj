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
        var map = HashMap<String, String>([("nihao", "cangjie")])
        let stringBuilder = StringBuilder()
        let html = HtmlWriter(stringBuilder)
        html.raw("nihao1")
        html.text("nihao1")
        html.tag("nihao1")
        html.tag("你好")
        html.tag("nihao仓颉#￥", map)
        html.tag("nihao仓颉#￥", map, true)
        html.line()
    }

    @TestCase
    public func htmlAllowingShouldNotEscapeInlineHtml02(): Unit {
        var a = 0
        try {
            var map = HashMap<String, String>([("你好", "你好")])
            let stringBuilder = StringBuilder()
            let html = HtmlWriter(stringBuilder)
            html.raw("你好")
            html.text("你好")
            html.tag("你好")
            html.tag("nihao仓颉#￥", map)
            html.tag("nihao仓颉#￥", map, true)
            html.line()
        } catch (e: Exception) {
        }
        @Assert(a,0)
    }

    @TestCase
    public func htmlAllowingShouldNotEscapeInlineHtml03(): Unit {
        var a = 0
        try {
            var map = HashMap<String, String>([("niaho1123", "cangjie")])
            let stringBuilder = StringBuilder()
            let html = HtmlWriter(stringBuilder)
            html.raw("niaho1123")
            html.text("niaho1123")
            html.tag("niaho1123")
            html.tag("nihao仓颉#￥", map)
            html.tag("nihao仓颉#￥", map, true)
            html.line()
        } catch (e: Exception) {
        }
        @Assert(a,0)
    }

    @TestCase
    public func htmlAllowingShouldNotEscapeInlineHtml04(): Unit {
        var a = 0
        try {
            var map = HashMap<String, String>([("nihao", "nihao仓颉")])
            let stringBuilder = StringBuilder()
            let html = HtmlWriter(stringBuilder)
            html.raw("nihao仓颉#￥")
            html.text("nihao仓颉#￥")
            html.tag("nihao仓颉#￥")
            html.tag("nihao仓颉#￥", map)
            html.tag("nihao仓颉#￥", map, true)
            html.line()
        } catch (e: Exception) {
        }
        @Assert(a,0)
    }

    @TestCase
    public func htmlAllowingShouldNotEscapeInlineHtml05(): Unit {
        var a = 0
        try {
            var map = HashMap<String, String>([("", "")])
            let stringBuilder = StringBuilder()
            let html = HtmlWriter(stringBuilder)
            html.raw("")
            html.text("")
            html.tag("")
            html.tag("", map)
            html.tag("", map, true)
            html.line()
        } catch (e: Exception) {
        }
        @Assert(a,0)
    }
}

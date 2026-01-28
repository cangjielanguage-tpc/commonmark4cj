// DEPENDENCE: z_test.cj
// EXEC: cjc %import-path %L %l %f z_test.cj -Woff unused
// EXEC: ./main

import commonmark4cj.commonmark.*
import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import std.collection.*

main(): Int64 {
    let tester = TextContentRendererChineseTest()
    tester.textContentText()
    tester.textContentEmphasis()
    tester.textContentQuotes()
    tester.textContentLinks()
    tester.textContentImages()
    tester.textContentLists()
    tester.textContentCode()
    tester.textContentCodeBlock()
    tester.textContentBrakes()
    tester.textContentHtml()
    0
}
@Test
public class TextContentRendererChineseTest {
    @TestCase
    func textContentText(): Unit {
        var source: String = ""
        var rendered: String = ""
        source = "我 是"
        rendered = defaultChineseRenderer().render(parse(source))
        assertEquals("我 是", rendered)
        rendered = strippedChineseRenderer().render(parse(source))
        assertEquals("我 是", rendered)

        source = "我 是\n\n我\n是"
        rendered = defaultChineseRenderer().render(parse(source))
        assertEquals("我 是\n我\n是", rendered)
        rendered = strippedChineseRenderer().render(parse(source))
        assertEquals("我 是 我 是", rendered)

        source = "f我o 是o\n\nb我a\n是r"
        rendered = defaultChineseRenderer().render(parse(source))
        assertEquals("f我o 是o\nb我a\n是r", rendered)
    }

    @TestCase
    func textContentEmphasis(): Unit {
        var source: String = ""
        var rendered: String = ""
        source =  "***f仓o颉o***"
        rendered = defaultChineseRenderer().render(parse(source))
        assertEquals("f仓o颉o", rendered)
        rendered = strippedChineseRenderer().render(parse(source))
        assertEquals("f仓o颉o", rendered)

        source = "f仓o颉o ***f仓o颉o*** f仓o颉o ***f仓o颉o***"
        //printNode(parse(source))
        rendered = defaultChineseRenderer().render(parse(source))
        //println(rendered)
        assertEquals("f仓o颉o f仓o颉o f仓o颉o f仓o颉o", rendered)
        rendered = strippedChineseRenderer().render(parse(source))
        //println(rendered)
        assertEquals("f仓o颉o f仓o颉o f仓o颉o f仓o颉o", rendered)

        source = "f仓o颉o\n***f仓o颉o***\nf仓o颉o\n\n***f仓o颉o***"
        rendered = defaultChineseRenderer().render(parse(source))
        assertEquals("f仓o颉o\nf仓o颉o\nf仓o颉o\nf仓o颉o", rendered)
        rendered = strippedChineseRenderer().render(parse(source))
        assertEquals("f仓o颉o f仓o颉o f仓o颉o f仓o颉o", rendered)
    }

    @TestCase
    func textContentQuotes() {
        var source: String = ""
        var rendered: String = ""

        source = "f仓o颉o\n>f仓o颉o\nf仓o颉o\n\nf仓o颉o"
        rendered = defaultChineseRenderer().render(parse(source))
        assertEquals("f仓o颉o\n«f仓o颉o\nf仓o颉o»\nf仓o颉o", rendered)
        rendered = strippedChineseRenderer().render(parse(source))
        assertEquals("f仓o颉o «f仓o颉o f仓o颉o» f仓o颉o", rendered)
    }
    
    @TestCase
    func textContentLinks() {
        var source: String = ""
        var expected: String = ""
        var rendered: String = ""

        source = "f仓o颉o [t仓ext](http://li你好nk \"tit颉le\") b仓a颉r"
        expected = "f仓o颉o \"t仓ext\" (tit颉le: http://li你好nk) b仓a颉r"
        rendered = defaultChineseRenderer().render(parse(source))
        assertEquals(expected, rendered)
        rendered = strippedChineseRenderer().render(parse(source))
        assertEquals(expected, rendered)

        source = "f仓o颉o [t仓ext](http://li你好nk \"http://li你好nk\") b仓a颉r"
        expected = "f仓o颉o \"t仓ext\" (http://li你好nk) b仓a颉r"
        rendered = defaultChineseRenderer().render(parse(source))
        assertEquals(expected, rendered)
        rendered = strippedChineseRenderer().render(parse(source))
        assertEquals(expected, rendered)

        source = "仓颉 [text仓颉](http://link) 仓颉"
        expected = "仓颉 \"text仓颉\" (http://link) 仓颉"
        rendered = defaultChineseRenderer().render(parse(source))
        assertEquals(expected, rendered)
        rendered = strippedChineseRenderer().render(parse(source))
        assertEquals(expected, rendered)

        source = "仓颉 [仓颉text]() 仓颉"
        expected = "仓颉 \"仓颉text\" 仓颉"
        rendered = defaultChineseRenderer().render(parse(source))
        assertEquals(expected, rendered)
        rendered = strippedChineseRenderer().render(parse(source))
        assertEquals(expected, rendered)

        source = "仓颉 http://link123#￥% 仓颉"
        expected = "仓颉 http://link123#￥% 仓颉"
        rendered = defaultChineseRenderer().render(parse(source))
        assertEquals(expected, rendered)
        rendered = strippedChineseRenderer().render(parse(source))
        assertEquals(expected, rendered)
    }

    @TestCase
    func textContentImages() {
        var source: String = ""
        var expected: String = ""
        var rendered: String = ""

        source = "仓颉 ![text%……￥](http://link \"title%……￥\") bar"
        expected = "仓颉 \"text%……￥\" (title%……￥: http://link) bar"
        rendered = defaultChineseRenderer().render(parse(source))
        assertEquals(expected, rendered)
        rendered = strippedChineseRenderer().render(parse(source))
        assertEquals(expected, rendered)

        source = "\u{FFFD} ![text\u{FFFD}](http://link) \u{FFFD}"
        expected = "\u{FFFD} \"text\u{FFFD}\" (http://link) \u{FFFD}"
        rendered = defaultChineseRenderer().render(parse(source))
        assertEquals(expected, rendered)
        rendered = strippedChineseRenderer().render(parse(source))
        assertEquals(expected, rendered)

        source = "fo……%￥*。、o ![text]() bar"
        expected = "fo……%￥*。、o \"text\" bar"
        rendered = defaultChineseRenderer().render(parse(source))
        assertEquals(expected, rendered)
        rendered = strippedChineseRenderer().render(parse(source))
        assertEquals(expected, rendered)
    }

    @TestCase
    func textContentLists() {
        var source: String = ""
        var rendered: String = ""

        source = "仓颉\n* 仓颉\n* bar\n\n仓颉"
        rendered = defaultChineseRenderer().render(parse(source))
        assertEquals("仓颉\n* 仓颉\n* bar\n仓颉", rendered)
        rendered = strippedChineseRenderer().render(parse(source))
        assertEquals("仓颉 仓颉 bar 仓颉", rendered)

        source = "仓%￥\u{FFFD}颉\n- foo\n- 仓%￥\u{FFFD}颉\n\nbar"
        rendered = defaultChineseRenderer().render(parse(source))
        assertEquals("仓%￥\u{FFFD}颉\n- foo\n- 仓%￥\u{FFFD}颉\nbar", rendered)
        rendered = strippedChineseRenderer().render(parse(source))
        assertEquals("仓%￥\u{FFFD}颉 foo 仓%￥\u{FFFD}颉 bar", rendered)

        source = "仓%￥\u{FFFD}颉\n1. \u{FFFD}\n2. bar\n\nbar"
        rendered = defaultChineseRenderer().render(parse(source))
        assertEquals("仓%￥\u{FFFD}颉\n1. \u{FFFD}\n2. bar\nbar", rendered)
        rendered = strippedChineseRenderer().render(parse(source))
        assertEquals("仓%￥\u{FFFD}颉 1. \u{FFFD} 2. bar bar", rendered)

        source = "foo\n0) foo\n1) bar\n\nbar"
        rendered = defaultChineseRenderer().render(parse(source))
        assertEquals("foo\n0) foo\n1) bar\nbar", rendered)
        rendered = strippedChineseRenderer().render(parse(source))
        assertEquals("foo 0) foo 1) bar bar", rendered)

        source = "bar\n1. 仓%￥\u{FFFD}颉\n   1. bar\n2. foo"
        rendered = defaultChineseRenderer().render(parse(source))
        assertEquals("bar\n1. 仓%￥\u{FFFD}颉\n   1. bar\n2. foo", rendered)
        rendered = strippedChineseRenderer().render(parse(source))
        assertEquals("bar 1. 仓%￥\u{FFFD}颉 1. bar 2. foo", rendered)

        source = "bar\n* 仓%￥\u{FFFD}颉\n   - bar\n* foo"
        rendered = defaultChineseRenderer().render(parse(source))
        assertEquals("bar\n* 仓%￥\u{FFFD}颉\n   - bar\n* foo", rendered)
        rendered = strippedChineseRenderer().render(parse(source))
        assertEquals("bar 仓%￥\u{FFFD}颉 bar foo", rendered)

        source = "bar 仓%￥\u{FFFD}颉\n* foo\n   1. bar\n   2. bar 仓%￥\u{FFFD}颉\n* foo"
        rendered = defaultChineseRenderer().render(parse(source))
        assertEquals("bar 仓%￥\u{FFFD}颉\n* foo\n   1. bar\n   2. bar 仓%￥\u{FFFD}颉\n* foo", rendered)
        rendered = strippedChineseRenderer().render(parse(source))
        assertEquals("bar 仓%￥\u{FFFD}颉 foo 1. bar 2. bar 仓%￥\u{FFFD}颉 foo", rendered)

        source = "bar\n1. foo\n   * bar 仓%￥\u{FFFD}颉\n   * bar\n2. foo"
        rendered = defaultChineseRenderer().render(parse(source))
        assertEquals("bar\n1. foo\n   * bar 仓%￥\u{FFFD}颉\n   * bar\n2. foo", rendered)
        rendered = strippedChineseRenderer().render(parse(source))
        assertEquals("bar 1. foo bar 仓%￥\u{FFFD}颉 bar 2. foo", rendered)

    }

    @TestCase
    func textContentCode() {
        var source: String = ""
        var expected: String = ""
        var rendered: String = ""

        source = "仓%￥\u{FFFD}颉 `仓%￥\u{FFFD}颉` bar"
        expected = "仓%￥\u{FFFD}颉 \"仓%￥\u{FFFD}颉\" bar"
        rendered = defaultChineseRenderer().render(parse(source))
        assertEquals(expected, rendered)
        rendered = strippedChineseRenderer().render(parse(source))
        assertEquals(expected, rendered)
    }

    @TestCase
    func textContentCodeBlock() {
        var source: String = ""
        var rendered: String = ""

        source = "fo仓%￥\u{FFFD}颉o\n```\nfo仓%￥\u{FFFD}颉o\nbar\n```\nba仓%￥\u{FFFD}颉r"
        rendered = defaultChineseRenderer().render(parse(source))
        assertEquals("fo仓%￥\u{FFFD}颉o\nfo仓%￥\u{FFFD}颉o\nbar\nba仓%￥\u{FFFD}颉r", rendered)
        rendered = strippedChineseRenderer().render(parse(source))
        assertEquals("fo仓%￥\u{FFFD}颉o fo仓%￥\u{FFFD}颉o bar ba仓%￥\u{FFFD}颉r", rendered)

        source = "fo仓%￥\u{FFFD}颉o\n\n    fo仓%￥\u{FFFD}颉o\n     bar\nba仓%￥\u{FFFD}颉r"
        rendered = defaultChineseRenderer().render(parse(source))
        assertEquals("fo仓%￥\u{FFFD}颉o\nfo仓%￥\u{FFFD}颉o\n bar\nba仓%￥\u{FFFD}颉r", rendered)
        rendered = strippedChineseRenderer().render(parse(source))
        assertEquals("fo仓%￥\u{FFFD}颉o fo仓%￥\u{FFFD}颉o bar ba仓%￥\u{FFFD}颉r", rendered)
    }

    @TestCase
    func textContentBrakes() {
        var source: String = ""
        var rendered: String = ""

        source = "fo仓%￥\u{FFFD}颉o\nba仓%￥\u{FFFD}颉r"
        rendered = defaultChineseRenderer().render(parse(source))
        assertEquals("fo仓%￥\u{FFFD}颉o\nba仓%￥\u{FFFD}颉r", rendered)
        rendered = strippedChineseRenderer().render(parse(source))
        assertEquals("fo仓%￥\u{FFFD}颉o ba仓%￥\u{FFFD}颉r", rendered)

        source = "fo仓%￥\u{FFFD}颉o  \nba仓%￥\u{FFFD}颉r"
        rendered = defaultChineseRenderer().render(parse(source))
        assertEquals("fo仓%￥\u{FFFD}颉o\nba仓%￥\u{FFFD}颉r", rendered)
        rendered = strippedChineseRenderer().render(parse(source))
        assertEquals("fo仓%￥\u{FFFD}颉o ba仓%￥\u{FFFD}颉r", rendered)

        source = "fo仓%￥\u{FFFD}颉o\n___\nba仓%￥\u{FFFD}颉r"
        rendered = defaultChineseRenderer().render(parse(source))
        assertEquals("fo仓%￥\u{FFFD}颉o\n***\nba仓%￥\u{FFFD}颉r", rendered)
        rendered = strippedChineseRenderer().render(parse(source))
        assertEquals("fo仓%￥\u{FFFD}颉o ba仓%￥\u{FFFD}颉r", rendered)
    }

    @TestCase
    func textContentHtml() {
        var rendered: String = ""

        var html: String = "<table>\n" +
                "  <tr>\n" +
                "    <td>\n" +
                "           foo仓%￥\u{FFFD}颉bar\n" +
                "    </td>\n" +
                "  </tr>\n" +
                "</table>"
        rendered = defaultChineseRenderer().render(parse(html))
        assertEquals(html, rendered)

        html = "foo <foo>foo仓%￥\u{FFFD}颉bar</foo> bar"
        rendered = defaultChineseRenderer().render(parse(html))
        assertEquals(html, rendered)
    }

}

func defaultChineseRenderer(): TextContentRenderer {
    return TextContentRenderer.builder().build()
}

func parse(source: String): Node {
    return Parser.builder().build().parse(source)
}

func strippedChineseRenderer(): TextContentRenderer {
    return TextContentRenderer.builder().setStripNewlines(true).build()
}

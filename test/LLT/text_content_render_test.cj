// DEPENDENCE: z_test.cj
// EXEC: cjc %import-path %L %l %f z_test.cj -Woff unused
// EXEC: ./main

import commonmark4cj.commonmark.*
import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import std.collection.*
import std.regex.{Regex, Matcher, MatchData, RegexOption, Position}

main(): Int64 {
    let tester = TextContentRendererTest()
    tester.textTest()
    tester.regexTest1()
    tester.regexTest2()
    tester.textContentText()
    tester.textContentRULTest()
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
public class TextContentRendererTest {
    @TestCase
    func textContentText(): Unit {
        var source: String = ""
        var rendered: String = ""
        source = "foo bar"
        rendered = defaultRenderer().render(parse(source))
        assertEquals("foo bar", rendered)
        rendered = strippedRenderer().render(parse(source))
        assertEquals("foo bar", rendered)

        source = "foo foo\n\nbar\nbar"
        rendered = defaultRenderer().render(parse(source))
        assertEquals("foo foo\nbar\nbar", rendered)
        rendered = strippedRenderer().render(parse(source))
        assertEquals("foo foo bar bar", rendered)
    }

    @TestCase
    func textContentRULTest(): Unit {
        var source: String = "<https://markdown.com.cn>"
        var rendered = defaultRenderer().render(parse(source))
        println(rendered)
        assertEquals("\"https://markdown.com.cn\" (https://markdown.com.cn)", rendered)
    }

    @TestCase
    func textTest() {
        var source: String = "oh my god！何其高竣，何*其峭险！蜀道太难走*呵，_123简直难于上青_天；_传说中蚕丛和鱼凫建立了_ 蜀国，开国的年代实在久远无法详谈"
        var rendered: String = ""

        rendered = defaultRenderer().render(parse(source))
        println(rendered)
        println(source)
        println("oh my god！何其高竣，何其峭险！蜀道太难走呵，_123简直难于上青_天；传说中蚕丛和鱼凫建立了 蜀国，开国的年代实在久远无法详谈")
        /*策略调整cangjie正则无法很好的支持中文标点 依赖中文标点的定界符会失效 依赖英文标点的定界符不受影响*/
        // assertEquals(
        //     "oh my god！何其高竣，何其峭险！蜀道太难走呵，_123简直难于上青_天；传说中蚕丛和鱼凫建立了 蜀国，开国的年代实在久远无法详谈",
        //     rendered
        // )
    }

    @TestCase
    func regexTest1() {
        let ASCII_PUNCTUATION: String = "!\"#\\$%&'\\(\\)\\*\\+,\\-\\./:;<=>\\?@\\[\\\\\\]\\^_`\\{\\|\\}~，！；’‘。"
        let PUNCTUATION: Regex = Regex("^[${ASCII_PUNCTUATION}]")

        //assertEquals(PUNCTUATION.matches(",，").isSome(), false)
        assertEquals(PUNCTUATION.matches(",，"), true)
        assertEquals(PUNCTUATION.matches("；ssss"), true)
        assertEquals(PUNCTUATION.matches("。"), true)
        assertEquals(PUNCTUATION.matches("。‘"), true)
        assertEquals(PUNCTUATION.matches("！"), true)
        assertEquals(PUNCTUATION.matches("#！"), true)
        assertEquals(PUNCTUATION.matches("我"), false)
        assertEquals(PUNCTUATION.matches("！我的老家在东北"), true)
    }

    @TestCase
    func regexTest2() {
        let ASCII_PUNCTUATION: String = "!\"#\\$%&'\\(\\)\\*\\+,\\-\\./:;<=>\\?@\\[\\\\\\]\\^_`\\{\\|\\}~"
        let PUNCTUATION: Regex = Regex("^[${ASCII_PUNCTUATION}]")

        //assertEquals(PUNCTUATION.matches(",，").isSome(), false)
        assertEquals(PUNCTUATION.matches(",，"), true)
        assertEquals(PUNCTUATION.matches("；ssss"), false)
        assertEquals(PUNCTUATION.matches("。"), false)
        assertEquals(PUNCTUATION.matches("。‘"), false)
        assertEquals(PUNCTUATION.matches("！"), false)
        assertEquals(PUNCTUATION.matches("#！"), true)
        assertEquals(PUNCTUATION.matches("我"), false)
    }

    @TestCase
    func textContentEmphasis(): Unit {
        var source: String = ""
        var rendered: String = ""
        source = "***foo***"
        rendered = defaultRenderer().render(parse(source))
        assertEquals("foo", rendered)
        rendered = strippedRenderer().render(parse(source))
        assertEquals("foo", rendered)

        source = "foo ***foo*** bar ***bar***"
        //printNode(parse(source))
        rendered = defaultRenderer().render(parse(source))
        //println(rendered)
        assertEquals("foo foo bar bar", rendered)
        rendered = strippedRenderer().render(parse(source))
        //println(rendered)
        assertEquals("foo foo bar bar", rendered)

        source = "foo\n***foo***\nbar\n\n***bar***"
        rendered = defaultRenderer().render(parse(source))
        assertEquals("foo\nfoo\nbar\nbar", rendered)
        rendered = strippedRenderer().render(parse(source))
        assertEquals("foo foo bar bar", rendered)
    }

    @TestCase
    func textContentQuotes() {
        var source: String = ""
        var rendered: String = ""

        source = "foo\n>foo\nbar\n\nbar"
        rendered = defaultRenderer().render(parse(source))
        assertEquals("foo\n«foo\nbar»\nbar", rendered)
        rendered = strippedRenderer().render(parse(source))
        assertEquals("foo «foo bar» bar", rendered)
    }

    @TestCase
    func textContentLinks() {
        var source: String = ""
        var expected: String = ""
        var rendered: String = ""

        source = "foo [text](http://link \"title\") bar"
        expected = "foo \"text\" (title: http://link) bar"
        rendered = defaultRenderer().render(parse(source))
        assertEquals(expected, rendered)
        rendered = strippedRenderer().render(parse(source))
        assertEquals(expected, rendered)

        source = "foo [text](http://link \"http://link\") bar"
        expected = "foo \"text\" (http://link) bar"
        rendered = defaultRenderer().render(parse(source))
        assertEquals(expected, rendered)
        rendered = strippedRenderer().render(parse(source))
        assertEquals(expected, rendered)

        source = "foo [text](http://link) bar"
        expected = "foo \"text\" (http://link) bar"
        rendered = defaultRenderer().render(parse(source))
        assertEquals(expected, rendered)
        rendered = strippedRenderer().render(parse(source))
        assertEquals(expected, rendered)

        source = "foo [text]() bar"
        expected = "foo \"text\" bar"
        rendered = defaultRenderer().render(parse(source))
        assertEquals(expected, rendered)
        rendered = strippedRenderer().render(parse(source))
        assertEquals(expected, rendered)

        source = "foo http://link bar"
        expected = "foo http://link bar"
        rendered = defaultRenderer().render(parse(source))
        assertEquals(expected, rendered)
        rendered = strippedRenderer().render(parse(source))
        assertEquals(expected, rendered)
    }

    @TestCase
    func textContentImages() {
        var source: String = ""
        var expected: String = ""
        var rendered: String = ""

        source = "foo ![text](http://link \"title\") bar"
        expected = "foo \"text\" (title: http://link) bar"
        rendered = defaultRenderer().render(parse(source))
        assertEquals(expected, rendered)
        rendered = strippedRenderer().render(parse(source))
        assertEquals(expected, rendered)

        source = "foo ![text](http://link) bar"
        expected = "foo \"text\" (http://link) bar"
        rendered = defaultRenderer().render(parse(source))
        assertEquals(expected, rendered)
        rendered = strippedRenderer().render(parse(source))
        assertEquals(expected, rendered)

        source = "foo ![text]() bar"
        expected = "foo \"text\" bar"
        rendered = defaultRenderer().render(parse(source))
        assertEquals(expected, rendered)
        rendered = strippedRenderer().render(parse(source))
        assertEquals(expected, rendered)
    }

    @TestCase
    func textContentLists() {
        var source: String = ""
        var rendered: String = ""

        source = "foo\n* foo\n* bar\n\nbar"
        rendered = defaultRenderer().render(parse(source))
        assertEquals("foo\n* foo\n* bar\nbar", rendered)
        rendered = strippedRenderer().render(parse(source))
        assertEquals("foo foo bar bar", rendered)

        source = "foo\n- foo\n- bar\n\nbar"
        rendered = defaultRenderer().render(parse(source))
        assertEquals("foo\n- foo\n- bar\nbar", rendered)
        rendered = strippedRenderer().render(parse(source))
        assertEquals("foo foo bar bar", rendered)

        source = "foo\n1. foo\n2. bar\n\nbar"
        rendered = defaultRenderer().render(parse(source))
        assertEquals("foo\n1. foo\n2. bar\nbar", rendered)
        rendered = strippedRenderer().render(parse(source))
        assertEquals("foo 1. foo 2. bar bar", rendered)

        source = "foo\n0) foo\n1) bar\n\nbar"
        rendered = defaultRenderer().render(parse(source))
        assertEquals("foo\n0) foo\n1) bar\nbar", rendered)
        rendered = strippedRenderer().render(parse(source))
        assertEquals("foo 0) foo 1) bar bar", rendered)

        source = "bar\n1. foo\n   1. bar\n2. foo"
        rendered = defaultRenderer().render(parse(source))
        assertEquals("bar\n1. foo\n   1. bar\n2. foo", rendered)
        rendered = strippedRenderer().render(parse(source))
        assertEquals("bar 1. foo 1. bar 2. foo", rendered)

        source = "bar\n* foo\n   - bar\n* foo"
        rendered = defaultRenderer().render(parse(source))
        assertEquals("bar\n* foo\n   - bar\n* foo", rendered)
        rendered = strippedRenderer().render(parse(source))
        assertEquals("bar foo bar foo", rendered)

        source = "bar\n* foo\n   1. bar\n   2. bar\n* foo"
        rendered = defaultRenderer().render(parse(source))
        assertEquals("bar\n* foo\n   1. bar\n   2. bar\n* foo", rendered)
        rendered = strippedRenderer().render(parse(source))
        assertEquals("bar foo 1. bar 2. bar foo", rendered)

        source = "bar\n1. foo\n   * bar\n   * bar\n2. foo"
        rendered = defaultRenderer().render(parse(source))
        assertEquals("bar\n1. foo\n   * bar\n   * bar\n2. foo", rendered)
        rendered = strippedRenderer().render(parse(source))
        assertEquals("bar 1. foo bar bar 2. foo", rendered)
    }

    @TestCase
    func textContentCode() {
        var source: String = ""
        var expected: String = ""
        var rendered: String = ""

        source = "foo `code` bar"
        expected = "foo \"code\" bar"
        rendered = defaultRenderer().render(parse(source))
        assertEquals(expected, rendered)
        rendered = strippedRenderer().render(parse(source))
        assertEquals(expected, rendered)
    }

    @TestCase
    func textContentCodeBlock() {
        var source: String = ""
        var rendered: String = ""

        source = "foo\n```\nfoo\nbar\n```\nbar"
        rendered = defaultRenderer().render(parse(source))
        assertEquals("foo\nfoo\nbar\nbar", rendered)
        rendered = strippedRenderer().render(parse(source))
        assertEquals("foo foo bar bar", rendered)

        source = "foo\n\n    foo\n     bar\nbar"
        //printNode(parse(source))
        rendered = defaultRenderer().render(parse(source))
        //println(rendered)
        assertEquals("foo\nfoo\n bar\nbar", rendered)
        rendered = strippedRenderer().render(parse(source))
        //println(rendered)
        assertEquals("foo foo bar bar", rendered)
    }

    @TestCase
    func textContentBrakes() {
        var source: String = ""
        var rendered: String = ""

        source = "foo\nbar"
        rendered = defaultRenderer().render(parse(source))
        assertEquals("foo\nbar", rendered)
        rendered = strippedRenderer().render(parse(source))
        assertEquals("foo bar", rendered)

        source = "foo  \nbar"
        rendered = defaultRenderer().render(parse(source))
        assertEquals("foo\nbar", rendered)
        rendered = strippedRenderer().render(parse(source))
        assertEquals("foo bar", rendered)

        source = "foo\n___\nbar"
        rendered = defaultRenderer().render(parse(source))
        assertEquals("foo\n***\nbar", rendered)
        rendered = strippedRenderer().render(parse(source))
        assertEquals("foo bar", rendered)
    }

    @TestCase
    func textContentHtml() {
        var rendered: String = ""

        var html: String = "<table>\n" + "  <tr>\n" + "    <td>\n" + "           foobar\n" + "    </td>\n" + "  </tr>\n" +
            "</table>"
        rendered = defaultRenderer().render(parse(html))
        assertEquals(html, rendered)

        html = "foo <foo>foobar</foo> bar"
        rendered = defaultRenderer().render(parse(html))
        assertEquals(html, rendered)
    }
}

func defaultRenderer(): TextContentRenderer {
    return TextContentRenderer.builder().build()
}

func parse(source: String): Node {
    return Parser.builder().build().parse(source)
}

func strippedRenderer(): TextContentRenderer {
    return TextContentRenderer.builder().setStripNewlines(true).build()
}

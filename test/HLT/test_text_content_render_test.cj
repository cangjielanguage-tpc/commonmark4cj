// 3rd_party_lib:commonmark4cj/build/release/commonmark4cj
// 3rd_party_lib_ohos:commonmark4cj/build/aarch64-linux-ohos/commonmark4cj
// dependence: z_test.cj

import commonmark4cj.commonmark.*
import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import std.collection.*

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

func printNode(node: ?Node): Unit {
    if (let Some(v) <- node) {
        var current = v
        while (let Some(p) <- (current.getParent())) {
            current = p
        }
        printNode(current, 0)
    }
}

func printNode(node: ?Node, dep: Int): Unit {
    if (node.isNone()) {
        return
    }
    println("${" "*dep}${node}")
    let child = node?.getFirstChild() ?? None
    printNode(child, dep + 4)
    let next = node?.getNext() ?? None
    printNode(next, dep)
}

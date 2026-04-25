// 3rd_party_lib:commonmark4cj/build/release/commonmark4cj
// 3rd_party_lib_ohos:commonmark4cj/build/aarch64-linux-ohos/commonmark4cj
// dependence: z_test.cj

import commonmark4cj.commonmark.*
import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import std.collection.*

@Test
public class TextContentWriterTest {
    @TestCase
    func whitespace(): Unit {
        let stringBuilder = StringBuilder()
        var writer: TextContentWriter = TextContentWriter(stringBuilder)
        writer.write("foo")
        writer.whitespace()
        writer.write("bar")
        assertEquals("foo bar", stringBuilder.toString())
    }

    @TestCase
    func colon(): Unit {
        let stringBuilder = StringBuilder()
        var writer: TextContentWriter = TextContentWriter(stringBuilder)
        writer.write("foo")
        writer.colon()
        writer.write("bar")
        assertEquals("foo:bar", stringBuilder.toString())
    }

    @TestCase
    func line(): Unit {
        let stringBuilder = StringBuilder()
        var writer: TextContentWriter = TextContentWriter(stringBuilder)
        writer.write("foo")
        writer.line()
        writer.write("bar")
        assertEquals("foo\nbar", stringBuilder.toString())
    }

    @TestCase
    func writeStripped(): Unit {
        let stringBuilder = StringBuilder()
        var writer: TextContentWriter = TextContentWriter(stringBuilder)
        writer.writeStripped("foo\n bar")
        assertEquals("foo bar", stringBuilder.toString())
    }

    @TestCase
    func write(): Unit {
        let stringBuilder = StringBuilder()
        var writer: TextContentWriter = TextContentWriter(stringBuilder)
        writer.writeStripped("foo bar")
        assertEquals("foo bar", stringBuilder.toString())
    }
}

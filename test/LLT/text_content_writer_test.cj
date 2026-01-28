// DEPENDENCE: z_test.cj
// EXEC: cjc %import-path %L %l %f z_test.cj
// EXEC: ./main

import commonmark4cj.commonmark.*
import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import std.collection.*

main(): Int64 {
    let tester = TextContentWriterTest()
    tester.whitespace()
    tester.colon()
    tester.line()
    tester.writeStripped()
    tester.write()
    0
}
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

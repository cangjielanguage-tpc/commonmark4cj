// 3rd_party_lib:commonmark4cj/build/release/commonmark4cj
// 3rd_party_lib_ohos:commonmark4cj/build/aarch64-linux-ohos/commonmark4cj
// dependence: z_test.cj

import commonmark4cj.commonmark.*
import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import std.collection.*
@Test
public class TestParser {

 
    @TestCase
    func test_parser_parse(): Unit {
        var stringbuilder=StringBuilder()
        var writer: TextContentWriter = TextContentWriter(stringbuilder)
        writer.writeStripped("\n123")
        writer.write("456")
        writer.write("a")
        writer.whitespace()
        writer.colon()
        writer.colon()
        writer.line()
        @Assert(stringbuilder.toString()," 123456a :\n")
    }


    @TestCase
    func test_parser_parse1(): Unit {
        var stringbuilder=StringBuilder()
        var writer: TextContentWriter = TextContentWriter(stringbuilder)
        writer.writeStripped("\n倉頡")
        writer.write("456")
        writer.write("a")
        writer.whitespace()
        writer.colon()
        writer.colon()
        writer.line()
        @Assert(stringbuilder.toString()," 倉頡456a :\n")
    }


    @TestCase
    func test_parser_parse2(): Unit {
        var stringbuilder=StringBuilder()
        var writer: TextContentWriter = TextContentWriter(stringbuilder)
        writer.writeStripped("③♡→←\\n倉頡")
        writer.write("____")
        writer.write("a")
        writer.whitespace()
        writer.colon()
        writer.colon()
        writer.line()
        @Assert(stringbuilder.toString(),"③♡→←\\n倉頡____a :\n")
    }

    @TestCase
    func test_parser_parse3(): Unit {
        var stringbuilder=StringBuilder()
        var writer: TextContentWriter = TextContentWriter(stringbuilder)
        writer.writeStripped("~~~~")
        writer.write("____")
        writer.write("a")
        writer.whitespace()
        writer.colon()
        writer.colon()
        writer.line()
        @Assert(stringbuilder.toString(),"~~~~____a :\n")
    }


    @TestCase
    func test_parser_parse4(): Unit {
        var stringbuilder=StringBuilder()
        var writer: TextContentWriter = TextContentWriter(stringbuilder)
        writer.writeStripped("")
        writer.write(" ")
        writer.write("a")
        writer.whitespace()
        writer.colon()
        writer.colon()
        writer.line()
        @Assert(stringbuilder.toString()," a :\n")
    }


    @TestCase
    func test_parser_parse5(): Unit {
        var stringbuilder=StringBuilder()
        var writer: TextContentWriter = TextContentWriter(stringbuilder)
        writer.writeStripped("")
        writer.write(" ")
        writer.write("")
        writer.whitespace()
        writer.colon()
        writer.colon()
        writer.line()
        @Assert(stringbuilder.toString()," :\n")
    }


    @TestCase
    public func htmlAllowingShouldNotEscapeInlineHtml06(): Unit {

        var map = HashMap<String, String>([("", "")])
        let stringBuilder = StringBuilder()
        let html = HtmlWriter(stringBuilder)
        html.raw("__")
        html.text("~~")
        html.tag("##")
        html.tag("__", map)
        html.tag("", map, true)
        html.line()
        @Assert(stringBuilder.toString().toRuneArray().size,25)
    }

    @TestCase
    public func Escaping01(): Unit {

        let stringBuilder = Escaping.escapeHtml("")
        @Assert(stringBuilder,"")
        @Assert(Escaping.unescapeString(""),"")
        @Assert(Escaping.percentEncodeUrl(""),"")
    }


    @TestCase
    public func Escaping02(): Unit {

        let stringBuilder = Escaping.escapeHtml("CANGJIE")
        @Assert(stringBuilder,"CANGJIE")
        @Assert(Escaping.unescapeString("CANGJIE"),"CANGJIE")
        @Assert(Escaping.percentEncodeUrl("CANGJIE"),"CANGJIE")
    }


    @TestCase
    public func Escaping03(): Unit {

        let stringBuilder = Escaping.escapeHtml("倉頡")
        @Assert(stringBuilder,"倉頡")
        @Assert(Escaping.unescapeString("倉頡"),"倉頡")
        @Assert(Escaping.percentEncodeUrl("倉頡"),"%E5%80%89%E9%A0%A1")
    }

    @TestCase
    public func Escaping04(): Unit {

        let stringBuilder = Escaping.escapeHtml("倉頡cangjie123")
        @Assert(stringBuilder,"倉頡cangjie123")
        @Assert(Escaping.unescapeString("倉頡cangjie123"),"倉頡cangjie123")
        @Assert(Escaping.percentEncodeUrl("倉頡cangjie123"),"%E5%80%89%E9%A0%A1cangjie123")
    }

    @TestCase
    public func Escaping05(): Unit {

        let stringBuilder = Escaping.escapeHtml("，。；‘；、")
        @Assert(stringBuilder,"，。；‘；、")
        @Assert(Escaping.unescapeString("，。；‘；、"),"，。；‘；、")
        @Assert(Escaping.percentEncodeUrl("，。；‘；、"),"%EF%BC%8C%E3%80%82%EF%BC%9B%E2%80%98%EF%BC%9B%E3%80%81")
    }


    @TestCase
    public func Escaping06(): Unit {

        let stringBuilder = Escaping.escapeHtml("https://blog.csdn.net/m0_67038390/article/details/124955381")
        @Assert(stringBuilder,"https://blog.csdn.net/m0_67038390/article/details/124955381")
        @Assert(Escaping.unescapeString("https://blog.csdn.net/m0_67038390/article/details/124955381"),"https://blog.csdn.net/m0_67038390/article/details/124955381")
        @Assert(Escaping.percentEncodeUrl("https://blog.csdn.net/m0_67038390/article/details/124955381"),"https://blog.csdn.net/m0_67038390/article/details/124955381")
    }

    @TestCase
    public func Escaping07(): Unit {

        let stringBuilder = Escaping.escapeHtml("，倉。；‘傑；、")
        @Assert(stringBuilder,"，倉。；‘傑；、")
        @Assert(Escaping.unescapeString("，倉。；‘傑；、"),"，倉。；‘傑；、")
        @Assert(Escaping.percentEncodeUrl("，倉。；‘傑；、"),"%EF%BC%8C%E5%80%89%E3%80%82%EF%BC%9B%E2%80%98%E5%82%91%EF%BC%9B%E3%80%81")
    }
}
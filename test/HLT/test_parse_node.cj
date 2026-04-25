// 3rd_party_lib:commonmark4cj/build/release/commonmark4cj
// 3rd_party_lib_ohos:commonmark4cj/build/aarch64-linux-ohos/commonmark4cj


import commonmark4cj.commonmark.*
import commonmark4cj.table.*
import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import std.collection.*
import std.reflect.{TypeInfo}
import std.unicode.*
import std.fs.*

@Test
public class TestParser {


    @TestCase
    func test_parser_parse1(): Unit {
        var arr:Array<String>=["oh","123","倉頡","倉頡◆☆ʊə③əʊП┳卐？＠","倉頡cangjie◆☆ʊə③əʊП┳卐？＠123","倉頡\ncangjie◆☆ʊə③əʊП┳卐？＠123","，"
        ,"https://\nnoties.io/Markwon/docs/v4/core/plugins.html#registry","┳③す▓▉㏘¤↗㊣",
        "__倉_你好_頡__,哈__倉_你好_頡__，哈","paragraph with <span id='foo' class=\"bar\">inline &amp; html</span>"]
        var a=0
        for (given in arr){
            println(given)
            var parser: Parser = Parser.builder().build()
            var document: Node = parser.parse(given)
            @Assert(document.getNext(),None)
            @Assert(document.getPrevious(),None)
            @Assert(document.getFirstChild().getOrThrow().toString(),"Paragraph{}")
            @Assert(document.getLastChild().getOrThrow().toString(),"Paragraph{}")
            @Assert(document.getParent(),None)
            var t=Text(given)
            @Assert(t.getLiteral(),arr[a])
            a++  
        }    
  
    @TestCase
    func test_parser_parse2(): Unit {
        var given="，。、sa，。、（）#&\"\",—-————__，。、__sa————-，"
            var parser: Parser = Parser.builder().build()
            var document: Node = parser.parse(given)
            @Assert(document.getNext(),None)
            @Assert(document.getPrevious(),None)
            @Assert(document.getFirstChild().getOrThrow().toString(),"Paragraph{}")
            @Assert(document.getLastChild().getOrThrow().toString(),"Paragraph{}")
            @Assert(document.getParent(),None)
            var t=Text(given)
            @Assert(t.getLiteral(),given)
            a++
        }  
    }
}
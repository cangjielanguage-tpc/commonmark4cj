// 3rd_party_lib:commonmark4cj/build/release/commonmark4cj
// 3rd_party_lib_ohos:commonmark4cj/build/aarch64-linux-ohos/commonmark4cj
// dependence: z_test.cj

import commonmark4cj.commonmark.*
import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import std.collection.*
import std.regex.{Regex, Matcher, MatchData, RegexOption, Position}

@Test
public class Tester {
    @TestCase
    func escaping_test(): Unit {
        var apeHtml = Escaping.escapeHtml("nihao")
        @Assert(apeHtml,"nihao")
    }

    @TestCase
    func escaping_test1(): Unit {
        var apeHtml = Escaping.escapeHtml("你好")
        @Assert(apeHtml,"你好")
    }

    @TestCase
    func escaping_test2(): Unit {
        var apeHtml = Escaping.escapeHtml("nihao你好")
        @Assert(apeHtml,"nihao你好")
    }

    @TestCase
    func escaping_test3(): Unit {
        var apeHtml = Escaping.escapeHtml("nihao你好1")
        @Assert(apeHtml,"nihao你好1")
    }

    @TestCase
    func escaping_test4(): Unit {
        var apeHtml = Escaping.escapeHtml("nihao你好1#￥")
        @Assert(apeHtml,"nihao你好1#￥")
    }

    @TestCase
    func escaping_test5(): Unit {
        var apeHtml = Escaping.escapeHtml("")
        @Assert(apeHtml,"")
    }

    // @TestCase
    @TestCase
    func escaping_test6(): Unit {
        var apeHtml = Escaping.unescapeString("nihao")
        @Assert(apeHtml,"nihao")
    }

    @TestCase
    func escaping_test7(): Unit {
        var apeHtml = Escaping.unescapeString("你好")
        @Assert(apeHtml,"你好")
    }

    @TestCase
    func escaping_test8(): Unit {
        var apeHtml = Escaping.unescapeString("nihao你好")
        @Assert(apeHtml,"nihao你好")
    }

    @TestCase
    func escaping_test9(): Unit {
        var apeHtml = Escaping.unescapeString("nihao你好1")
        @Assert(apeHtml,"nihao你好1")
    }

    @TestCase
    func escaping_test10(): Unit {
        var apeHtml = Escaping.unescapeString("nihao你好1#￥")
        @Assert(apeHtml,"nihao你好1#￥")
    }

    @TestCase
    func escaping_test11(): Unit {
        var apeHtml = Escaping.unescapeString("")
        @Assert(apeHtml,"")
    }

    // @TestCase
    @TestCase
    func escaping_test12(): Unit {
        var apeHtml = Escaping.percentEncodeUrl("nihao")
        @Assert(apeHtml,"nihao")
    }

    @TestCase
    func escaping_test13(): Unit {
        var apeHtml = Escaping.percentEncodeUrl("你好")
        @Assert(apeHtml,"%E4%BD%A0%E5%A5%BD")
    }

    @TestCase
    func escaping_test14(): Unit {
        var apeHtml = Escaping.percentEncodeUrl("nihao你好")
        @Assert(apeHtml,"nihao%E4%BD%A0%E5%A5%BD")
    }

    @TestCase
    func escaping_test15(): Unit {
        var apeHtml = Escaping.percentEncodeUrl("nihao你好1")
        @Assert(apeHtml,"nihao%E4%BD%A0%E5%A5%BD1")
    }

    @TestCase
    func escaping_test16(): Unit {
        var apeHtml = Escaping.percentEncodeUrl("nihao你好1#￥")
        @Assert(apeHtml,"nihao%E4%BD%A0%E5%A5%BD1#%EF%BF%A5")
    }

    @TestCase
    func escaping_test17(): Unit {
        var apeHtml = Escaping.percentEncodeUrl("")
        @Assert(apeHtml,"")
    }
}

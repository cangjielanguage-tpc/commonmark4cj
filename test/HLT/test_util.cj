// 3rd_party_lib:commonmark4cj/build/release/commonmark4cj
// 3rd_party_lib_ohos:commonmark4cj/build/aarch64-linux-ohos/commonmark4cj
// dependence: z_test.cj

import commonmark4cj.commonmark.*
import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import std.collection.*
import std.regex.{Regex, Matcher, MatchData, RegexOption, Position, RegexFlag }

@Test
public class Tester {
    @TestCase
    func escaping_test(): Unit {
        let escapeString: String = Escaping.escapeHtml("nothing to escape")
        @PowerAssert(escapeString == "nothing to escape")
        let escapeString2: String = Escaping.escapeHtml("&")
        @PowerAssert(escapeString2 == "&amp;")
        let escapeString3: String = Escaping.escapeHtml("<")
        @PowerAssert(escapeString3 == "&lt;")
        let escapeString4: String = Escaping.escapeHtml(">")
        @PowerAssert(escapeString4 == "&gt;")
        let escapeString5: String = Escaping.escapeHtml("\"")
        @PowerAssert(escapeString5 == "&quot;")

        let escapeString6: String = Escaping.escapeHtml("< start")
        @PowerAssert(escapeString6 == "&lt; start")
        let escapeString7: String = Escaping.escapeHtml("end >")
        @PowerAssert(escapeString7 == "end &gt;")
        let escapeString8: String = Escaping.escapeHtml("< both >")
        @PowerAssert(escapeString8 == "&lt; both &gt;")
        let escapeString9: String = Escaping.escapeHtml("< middle & too >")
        @PowerAssert(escapeString9 == "&lt; middle &amp; too &gt;")

        let text = "Example string with special characters: !@#$%^&*()_+|~- and encoded characters: &amp;#x123; &amp;#123; and &amp;test;"
        let unescapeString: String = Escaping.unescapeString(text)
        let t = "Example string with special characters: !@#$%^&*()_+|~- and encoded characters: &#x123; &#123; and &test;"
        @PowerAssert(unescapeString == t)
    }

    @TestCase
    func cangjie_readln_test(): Unit {
        let arr = ByteBuffer()
        arr.write("---\r\naaa".toArray())
        @PowerAssert(StringReader(arr).readln()?.toArray() == [UInt8(45), UInt8(45), UInt8(45)])
        // @PowerAssert(StringReader(arr).readln()?.toArray() == [45, 45, 45, 13]) // cangjie 49.2以下版本
    }

    @TestCase
    func test(): Unit {
        let text = "Example string with special characters: !@#$%^&*()_+|~- and encoded characters: &amp;#x123; &amp;#123; and &amp;test;"
        let ESCAPABLE: String = "[!\"#$%&\'()*+,./:<=>?@\\[\\\\\\]^_`{|}~-]"
        let ENTITY: String = "&(?:#x[a-f0-9]{1,6}|#[0-9]{1,7}|[a-z][a-z0-9]{1,31})"
        Regex("[\\\\&]")
        let ENTITY_OR_ESCAPED_CHAR = Regex(
            "\\\\" + ESCAPABLE + '|'.toString() + ENTITY,
            IgnoreCase
        )

        let matcher: Matcher = ENTITY_OR_ESCAPED_CHAR.matcher(text)
        println(matcher.allCount())
        while (let Some(mds: MatchData) <- matcher.find()) { // 3
            let pos = mds.matchPosition() // 80 - 84    92 - 96    107 - 111
            println(mds.matchString()) //    &amp    &amp    &amp
            println(pos.start)
            println(pos.end)
        }

        match (ENTITY_OR_ESCAPED_CHAR.matcher(text).find()) {
            case Some(r) => println(1) // this
            case None => return println(2)
        }

        let s: HashMap<String, String> = Html5Entities.readEntities()
        match (s.get("QUOT")) { // java [34] cj [34]
            case Some(stringS) => println("QUOT: ${stringS.toArray()}")
            case _ => println("wrong")
        }

        let s2: HashMap<String, String> = Html5Entities.readEntities()
        match (s2.get("rlm")) { // java [-30, -128, -113] cj [226, 128, 143]
            case Some(stringS) => println("rlm: ${stringS.toArray()}")
            case _ => println("wrong")
        }

        let s3: HashMap<String, String> = Html5Entities.readEntities()
        match (s3.get("lrm")) { // java [-30, -128, -114] cj [226, 128, 142]
            case Some(stringS) => println("lrm: ${stringS.toArray()}")
            case _ => println("wrong")
        }

        let s4: HashMap<String, String> = Html5Entities.readEntities()
        match (s4.get("blank")) { // java [-30, -112, -93] cj [226, 144, 163]
            case Some(stringS) => println("blank: ${stringS.toArray()}")
            case _ => println("wrong")
        }

        let s5: HashMap<String, String> = Html5Entities.readEntities()
        match (s5.get("quaternions")) { // java [-30, -124, -115] cj [226, 132, 141]
            case Some(stringS) => println("quaternions: ${stringS.toArray()}")
            case _ => println("wrong")
        }
    }
}

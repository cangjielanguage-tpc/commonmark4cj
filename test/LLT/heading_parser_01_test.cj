// DEPENDENCE: z_test.cj
// EXEC: cjc %import-path %L %l %f z_test.cj -Woff unused
// EXEC: ./main

import commonmark4cj.commonmark.*
import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import std.unicode.*
import std.reflect.{TypeInfo}

main() {
    let tester = HeadingParserTests()
    tester.test1()
    tester.test2()
    tester.test3()
    tester.test4()
    tester.test5()
    tester.test6()
    tester.test7()
    tester.test8()
    tester.test9()
    tester.test10()
    tester.test11()
    tester.test12()
    tester.test13()
    tester.test14()
    tester.test15()
    tester.test16()
    tester.test17()
    tester.test18()
    tester.test19()
    tester.test20()
    tester.test21()
    tester.test22()
    tester.test23()
    tester.test24()
    tester.test25()
    tester.test26()
    tester.test27()
    tester.test28()
    tester.test29()
    tester.test30()
    return 0
}

@Test
public class HeadingParserTests {
    private static let PARSER: Parser = Parser.builder().build()
    private static let RENDERER: HtmlRenderer = HtmlRenderer.builder().build()

    @TestCase
    public func test1(): Unit {
        @Expect("<h1>test</h1>", render("# test"))
    }

    @TestCase
    public func test2(): Unit {
        @Expect("<h2>test</h2>", render("## test"))
    }

    @TestCase
    public func test3(): Unit {
        @Expect("<h3>test</h3>", render("### test"))
    }

    @TestCase
    public func test4(): Unit {
        @Expect("<h4>test</h4>", render("#### test"))
    }

    @TestCase
    public func test5(): Unit {
        @Expect("<h5>test</h5>", render("##### test"))
    }

    @TestCase
    public func test6(): Unit {
        @Expect("<h6>test</h6>", render("###### test"))
    }

    @TestCase
    public func test7(): Unit {
        @Expect("<p>####### test</p>", render("###### test"))
    }

    @TestCase
    public func test8(): Unit {
        @Expect("<p>#######test</p>", render("######test"))
    }

    @TestCase
    public func test9(): Unit {
        @Expect("<p>#test</p>", render("#test"))
    }

    @TestCase
    public func test10(): Unit {
        @Expect("<h1>*</h1>", render("# *"))
    }

    @TestCase
    public func test11(): Unit {
        @Expect("<h1></h1>", render("# \n"))
    }

    @TestCase
    public func test12(): Unit {
        @Expect("<h1></h1>", render("# \r"))
    }

    @TestCase
    public func test13(): Unit {
        @Expect("<h1></h1>", render("# \t"))
    }

    @TestCase
    public func test14(): Unit {
        @Expect("<h1></h1>", render("# \r\t"))
    }

    @TestCase
    public func test15(): Unit {
        @Expect("<h1>&lt;</h1>", render("# &lt;"))
    }

    @TestCase
    public func test16(): Unit {
        @Expect("<p>test=</p>", render("test="))
    }

    @TestCase
    public func test17(): Unit {
        @Expect("<p>test =</p>", render("test\t="))
    }
    @TestCase
    public func test18(): Unit {
        @Expect("<h1>test</h1>", render("test\r="))
    }
    @TestCase
    public func test19(): Unit {
        @Expect("<p>test\n=</p>", render("test\r\t="))
    }
    @TestCase
    public func test20(): Unit {
        @Expect("<p>test=</p>", render("test=\n"))
    }
    @TestCase
    public func test21(): Unit {
        @Expect("<h2>test</h2>", render("test\n--"))
    }
    @TestCase
    public func test22(): Unit {
        @Expect("<h2>test</h2>", render("test\n-------"))
    }
    @TestCase
    public func test23(): Unit {
       @Expect("<h1>test</h1>", render("test\n=="))
    }
    @TestCase
    public func test24(): Unit {
       @Expect("<p>test\n== -</p>", render("test\n== -"))
    }
    @TestCase
    public func test25(): Unit {
       @Expect("<p>test</p>\n<p>=</p>", render("test\n\n="))
    }
    @TestCase
    public func test26(): Unit {
        @Expect("<h1>test</h1>", render("\ntest\n="))
    }
    @TestCase
    public func test27(): Unit {
       @Expect("<h1>test</h1>\n<p>=</p>", render("# test\n="))
    }
    @TestCase
    public func test28(): Unit {
        @Expect("<h1>test</h1>\n<ul>\n<li></li>\n</ul>", render("# test\n-"))
    }
    @TestCase
    public func test29(): Unit {
        @Expect("<h1>test</h1>\n<p>--</p>", render("# test\n--"))
    }
    @TestCase
    public func test30(): Unit {
        @Expect("<ul>\n<li>test\n--</li>\n</ul>", render("- test\n--"))
    }

    func render(source: String): String {
        let node: Node = PARSER.parse(source)
        return RENDERER.render(node)
    }
  
}

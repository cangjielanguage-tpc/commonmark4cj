// EXEC: cjc %import-path %L %l %f --test
// EXEC: ./main

package commonmark

import commonmark4cj.commonmark.*
import std.unittest.*
import std.unittest.testmacro.*

@Test
public class EscapingTest {

    @TestCase
    public func test1(): Unit {
        @Expect("nothing to escape", Escaping.escapeHtml("nothing to escape"))
    }
    @TestCase
    public func test2(): Unit {
        @Expect("&amp;", Escaping.escapeHtml("&"))
    }
    @TestCase
    public func test3(): Unit {
        @Expect("&lt;", Escaping.escapeHtml("<"))
    }
    @TestCase
    public func test4(): Unit {
        @Expect("&gt;", Escaping.escapeHtml(">"))
    }
    @TestCase
    public func test5(): Unit {
        @Expect("&quot;", Escaping.escapeHtml("\""))
    }
    @TestCase
    public func test6(): Unit {
        @Expect("&lt; start", Escaping.escapeHtml("< start"))
    }
    @TestCase
    public func test7(): Unit {
        @Expect("end &gt;", Escaping.escapeHtml("end >"))
    }
    @TestCase
    public func test8(): Unit {
        @Expect("&lt; both &gt;", Escaping.escapeHtml("< both >"))
    }
    @TestCase
    public func test9(): Unit {
        @Expect("&lt; middle &amp; too &gt;", Escaping.escapeHtml("< middle & too >"))
    }
  
}

// DEPENDENCE: z_test.cj
// EXEC: cjc %import-path %L %l %f z_test.cj -Woff unused
// EXEC: ./main

import commonmark4cj.commonmark.*
import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import std.reflect.{TypeInfo}

main() {
    let tester = DelimitedTest()
    tester.emphasisDelimiters()
    return 0
}

class DelimitedAbstractVisitor <: AbstractVisitor {
    var list: ArrayList<Delimited> = ArrayList<Delimited>()

    init(list: ArrayList<Delimited>) {
        this.list = list
    }
    public override func visit(node: Emphasis) {
        list.add(node)
    }
    public override func visit(node: StrongEmphasis) {
        list.add(node)
    }
}

@Test
public class DelimitedTest {
    @TestCase
    public func emphasisDelimiters(): Unit {
        let input: String = "* *emphasis* \n" + "* **strong** \n" + "* _important_ \n" + "* __CRITICAL__ \n"

        let parser: Parser = Parser.builder().build()
        let document: Node = parser.parse(input)

        let list: ArrayList<Delimited> = ArrayList<Delimited>()

        let visitor: DelimitedAbstractVisitor = DelimitedAbstractVisitor(list)
        document.accept(visitor)

        assertEquals(4, list.size)

        let emphasis: Delimited = list.get(0)()
        let strong: Delimited = list.get(1)()
        let important: Delimited = list.get(2)()
        let critical: Delimited = list.get(3)()

        assertEquals("*", emphasis.getOpeningDelimiter()())
        assertEquals("*", emphasis.getClosingDelimiter()())
        assertEquals("**", strong.getOpeningDelimiter()())
        assertEquals("**", strong.getClosingDelimiter()())
        assertEquals("_", important.getOpeningDelimiter()())
        assertEquals("_", important.getClosingDelimiter()())
        assertEquals("__", critical.getOpeningDelimiter()())
        assertEquals("__", critical.getClosingDelimiter()())
    }
}

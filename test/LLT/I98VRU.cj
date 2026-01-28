// DEPENDENCE: z_test.cj
// EXEC: cjc %import-path %L %l %f z_test.cj
// EXEC: ./main

import commonmark4cj.commonmark.*
import std.unittest.*
import std.unittest.testmacro.*
import std.reflect.*

main(): Int64 {
    let tester = I98VRUTester()
    tester.t1()
    return 0
}

@Test
public class I98VRUTester {
    @TestCase
    func t1(): Unit {
        let md = Parser.builder().build()
        let node = md.parse("nihao仓颉")
        printNode(node)

        let text = TextContentRenderer.builder().build().render(node)
        @Assert(text,"nihao仓颉")
    }
}
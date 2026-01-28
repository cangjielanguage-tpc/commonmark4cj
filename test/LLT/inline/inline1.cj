// DEPENDENCE: ../z_test.cj
// EXEC: cjc %import-path %L %l %f z_test.cj -Woff unused --test --debug-macro
// EXEC: ./main 
//--filter=*.t1 --show-all-output

internal import commonmark4cj.commonmark.*
internal import commonmark4cj.table.*
internal import std.collection.*
internal import std.regex.*

@Test
func t1(): Unit {
    let parser = Parser.builder().extensions([TablesExtension.create()]).build()
    let doc = parser.parse(#"| f\|oo  |
| ------ |
| b `\|` az |
| b **\|** im |"#)
    printNode(doc)
}

@Test
func t2(): Unit {
    let str = #"b **\|** im"#.toArray()
    let f = {
        i: Int =>
        let (r, l) = Rune.getPreviousFromUtf8(str, i)
        println("${r}-${UInt32(r)}-${l}")
    }
    f(1)
    f(2)
    f(3)
    f(4)
}
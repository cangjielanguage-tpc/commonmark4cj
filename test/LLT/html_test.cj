// DEPENDENCE: z_test.cj
// EXEC: cjc %import-path %L %l %f z_test.cj --test
// EXEC: ./main

import commonmark4cj.commonmark.*

@Test
func html1(): Unit {
    let md = Parser.builder().build()

    var node = md.parse("<a>asd</a>")
    printNode(node)

    node = md.parse("### <a>asd</a>")
    printNode(node)

    node = md.parse(#"<a>  adsfa
    asd
    </a>"#)
    printNode(node)

    node = md.parse(#"  <a> as d  </a>
    <a>asd</a>"#)
    printNode(node)
}
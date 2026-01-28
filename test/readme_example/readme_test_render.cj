// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import commonmark4cj.commonmark.*

main(): Int64 {
    let rendered: String = htmlAllowingRenderer().render(
        parse("paragraph with <span id='foo' class=\"bar\">inline &amp; html</span>"))
    println(rendered)
    return 0
}

func htmlAllowingRenderer(): HtmlRenderer {
    return HtmlRenderer.builder().escapeHtml(false).build()
}

func parse(source: String): Node {
    return Parser.builder().build().parse(source)
}
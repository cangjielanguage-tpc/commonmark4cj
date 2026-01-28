// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import commonmark4cj.commonmark.*
main(): Int64 {
    var tb = Text("bb") // node子类
    var ta = Text("aa")
    ta.appendChild(tb)
    var firstChild: ?Node = ta.getFirstChild()
    var lastChild: ?Node = ta.getLastChild()
    println((firstChild.getOrThrow() as Text).getOrThrow().getLiteral())
    println((lastChild.getOrThrow() as Text).getOrThrow().getLiteral())

    var next: ?Node = firstChild.getOrThrow().getNext()
    var prev: ?Node = lastChild.getOrThrow().getPrevious()
    println(next.isNone())
    println(prev.isNone())
    var tc = Text("cc")
    ta.appendChild(tc)
    lastChild = ta.getLastChild()
    firstChild = ta.getFirstChild()
    println((lastChild.getOrThrow() as Text).getOrThrow().getLiteral())
    println((firstChild.getOrThrow() as Text).getOrThrow().getLiteral())

    next = firstChild.getOrThrow().getNext()
    prev = lastChild.getOrThrow().getPrevious()
    println(next.isNone())
    println(prev.isNone())
    println((next.getOrThrow() as Text).getOrThrow().getLiteral())
    println((prev.getOrThrow() as Text).getOrThrow().getLiteral())

    return 0
}
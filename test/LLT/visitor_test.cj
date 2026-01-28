// DEPENDENCE: z_test.cj 
// EXEC: cjc %import-path %L %l %f z_test.cj
// EXEC: ./main

import commonmark4cj.commonmark.*
import std.unittest.*
import std.unittest.testmacro.*

main(): Int64 {
    let tester = VisitorTest()
    tester.visitorDocument()
    tester.visitorBlockQuote()
    tester.visitorBulletListQuote()
    tester.visitorCodeQuote()
    tester.visitorFencedCodeBlockQuote()
    tester.visitorHtmlBlockQuote()
    tester.visitorIndentedCodeBlockQuote()
    tester.visitorOrderedListQuote()
    tester.visitorListItemQuote()
    tester.visitorThematicBreakQuote()
    tester.visitorHeadingQuote()
    tester.visitorEmphasisQuote()
    tester.visitorHardLineBreakQuote()
    tester.visitorHtmlInlineQuote()
    tester.visitorImageQuote()
    tester.visitorLink()
    tester.visitorSoftLineBreak()
    tester.visitorStrongEmphasis()
    return 0
}
class visitorImpl <: AbstractVisitor {
    public func visit(code: Code): Unit {
        code.insertAfter(Text("new text"))
        code.unlink()
    }
}
class visitorCodeImpl <: AbstractVisitor {
    public func visit(text: Text): Unit {
        text.insertAfter(Code("new text"))
        text.unlink()
    }
}

class visitorEmphasisImpl <: AbstractVisitor {
    public func visit(text: Text): Unit {
        text.appendChild(Code("new text"))
    }
}
@Test
public class VisitorTest {

    @TestCase
    public func visitorDocument(): Unit {
        let visitor: Visitor = visitorImpl()

        var document: Document = Document()
        var paragraph = Paragraph()
        var text = Text("text")
        var code = Code("code")

        document.appendChild(paragraph)
        document.appendChild(text)
        document.appendChild(code)

        document.accept(visitor)

        assertEquals("Text{literal=new text}", document.getLastChild()().toString())
    }

    @TestCase
    public func visitorBlockQuote(): Unit {
        let visitor: Visitor = visitorImpl()

        var blockQuote: BlockQuote = BlockQuote()
        var text = Text("text")
        var code = Code("code")

        blockQuote.appendChild(text)
        blockQuote.appendChild(code)

        blockQuote.accept(visitor)

        assertEquals("Text{literal=new text}", blockQuote.getLastChild()().toString())
        assertEquals("Text{literal=text}", blockQuote.getFirstChild()().toString())
    }

    @TestCase
    public func visitorBulletListQuote(): Unit {
        let visitor: Visitor = visitorImpl()

        var bulletList: BulletList = BulletList(r'*')
        var text = Text("text")
        var code = Code("code")

        bulletList.appendChild(text)
        bulletList.appendChild(code)

        bulletList.accept(visitor)

        assertEquals("Text{literal=new text}", bulletList.getLastChild()().toString())
        assertEquals("Text{literal=text}", bulletList.getFirstChild()().toString())
    }

    @TestCase
    public func visitorCodeQuote(): Unit {
        let visitor: Visitor = visitorCodeImpl()

        var bulletList: Code = Code("p")
        var text = Text("text")
        var code = Code("code")

        bulletList.appendChild(text)
        bulletList.appendChild(code)

        bulletList.accept(visitor)

        assertEquals("Code{}", bulletList.getLastChild()().toString())
        assertEquals("Code{}", bulletList.getFirstChild()().toString())
    }    

    @TestCase
    public func visitorFencedCodeBlockQuote(): Unit {
        let visitor: Visitor = visitorCodeImpl()

        var node: FencedCodeBlock = FencedCodeBlock()
        var text = Text("text")
        var code = Code("code")
        var paragraph = Paragraph()

        node.appendChild(text)
        node.appendChild(code)
        node.appendChild(paragraph)

        node.accept(visitor)

        assertEquals("Code{}", node.getFirstChild()().toString())
        assertEquals("Code{}", node.getFirstChild()().getNext()().toString())
        assertEquals("Paragraph{}", node.getFirstChild()().getNext()().getNext()().toString())
    }    

    @TestCase
    public func visitorHtmlBlockQuote(): Unit {
        let visitor: Visitor = visitorCodeImpl()

        var node: HtmlBlock = HtmlBlock()
        var text = Text("text")
        var code = Code("code")
        var paragraph = Paragraph()

        node.appendChild(text)
        node.appendChild(code)
        node.appendChild(paragraph)

        node.accept(visitor)

        assertEquals("Code{}", node.getFirstChild()().toString())
        assertEquals("Code{}", node.getFirstChild()().getNext()().toString())
        assertEquals("Paragraph{}", node.getFirstChild()().getNext()().getNext()().toString())
    }  

    @TestCase
    public func visitorIndentedCodeBlockQuote(): Unit {
        let visitor: Visitor = visitorCodeImpl()

        var node: IndentedCodeBlock = IndentedCodeBlock()
        var text = Text("text")
        var code = Code("code")
        var paragraph = Paragraph()

        node.appendChild(text)
        node.appendChild(code)
        node.appendChild(paragraph)

        node.accept(visitor)

        assertEquals("Code{}", node.getFirstChild()().toString())
        assertEquals("Code{}", node.getFirstChild()().getNext()().toString())
        assertEquals("Paragraph{}", node.getFirstChild()().getNext()().getNext()().toString())
    } 

    @TestCase
    public func visitorOrderedListQuote(): Unit {
        let visitor: Visitor = visitorCodeImpl()

        var node: OrderedList = OrderedList(1,r',')
        var text = Text("text")
        var code = Code("code")
        var paragraph = Paragraph()

        node.appendChild(text)
        node.appendChild(code)
        node.appendChild(paragraph)

        node.accept(visitor)

        assertEquals("Code{}", node.getFirstChild()().toString())
        assertEquals("Code{}", node.getFirstChild()().getNext()().toString())
        assertEquals("Paragraph{}", node.getFirstChild()().getNext()().getNext()().toString())
    } 

    @TestCase
    public func visitorListItemQuote(): Unit {
        let visitor: Visitor = visitorCodeImpl()

        var node: ListItem = ListItem()
        var text = Text("text")
        var code = Code("code")
        var paragraph = Paragraph()

        node.appendChild(text)
        node.appendChild(code)
        node.appendChild(paragraph)

        node.accept(visitor)

        assertEquals("Code{}", node.getFirstChild()().toString())
        assertEquals("Code{}", node.getFirstChild()().getNext()().toString())
        assertEquals("Paragraph{}", node.getFirstChild()().getNext()().getNext()().toString())
    } 

    @TestCase
    public func visitorThematicBreakQuote(): Unit {
        let visitor: Visitor = visitorCodeImpl()

        var node: ThematicBreak = ThematicBreak()
        var text = Text("text")
        var code = Code("code")
        var paragraph = Paragraph()

        node.appendChild(text)
        node.appendChild(code)
        node.appendChild(paragraph)

        node.accept(visitor)

        assertEquals("Code{}", node.getFirstChild()().toString())
        assertEquals("Code{}", node.getFirstChild()().getNext()().toString())
        assertEquals("Paragraph{}", node.getFirstChild()().getNext()().getNext()().toString())
    } 

    @TestCase
    public func visitorHeadingQuote(): Unit {
        let visitor: Visitor = visitorCodeImpl()

        var node: Heading = Heading()
        var text = Text("text")
        var code = Code("code")
        var paragraph = Paragraph()

        node.appendChild(text)
        node.appendChild(code)
        node.appendChild(paragraph)

        node.accept(visitor)

        assertEquals("Code{}", node.getFirstChild()().toString())
        assertEquals("Code{}", node.getFirstChild()().getNext()().toString())
        assertEquals("Paragraph{}", node.getFirstChild()().getNext()().getNext()().toString())
    } 

    @TestCase
    public func visitorEmphasisQuote(): Unit {
        let visitor: Visitor = visitorEmphasisImpl()

        var node: Emphasis = Emphasis("*")
        var child: Text = Text("hello")

        node.appendChild(child)
        node.accept(visitor)

        assertEquals("Text{literal=hello}", node.getFirstChild()().toString())
        assertEquals("Code{}", node.getFirstChild()().getFirstChild()().toString())
    } 

    @TestCase
    public func visitorHardLineBreakQuote(): Unit {
        let visitor: Visitor = visitorEmphasisImpl()

        var node: HardLineBreak = HardLineBreak()
        var child: Text = Text("hello")

        node.appendChild(child)
        node.accept(visitor)

        assertEquals("Text{literal=hello}", node.getFirstChild()().toString())
        assertEquals("Code{}", node.getFirstChild()().getFirstChild()().toString())
    } 

    @TestCase
    public func visitorHtmlInlineQuote(): Unit {
        let visitor: Visitor = visitorEmphasisImpl()

        var node: HtmlInline = HtmlInline("p1")
        var child: Text = Text("hello")

        node.appendChild(child)
        node.accept(visitor)    

        assertEquals("Text{literal=hello}", node.getFirstChild()().toString())
        assertEquals("Code{}", node.getFirstChild()().getFirstChild()().toString())
    } 

    @TestCase
    public func visitorImageQuote(): Unit {
        let visitor: Visitor = visitorEmphasisImpl()

        var node: Image = Image("path", "title")
        var child: Text = Text("hello")

        node.appendChild(child)
        node.accept(visitor)

        assertEquals("Text{literal=hello}", node.getFirstChild()().toString())
        assertEquals("Code{}", node.getFirstChild()().getFirstChild()().toString())
    }

    @TestCase
    public func visitorLink(): Unit {
        let visitor: Visitor = visitorEmphasisImpl()

        var node: Link = Link("path", "title")
        var child: Text = Text("hello")

        node.appendChild(child)
        node.accept(visitor)

        assertEquals("Text{literal=hello}", node.getFirstChild()().toString())
        assertEquals("Code{}", node.getFirstChild()().getFirstChild()().toString())
    }

    @TestCase
    public func visitorSoftLineBreak(): Unit {
        let visitor: Visitor = visitorEmphasisImpl()

        var node: SoftLineBreak = SoftLineBreak()
        var child: Text = Text("hello")

        node.appendChild(child)
        node.accept(visitor)

        assertEquals("Text{literal=hello}", node.getFirstChild()().toString())
        assertEquals("Code{}", node.getFirstChild()().getFirstChild()().toString())
    }

    @TestCase
    public func visitorStrongEmphasis(): Unit {
        let visitor: Visitor = visitorEmphasisImpl()

        var node: StrongEmphasis = StrongEmphasis("***")
        var child: Text = Text("hello")

        node.appendChild(child)
        node.accept(visitor)

        assertEquals("Text{literal=hello}", node.getFirstChild()().toString())
        assertEquals("Code{}", node.getFirstChild()().getFirstChild()().toString())
    }

}

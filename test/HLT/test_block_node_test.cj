// 3rd_party_lib:commonmark4cj/build/release/commonmark4cj
// 3rd_party_lib_ohos:commonmark4cj/build/aarch64-linux-ohos/commonmark4cj
// dependence: z_test.cj

import commonmark4cj.commonmark.*
import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import std.collection.*

@Test
public class BlockNodeTest {
    @TestCase
    func documentTest(): Unit {
        var document: Document = Document ()
        var paragraph = Paragraph()
        var blockQuote = BlockQuote()
        var htmlBlock = HtmlBlock()
        var thematicBreak = ThematicBreak()
        var indentedCodeBlock = IndentedCodeBlock()
        var text = Text("text")
        document.appendChild(paragraph)
        document.appendChild(blockQuote)
        document.appendChild(htmlBlock)
        document.appendChild(thematicBreak)
        document.appendChild(indentedCodeBlock)
        document.appendChild(text)
        assertEquals("Document{}", blockQuote.getParent()().toString())
        assertEquals(None, document.getParent())
        htmlBlock.setLiteral("p1")
        assertEquals("p1", htmlBlock.getLiteral())
        assertEquals("HtmlBlock{}", thematicBreak.getPrevious()().toString())
        htmlBlock.insertBefore(Text("foo"))
        assertEquals("Text{literal=foo}", htmlBlock.getPrevious()().toString())
        assertEquals(true, paragraph != htmlBlock)
    }

    @TestCase
    func documentTest2(): Unit {
        var document: Document = Document ()
        var paragraph = Paragraph()
        document.prependChild(paragraph)
        assertEquals("Paragraph{}", document.getFirstChild()().toString())
    }

    @TestCase
    func documentTest3(): Unit {
        var indentedCodeBlock  = IndentedCodeBlock()
        indentedCodeBlock.setLiteral("foo")
        assertEquals("foo", indentedCodeBlock.getLiteral())
    }

    @TestCase
    func indentedCodeBlockTest(): Unit {
        var indentedCodeBlock  = IndentedCodeBlock()
        indentedCodeBlock.setLiteral("foo")
        assertEquals("foo", indentedCodeBlock.getLiteral())
    }

    @TestCase
    func fencedCodeBlockTest(): Unit {
        var fencedCodeBlock = FencedCodeBlock()
        fencedCodeBlock.setFenceChar(r'`')
        fencedCodeBlock.setFenceLength(1)
        fencedCodeBlock.setFenceIndent(1)
        fencedCodeBlock.setInfo("cangjie")
        fencedCodeBlock.setLiteral("var")
        assertEquals(r'`', fencedCodeBlock.getFenceChar())
        assertEquals(1, fencedCodeBlock.getFenceLength())
        assertEquals(1, fencedCodeBlock.getFenceIndent())
        assertEquals("cangjie", fencedCodeBlock.getInfo())
        assertEquals("var", fencedCodeBlock.getLiteral())
    }

    @TestCase
    func headingTest(): Unit {
        var Heading = Heading ()
        Heading.setLevel(1)
        assertEquals(1, Heading.getLevel())
    }

    @TestCase
    func bulletListTest(): Unit {
        var BulletList  = BulletList(r'*')
        assertEquals(r'*', BulletList.getBulletMarker())
        BulletList.setBulletMarker(r'$')
        assertEquals(r'$', BulletList.getBulletMarker())
    }

    @TestCase
    func orderedListTest(): Unit {
        var orderedList = OrderedList(1, r'.')
        assertEquals(1, orderedList.getStartNumber())
        assertEquals(r'.', orderedList.getDelimiter())
        orderedList.setStartNumber(2)
        orderedList.setDelimiter(r',')
        assertEquals(2, orderedList.getStartNumber())
        assertEquals(r',', orderedList.getDelimiter())
    }

    @TestCase
    func fencedCodeBlockTest1(): Unit {
        var fencedCodeBlock = FencedCodeBlock()
        fencedCodeBlock.setFenceLength(-9223372036854775808)
        fencedCodeBlock.setFenceIndent(-9223372036854775808)
        @Assert(fencedCodeBlock.getFenceLength(),-9223372036854775808)
        @Assert(fencedCodeBlock.getFenceIndent(),-9223372036854775808)
    }


    @TestCase
    func fencedCodeBlockTest2(): Unit {
        var fencedCodeBlock = FencedCodeBlock()
        fencedCodeBlock.setFenceLength(9223372036854775807)
        fencedCodeBlock.setFenceIndent(9223372036854775807)
        @Assert(fencedCodeBlock.getFenceLength(),9223372036854775807)
        @Assert(fencedCodeBlock.getFenceIndent(),9223372036854775807)
    }

    @TestCase
    func fencedCodeBlockTest3(): Unit {
        var fencedCodeBlock = FencedCodeBlock()
        fencedCodeBlock.setFenceLength(0)
        fencedCodeBlock.setFenceIndent(0)
        @Assert(fencedCodeBlock.getFenceLength(),0)
        @Assert(fencedCodeBlock.getFenceIndent(),0)
    }


    @TestCase
    func headingTest1(): Unit {
        var Heading = Heading ()
        Heading.setLevel(-9223372036854775808)
        @Assert(-9223372036854775808, Heading.getLevel())
    }

    @TestCase
    func headingTest2(): Unit {
        var Heading = Heading ()
        Heading.setLevel(9223372036854775807)
        @Assert(9223372036854775807, Heading.getLevel())
    }


    @TestCase
    func orderedListTest1(): Unit {
        var orderedList = OrderedList(9223372036854775807, r'.')
        @Assert(9223372036854775807, orderedList.getStartNumber())
        @Assert(r'.', orderedList.getDelimiter())
        orderedList.setStartNumber(9223372036854775807)
        orderedList.setDelimiter(r'，')
        @Assert(9223372036854775807, orderedList.getStartNumber())
        @Assert(r'，', orderedList.getDelimiter())
    }

    @TestCase
    func orderedListTest2(): Unit {
        var orderedList = OrderedList(0, r'.')
        @Assert(0, orderedList.getStartNumber())
        @Assert(r'.', orderedList.getDelimiter())
        orderedList.setStartNumber(-9223372036854775808)
        orderedList.setDelimiter(r'↗')
        @Assert(-9223372036854775808, orderedList.getStartNumber())
        @Assert(r'↗', orderedList.getDelimiter())
    }

    @TestCase
    func orderedListTest3(): Unit {
        var orderedList = OrderedList(0, r'.')
        @Assert(0, orderedList.getStartNumber())
        @Assert(r'.', orderedList.getDelimiter())
        orderedList.setStartNumber(0)
        orderedList.setDelimiter(r'仓')
        @Assert(0, orderedList.getStartNumber())
        @Assert(r'仓', orderedList.getDelimiter())
    }

    @TestCase
    func orderedListTest4(): Unit {
        var orderedList = OrderedList(0, r'.')
        @Assert(0, orderedList.getStartNumber())
        @Assert(r'.', orderedList.getDelimiter())
        orderedList.setStartNumber(0)
        orderedList.setDelimiter(r'③')
        @Assert(0, orderedList.getStartNumber())
        @Assert(r'③', orderedList.getDelimiter())
    }


    
    @TestCase
    func orderedListTest5(): Unit {
        var a=0
        try{
            BlockContinue.atIndex(-9223372036854775808)
            BlockContinue.atColumn(-9223372036854775808)
            BlockContinue.atIndex(9223372036854775807)
            BlockContinue.atColumn(9223372036854775807)
        } catch (e: Exception) {
            a++
        }
        @Assert(a ,0)
    }

}

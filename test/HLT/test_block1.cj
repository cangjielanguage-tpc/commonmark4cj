// 3rd_party_lib:commonmark4cj/build/release/commonmark4cj
// 3rd_party_lib_ohos:commonmark4cj/build/aarch64-linux-ohos/commonmark4cj

import commonmark4cj.commonmark.*
import commonmark4cj.table.*

@Test
public class TestCommarkBlockQuote{
    @TestCase
    func test_BlockQuote_init1():Unit {
        var blockQuote1 = BlockQuote()
        var blockQuote2 = BlockQuote()
        blockQuote1.appendChild(blockQuote2)
        let blockQuote3: ?Node = blockQuote2.getParent()
        @Assert(blockQuote3.isSome(),true)
        @Assert(blockQuote3.getOrThrow() is BlockQuote,true)
        @Assert(blockQuote3.getOrThrow() == blockQuote1,true)
    }


    @TestCase
    func test_BlockQuote_init2():Unit {
        var blockQuote1 = BlockQuote()
        var text = Text("仓颉")
        try {
            text.appendChild(blockQuote1)
        } catch (e: IllegalArgumentException) {
            @Assert(e.toString().contains("Parent of block must also be block (can not be inline)") ,true)
        }
    }


    @TestCase
    func test_BlockQuote_init3():Unit {
        var blockQuote1 = BlockQuote()
        var text = Text("123")
        try {
            text.appendChild(blockQuote1)
        } catch (e: IllegalArgumentException) {
            @Assert(e.toString().contains("Parent of block must also be block (can not be inline)") ,true)
        }
    }


    @TestCase
    func test_BlockQuote_init4():Unit {
        var blockQuote1 = BlockQuote()
        var text = Text("123仓颉")
        try {
            text.appendChild(blockQuote1)
        } catch (e: IllegalArgumentException) {
            @Assert(e.toString().contains("Parent of block must also be block (can not be inline)") ,true)
        }
    }

}

@Test        /****Test+库名+类名***/
public class TestCommarkHtmlBlock{

    @TestCase
    func test_HtmlBlock_init2():Unit {
        var htmlBlock = HtmlBlock()
        htmlBlock.setLiteral("仓颉")
        @Assert(htmlBlock.getLiteral(),"仓颉")
    }

    @TestCase
    func test_HtmlBlock_init3():Unit {
        var htmlBlock = HtmlBlock()
        htmlBlock.setLiteral("仓颉")
        htmlBlock.setLiteral("123213")
        @Assert(htmlBlock.getLiteral(),"123213")
    }

    @TestCase
    func test_HtmlBlock_init4():Unit {
        var htmlBlock = HtmlBlock()
        htmlBlock.setLiteral("### ")
        htmlBlock.setLiteral("## ")
        @Assert(htmlBlock.getLiteral(),"## ")
    }

    @TestCase
    func test_HtmlBlock_accept():Unit {
        var htmlBlock = HtmlBlock()
        htmlBlock.setLiteral("~~~")
        htmlBlock.setLiteral("~仓颉~")
        @Assert(htmlBlock.getLiteral(),"~仓颉~")
    }
}

@Test        /****Test+库名+类名***/
public class TestCommarkIndentedCodeBlock{
    @TestCase
    func test_IndentedCodeBlock_init1():Unit {
        var indentedCodeBlock = IndentedCodeBlock()
        @Assert(indentedCodeBlock.getLiteral(),"")
    }

    @TestCase
    func test_IndentedCodeBlock_init2():Unit {
        var indentedCodeBlock = IndentedCodeBlock()
        indentedCodeBlock.setLiteral("，、，、")
        @Assert(indentedCodeBlock.getLiteral(),"，、，、")
    }

    @TestCase
    func test_IndentedCodeBlock_init3():Unit {
        var indentedCodeBlock = IndentedCodeBlock()
        indentedCodeBlock.setLiteral("、仓颉123，、")
        indentedCodeBlock.setLiteral("、仓颉123，111")
        @Assert(indentedCodeBlock.getLiteral(),"、仓颉123，111")
    }

}

@Test        /****Test+库名+类名***/
public class TestCommarkFencedCodeBlock{
    @TestCase
    func test_FencedCodeBlock_init1():Unit {
        var fencedCodeBlock = FencedCodeBlock()
        @Assert(fencedCodeBlock.getFenceChar(),r'\u{0}')
        @Assert(fencedCodeBlock.getFenceLength(), 0)
        @Assert(fencedCodeBlock.getFenceIndent(), 0)
        @Assert(fencedCodeBlock.getInfo(), "")
        @Assert(fencedCodeBlock.getLiteral(),"")    
    }

    @TestCase
    func test_FencedCodeBlock_init2():Unit {
        var fencedCodeBlock = FencedCodeBlock()
        fencedCodeBlock.setFenceChar(r'仓')
        fencedCodeBlock.setFenceLength(2222222222)
        fencedCodeBlock.setFenceIndent(2222222222)
        fencedCodeBlock.setInfo("仓颉12")
        fencedCodeBlock.setLiteral("仓颉literal12")
        @Assert(fencedCodeBlock.getFenceChar(),r'仓')
        @Assert(fencedCodeBlock.getFenceLength(), 2222222222)
        @Assert(fencedCodeBlock.getFenceIndent(), 2222222222)
        @Assert(fencedCodeBlock.getInfo(), "仓颉12")
        @Assert(fencedCodeBlock.getLiteral(), "仓颉literal12")
    }

    @TestCase
    func test_FencedCodeBlock_init3():Unit {
        var fencedCodeBlock = FencedCodeBlock()
        fencedCodeBlock.setFenceChar(r'#')
        fencedCodeBlock.setFenceLength(-2222222222)
        fencedCodeBlock.setFenceIndent(-2222222222)
        fencedCodeBlock.setInfo("（")
        fencedCodeBlock.setLiteral("）")
        @Assert(fencedCodeBlock.getFenceChar(),r'#')
        @Assert(fencedCodeBlock.getFenceLength(), -2222222222)
        @Assert(fencedCodeBlock.getFenceIndent(), -2222222222)
        @Assert(fencedCodeBlock.getInfo(), "（")
        @Assert(fencedCodeBlock.getLiteral(), "）")
    }

    @TestCase
    func test_FencedCodeBlock_accept():Unit {
        var fencedCodeBlock = FencedCodeBlock()
        fencedCodeBlock.appendChild(Text("仓颉"))
        fencedCodeBlock.accept(AbstractVisitorImpl())
        let firstChild = fencedCodeBlock.getFirstChild().getOrThrow()
        @Assert((firstChild as Text).getOrThrow().getLiteral(),"仓颉")
        let lastChild = fencedCodeBlock.getLastChild().getOrThrow()
        @Assert((lastChild as Text).getOrThrow().getLiteral(),"cc")
    }

    @TestCase
    func test_FencedCodeBlock_accept1():Unit {
        var fencedCodeBlock = FencedCodeBlock()
        fencedCodeBlock.appendChild(Text("仓颉#￥"))
        fencedCodeBlock.accept(AbstractVisitorImpl())
        let firstChild = fencedCodeBlock.getFirstChild().getOrThrow()
        @Assert((firstChild as Text).getOrThrow().getLiteral(),"仓颉#￥")
 
    }
}

@Test        /****Test+库名+类名***/
public class TestCommarkHeading{

    @TestCase
    func test_HtmlBlock_init2():Unit {
        var heading = Heading()
        heading.setLevel(-25694231578412)
        @Assert(heading.getLevel(), -25694231578412)
    }

    @TestCase
    func test_HtmlBlock_init12():Unit {
        var heading = Heading()
        heading.setLevel(1425694231578412)
        @Assert(heading.getLevel(), 1425694231578412)
    }

    @TestCase
    func test_HtmlBlock_init3():Unit {
        var heading = Heading()
        heading.setLevel(1425694231578412)
        heading.setLevel(-1425694231578412)
        @Assert(heading.getLevel(), -1425694231578412)
    }

    @TestCase
    func test_HtmlBlock_init4():Unit {
        var heading = Heading()
        heading.setLevel(1425694231578412)
        heading.setLevel(1425694231578412)
        @Assert(heading.getLevel(),1425694231578412)
    }

    @TestCase
    func test_Heading_accept():Unit {
        var heading = Heading()
        heading.appendChild(Text("……&*"))
        heading.accept(AbstractVisitorImpl())
        @Assert(heading.getLevel(), 0)
        let firstChild = heading.getFirstChild().getOrThrow()
        @Assert((firstChild as Text).getOrThrow().getLiteral(),"……&*")
        let lastChild = heading.getLastChild().getOrThrow()
        @Assert((lastChild as Text).getOrThrow().getLiteral(),"cc")
    }
}

@Test        /****Test+库名+类名***/
public class TestCommarkBulletList{
    @TestCase
    func test_BulletList_init1():Unit {
        var bulletList = BulletList(r'\u{85}')
        @Assert(bulletList.getBulletMarker(), r'\u{85}')
        @Assert(bulletList.isTight(), false)
    }

    @TestCase
    func test_BulletList_init2():Unit {
        var bulletList = BulletList(r'\u{0}')
        bulletList.setBulletMarker(r'颉')
        bulletList.setTight(false)
        @Assert(bulletList.getBulletMarker(), r'颉')
        @Assert(bulletList.isTight(), false)
    }

    @TestCase
    func test_BulletList_init3():Unit {
        var bulletList = BulletList(r'\u{0}')
        bulletList.setBulletMarker(r'&')
        bulletList.setTight(false)
        bulletList.setBulletMarker(r'\u{5}')
        bulletList.setTight(false)
        @Assert(bulletList.getBulletMarker(), r'\u{5}')
        @Assert(bulletList.isTight(), false)
    }

    @TestCase
    func test_BulletList_accept():Unit {
        var bulletList = BulletList(r'仓')
        bulletList.appendChild(Text("仓颉"))
        bulletList.accept(AbstractVisitorImpl())
        @Assert(bulletList.getBulletMarker(), r'仓')
        let firstChild = bulletList.getFirstChild().getOrThrow()
        @Assert((firstChild as Text).getOrThrow().getLiteral(),"仓颉")
        let lastChild = bulletList.getLastChild().getOrThrow()
        @Assert((lastChild as Text).getOrThrow().getLiteral(),"cc")
    }
}


@Test        /****Test+库名+类名***/
public class TestCommarkOrderedList{
    @TestCase
    func test_OrderedList_init1():Unit {
        var orderedList = OrderedList(555, r'~')
        @Assert(orderedList.getStartNumber(), 555)
        @Assert(orderedList.getDelimiter(), r'~')
        @Assert(orderedList.isTight(), false)
    }

    @TestCase
    func test_OrderedList_init2():Unit {
        var orderedList = OrderedList(1, r'~')
        orderedList.setStartNumber(-8888)
        orderedList.setDelimiter(r'*')
        orderedList.setTight(true)
        @Assert(orderedList.getStartNumber(), -8888)
        @Assert(orderedList.getDelimiter(), r'*')
        @Assert(orderedList.isTight(), true)
    }

    @TestCase
    func test_OrderedList_init3():Unit {
        var orderedList = OrderedList(8, r'1')
        orderedList.setStartNumber(0)
        orderedList.setDelimiter(r'~')
        orderedList.setTight(false)
        orderedList.setStartNumber(1)
        orderedList.setDelimiter(r'*')
        orderedList.setTight(true)
        @Assert(orderedList.getStartNumber(), 1)
        @Assert(orderedList.getDelimiter(), r'*')
        @Assert(orderedList.isTight(), true)
    }

    @TestCase
    func test_OrderedList_accept():Unit {
        var orderedList = OrderedList(0, r'*')
        orderedList.appendChild(Text("&*"))
        orderedList.accept(AbstractVisitorImpl())
        @Assert(orderedList.isTight(), false)
        let firstChild = orderedList.getFirstChild().getOrThrow()
        @Assert((firstChild as Text).getOrThrow().getLiteral(),"&*")
        let lastChild = orderedList.getLastChild().getOrThrow()
        @Assert((lastChild as Text).getOrThrow().getLiteral(),"cc")
    }
}

class AbstractVisitorImpl <: AbstractVisitor {
    public func visit(blockQuote: BlockQuote): Unit {
        blockQuote.appendChild(Text("cc"))
    }

    public func visit(htmlBlock: HtmlBlock): Unit {
        htmlBlock.appendChild(Text("cc"))
    }

    public func visit(thematicBreak: ThematicBreak): Unit {
        thematicBreak.appendChild(Text("cc"))
    }

    public func visit(document: Document): Unit {
        document.appendChild(Text("cc"))
    }

    public func visit(paragraph: Paragraph): Unit {
        paragraph.appendChild(Text("cc"))
    }

    public func visit(indentedCodeBlock: IndentedCodeBlock): Unit {
        indentedCodeBlock.appendChild(Text("cc"))
    }

    public func visit(fencedCodeBlock: FencedCodeBlock): Unit {
        fencedCodeBlock.appendChild(Text("cc"))
    }

    public func visit(listItem: ListItem): Unit {
        listItem.appendChild(Text("cc"))
    }

    public func visit(heading: Heading): Unit {
        heading.appendChild(Text("cc"))
    }

    public func visit(bulletList: BulletList): Unit {
        bulletList.appendChild(Text("cc"))
    }

    public func visit(orderedList: OrderedList): Unit {
        orderedList.appendChild(Text("cc"))
    }
}
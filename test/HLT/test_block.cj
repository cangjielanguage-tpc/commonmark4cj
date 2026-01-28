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
        var text = Text("aa")
        try {
            text.appendChild(blockQuote1)
        } catch (e: IllegalArgumentException) {
            @Assert(e.toString().contains("Parent of block must also be block (can not be inline)") ,true)
        }
    }

    @TestCase
    func test_BlockQuote_accept():Unit {
        var blockQuote = BlockQuote()
        blockQuote.appendChild(Text("bb"))
        blockQuote.accept(AbstractVisitorImpl())
        let firstChild = blockQuote.getFirstChild().getOrThrow()
        @Assert((firstChild as Text).getOrThrow().getLiteral(),"bb")
        let lastChild = blockQuote.getLastChild().getOrThrow()
        @Assert((lastChild as Text).getOrThrow().getLiteral(),"cc")
    }
}

@Test        /****Test+库名+类名***/
public class TestCommarkHtmlBlock{
    @TestCase
    func test_HtmlBlock_init1():Unit {
        var htmlBlock = HtmlBlock()
        @Assert(htmlBlock.getLiteral(),"")
    }

    @TestCase
    func test_HtmlBlock_init2():Unit {
        var htmlBlock = HtmlBlock()
        htmlBlock.setLiteral("tt")
        @Assert(htmlBlock.getLiteral(),"tt")
    }

    @TestCase
    func test_HtmlBlock_init3():Unit {
        var htmlBlock = HtmlBlock()
        htmlBlock.setLiteral("tt")
        htmlBlock.setLiteral("")
        @Assert(htmlBlock.getLiteral(),"")
    }

    @TestCase
    func test_HtmlBlock_init4():Unit {
        var htmlBlock = HtmlBlock()
        htmlBlock.setLiteral("")
        htmlBlock.setLiteral("tt")
        @Assert(htmlBlock.getLiteral(),"tt")
    }

    @TestCase
    func test_HtmlBlock_accept():Unit {
        var htmlBlock = HtmlBlock()
        htmlBlock.appendChild(Text("bb"))
        htmlBlock.accept(AbstractVisitorImpl())
        @Assert(htmlBlock.getLiteral(),"")
        let firstChild = htmlBlock.getFirstChild().getOrThrow()
        @Assert((firstChild as Text).getOrThrow().getLiteral(),"bb")
        let lastChild = htmlBlock.getLastChild().getOrThrow()
        @Assert((lastChild as Text).getOrThrow().getLiteral(),"cc")
    }
}

@Test        /****Test+库名+类名***/
public class TestCommarkThematicBreak{
    @TestCase
    func test_ThematicBreak_accept():Unit {
        var thematicBreak = ThematicBreak()
        thematicBreak.appendChild(Text("bb"))
        thematicBreak.accept(AbstractVisitorImpl())
        let firstChild = thematicBreak.getFirstChild().getOrThrow()
        @Assert((firstChild as Text).getOrThrow().getLiteral(),"bb")
        let lastChild = thematicBreak.getLastChild().getOrThrow()
        @Assert((lastChild as Text).getOrThrow().getLiteral(),"cc")
    }
}

@Test        /****Test+库名+类名***/
public class TestCommarkDocument{
    @TestCase
    func test_Document_accept():Unit {
        var document = Document()
        document.appendChild(Text("bb"))
        document.accept(AbstractVisitorImpl())
        let firstChild = document.getFirstChild().getOrThrow()
        @Assert((firstChild as Text).getOrThrow().getLiteral(),"bb")
        let lastChild = document.getLastChild().getOrThrow()
        @Assert((lastChild as Text).getOrThrow().getLiteral(),"cc")
    }
}

@Test        /****Test+库名+类名***/
public class TestCommarkParagraph{
    @TestCase
    func test_Paragraph_accept():Unit {
        var paragraph = Paragraph()
        paragraph.appendChild(Text("bb"))
        paragraph.accept(AbstractVisitorImpl())
        let firstChild = paragraph.getFirstChild().getOrThrow()
        @Assert((firstChild as Text).getOrThrow().getLiteral(),"bb")
        let lastChild = paragraph.getLastChild().getOrThrow()
        @Assert((lastChild as Text).getOrThrow().getLiteral(),"cc")
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
        indentedCodeBlock.setLiteral("tt")
        @Assert(indentedCodeBlock.getLiteral(),"tt")
    }

    @TestCase
    func test_IndentedCodeBlock_init3():Unit {
        var indentedCodeBlock = IndentedCodeBlock()
        indentedCodeBlock.setLiteral("tt")
        indentedCodeBlock.setLiteral("")
        @Assert(indentedCodeBlock.getLiteral(),"")
    }

    @TestCase
    func test_IndentedCodeBlock_init4():Unit {
        var indentedCodeBlock = IndentedCodeBlock()
        indentedCodeBlock.setLiteral("")
        indentedCodeBlock.setLiteral("tt")
        @Assert(indentedCodeBlock.getLiteral(),"tt")
    }

    @TestCase
    func test_IndentedCodeBlock_accept():Unit {
        var indentedCodeBlock = IndentedCodeBlock()
        indentedCodeBlock.appendChild(Text("bb"))
        indentedCodeBlock.accept(AbstractVisitorImpl())
        @Assert(indentedCodeBlock.getLiteral(),"")
        let firstChild = indentedCodeBlock.getFirstChild().getOrThrow()
        @Assert((firstChild as Text).getOrThrow().getLiteral(),"bb")
        let lastChild = indentedCodeBlock.getLastChild().getOrThrow()
        @Assert((lastChild as Text).getOrThrow().getLiteral(),"cc")
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
        @Assert(fencedCodeBlock.getLiteral(), "")
    }

    @TestCase
    func test_FencedCodeBlock_init2():Unit {
        var fencedCodeBlock = FencedCodeBlock()
        fencedCodeBlock.setFenceChar(r'a')
        fencedCodeBlock.setFenceLength(-1)
        fencedCodeBlock.setFenceIndent(-1)
        fencedCodeBlock.setInfo("info")
        fencedCodeBlock.setLiteral("literal")
        @Assert(fencedCodeBlock.getFenceChar(),r'a')
        @Assert(fencedCodeBlock.getFenceLength(), -1)
        @Assert(fencedCodeBlock.getFenceIndent(), -1)
        @Assert(fencedCodeBlock.getInfo(), "info")
        @Assert(fencedCodeBlock.getLiteral(), "literal")
    }

    @TestCase
    func test_FencedCodeBlock_init3():Unit {
        var fencedCodeBlock = FencedCodeBlock()
        fencedCodeBlock.setFenceChar(r' ')
        fencedCodeBlock.setFenceLength(0)
        fencedCodeBlock.setFenceIndent(0)
        fencedCodeBlock.setInfo("")
        fencedCodeBlock.setLiteral("")
        @Assert(fencedCodeBlock.getFenceChar(),r' ')
        @Assert(fencedCodeBlock.getFenceLength(), 0)
        @Assert(fencedCodeBlock.getFenceIndent(), 0)
        @Assert(fencedCodeBlock.getInfo(), "")
        @Assert(fencedCodeBlock.getLiteral(), "")
    }

    @TestCase
    func test_FencedCodeBlock_accept():Unit {
        var fencedCodeBlock = FencedCodeBlock()
        fencedCodeBlock.appendChild(Text("bb"))
        fencedCodeBlock.accept(AbstractVisitorImpl())
        let firstChild = fencedCodeBlock.getFirstChild().getOrThrow()
        @Assert((firstChild as Text).getOrThrow().getLiteral(),"bb")
        let lastChild = fencedCodeBlock.getLastChild().getOrThrow()
        @Assert((lastChild as Text).getOrThrow().getLiteral(),"cc")
    }
}

@Test        /****Test+库名+类名***/
public class TestCommarkListItem{
    @TestCase
    func test_ListItem_accept():Unit {
        var listItem = ListItem()
        listItem.appendChild(Text("bb"))
        listItem.accept(AbstractVisitorImpl())
        let firstChild = listItem.getFirstChild().getOrThrow()
        @Assert((firstChild as Text).getOrThrow().getLiteral(),"bb")
        let lastChild = listItem.getLastChild().getOrThrow()
        @Assert((lastChild as Text).getOrThrow().getLiteral(),"cc")
    }
}

@Test        /****Test+库名+类名***/
public class TestCommarkHeading{
    @TestCase
    func test_Heading_init1():Unit {
        var heading = Heading()
        @Assert(heading.getLevel(), 0)
    }

    @TestCase
    func test_HtmlBlock_init2():Unit {
        var heading = Heading()
        heading.setLevel(-10)
        @Assert(heading.getLevel(), -10)
    }

    @TestCase
    func test_HtmlBlock_init3():Unit {
        var heading = Heading()
        heading.setLevel(-10)
        heading.setLevel(0)
        @Assert(heading.getLevel(), 0)
    }

    @TestCase
    func test_HtmlBlock_init4():Unit {
        var heading = Heading()
        heading.setLevel(0)
        heading.setLevel(10)
        @Assert(heading.getLevel(),10)
    }

    @TestCase
    func test_Heading_accept():Unit {
        var heading = Heading()
        heading.appendChild(Text("bb"))
        heading.accept(AbstractVisitorImpl())
        @Assert(heading.getLevel(), 0)
        let firstChild = heading.getFirstChild().getOrThrow()
        @Assert((firstChild as Text).getOrThrow().getLiteral(),"bb")
        let lastChild = heading.getLastChild().getOrThrow()
        @Assert((lastChild as Text).getOrThrow().getLiteral(),"cc")
    }
}

@Test        /****Test+库名+类名***/
public class TestCommarkBulletList{
    @TestCase
    func test_BulletList_init1():Unit {
        var bulletList = BulletList(r'\u{0}')
        @Assert(bulletList.getBulletMarker(), r'\u{0}')
        @Assert(bulletList.isTight(), false)
    }

    @TestCase
    func test_BulletList_init2():Unit {
        var bulletList = BulletList(r'\u{0}')
        bulletList.setBulletMarker(r'a')
        bulletList.setTight(true)
        @Assert(bulletList.getBulletMarker(), r'a')
        @Assert(bulletList.isTight(), true)
    }

    @TestCase
    func test_BulletList_init3():Unit {
        var bulletList = BulletList(r'\u{0}')
        bulletList.setBulletMarker(r'a')
        bulletList.setTight(true)
        bulletList.setBulletMarker(r'\u{0}')
        bulletList.setTight(false)
        @Assert(bulletList.getBulletMarker(), r'\u{0}')
        @Assert(bulletList.isTight(), false)
    }

    @TestCase
    func test_BulletList_accept():Unit {
        var bulletList = BulletList(r'a')
        bulletList.appendChild(Text("bb"))
        bulletList.accept(AbstractVisitorImpl())
        @Assert(bulletList.getBulletMarker(), r'a')
        let firstChild = bulletList.getFirstChild().getOrThrow()
        @Assert((firstChild as Text).getOrThrow().getLiteral(),"bb")
        let lastChild = bulletList.getLastChild().getOrThrow()
        @Assert((lastChild as Text).getOrThrow().getLiteral(),"cc")
    }
}


@Test        /****Test+库名+类名***/
public class TestCommarkOrderedList{
    @TestCase
    func test_OrderedList_init1():Unit {
        var orderedList = OrderedList(1, r'*')
        @Assert(orderedList.getStartNumber(), 1)
        @Assert(orderedList.getDelimiter(), r'*')
        @Assert(orderedList.isTight(), false)
    }

    @TestCase
    func test_OrderedList_init2():Unit {
        var orderedList = OrderedList(1, r'*')
        orderedList.setStartNumber(0)
        orderedList.setDelimiter(r'#')
        orderedList.setTight(true)
        @Assert(orderedList.getStartNumber(), 0)
        @Assert(orderedList.getDelimiter(), r'#')
        @Assert(orderedList.isTight(), true)
    }

    @TestCase
    func test_OrderedList_init3():Unit {
        var orderedList = OrderedList(1, r'*')
        orderedList.setStartNumber(0)
        orderedList.setDelimiter(r'#')
        orderedList.setTight(true)

        orderedList.setStartNumber(1)
        orderedList.setDelimiter(r'*')
        orderedList.setTight(false)
        @Assert(orderedList.getStartNumber(), 1)
        @Assert(orderedList.getDelimiter(), r'*')
        @Assert(orderedList.isTight(), false)
    }

    @TestCase
    func test_OrderedList_accept():Unit {
        var orderedList = OrderedList(1, r'*')
        orderedList.appendChild(Text("bb"))
        orderedList.accept(AbstractVisitorImpl())
        @Assert(orderedList.isTight(), false)
        let firstChild = orderedList.getFirstChild().getOrThrow()
        @Assert((firstChild as Text).getOrThrow().getLiteral(),"bb")
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
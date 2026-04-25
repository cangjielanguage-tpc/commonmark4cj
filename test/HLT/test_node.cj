// 3rd_party_lib:commonmark4cj/build/release/commonmark4cj
// 3rd_party_lib_ohos:commonmark4cj/build/aarch64-linux-ohos/commonmark4cj

import commonmark4cj.commonmark.*
import commonmark4cj.table.*

@Test /****Test+库名+类名***/
public class TestCommarkNode {
    @TestCase
    func test_Node_appendChild(): Unit {
        var tb = Text("bb") // node比较简单的子类
        var ta = Text("aa")
        ta.appendChild(tb)
        var firstChild: ?Node = ta.getFirstChild()
        var lastChild: ?Node = ta.getLastChild()
        @Assert((firstChild.getOrThrow() as Text).getOrThrow().getLiteral(), "bb")
        @Assert((lastChild.getOrThrow() as Text).getOrThrow().getLiteral(), "bb")
        var next: ?Node = firstChild.getOrThrow().getNext()
        var prev: ?Node = lastChild.getOrThrow().getPrevious()
        @Assert(next.isNone(),true)
        @Assert(prev.isNone(),true)
        var tc = Text("cc")
        ta.appendChild(tc)
        lastChild = ta.getLastChild()
        firstChild = ta.getFirstChild()
        @Assert((lastChild.getOrThrow() as Text).getOrThrow().getLiteral(), "cc")
        @Assert((firstChild.getOrThrow() as Text).getOrThrow().getLiteral(), "bb")

        next = firstChild.getOrThrow().getNext()
        prev = lastChild.getOrThrow().getPrevious()
        @Assert(next.isNone(),false)
        @Assert(prev.isNone(),false)
        @Assert((next.getOrThrow() as Text).getOrThrow().getLiteral(), "cc")
        @Assert((prev.getOrThrow() as Text).getOrThrow().getLiteral(), "bb")
    }

    @TestCase
    func test_Node_prependChild(): Unit {
        var tb = Text("bb") // node比较简单的子类
        var ta = Text("aa")
        ta.prependChild(tb)
        var firstChild: ?Node = ta.getFirstChild()
        var lastChild: ?Node = ta.getLastChild()
        @Assert((firstChild.getOrThrow() as Text).getOrThrow().getLiteral(), "bb")
        @Assert((lastChild.getOrThrow() as Text).getOrThrow().getLiteral(), "bb")
        var next: ?Node = firstChild.getOrThrow().getNext()
        var prev: ?Node = lastChild.getOrThrow().getPrevious()
        @Assert(next.isNone(),true)
        @Assert(prev.isNone(),true)
        var tc = Text("cc")
        ta.prependChild(tc)
        lastChild = ta.getLastChild()
        firstChild = ta.getFirstChild()
        @Assert((lastChild.getOrThrow() as Text).getOrThrow().getLiteral(), "bb")
        @Assert((firstChild.getOrThrow() as Text).getOrThrow().getLiteral(), "cc")
        next = firstChild.getOrThrow().getNext()
        prev = lastChild.getOrThrow().getPrevious()
        @Assert(next.isNone(),false)
        @Assert(prev.isNone(),false)
        @Assert((next.getOrThrow() as Text).getOrThrow().getLiteral(), "bb")
        @Assert((prev.getOrThrow() as Text).getOrThrow().getLiteral(), "cc")
    }

    @TestCase
    func test_Node_unlink(): Unit {
        var tb = Text("bb") // node比较简单的子类
        var ta = Text("aa")
        var tc = Text("cc")
        ta.appendChild(tb)
        ta.appendChild(tc)
        var parent: ?Node = tb.getParent()
        var next: ?Node = tb.getNext()
        var prev: ?Node = tb.getPrevious()
        @Assert((parent.getOrThrow() as Text).getOrThrow().getLiteral(), "aa")
        @Assert((next.getOrThrow() as Text).getOrThrow().getLiteral(), "cc")
        @Assert(prev.isNone(), true)
        tb.unlink()
        parent = tb.getParent()
        next = tb.getNext()
        prev = tb.getPrevious()
        @Assert(parent.isNone(), true)
        @Assert(next.isNone(), true)
        @Assert(prev.isNone(), true)
    }

    @TestCase
    func test_Node_insertAfter(): Unit {
        var tb = Text("bb") // node比较简单的子类
        var ta = Text("aa")
        ta.appendChild(tb)
        var firstChild: ?Node = ta.getFirstChild()
        var lastChild: ?Node = ta.getLastChild()
        @Assert((firstChild.getOrThrow() as Text).getOrThrow().getLiteral(), "bb")
        @Assert((lastChild.getOrThrow() as Text).getOrThrow().getLiteral(), "bb")
        var next: ?Node = firstChild.getOrThrow().getNext()
        var prev: ?Node = lastChild.getOrThrow().getPrevious()
        @Assert(next.isNone(),true)
        @Assert(prev.isNone(),true)
        var tc = Text("cc")
        tb.insertAfter(tc)
        lastChild = ta.getLastChild()
        firstChild = ta.getFirstChild()
        @Assert((lastChild.getOrThrow() as Text).getOrThrow().getLiteral(), "cc")
        @Assert((firstChild.getOrThrow() as Text).getOrThrow().getLiteral(), "bb")

        next = firstChild.getOrThrow().getNext()
        prev = lastChild.getOrThrow().getPrevious()
        @Assert(next.isNone(),false)
        @Assert(prev.isNone(),false)
        @Assert((next.getOrThrow() as Text).getOrThrow().getLiteral(), "cc")
        @Assert((prev.getOrThrow() as Text).getOrThrow().getLiteral(), "bb")
    }

    @TestCase
    func test_Node_insertBefore(): Unit {
        var tb = Text("bb") // node比较简单的子类
        var ta = Text("aa")
        ta.appendChild(tb)
        var firstChild: ?Node = ta.getFirstChild()
        var lastChild: ?Node = ta.getLastChild()
        @Assert((firstChild.getOrThrow() as Text).getOrThrow().getLiteral(), "bb")
        @Assert((lastChild.getOrThrow() as Text).getOrThrow().getLiteral(), "bb")
        var next: ?Node = firstChild.getOrThrow().getNext()
        var prev: ?Node = lastChild.getOrThrow().getPrevious()
        @Assert(next.isNone(),true)
        @Assert(prev.isNone(),true)
        var tc = Text("cc")
        tb.insertBefore(tc)
        lastChild = ta.getLastChild()
        firstChild = ta.getFirstChild()
        @Assert((lastChild.getOrThrow() as Text).getOrThrow().getLiteral(), "bb")
        @Assert((firstChild.getOrThrow() as Text).getOrThrow().getLiteral(), "cc")
        next = firstChild.getOrThrow().getNext()
        prev = lastChild.getOrThrow().getPrevious()
        @Assert(next.isNone(),false)
        @Assert(prev.isNone(),false)
        @Assert((next.getOrThrow() as Text).getOrThrow().getLiteral(), "bb")
        @Assert((prev.getOrThrow() as Text).getOrThrow().getLiteral(), "cc")
    }

    @TestCase
    func test_Node_equal(): Unit {
        var tb = Text("bb") // node比较简单的子类
        var ta = Text("aa")
        ta.appendChild(tb)
        var firstChild: ?Node = ta.getFirstChild()
        var lastChild: ?Node = ta.getLastChild()
        @Assert((firstChild.getOrThrow() as Text).getOrThrow().getLiteral(), "bb")
        @Assert((lastChild.getOrThrow() as Text).getOrThrow().getLiteral(), "bb")
        @Assert(firstChild.getOrThrow() == lastChild.getOrThrow(), true)
        var tc = Text("bb")
        @Assert(firstChild.getOrThrow() != tc, true)
    }
}

@Test /****Test+库名+类名***/
public class TestCommarkText {
    @TestCase
    func test_Text_init1(): Unit {
        var text = Text("tt")
        @Assert(text.getLiteral(),"tt")
    }

    @TestCase
    func test_Text_init2(): Unit {
        var text = Text("")
        @Assert(text.getLiteral(),"")
    }

    @TestCase
    func test_Text_setLiteral1(): Unit {
        var text = Text("")
        text.setLiteral("tt")
        @Assert(text.getLiteral(),"tt")
    }

    @TestCase
    func test_Text_setLiteral2(): Unit {
        var text = Text("tt")
        text.setLiteral("")
        @Assert(text.getLiteral(),"")
    }

    @TestCase
    func test_Text_accept(): Unit {
        var text = Text("aa")
        text.appendChild(Text("bb"))
        text.accept(AbstractVisitorImpl())
        @Assert(text.getLiteral(),"aa")
        let firstChild = text.getFirstChild().getOrThrow()
        @Assert((firstChild as Text).getOrThrow().getLiteral(),"bb")
        let lastChild = text.getLastChild().getOrThrow()
        @Assert((lastChild as Text).getOrThrow().getLiteral(),"cc")
    }
}

@Test /****Test+库名+类名***/
public class TestCommarkHtmlInline {
    @TestCase
    func test_HtmlInline_init1(): Unit {
        var html = HtmlInline("tt")
        @Assert(html.getLiteral(),"tt")
    }

    @TestCase
    func test_HtmlInline_init2(): Unit {
        var html = HtmlInline("")
        @Assert(html.getLiteral(),"")
    }

    @TestCase
    func test_HtmlInline_setLiteral1(): Unit {
        var html = HtmlInline("")
        html.setLiteral("tt")
        @Assert(html.getLiteral(),"tt")
    }

    @TestCase
    func test_HtmlInline_setLiteral2(): Unit {
        var html = HtmlInline("tt")
        html.setLiteral("")
        @Assert(html.getLiteral(),"")
    }

    @TestCase
    func test_Text_accept(): Unit {
        var html = HtmlInline("aa")
        html.appendChild(Text("bb"))
        html.accept(AbstractVisitorImpl())
        @Assert(html.getLiteral(),"aa")
        let firstChild = html.getFirstChild().getOrThrow()
        @Assert((firstChild as Text).getOrThrow().getLiteral(),"bb")
        let lastChild = html.getLastChild().getOrThrow()
        @Assert((lastChild as Code).getOrThrow().getLiteral(),"cc")
    }
}

@Test /****Test+库名+类名***/
public class TestCommarkCustomNode {
    @TestCase
    func test_Text_accept(): Unit {
        var custom = CustomNodeImpl()
        custom.appendChild(Text("bb"))
        custom.accept(AbstractVisitorImpl())
        let firstChild = custom.getFirstChild().getOrThrow()
        @Assert((firstChild as Text).getOrThrow().getLiteral(),"bb")
        let lastChild = custom.getLastChild().getOrThrow()
        @Assert((lastChild as Code).getOrThrow().getLiteral(),"cc")
    }
}

@Test /****Test+库名+类名***/
public class TestCommarkImage {
    @TestCase
    func test_Image_init1(): Unit {
        var iamge = Image("https://example.com/beautiful-garden.jpg", "我的美丽花园")
        @Assert(iamge.getDestination(),"https://example.com/beautiful-garden.jpg")
        @Assert(iamge.getTitle(),"我的美丽花园")
    }

    @TestCase
    func test_Image_init2(): Unit {
        var iamge = Image("", "")
        @Assert(iamge.getDestination(),"")
        @Assert(iamge.getTitle(),"")
    }

    @TestCase
    func test_Image_set(): Unit {
        var iamge = Image("", "")
        iamge.setDestination("https://example.com/beautiful-garden.jpg")
        iamge.setTitle("我的美丽花园")
        @Assert(iamge.getDestination(),"https://example.com/beautiful-garden.jpg")
        @Assert(iamge.getTitle(),"我的美丽花园")
    }

    @TestCase
    func test_Image_setLiteral2(): Unit {
        var iamge = Image("https://example.com/beautiful-garden.jpg", "我的美丽花园")
        iamge.setDestination("")
        iamge.setTitle("")
        @Assert(iamge.getDestination(),"")
        @Assert(iamge.getTitle(),"")
    }

    @TestCase
    func test_Image_accept(): Unit {
        var iamge = Image("https://example.com/beautiful-garden.jpg", "我的美丽花园")
        iamge.appendChild(Text("bb"))
        iamge.accept(AbstractVisitorImpl())
        @Assert(iamge.getTitle(),"我的美丽花园")
        let firstChild = iamge.getFirstChild().getOrThrow()
        @Assert((firstChild as Text).getOrThrow().getLiteral(),"bb")
        let lastChild = iamge.getLastChild().getOrThrow()
        @Assert((lastChild as Code).getOrThrow().getLiteral(),"cc")
    }
}

@Test /****Test+库名+类名***/
public class TestCommarkCode {
    @TestCase
    func test_Code_init1(): Unit {
        var code = Code("tt")
        @Assert(code.getLiteral(),"tt")
    }

    @TestCase
    func test_Code_init2(): Unit {
        var code = Code("")
        @Assert(code.getLiteral(),"")
    }

    @TestCase
    func test_Code_setLiteral1(): Unit {
        var code = Code("")
        code.setLiteral("tt")
        @Assert(code.getLiteral(),"tt")
    }

    @TestCase
    func test_Code_setLiteral2(): Unit {
        var code = Code("tt")
        code.setLiteral("")
        @Assert(code.getLiteral(),"")
    }

    @TestCase
    func test_Code_accept(): Unit {
        var code = Code("aa")
        code.appendChild(Text("bb"))
        code.accept(AbstractVisitorImpl())
        @Assert(code.getLiteral(),"aa")
        let firstChild = code.getFirstChild().getOrThrow()
        @Assert((firstChild as Text).getOrThrow().getLiteral(),"bb")
        let lastChild = code.getLastChild().getOrThrow()
        @Assert((lastChild as Code).getOrThrow().getLiteral(),"cc")
    }
}

@Test /****Test+库名+类名***/
public class TestCommarkHardLineBreak {
    @TestCase
    func test_HardLineBreak_accept(): Unit {
        var hardLine = HardLineBreak()
        hardLine.appendChild(Text("bb"))
        hardLine.accept(AbstractVisitorImpl())
        let firstChild = hardLine.getFirstChild().getOrThrow()
        @Assert((firstChild as Text).getOrThrow().getLiteral(),"bb")
        let lastChild = hardLine.getLastChild().getOrThrow()
        @Assert((lastChild as Code).getOrThrow().getLiteral(),"cc")
    }
}

@Test /****Test+库名+类名***/
public class TestCommarkSoftLineBreak {
    @TestCase
    func test_SoftLineBreak_accept(): Unit {
        var softLine = SoftLineBreak()
        softLine.appendChild(Text("bb"))
        softLine.accept(AbstractVisitorImpl())
        let firstChild = softLine.getFirstChild().getOrThrow()
        @Assert((firstChild as Text).getOrThrow().getLiteral(),"bb")
        let lastChild = softLine.getLastChild().getOrThrow()
        @Assert((lastChild as Code).getOrThrow().getLiteral(),"cc")
    }
}

@Test /****Test+库名+类名***/
public class TestCommarkLinkReferenceDefinition {
    @TestCase
    func test_LinkReferenceDefinition_init1(): Unit {
        var iamge = LinkReferenceDefinition("example", "https://example.com/beautiful-garden.jpg", "我的美丽花园")
        @Assert(iamge.getDestination(),"https://example.com/beautiful-garden.jpg")
        @Assert(iamge.getTitle(),"我的美丽花园")
        @Assert(iamge.getLabel(),"example")
    }

    @TestCase
    func test_LinkReferenceDefinition_init2(): Unit {
        var link = LinkReferenceDefinition("", "", "")
        @Assert(link.getDestination(),"")
        @Assert(link.getTitle(),"")
        @Assert(link.getLabel(),"")
    }

    @TestCase
    func test_LinkReferenceDefinition_set(): Unit {
        var link = LinkReferenceDefinition("", "", "")
        link.setDestination("https://example.com/beautiful-garden.jpg")
        link.setTitle("我的美丽花园")
        link.setLabel("example")
        @Assert(link.getDestination(),"https://example.com/beautiful-garden.jpg")
        @Assert(link.getTitle(),"我的美丽花园")
        @Assert(link.getLabel(),"example")
    }

    @TestCase
    func test_LinkReferenceDefinition_setLiteral2(): Unit {
        var link = LinkReferenceDefinition("example", "https://example.com/beautiful-garden.jpg", "我的美丽花园")
        link.setDestination("")
        link.setTitle("")
        link.setLabel("")
        @Assert(link.getDestination(),"")
        @Assert(link.getTitle(),"")
        @Assert(link.getLabel(),"")
    }

    @TestCase
    func test_LinkReferenceDefinition_accept(): Unit {
        var link = LinkReferenceDefinition("example", "https://example.com/beautiful-garden.jpg", "我的美丽花园")
        link.appendChild(Text("bb"))
        link.accept(AbstractVisitorImpl())
        @Assert(link.getLabel(),"example")
        let firstChild = link.getFirstChild().getOrThrow()
        @Assert((firstChild as Text).getOrThrow().getLiteral(),"bb")
        let lastChild = link.getLastChild().getOrThrow()
        @Assert((lastChild as Code).getOrThrow().getLiteral(),"cc")
    }
}

@Test /****Test+库名+类名***/
public class TestCommarkLink {
    @TestCase
    func test_Link_init1(): Unit {
        var iamge = Link("https://example.com/beautiful-garden.jpg", "我的美丽花园")
        @Assert(iamge.getDestination(),"https://example.com/beautiful-garden.jpg")
        @Assert(iamge.getTitle(),"我的美丽花园")
    }

    @TestCase
    func test_Link_init2(): Unit {
        var link = Link("", "")
        @Assert(link.getDestination(),"")
        @Assert(link.getTitle(),"")
    }

    @TestCase
    func test_Link_set(): Unit {
        var link = Link("", "")
        link.setDestination("https://example.com/beautiful-garden.jpg")
        link.setTitle("我的美丽花园")
        @Assert(link.getDestination(),"https://example.com/beautiful-garden.jpg")
        @Assert(link.getTitle(),"我的美丽花园")
    }

    @TestCase
    func test_Link_setLiteral2(): Unit {
        var link = Link("https://example.com/beautiful-garden.jpg", "我的美丽花园")
        link.setDestination("")
        link.setTitle("")
        @Assert(link.getDestination(),"")
        @Assert(link.getTitle(),"")
    }

    @TestCase
    func test_Link_accept(): Unit {
        var link = Link("https://example.com/beautiful-garden.jpg", "我的美丽花园")
        link.appendChild(Text("bb"))
        link.accept(AbstractVisitorImpl())
        @Assert(link.getTitle(),"我的美丽花园")
        let firstChild = link.getFirstChild().getOrThrow()
        @Assert((firstChild as Text).getOrThrow().getLiteral(),"bb")
        let lastChild = link.getLastChild().getOrThrow()
        @Assert((lastChild as Code).getOrThrow().getLiteral(),"cc")
    }
}

@Test /****Test+库名+类名***/
public class TestCommarkStrongEmphasis {
    @TestCase
    func test_StrongEmphasis_init1(): Unit {
        var strong = StrongEmphasis("我的美丽花园")
        @Assert(strong.getOpeningDelimiter(),"我的美丽花园")
        @Assert(strong.getClosingDelimiter(),"我的美丽花园")
    }

    @TestCase
    func test_StrongEmphasis_init2(): Unit {
        var strong = StrongEmphasis("")
        @Assert(strong.getOpeningDelimiter(),"")
        @Assert(strong.getClosingDelimiter(),"")
    }

    @TestCase
    func test_StrongEmphasis_set(): Unit {
        var strong = StrongEmphasis("")
        strong.setDelimiter("我的美丽花园")
        @Assert(strong.getOpeningDelimiter(),"我的美丽花园")
        @Assert(strong.getClosingDelimiter(),"我的美丽花园")
    }

    @TestCase
    func test_StrongEmphasis_setLiteral2(): Unit {
        var strong = StrongEmphasis("我的美丽花园")
        strong.setDelimiter("")
        @Assert(strong.getOpeningDelimiter(),"")
        @Assert(strong.getClosingDelimiter(),"")
    }

    @TestCase
    func test_StrongEmphasis_accept(): Unit {
        var strong = StrongEmphasis("我的美丽花园")
        strong.appendChild(Text("bb"))
        strong.accept(AbstractVisitorImpl())
        @Assert(strong.getOpeningDelimiter(),"我的美丽花园")
        let firstChild = strong.getFirstChild().getOrThrow()
        @Assert((firstChild as Text).getOrThrow().getLiteral(),"bb")
        let lastChild = strong.getLastChild().getOrThrow()
        @Assert((lastChild as Code).getOrThrow().getLiteral(),"cc")
    }
}

@Test /****Test+库名+类名***/
public class TestCommarkEmphasis {
    @TestCase
    func test_Emphasis_init1(): Unit {
        var emphasis = Emphasis("我的美丽花园")
        @Assert(emphasis.getOpeningDelimiter(),"我的美丽花园")
        @Assert(emphasis.getClosingDelimiter(),"我的美丽花园")
    }

    @TestCase
    func test_Emphasis_init2(): Unit {
        var emphasis = Emphasis("")
        @Assert(emphasis.getOpeningDelimiter(),"")
        @Assert(emphasis.getClosingDelimiter(),"")
    }

    @TestCase
    func test_Emphasis_set(): Unit {
        var emphasis = Emphasis("")
        emphasis.setDelimiter("我的美丽花园")
        @Assert(emphasis.getOpeningDelimiter(),"我的美丽花园")
        @Assert(emphasis.getClosingDelimiter(),"我的美丽花园")
    }

    @TestCase
    func test_Emphasis_setLiteral2(): Unit {
        var emphasis = Emphasis("我的美丽花园")
        emphasis.setDelimiter("")
        @Assert(emphasis.getOpeningDelimiter(),"")
        @Assert(emphasis.getClosingDelimiter(),"")
    }

    @TestCase
    func test_Emphasis_accept(): Unit {
        var emphasis = Emphasis("我的美丽花园")
        emphasis.appendChild(Text("bb"))
        emphasis.accept(AbstractVisitorImpl())
        @Assert(emphasis.getOpeningDelimiter(),"我的美丽花园")
        let firstChild = emphasis.getFirstChild().getOrThrow()
        @Assert((firstChild as Text).getOrThrow().getLiteral(),"bb")
        let lastChild = emphasis.getLastChild().getOrThrow()
        @Assert((lastChild as Code).getOrThrow().getLiteral(),"cc")
    }
}

public class CustomNodeImpl <: CustomNode {public func getNodeType():NodeType{"CustomNodeImpl"}}

class AbstractVisitorImpl <: AbstractVisitor {
    public func visit(text: Text): Unit {
        text.appendChild(Text("cc"))
    }

    public func visit(htmlInline: HtmlInline): Unit {
        htmlInline.appendChild(Code("cc"))
    }

    public func visit(custom: CustomNode): Unit {
        custom.appendChild(Code("cc"))
    }

    public func visit(image: Image): Unit {
        image.appendChild(Code("cc"))
    }

    public func visit(code: Code): Unit {
        code.appendChild(Code("cc"))
    }

    public func visit(hardLineBreak: HardLineBreak): Unit {
        hardLineBreak.appendChild(Code("cc"))
    }

    public func visit(softLineBreak: SoftLineBreak): Unit {
        softLineBreak.appendChild(Code("cc"))
    }

    public func visit(linkReferenceDefinition: LinkReferenceDefinition): Unit {
        linkReferenceDefinition.appendChild(Code("cc"))
    }

    public func visit(link: Link): Unit {
        link.appendChild(Code("cc"))
    }

    public func visit(strongEmphasis: StrongEmphasis): Unit {
        strongEmphasis.appendChild(Code("cc"))
    }

    public func visit(emphasis: Emphasis): Unit {
        emphasis.appendChild(Code("cc"))
    }
}

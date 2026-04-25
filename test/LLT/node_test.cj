// DEPENDENCE: z_test.cj
// EXEC: cjc %import-path %L %l %f z_test.cj
// EXEC: ./main

import commonmark4cj.commonmark.*
import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import std.collection.*

main(): Int64 {
    let tester = NodeTest()
    tester.textTest()
    tester.htmlInlineTest()
    tester.imageTest()
    tester.codeTest()
    tester.linkReferenceDefinitionTest()
    tester.linkTest()
    tester.strongEmphasisTest()
    tester.emphasisTest()
    0
}
@Test
public class NodeTest {
    @TestCase
    func textTest(): Unit {
        var text: Text = Text("this is text")
        assertEquals("this is text", text.getLiteral())

        text.setLiteral("this is other text")
        assertEquals("this is other text", text.getLiteral())

        var text2: Text = Text("this is text")
        var text3: Text = text
        assertEquals(false, text==text2)
        assertEquals(true, text==text3)
    }

    @TestCase
    func htmlInlineTest(): Unit {
        var text: HtmlInline = HtmlInline("<h1>hello</h1>")
        assertEquals("<h1>hello</h1>", text.getLiteral())

        text.setLiteral("<h1>hello world</h1>")
        assertEquals("<h1>hello world</h1>", text.getLiteral())
    }

    @TestCase
    func imageTest(): Unit {
        var text: Image = Image("E:\\gtt_private\\1.png", "tupian")
        assertEquals("E:\\gtt_private\\1.png", text.getDestination())
        assertEquals("tupian", text.getTitle())

        text.setDestination("E:\\gtt_private\\2.png")
        text.setTitle("other")
        assertEquals("E:\\gtt_private\\2.png", text.getDestination())
        assertEquals("other", text.getTitle())
    }

    @TestCase
    func codeTest(): Unit {
        var text: Code  = Code ("```\ncode\n```")
        assertEquals("```\ncode\n```", text.getLiteral())

        text.setLiteral("```\nfoo\n```")
        assertEquals("```\nfoo\n```", text.getLiteral())
    }

    @TestCase
    func linkReferenceDefinitionTest(): Unit {
        var text: LinkReferenceDefinition = LinkReferenceDefinition()
        assertEquals(None, text.getLabel())
        text = LinkReferenceDefinition("foo", "/url", "title")
        assertEquals("foo", text.getLabel())
        assertEquals("/url", text.getDestination())
        assertEquals("title", text.getTitle())

        text.setLabel("bar")
        text.setDestination("/path")
        text.setTitle("titles")

        assertEquals("bar", text.getLabel())
        assertEquals("/path", text.getDestination())
        assertEquals("titles", text.getTitle())
    }
    
    @TestCase
    func linkTest(): Unit {
        var text: Link  = Link("/url", "title")
        assertEquals("/url", text.getDestination())
        assertEquals("title", text.getTitle())

        text.setDestination("/path")
        text.setTitle("titles")

        assertEquals("/path", text.getDestination())
        assertEquals("titles", text.getTitle())
    }

    @TestCase
    func strongEmphasisTest(): Unit {
        var text: StrongEmphasis = StrongEmphasis() 
        assertEquals(None, text.getOpeningDelimiter())
        
        text = StrongEmphasis("***")
        assertEquals("***", text.getOpeningDelimiter())
        assertEquals("***", text.getClosingDelimiter())

        text.setDelimiter("**")
        assertEquals("**", text.getOpeningDelimiter())
        assertEquals("**", text.getClosingDelimiter())
    }

    @TestCase
    func emphasisTest(): Unit {
        var text: Emphasis  = Emphasis () 
        assertEquals(None, text.getOpeningDelimiter())
        
        text = Emphasis ("***")
        assertEquals("***", text.getOpeningDelimiter())
        assertEquals("***", text.getClosingDelimiter())

        text.setDelimiter("**")
        assertEquals("**", text.getOpeningDelimiter())
        assertEquals("**", text.getClosingDelimiter())
    }
}

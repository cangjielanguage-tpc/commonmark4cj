// 3rd_party_lib:commonmark4cj/build/release/commonmark4cj
// 3rd_party_lib_ohos:commonmark4cj/build/aarch64-linux-ohos/commonmark4cj
// dependence: z_test.cj

import commonmark4cj.commonmark.*
import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import std.reflect.{TypeInfo}

@Test
public class LinkReferenceDefinitionNodeTest {
    @TestCase
    public func testDefinitionWithoutParagraph(): Unit {
        let document: Node = parses("This is a paragraph with a [foo] link.\n\n[foo]: /url 'title'")
        let nodes: ArrayList<Node> = Nodes.getChildren(document)
        assertEquals(2, nodes.size)
        assertEquals("Paragraph{}", nodes.get(0)().toString())
        let definition: LinkReferenceDefinition = assertDef(nodes.get(1)(), "foo")
        assertEquals("/url", definition.getDestination())
        assertEquals("title", definition.getTitle())
    }

    @TestCase
    public func testDefinitionWithParagraph() {
        let document: Node = parses("[foo]: /url\nThis is a paragraph with a [foo] link.")
        let nodes: ArrayList<Node> = Nodes.getChildren(document)
        assertEquals(2, nodes.size)
        assertEquals("LinkReferenceDefinition{}", nodes.get(0)().toString())
        assertEquals("Paragraph{}", nodes.get(1)().toString())
    }

    @TestCase
    public func testMultipleDefinitions() {
        let document: Node = parses("This is a paragraph with a [foo] link.\n\n[foo]: /url\n[bar]: /url");
        let nodes: ArrayList<Node> = Nodes.getChildren(document);
        assertEquals(3, nodes.size)
        assertEquals("Paragraph{}", nodes.get(0)().toString())
        assertDef(nodes.get(1)(), "foo")
        assertDef(nodes.get(2)(), "bar")
    }

    @TestCase
    public func testMultipleDefinitionsWithSameLabel() {
        let document: Node = parses("This is a paragraph with a [foo] link.\n\n[foo]: /url1\n[foo]: /url2");
        let nodes: ArrayList<Node> = Nodes.getChildren(document);
        assertEquals(3, nodes.size)
        assertEquals("Paragraph{}", nodes.get(0)().toString())
        let def1: LinkReferenceDefinition = assertDef(nodes.get(1)(), "foo")
        assertEquals("/url1", def1.getDestination())
        let def2: LinkReferenceDefinition = assertDef(nodes.get(2)(), "foo")
        assertEquals("/url2", def2.getDestination())
    }

    @TestCase
    public func testDefinitionOfReplacedBlock() {
        let document: Node = parses("[foo]: /url\nHeading\n=======")
        let nodes: ArrayList<Node> = Nodes.getChildren(document);
        assertEquals(2, nodes.size)
        assertDef(nodes.get(0)(), "foo")
        assertEquals("Heading{}", nodes.get(1)().toString())
    }

    @TestCase
    public func testDefinitionInListItem() {
        let document: Node = parses("* [foo]: /url\n  [foo]\n")
        assertEquals("BulletList{}", document.getFirstChild()().toString())
        let item: Node = document.getFirstChild()().getFirstChild()()
        assertEquals("ListItem{}", item.toString())
        let nodes: ArrayList<Node> = Nodes.getChildren(item)
        assertEquals(2, nodes.size)
        assertDef(nodes.get(0)(), "foo")
        assertEquals("Paragraph{}", nodes.get(1)().toString())
    }

    @TestCase
    public func testDefinitionInListItem2() {
        let document: Node = parses("* [foo]: /url\n*  [foo]\n")
        assertEquals("BulletList{}", document.getFirstChild()().toString())
        let items: ArrayList<Node> = Nodes.getChildren(document.getFirstChild()())
        assertEquals(2, items.size)
        let item1: Node = items.get(0)()
        let item2: Node = items.get(1)()
        assertEquals("ListItem{}", item1.toString())
        assertEquals("ListItem{}", item2.toString())
        assertEquals(1, Nodes.getChildren(item1).size)
        assertDef(item1.getFirstChild()(), "foo")
        assertEquals(1, Nodes.getChildren(item2).size)
        assertEquals("Paragraph{}", item2.getFirstChild()().toString())
    }
}

func parses(input: String): Node {
    let parser: Parser = Parser.builder().build()
    return parser.parse(input)
}

func assertDef(node: Node, label: String): LinkReferenceDefinition {
    assertEquals("LinkReferenceDefinition{}", node.toString())
    let def: ?LinkReferenceDefinition = node as LinkReferenceDefinition
    assertEquals(label, def().getLabel())
    return def()
}

public class Nodes {
    public static func getChildren(parent: Node): ArrayList<Node> {
        var children: ArrayList<Node> = ArrayList<Node>()
        var child: ?Node = parent.getFirstChild()
        while (child.isSome()) {
            children.add(child.getOrThrow())
            child = child.getOrThrow().getNext()
        }
        return children
    }
}

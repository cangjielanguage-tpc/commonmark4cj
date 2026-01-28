package commonmark4cj.strikethrough

class StrikethroughHtmlNodeRenderer <: StrikethroughNodeRenderer {
    private let context: HtmlNodeRendererContext
    private let html: HtmlWriter

    public init(context: HtmlNodeRendererContext) {
        this.context = context
        this.html = context.getWriter()
    }

    public override func render(node: Node): Unit {
        let attributes: HashMap<String, String> = context.extendAttributes(node, "del", HashMap<String, String>())
        html.tag("del", attributes)
        renderChildren(node)
        html.tag("/del")
    }

    private func renderChildren(parent: Node): Unit {
        var node: ?Node = parent.getFirstChild()
        while (let Some(v) <- node) {
            node = v.getNext()
            context.render(v)
        }
    }
}

class StrikethroughTextContentNodeRenderer <: StrikethroughNodeRenderer {
    private let context: TextContentNodeRendererContext
    private let textContent: TextContentWriter

    public init(context: TextContentNodeRendererContext) {
        this.context = context
        this.textContent = context.getWriter()
    }

    public override func render(node: Node): Unit {
        textContent.write("/")
        renderChildren(node)
        textContent.write("/")
    }

    private func renderChildren(parent: Node): Unit {
        var node: ?Node = parent.getFirstChild()
        while (let Some(v) <- node) {
            node = v.getNext()
            context.render(v)
        }
    }
}

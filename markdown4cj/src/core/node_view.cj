/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package markdown.core

/**
 * 分离式的NodeView
 */
public class NodeView <: ToString {
    /* BlockQuote深度 -1:无效 >=0:深度 */
    public var blockQuoteDepth: Int = -1
    /* 是否被BlockQuote修饰 */
    public var blockQuote: Bool = false
    /* 是否被Emphasis修饰 */
    public var emphasis: Bool = false
    /* 是否被StrongEmphasis修饰 */
    public var strongEmphasis: Bool = false
    /* 是否被Link修饰 */
    public var link: ?Link = None
    /* 是否属于BulletList */
    public var bulletList: Bool = false
    /* 属于第几层OrderedListItem -1:无效 >=0:深度 */
    public var depth: Int = -1
    /* 属于第几位OrderedListItem -1:无效 >=0:序号 */
    public var order: Int = -1
    public var orderedList: ?Int = None
    /* 属于第几层BulletListItem -1:无效 >=0:深度 */
    public var bulletListDepth: Int = -1
    /* ListItem中可包含多个Block，但只有第一个Block有列表符号 */
    public var listMark: Bool = false
    // 本身Node节点
    public var node: Node
    // Node节点开始结束标志 -1:无效 0:开始 1:结束
    var startend = -1
    // 是否为Node开始
    public prop isNodeStart: Bool {
        get() {
            startend == 0
        }
    }
    // 是否为Node结束
    public prop isNodeEnd: Bool {
        get() {
            startend == 1
        }
    }
    // 子节点列表
    public let children: ArrayList<NodeView> = ArrayList<NodeView>()
    // NodeViewTree中的上级NodeView
    public var collector: ?NodeView = None
    // 供插件使用的自定义属性
    public var props: ?HashMap<String, Any> = None
    // 所有上级列表节点 用于ListItem中第一个Block前的列表符号绘制
    public var list: ArrayList<NodeView> = EMPTY_LIST
    private static let EMPTY_LIST = ArrayList<NodeView>()

    public init(currentNode: Node) {
        this.node = currentNode
        setView(currentNode)
    }

    public init(currentNode: Node, parentView: NodeView) {
        this.node = currentNode
        mergeView(parentView)
        setView(currentNode)
        setListItemFirstChild(currentNode, parentView)
    }

    /**
     * 用于将父节点的样式传递给子节点
     */
    func mergeView(parentView: NodeView): Unit {
        this.link = parentView.link
        this.emphasis = parentView.emphasis
        this.strongEmphasis = parentView.strongEmphasis

        this.blockQuote = parentView.blockQuote
        this.blockQuoteDepth = parentView.blockQuoteDepth

        this.bulletList = parentView.bulletList
        this.bulletListDepth = parentView.bulletListDepth

        this.depth = parentView.depth
        this.order = parentView.order
        this.orderedList = parentView.orderedList

        this.collector = parentView.collector

        if (let Some(v) <- parentView.props) {
            this.props = HashMap<String, Any>(v)
        }
    }

    /**
     * 根据当前节点类型设置样式
     */
    func setView(currentNode: Node): Unit {
        if (currentNode is BlockQuote) {
            this.blockQuoteDepth++
            this.blockQuote = true
        } else if (currentNode is Emphasis) {
            this.emphasis = true
        } else if (currentNode is StrongEmphasis) {
            this.strongEmphasis = true
        } else if (currentNode is Link) {
            this.link = currentNode as Link
        } else if (currentNode is BulletList) {
            this.bulletListDepth++
            this.bulletList = true
        } else if (currentNode is OrderedList) {
            this.depth++
            this.orderedList = (currentNode as OrderedList)?.getStartNumber()
        } else if (currentNode is ListItem) {
            if (let Some(parent) <- this.orderedList) {
                this.order = if (let Some(previous) <- currentNode.getPrevious()?.getView()) {
                    previous.order + 1
                } else {
                    parent
                }
            }
        }
    }

    /**
     * 设置ListItem中可包含多个Block，但只有第一个Block有列表符号
     */
    func setListItemFirstChild(currentNode: Node, parentView: NodeView): Unit {
        if (currentNode.getPrevious().isSome()) {
            return
        }
        let parent = parentView.node
        if (!(parent is ListItem || parent is BlockQuote)) {
            return
        }
        if (currentNode is BlockQuote || currentNode is OrderedList || currentNode is BulletList) {
            return
        }
        this.list = ArrayList<NodeView>()
        var tmp: ?Node = parent
        let end = this.collector().node
        while (let Some(n) <- tmp) {
            let isListNode = n is BlockQuote || n is OrderedList || n is BulletList
            if (isListNode && (list.size == 0 || n.getNodeType() != list[0].node.getNodeType())) {
                list.add(n.getView(), at: 0)
            }
            if (n == end) {
                break
            }
            tmp = n.getParent()
        }
    }

    private func isListNode(n: Node): Bool {
        n is BlockQuote || n is OrderedList || n is BulletList
    }

    public override func toString(): String {
        let emphaStr = if (emphasis) {
            "emphasis:${emphasis}"
        } else {
            ""
        }
        let strongStr = if (strongEmphasis) {
            "strongEmphasis:${strongEmphasis}"
        } else {
            ""
        }
        let linkStr = link?.toString() ?? ""
        let bulletStr = if (bulletList) {
            "{bulletListDepth:${bulletListDepth}}"
        } else {
            ""
        }
        let orderListStr = if (let Some(v) <- orderedList) {
            "{${v},depth:${depth},order:${order}}"
        } else {
            ""
        }
        let blockQuoteStr = if (blockQuote) {
            "{blockQuoteDepth:${blockQuoteDepth}}"
        } else {
            ""
        }
        let propStr = if (let Some(kvs) <- props) {
            let str = kvs |> map<(String, Any), String> {kv => "${kv[0]}:${kv[1] as ToString}"} |>
                collectString<String>(delimiter: ",")
            "{${str}}"
        } else {
            ""
        }
        let startEndStr = if (startend > -1) {
            "{isNodeStart:${isNodeStart},isNodeEnd:${isNodeEnd}}"
        } else {
            ""
        }
        let listStr = if (list.size > 0) {
            list.toString()
        } else {
            ""
        }
        return "view:{${node}${startEndStr}${emphaStr}${strongStr}${linkStr}${bulletStr}${orderListStr}${blockQuoteStr}${propStr}${listStr}}"
    }

    public func clear(): Unit {
        //        this.blockQuote = None
        //        this.emphasis = None
        //        this.strongEmphasis = None
        this.link = None
        //        this.bulletList = None
        this.orderedList = None
        this.collector = None
        this.props = None
        this.list = EMPTY_LIST
        // this.node=unsafe{zeroValue<Node>()}
    }
}

public func buildView(node: Node, needCollect: Bool, needProps!: Bool = false): NodeView {
    if (let Some(v) <- (node.custom as NodeView)) {
        return v
    }
    let view = if (let Some(parentView: NodeView) <- node.getParent()?.custom) {
        NodeView(node, parentView)
    } else {
        NodeView(node)
    }
    if (needProps && view.props.isNone()) {
        view.props = HashMap<String, Any>()
    }
    if (needCollect) {
        view.collector?.children.add(view)
        view.collector = view
    }
    node.custom = view
    return view
}

public func buildFlatView(node: Node, nodeVisitor: (Node) -> Unit, needProps!: Bool = false): Unit {
    let (start, end) = if (let Some(parentView: NodeView) <- node.getParent()?.custom) {
        if (parentView.node is Document) {
            let list = NodeView(node, parentView)
            list.depth = -1
            list.bulletListDepth = -1
            list.blockQuoteDepth = -1
            list.collector?.children.add(list)
            list.collector = list
            (NodeView(node, list), NodeView(node, list))
        } else {
            (NodeView(node, parentView), NodeView(node, parentView))
        }
    } else {
        (NodeView(node), NodeView(node))
    }
    start.startend = 0
    if (needProps && start.props.isNone()) {
        start.props = HashMap<String, Any>()
    }
    node.custom = start

    start.collector?.children.add(start)

    nodeVisitor(node)

    end.startend = 1
    start.collector?.children.add(end)
}

public func buildListView(node: Node, needProps!: Bool = false): NodeView {
    if (let Some(_: Document) <- node.getParent()) {
        buildView(node, true, needProps: needProps)
    } else {
        buildView(node, false, needProps: needProps)
    }
}

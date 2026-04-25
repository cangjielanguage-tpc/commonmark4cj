/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package markdown.plugin

public class TablePlugin <: AbstractMarkdownPlugin {
    public static func create(): TablePlugin {
        return TablePlugin()
    }

    public func configureParser(builder: ParserBuilder): Unit {
        builder.extensions([TablesExtension.create()])
    }

    public func configureVisitor(builder: MarkdownVisitorBuilder): Unit {
        let count = [0, 0] // rowCount,cellCount
        builder
            .on(
                "TableBlock",
                {
                    visitor, node =>
                    count[0] = 0
                    count[1] = 0
                    let view = buildView(node, true, needProps: true)
                    visitor.visitChildren(node)
                    view.props?.add("rowCount", count[0])
                    view.props?.add("cellCount", count[1])
                    view.props?.add("columnCount", if (count[0] == 0) {
                        0
                    } else {
                        count[1] / count[0]
                    })
                }
            )
            .on(
                "TableRow",
                {
                    visitor, node =>
                    count[0]++
                    buildView(node, true)
                    visitor.visitChildren(node)
                }
            )
            .on(
                "TableCell",
                {
                    visitor, node =>
                    count[1]++
                    buildView(node, true)
                    visitor.visitChildren(node)
                }
            )
            .on("TableHead", tableNodeVisitor)
            .on("TableBody", tableNodeVisitor)
    }

    func tableNodeVisitor(visitor: MarkdownVisitor, node: Node): Unit {
        buildView(node, true)
        visitor.visitChildren(node)
    }

    public func getClassType(): String {
        "TablePlugin"
    }
}

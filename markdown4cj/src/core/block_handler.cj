/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package markdown.core

/**
 * Primary purpose is to control the spacing applied before/after certain blocks, which
 * visitors are created elsewhere
 */
public interface BlockHandler {
    func blockStart(visitor: MarkdownVisitor, node: Node): Unit

    func blockEnd(visitor: MarkdownVisitor, node: Node): Unit
}

public class BlockHandlerDef <: BlockHandler {
    public override func blockStart(_: MarkdownVisitor, _: Node): Unit {
        // visitor.ensureNewLine()
    }

    public override func blockEnd(visitor: MarkdownVisitor, node: Node): Unit {
        if (visitor.hasNext(node)) {
            // visitor.ensureNewLine()
            // visitor.forceNewLine()
        }
    }
}

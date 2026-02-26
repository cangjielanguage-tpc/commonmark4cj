/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package markdown.plugin

import ohos.hilog.Hilog

public class LinkifyPlugin <: AbstractMarkdownPlugin {
    public static func create(): LinkifyPlugin {
        return LinkifyPlugin()
    }

    public func configureParser(parser: ParserBuilder): Unit {
        parser.postProcessor(LinkifyPostProcessor())
    }

    public func getClassType(): String {
        "LinkifyPlugin"
    }
}

class LinkifyPostProcessor <: PostProcessor {
    public func process(node: Node): Node {
        let visitor = LinkifyVisitor()
        node.accept(visitor)
        return node
    }
}

public class LinkifyVisitor <: AbstractVisitor {
    public static var urlreg = Regex(#"https?://[!*'();:@&=+$,/?#[\]a-zA-Z0-9-_.~]+"#)
    public func visit(node: Text): Unit {
        if (let Some(_: Link) <- node.getParent()) {
            return
        }

        let originTextNode = (node as Text)()
        let fulltext = originTextNode.getLiteral()
        var i = 0
        for (data in urlreg.lazyFindAll(fulltext)) {
            // 处理正则前的文本
            if (i < data.matchPosition().start) {
                let snippet = fulltext[i..data.matchPosition().start]
                let text = Text(snippet)
                originTextNode.insertBefore(text)
            }

            // 处理正则区
            let snippet = data.matchString()
            let link = Link(snippet, snippet)
            link.appendChild(Text(snippet))
            originTextNode.insertBefore(link)
            i = data.matchPosition().end
        }
        // 处理剩余文本
        if (i < fulltext.size) {
            let snippet = fulltext[i..]
            originTextNode.setLiteral(snippet)
        } else {
            originTextNode.unlink()
        }
    }
}

package commonmark_hybrid

/*
 * 自定义开闭区间标签插件
 *     <cmtag>...</cmtag>
 */
class CustomOpenCloseTagPlugin <: AbstractMarkdownPlugin {
    CustomOpenCloseTagPlugin(let cmInlineTags: Array<String>) {}

    public func configureParser(builder: ParserBuilder): Unit {
        builder.customInlineContentParserFactory(CustomOpenCloseTagParser(this))
    }

    public func getClassType(): String {
        'CustomOpenCloseTagPlugin'
    }
}

class CustomOpenCloseTagParser <: InlineParserIntegration {
    CustomOpenCloseTagParser(let ctx: CustomOpenCloseTagPlugin) {}

    public func create(): InlineContentParser {
        this
    }
    public func getTriggerCharacters(): HashSet<Rune> {
        return HashSet([r"<"]);
    }

    public func tryParse(inlineParserState: InlineParserState): ParsedInline {
        let scanner = inlineParserState.getScanner()
        let pos0 = scanner.position()
        for (tagName in ctx.cmInlineTags) {
            scanner.setPosition(pos0)
            if (scanner.next("<${tagName}>")) {
                let close = "</${tagName}>".toArray()
                let content = scanner.readUtil(true, close) ?? continue
                let tag = CustomTag(tagName)
                tag.content = content
                return ParsedInline.of(tag, scanner.position())
            }
        }
        return ParsedInline.none()
    }
}

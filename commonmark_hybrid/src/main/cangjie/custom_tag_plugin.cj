package commonmark_hybrid

import ohos.hilog.Hilog
import std.reflect.*

/*
 * 自定义标签插件
 *   行内单标签:
 *     <cmtag.inline.mytag/>
 *     <cmtag.inline.mytag>
 *   行内开闭标签: 当前不支持
 *   属性:
 *     a
 *     a=true
 *     a="true"
 *     a='true'
 */
class CustomTagPlugin <: AbstractMarkdownPlugin {
    CustomTagPlugin(let cmInlineTags: Array<String>) {}

    public func configureParser(builder: ParserBuilder): Unit {
        builder.customInlineContentParserFactory(CustomTagParser(this))
    }

    public func getClassType(): String {
        'CustomTagPlugin'
    }
}

class CustomTagParser <: InlineParserIntegration {
    CustomTagParser(let ctx: CustomTagPlugin) {}

    public func create(): InlineContentParser {
        this
    }
    public func getTriggerCharacters(): HashSet<Rune> {
        return HashSet([r"<"]);
    }

    public func tryParse(inlineParserState: InlineParserState): ParsedInline {
        let scanner = inlineParserState.getScanner()
        var line = scanner.peekLine()
        line = line[1..]
        for (v in ctx.cmInlineTags) {
            if (line.startsWith(v)) {
                let tag = TagReader(scanner).read() ?? continue
                return ParsedInline.of(tag, scanner.position())
            }
        }
        return ParsedInline.none()
    }
}

class CustomTag <: CustomNode {
    CustomTag(public let tagName: String) {}
    public var content: ?String = None
    public let tagAttrs: HashMap<String, String> = HashMap()
    public func getNodeType(): String {
        "CustomTag"
    }
    public func toStringAttributes(): String {
        let builder = StringBuilder("tagName:${tagName}")
        if(tagAttrs.size > 0){
            builder.append(",tagAttrs:${tagAttrs}")
        }
        if(let Some(v) <- content){
            builder.append(",content:${v}")
        }
        return builder.toString()
    }
}

class TagReader {
    TagReader(let scanner: Scanner) {}
    func read(): ?CustomTag {
        readTagStart() ?? return None
        scanner.whitespace()
        let name = readTagName() ?? return None
        let tag = CustomTag(name)
        while (true) {
            scanner.whitespace()
            match (scanner.peek()) {
                case b'/' | b'>' | 0 => break
                case _ => ()
            }
            let name = readPropName() ?? break
            let value = readPropValue()
            tag.tagAttrs.add(name, value)
        }
        readTagEnd() ?? return None
        return tag
    }
    /*读取 < </ */
    func readTagStart(): ?Bool {
        scanner.next(b'<')
        scanner.whitespace()
        scanner.next(b'/')
        true
    }
    /*读取标签name*/
    func readTagName(): ?String {
        scanner.whitespace()
        return scanner.readUtil(b' ', b'/', b'>')
    }
    /*读取属性name*/
    func readPropName(): ?String {
        scanner.whitespace()
        return scanner.readUtil(b'=', b' ', b'/', b'>')
    }
    /*读取属性value*/
    func readPropValue(): String {
        if (scanner.next(b'=')) {
            return match {
                case scanner.next(b'"') => scanner.readUtil(true, b'"')
                case scanner.next(b'\'') => scanner.readUtil(true, b'\'')
                case _ => scanner.readUtil(b' ', b'/', b'>')
            } ?? ""
        }
        return ""
    }
    /*读取 > /> */
    func readTagEnd(): ?Bool {
        scanner.next(b'/')
        scanner.whitespace()
        return scanner.next(b'>')
    }
}

extend Scanner {
    func readUtil(bs: Array<Byte>): ?String {
        readUtil(false, bs)
    }
    func readUtil(dropMatcherByteWhenFind: Bool, bs: Array<Byte>): ?String {
        let p0 = this.position()
        var len = 0
        while (true) {
            match (this.peek()) {
                case b'\n' | 0 => return None
                case v where bs.indexOf(v).isSome() => break
                case _ =>
                    len++
                    this.next()
                    continue
            }
        }
        let p1 = this.position()
        let name = this.getSource(p0, p1).getContent()
        if (!name.isEmpty()) {
            if (dropMatcherByteWhenFind) {
                for(_ in 0..bs.size){
                    this.next()
                }
            }
            return name
        }
        return None
    }
}

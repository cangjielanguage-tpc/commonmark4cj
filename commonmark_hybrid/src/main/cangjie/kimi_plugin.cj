/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package commonmark_hybrid

import std.regex.*

class KimiPlugin <: AbstractMarkdownPlugin {
    KimiPlugin() {
    }

    public func configureParser(_: ParserBuilder): Unit {
        Characters.isPunctuationCodePoint = {
            codePoint: Rune =>
            /* delimiter 不判断任何标点 */
            return false
            /*
             * An ASCII punctuation character is
             * ! " # $ % & ' ( ) * + , - . / (U+21–2F)
             * : ; < = > ? @                 (U+3A–40)
             * [ \ ] ^ _ `                   (U+5B–60)
             * { | } ~                       (U+7B–7E)
             * delimiter 只判断ascii标点
            match {
                case r'!' <= codePoint && codePoint <= r'.' => return true
                case r':' <= codePoint && codePoint <= r'@' => return true
                case r'[' <= codePoint && codePoint <= r'`' => return true
                case r'{' <= codePoint && codePoint <= r'~' => return true
                case _ => return false
            }
             */
        }
        LinkifyVisitor.urlreg = Regex(#"https?://[!*'();:@&=+$,/?#[\]a-zA-Z0-9-_.~\p{Han}]+"#, Unicode)
    }

    public func getClassType(): String {
        'KimiPlugin'
    }
}

/**
 * @desc   : 小月球loading 解析器
 * @author : guoxiao@moonshot.cn
 * @date   : 2025/7/1 20:29
 */
class MoonLoadingParser <: InlineParserIntegration {
    static let MOON_LOADING = '<^moonLoading^>'

    public func create(): InlineContentParser {
        this
    }
    public func getTriggerCharacters(): HashSet<Rune> {
        return HashSet([r'<'])
    }
    public func tryParse(inlineParserState: InlineParserState): ParsedInline {
        let scanner = inlineParserState.getScanner()
        let start = scanner.index
        let line = scanner
            .lines[scanner.lineIndex]
            .getContent()
        var str = line[scanner.index..]
        if (str.startsWith(MoonLoadingParser.MOON_LOADING)) {
            return ParsedInline.of(JsInlineNode('Moon', HashMap()),
                SourcePosition(scanner.lineIndex, start + MoonLoadingParser
                    .MOON_LOADING
                    .size))
        } else {
            return ParsedInline.none()
        }
    }
}

const TAG = 'InsertImageParser'
// 解析 <INSERT_IMAGE id="123456" /> 标签
class InsertImageParser <: InlineParserIntegration {
    static let PARAM_KEY = "key"

    private static let TAG_START = '<INSERT_IMAGE'
    private static let TAG_END = '>'

    public func create(): InlineContentParser {
        this
    }
    public func getTriggerCharacters(): HashSet<Rune> {
        return HashSet([r"<"])
    }

    public func tryParse(inlineParserState: InlineParserState): ParsedInline {
        let scanner = inlineParserState.getScanner()
        let start = scanner.index
        let line = scanner
            .lines[scanner.lineIndex]
            .getContent()
        var str = line[scanner.index..]
        if (str.startsWith(InsertImageParser.TAG_START)) {
            let endIndex = str.indexOf(InsertImageParser.TAG_END) ?? return ParsedInline.none()
            str = str[0..endIndex + 1]
            let firstQuote = str.indexOf('"') ?? return ParsedInline.none()
            let lastQuote = str.lastIndexOf('"') ?? return ParsedInline.none()
            let id = str[firstQuote + 1..lastQuote]
            //      KLog.debug(TAG, ()=>`str = ${str}, id = ${id}`)
            let map = HashMap<String, String>()
            map.add(InsertImageParser.PARAM_KEY, id)

            return ParsedInline.of(JsInlineNode('InsertImage', map),
                SourcePosition(scanner.lineIndex, start + endIndex + 1))
        } else {
            return ParsedInline.none()
        }
    }
}

class KimiInlineParser3 <: InlineParserIntegration {
    static let START: Rune = r'\u{E3A0}'
    static let END: String = "\u{E3A8}"
    static let LIMIT = 255
    public func create(): InlineContentParser {
        this
    }
    public func getTriggerCharacters(): HashSet<Rune> {
        return HashSet([START])
    }
    public func tryParse(inlineParserState: InlineParserState): ParsedInline {
        let scanner = inlineParserState.getScanner()
        scanner.next()
        let start = scanner.index
        let line = scanner.peekLine()
        if (let Some(i) <- line.indexOf(END)) {
            let data = line[..i]
            if (count(data.runes()) <= LIMIT) {
                return ParsedInline.of(JsInlineNode('KimiInlineNode3', HashMap([("", data)])),
                    SourcePosition(scanner.lineIndex, start + data.size + END.size))
            }
        }
        return ParsedInline.none()
    }
}

let Kimi_Inline_Parser = Plugin4InlineParserIntegration([InsertImageParser(), MoonLoadingParser(), KimiInlineParser3()])

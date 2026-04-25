/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights resvered.
 */
package commonmark4cj.commonmark

/**
 * Attempt to parse inline HTML.
 */
public class HtmlInlineParser <: InlineContentParser {
    private static let asciiLetter: AsciiMatcher = AsciiMatcher.builder().range(b'A', b'Z').range(b'a', b'z').build()

    // spec: A tag name consists of an ASCII letter followed by zero or more ASCII letters, digits, or hyphens (-).
    private static let tagNameStart: AsciiMatcher = asciiLetter
    private static let tagNameContinue: AsciiMatcher = tagNameStart.newBuilder().range(b'0', b'9').c(b'-').build()

    // spec: An attribute name consists of an ASCII letter, _, or :, followed by zero or more ASCII letters, digits,
    // _, ., :, or -. (Note: This is the XML specification restricted to ASCII. HTML5 is laxer.)
    private static let attributeStart: AsciiMatcher = asciiLetter.newBuilder().c(b'_').c(b':').build()
    private static let attributeContinue: AsciiMatcher = attributeStart
        .newBuilder()
        .range(b'0', b'9')
        .c(b'.')
        .c(b'-')
        .build()
    // spec: An unquoted attribute value is a nonempty string of characters not including whitespace, ", ', =, <, >, or `.
    private static let attributeValueEnd: AsciiMatcher = AsciiMatcher
        .builder()
        .c(b' ')
        .c(b'\t')
        .c(b'\n')
        .c(r'\u{000B}')
        .c(b'\f')
        .c(b'\r')
        .c(b'"')
        .c(b'\'')
        .c(b'=')
        .c(b'<')
        .c(b'>')
        .c(b'`')
        .build()

    // @Override
    public func tryParse(inlineParserState: InlineParserState): ParsedInline {
        let scanner: Scanner = inlineParserState.getScanner()
        let start: SourcePosition = scanner.position()
        // Skip over `<`
        scanner.next()

        var c = scanner.peek()
        if (tagNameStart.matches(c)) {
            if (tryOpenTag(scanner)) {
                return htmlInline(start, scanner)
            }
        } else if (c == b'/') {
            if (tryClosingTag(scanner)) {
                return htmlInline(start, scanner)
            }
        } else if (c == b'?') {
            if (tryProcessingInstruction(scanner)) {
                return htmlInline(start, scanner)
            }
        } else if (c == b'!') {
            // comment, declaration or CDATA
            scanner.next()
            c = scanner.peek()
            if (c == b'-') {
                if (tryComment(scanner)) {
                    return htmlInline(start, scanner)
                }
            } else if (c == b'[') {
                if (tryCdata(scanner)) {
                    return htmlInline(start, scanner)
                }
            } else if (asciiLetter.matches(c)) {
                if (tryDeclaration(scanner)) {
                    return htmlInline(start, scanner)
                }
            }
        }

        return ParsedInline.none()
    }

    private static func htmlInline(start: SourcePosition, scanner: Scanner): ParsedInline {
        let text: String = scanner.getSource(start, scanner.position()).getContent()
        let node: HtmlInline = HtmlInline(text)
        return ParsedInline.of(node, scanner.position())
    }

    private static func tryOpenTag(scanner: Scanner): Bool {
        // spec: An open tag consists of a < character, a tag name, zero or more attributes, optional whitespace,
        // an optional / character, and a > character.
        scanner.next()
        scanner.matches(tagNameContinue)
        var whitespace: Bool = scanner.whitespace() >= 1
        // spec: An attribute consists of whitespace, an attribute name, and an optional attribute value specification.
        while (whitespace && scanner.matches(attributeStart) >= 1) { /*cjlint-ignore !G.EXP.03 */
            scanner.matches(attributeContinue)
            // spec: An attribute value specification consists of optional whitespace, a = character,
            // optional whitespace, and an attribute value.
            whitespace = scanner.whitespace() >= 1
            if (scanner.next('=')) {
                scanner.whitespace()
                let valueStart = scanner.peek()
                if (valueStart == b'\'') {
                    scanner.next()
                    if (scanner.find(b'\'') < 0) {
                        return false
                    }
                    scanner.next()
                } else if (valueStart == b'"') {
                    scanner.next()
                    if (scanner.find(b'"') < 0) {
                        return false
                    }
                    scanner.next()
                } else {
                    if (scanner.find(attributeValueEnd) <= 0) {
                        return false
                    }
                }

                // Whitespace is required between attributes
                whitespace = scanner.whitespace() >= 1
            }
        }

        scanner.next(b'/')
        return scanner.next(b'>')
    }

    private static func tryClosingTag(scanner: Scanner): Bool {
        // spec: A closing tag consists of the string </, a tag name, optional whitespace, and the character >.
        scanner.next()
        if (scanner.matches(tagNameStart) >= 1) {
            scanner.matches(tagNameContinue)
            scanner.whitespace()
            return scanner.next('>')
        }
        return false
    }

    private static func tryProcessingInstruction(scanner: Scanner): Bool {
        // spec: A processing instruction consists of the string <?, a string of characters not including the string ?>,
        // and the string ?>.
        scanner.next()
        while (scanner.find(b'?') > 0) {
            scanner.next()
            if (scanner.next(b'>')) {
                return true
            }
        }
        return false
    }

    private static func tryComment(scanner: Scanner): Bool {
        // spec: An [HTML comment](@) consists of `<!-->`, `<!--->`, or  `<!--`, a string of
        // characters not including the string `-->`, and `-->` (see the
        // [HTML spec](html/spec/whatwg/org/multipage/parsing.html#markup-declaration-open-state)).

        // Skip first `-`
        scanner.next()
        if (!scanner.next(b'-')) {
            return false
        }

        if (scanner.next(b'>') || scanner.next("->")) { /*cjlint-ignore !G.EXP.03 */
            return true
        }

        while (scanner.find(b'-') >= 0) {
            if (scanner.next("-->")) {
                return true
            } else {
                scanner.next()
            }
        }

        return false
    }

    private static func tryCdata(scanner: Scanner): Bool {
        // spec: A CDATA section consists of the string <![CDATA[, a string of characters not including the string ]]>,
        // and the string ]]>.

        // Skip `[`
        scanner.next()

        if (scanner.next("CDATA[")) {
            while (scanner.find(b']') >= 0) {
                if (scanner.next("]]>")) {
                    return true
                } else {
                    scanner.next()
                }
            }
        }

        return false
    }

    private static func tryDeclaration(scanner: Scanner): Bool {
        // spec: A declaration consists of the string <!, an ASCII letter, zero or more characters not including
        // the character >, and the character >.
        scanner.matches(asciiLetter)
        if (scanner.whitespace() <= 0) {
            return false
        }
        if (scanner.find(b'>') >= 0) {
            scanner.next()
            return true
        }
        return false
    }
}

public class HtmlInlineParserFactory <: InlineContentParserFactory {

    // @Override
    @Frozen
    public func getTriggerCharacters(): HashSet<Rune> {
        return HashSet(r'<')
    }

    // @Override
    public func create(): InlineContentParser {
        return HtmlInlineParser()
    }
}

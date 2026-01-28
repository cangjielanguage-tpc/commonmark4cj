/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights resvered.
 */
package commonmark4cj.commonmark

/**
 * Parse a backslash-escaped special character, adding either the escaped  character, a hard line break
 * (if the backslash is followed by a newline), or a literal backslash to the block's children.
 */
public class BackslashInlineParser <: InlineContentParser {
    // @Override
    public func tryParse(inlineParserState: InlineParserState): ParsedInline {
        let scanner: Scanner = inlineParserState.getScanner()
        // Backslash
        scanner.next()

        let next = scanner.peek()
        if (next == b'\n') {
            scanner.next()
            return ParsedInline.of(HardLineBreak(), scanner.position())
        } else if (next != b'\0' && isEscapable(next)) {
            scanner.next()
            return ParsedInline.of(Text(Rune(next).toString()), scanner.position())
        } else {
            return ParsedInline.of(Text("\\"), scanner.position())
        }
    }
}

public class BackslashInlineParserFactory <: InlineContentParserFactory {
    // @Override
    @Frozen
    public func getTriggerCharacters(): HashSet<Rune> {
        return HashSet(r'\\')
    }

    // @Override
    @Frozen
    public func create(): InlineContentParser {
        return BackslashInlineParser()
    }
}

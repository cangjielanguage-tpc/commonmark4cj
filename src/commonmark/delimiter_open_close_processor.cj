package commonmark4cj.commonmark

/**
 * Customizes whether a delimiter run can open and/or close a delimited inline node.
 * <p>
 * Return {@code None} to keep the built-in CommonMark flanking rules for the current delimiter run.
 */
public type DelimiterOpenCloseProcessor = (context: DelimiterOpenCloseContext) -> ?DelimiterOpenCloseResult

public type CharacterPredicate = (codePoint: Rune) -> Bool

/**
 * Result of delimiter open/close detection.
 */
public class DelimiterOpenCloseResult {
    private let _canOpen: Bool
    private let _canClose: Bool

    public DelimiterOpenCloseResult(canOpen: Bool, canClose: Bool) {
        this._canOpen = canOpen
        this._canClose = canClose
    }

    public static func of(canOpen: Bool, canClose: Bool): DelimiterOpenCloseResult {
        return DelimiterOpenCloseResult(canOpen, canClose)
    }

    public func canOpen(): Bool {
        return _canOpen
    }

    public func canClose(): Bool {
        return _canClose
    }
}

/**
 * Context for delimiter open/close detection.
 */
public class DelimiterOpenCloseContext {
    private let _delimiterChar: Rune
    private let _delimiterCount: Int64
    private let _before: Rune
    private let _after: Rune
    private let _delimiterProcessor: DelimiterProcessor

    public DelimiterOpenCloseContext(
        delimiterChar: Rune,
        delimiterCount: Int64,
        before: Rune,
        after: Rune,
        delimiterProcessor: DelimiterProcessor
    ) {
        this._delimiterChar = delimiterChar
        this._delimiterCount = delimiterCount
        this._before = before
        this._after = after
        this._delimiterProcessor = delimiterProcessor
    }

    public func delimiterChar(): Rune {
        return _delimiterChar
    }

    public func delimiterCount(): Int64 {
        return _delimiterCount
    }

    public func before(): Rune {
        return _before
    }

    public func after(): Rune {
        return _after
    }

    public func delimiterProcessor(): DelimiterProcessor {
        return _delimiterProcessor
    }

    public func defaultResult(): DelimiterOpenCloseResult {
        let (canOpen, canClose) = defaultDelimiterOpenClose(
            _delimiterChar,
            _before,
            _after,
            _delimiterProcessor,
            Characters.isPunctuationCodePoint,
            Characters.isWhitespaceCodePoint
        )
        return DelimiterOpenCloseResult(canOpen, canClose)
    }

    public func defaultResultWith(
        isPunctuationCodePoint: CharacterPredicate,
        isWhitespaceCodePoint: CharacterPredicate
    ): DelimiterOpenCloseResult {
        let (canOpen, canClose) = defaultDelimiterOpenClose(
            _delimiterChar,
            _before,
            _after,
            _delimiterProcessor,
            isPunctuationCodePoint,
            isWhitespaceCodePoint
        )
        return DelimiterOpenCloseResult(canOpen, canClose)
    }
}

func defaultDelimiterOpenClose(
    delimiterChar: Rune,
    before: Rune,
    after: Rune,
    delimiterProcessor: DelimiterProcessor,
    isPunctuationCodePoint: CharacterPredicate,
    isWhitespaceCodePoint: CharacterPredicate
): (Bool, Bool) {
    let beforeIsPunctuation = before == Scanner.END_RUNE || isPunctuationCodePoint(before)
    let beforeIsWhitespace = before == Scanner.END_RUNE || isWhitespaceCodePoint(before)
    let afterIsPunctuation = after == Scanner.END_RUNE || isPunctuationCodePoint(after)
    let afterIsWhitespace = after == Scanner.END_RUNE || isWhitespaceCodePoint(after)

    let leftFlanking = !afterIsWhitespace && (!afterIsPunctuation || beforeIsWhitespace || beforeIsPunctuation)
    let rightFlanking = !beforeIsWhitespace && (!beforeIsPunctuation || afterIsWhitespace || afterIsPunctuation)

    let canOpen: Bool
    let canClose: Bool
    if (delimiterChar == r'_') {
        canOpen = leftFlanking && (!rightFlanking || beforeIsPunctuation)
        canClose = rightFlanking && (!leftFlanking || afterIsPunctuation)
    } else {
        canOpen = leftFlanking && delimiterChar == delimiterProcessor.getOpeningCharacter()
        canClose = rightFlanking && delimiterChar == delimiterProcessor.getClosingCharacter()
    }
    return (canOpen, canClose)
}

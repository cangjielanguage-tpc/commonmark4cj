/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package commonmark4cj.commonmark
/**
 * A delimiter run is one or more of the same delimiter character.
 */
public interface DelimiterRun {

    /**
     * @return whether this can open a delimiter
     */
    func canOpen(): Bool

    /**
     * @return whether this can close a delimiter
     */
    func canClose(): Bool

    /**
     * @return the number of characters in this delimiter run (that are left for processing)
     */
    func getLength(): Int64

    /**
     * @return the number of characters originally in this delimiter run at the start of processing, this is the same
     * as {{@link #length()}}
     */
    func getOriginalLength(): Int64

    /**
     * @return the innermost opening delimiter, e.g. for {@code ***} this is the last {@code *}
     */
    func getOpener(): Text

    /**
     * @return the innermost closing delimiter, e.g. for {@code ***} this is the first {@code *}
     */
    func getCloser(): Text

    /**
     * Get the opening delimiter nodes for the specified length of delimiters. Length must be between 1 and
     * {@link #length()}.
     * <p>
     * For example, for a delimiter run {@code ***}, calling this with 1 would return the last {@code *}.
     * Calling it with 2 would return the second last {@code *} and the last {@code *}.
     */
    @Frozen
    func getOpeners(length: Int): ReadOnlyList<Text>

    /**
     * Get the closing delimiter nodes for the specified length of delimiters. Length must be between 1 and
     * {@link #length()}.
     * <p>
     * For example, for a delimiter run {@code ***}, calling this with 1 would return the first {@code *}.
     * Calling it with 2 would return the first {@code *} and the second {@code *}.
     */
    @Frozen
    func getClosers(length: Int): ReadOnlyList<Text>
}

/**
 * Delimiter (emphasis, strong emphasis or custom emphasis).
 */
public class Delimiter <: DelimiterRun & Equatable<Delimiter> {
    public let characters: ArrayList<Text>
    public let delimiterChar: Rune
    private let originalLength: Int64

    /**
     * Can open emphasis, see spec.
     */
    public let canOpenBool: Bool

    /**
     * Can close emphasis, see spec.
     */
    public let canCloseBool: Bool

    public var previous: ?Delimiter = None
    public var next: ?Delimiter = None

    @Frozen
    public init(characters: ArrayList<Text>, delimiterChar: Rune, canOpen: Bool, canClose: Bool, previous: ?Delimiter) {
        this.characters = characters
        this.delimiterChar = delimiterChar
        this.canOpenBool = canOpen
        this.canCloseBool = canClose
        this.previous = previous
        this.originalLength = characters.size
    }

    public func canOpen(): Bool {
        return canOpenBool
    }

    public func canClose(): Bool {
        return canCloseBool
    }

    public func getLength(): Int64 {
        return characters.size
    }

    public func getOriginalLength(): Int64 {
        return originalLength
    }

    public operator func ==(other: Delimiter): Bool {
        return refEq(this, other)
    }

    public operator func !=(other: Delimiter): Bool {
        return !refEq(this, other)
    }

    public func getOpener(): Text {
        return characters.last.getOrThrow()
    }

    public func getCloser(): Text {
        return characters[0]
    }

    @Frozen
    public func getOpeners(length: Int): ReadOnlyList<Text> {
        if (!(length >= 1 && length <= getLength())) {
            throw IllegalArgumentException("length must be between 1 and ${getLength()}, was ${length}")
        }
        return characters[characters.size - length..characters.size]
    }

    @Frozen
    public func getClosers(length: Int): ReadOnlyList<Text> {
        if (!(length >= 1 && length <= getLength())) {
            throw IllegalArgumentException("length must be between 1 and ${getLength()}, was ${length}")
        }
        return characters[0..length]
    }
}

/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package commonmark4cj.commonmark

/**
 * Opening bracket for links ({@code [}), images ({@code ![}), or links with other markers.
 */
public class Bracket {

    /**
     * The node of a marker such as {@code !} if present, null otherwise.
     */
    public let markerNode: ?Text

    /**
     * The position of the marker if present, null otherwise.
     */
    public let markerPosition: ?SourcePosition

    /**
     * The node of {@code [}.
     */
    public let bracketNode: Text

    /**
     * The position of {@code [}.
     */
    public let bracketPosition: SourcePosition

    /**
     * The position of the content (after the opening bracket)
     */
    public let contentPosition: SourcePosition

    /**
     * Previous bracket.
     */
    public let previous: ?Bracket

    /**
     * Previous delimiter (emphasis, etc) before this bracket.
     */
    public let previousDelimiter: ?Delimiter

    /**
     * Whether this bracket is allowed to form a link/image (also known as "active").
     */
    public var allowed: Bool = true

    /**
     * Whether there is an unescaped bracket (opening or closing) after this opening bracket in the text parsed so far.
     */
    public var bracketAfter: Bool = false

    public static func link(bracketNode: Text, bracketPosition: SourcePosition, contentPosition: SourcePosition,
        previous: ?Bracket, previousDelimiter: ?Delimiter): Bracket {
        return Bracket(None, None, bracketNode, bracketPosition, contentPosition, previous, previousDelimiter)
    }

    public static func withMarker(markerNode: Text, markerPosition: SourcePosition, bracketNode: Text,
        bracketPosition: SourcePosition, contentPosition: SourcePosition, previous: ?Bracket,
        previousDelimiter: ?Delimiter): Bracket {
        return Bracket(markerNode, markerPosition, bracketNode, bracketPosition, contentPosition, previous,
            previousDelimiter)
    }

    private init(markerNode: ?Text, markerPosition: ?SourcePosition, bracketNode: Text, bracketPosition: SourcePosition,
        contentPosition: SourcePosition, previous: ?Bracket, previousDelimiter: ?Delimiter) {
        this.markerNode = markerNode
        this.markerPosition = markerPosition
        this.bracketNode = bracketNode
        this.bracketPosition = bracketPosition
        this.contentPosition = contentPosition
        this.previous = previous
        this.previousDelimiter = previousDelimiter
    }
}

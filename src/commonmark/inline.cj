/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package commonmark4cj.commonmark

public abstract class EmphasisDelimiterProcessor <: DelimiterProcessor {
    private let delimiterChar: Rune

    protected init(delimiterChar: Rune) {
        this.delimiterChar = delimiterChar
    }

    public override func getOpeningCharacter(): Rune {
        return delimiterChar
    }

    public override func getClosingCharacter(): Rune {
        return delimiterChar
    }

    public override func getMinLength(): Int64 {
        return 1
    }

    public override func process(openingRun: DelimiterRun, closingRun: DelimiterRun): Int {
        // "multiple of 3" rule for internal delimiter runs
        if ((openingRun.canClose() || closingRun.canOpen()) && closingRun.getOriginalLength() % 3 != 0 &&
            (openingRun.getOriginalLength() + closingRun.getOriginalLength()) % 3 == 0) {
            return 0
        }

        var usedDelimiters = 0
        // calculate actual number of delimiters used from this closer
        let emphasis: Node = if (openingRun.getLength() >= 2 && closingRun.getLength() >= 2) {
            usedDelimiters = 2
            StrongEmphasis(delimiterChar.toString() * 2)
        } else {
            usedDelimiters = 1
            Emphasis(delimiterChar.toString())
        }

        let sourceSpans = SourceSpans.empty()
        sourceSpans.addAllFromTexts(openingRun.getOpeners(usedDelimiters))

        let opener = openingRun.getOpener()
        for (node in Nodes.between(opener, closingRun.getCloser())) {
            emphasis.appendChild(node)
            sourceSpans.addAll(node.getSourceSpans())
        }

        sourceSpans.addAllFromTexts(closingRun.getClosers(usedDelimiters))

        emphasis.setSourceSpans(sourceSpans.getSourceSpans())
        opener.insertAfter(emphasis)

        return usedDelimiters
    }
}

public class UnderscoreDelimiterProcessor <: EmphasisDelimiterProcessor {
    public init() {
        super(r'_')
    }
}

public class AsteriskDelimiterProcessor <: EmphasisDelimiterProcessor {
    public init() {
        super(r'*')
    }
}

/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights resvered.
 */
package commonmark4cj.commonmark

/**
 * Matcher interface for {@code Rune} values.
 * <p>
 * Note that because this matches on {@code Rune} values only (as opposed to {@code Int} code points),
 * this only operates on the level of code units and doesn't support supplementary characters
 * (see {@link Character#isSupplementaryCodePoint(Int)}).
 */
public interface CharMatcher {
    func matches(b: Byte): Bool
}

/**
 * Char matcher that can match ASCII characters efficiently.
 */
public class AsciiMatcher <: CharMatcher {
    private let set: BitSet

    AsciiMatcher(builder: AsciiMatcherBuilder) {
        this.set = builder.set
    }

    public func matches(b: Byte): Bool {
        return set.get(b)
    }

    public func newBuilder(): AsciiMatcherBuilder {
        return AsciiMatcherBuilder(set.clone())
    }

    public static func builder(): AsciiMatcherBuilder {
        return AsciiMatcherBuilder(BitSet())
    }

    public static func builder(matcher: AsciiMatcher): AsciiMatcherBuilder {
        return AsciiMatcherBuilder(matcher.set.clone())
    }
}

public class AsciiMatcherBuilder {
    let set: BitSet

    AsciiMatcherBuilder(set: BitSet) {
        this.set = set
    }

    public func c(ch: Byte): AsciiMatcherBuilder {
        set.set(ch)
        return this
    }
    public func c(ch: Rune): AsciiMatcherBuilder {
        let u32 = UInt32(ch)
        if (u32 > 127) {
            throw IllegalArgumentException("Can only match ASCII characters")
        }
        c(UInt8(u32))
    }

    public func anyOf(s: String): AsciiMatcherBuilder {
        for (i in 0..s.size) {
            c(s[i])
        }
        return this
    }

    @Frozen
    public func anyOf(characters: Set<Byte>): AsciiMatcherBuilder {
        for (ch in characters) {
            c(ch)
        }
        return this
    }

    public func range(from: Byte, toInclusive: Byte): AsciiMatcherBuilder {
        for (ch in from..=toInclusive) {
            c(ch)
        }
        return this
    }

    public func build(): AsciiMatcher {
        return AsciiMatcher(this)
    }
}

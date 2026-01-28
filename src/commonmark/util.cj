/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package commonmark4cj.commonmark

/* Character range of ascii type：0-127*/
public type AsciiByte = Byte

public class Escaping {
    public static let ESCAPABLE: String = "[!\"#$%&\'()*+,./:;<=>?@\\[\\\\\\]^_`{|}~-]"

    public static let ENTITY: String = "&(?:#x[a-f0-9]{1,6}|#[0-9]{1,7}|[a-z][a-z0-9]{1,31});"

    private static let ENTITY_OR_ESCAPED_CHAR = Regex(
        "\\\\" + ESCAPABLE + '|'.toString() + ENTITY,
        IgnoreCase
    )

    // From RFC 3986 (see "reserved", "unreserved") except don't escape '[' or ']' to be compatible with JS encodeURI
    private static let ESCAPE_IN_URI = Regex("(%[a-fA-F0-9]{0,2}|[^:/?#@!$&'()*+,;=a-zA-Z0-9\\-._~])")

    static let amp: Array<Byte> = "&amp;".toArray()
    static let lt: Array<Byte> = "&lt;".toArray()
    static let gt: Array<Byte> = "&gt;".toArray()
    static let quot: Array<Byte> = "&quot;".toArray()

    public static func escapeHtml(input: String): String {
        // Avoid building a new string in the majority of cases (nothing to escape)
        let arr: Array<Byte> = unsafe { input.rawData() }
        var sb: ?ArrayList<Byte> = None
        var i: Int64 = 0
        while (i < arr.size) {
            let replacement: Array<Byte> = match (arr[i]) {
                case '&' => amp
                case '<' => lt
                case '>' => gt
                case '\"' => quot
                case byte =>
                    if (let Some(s) <- sb) {
                        s.add(byte)
                    }
                    i++
                    continue
            }
            if (sb.isNone()) {
                sb = ArrayList<Byte>(arr.size + 16)
                sb?.add(all: arr[..i])
            }
            sb?.add(all: replacement)
            i++
        }
        if (let Some(s) <- sb) {
            return unsafe { String.fromUtf8Unchecked(s.getRawArray()[..s.size]) }
        } else {
            return input
        }
    }

    /**
     * Replace entities and backslash escapes with literal characters.
     */
    public static func unescapeString(s: String): String {
        //        match (BACKSLASH_OR_AMP.find(s)) {
        //            case None => return s
        //            case _ => return replaceAll(ENTITY_OR_ESCAPED_CHAR, s, UnescapeReplacer())
        //        }
        for (b in s) {
            if (b == b'\\' || b == b'&') {
                return replaceAll(ENTITY_OR_ESCAPED_CHAR, s, UnescapeReplacer())
            }
        }
        return s
    }

    public static func percentEncodeUrl(s: String): String {
        let str = s |> map<Byte, ToString> {
            b => if (b < 128) {
                String(Rune(b))
            } else {
                "%${b.format("X")}"
            }
        } |> collectString(delimiter: "")
        return replaceAll(ESCAPE_IN_URI, str, UriReplacer())
    }

    public static func normalizeReference(input: String): String {
        // Strip '[' and ']'
        let stripped: String = input[1..input.size - 1]
        return normalizeLabelContent(stripped)
    }

    protected static func normalizeLabelContent(input: String): String {
        let trimmed: String = input.trimAscii()
        //        let lowercase: String = trimmed.toAsciiLower()
        //        return WHITESPACE.replaceAll(lowercase, " ")
        let arr = trimmed.toArray()
        for (i in 0..arr.size) {
            if (arr[i] >= b'a' && arr[i] <= b'z') {
                arr[i] -= 0x20
            } else if (arr[i] == b'\r' || arr[i] == b'\n' || arr[i] == b'\t') {
                arr[i] = b' '
            }
        }
        return unsafe { String.fromUtf8Unchecked(arr) }
    }

    private static func replaceAll(p: Regex, s: String, replacer: Replacer): String {
        let matcher: Array<MatchData> = p.findAll(s)

        if (matcher.size < 1) {
            return s
        }

        var sb: StringBuilder = StringBuilder(s.size + 16)
        var lastEnd: Int64 = 0

        var pos: Position
        var i: Int64 = 0
        while (i < matcher.size) {
            pos = matcher[i].matchPosition()
            sb.append(s[lastEnd..pos.start])
            replacer.replace(matcher[i].matchString(), sb)
            lastEnd = pos.end
            i++
        }

        if (lastEnd != s.size) {
            sb.append(s[lastEnd..])
        }
        return sb.toString()
    }
}

class UnescapeReplacer <: Replacer {
    public func replace(input: String, sb: StringBuilder): Unit {
        if (input[0] == b'\\') {
            sb.append(input[1..])
        } else {
            sb.append(Html5Entities.entityToString(input))
        }
    }
}

class UriReplacer <: Replacer {
    private static let HEX_DIGITS: Array<Rune> = [r'0', r'1', r'2', r'3', r'4', r'5', r'6', r'7', r'8', r'9', r'A', r'B',
        r'C', r'D', r'E', r'F']

    public func replace(input: String, sb: StringBuilder): Unit {
        if (input[0] == b'%') {
            if (input.size == 3) {
                // Already percent-encoded, preserve
                sb.append(input)
            } else {
                // %25 is the percent-encoding for %
                sb.append("%25")
                sb.append(input[1..])
            }
        } else {
            for (b in input) {
                sb.append('%')
                sb.append(HEX_DIGITS[Int64((b >> 4) & 0xF)])
                sb.append(HEX_DIGITS[Int64(b & 0xF)])
            }
        }
    }
}

public interface Replacer {
    func replace(input: String, sb: StringBuilder): Unit
}

public class Html5Entities {
    private static let NAMED_CHARACTER_REFERENCES: HashMap<String, String> = readEntities()
    private static let NUMERIC_PATTERN = Regex("^&#[Xx]?")

    public static func entityToString(input: String): String {
        let md: ?MatchData = NUMERIC_PATTERN.find(input)
        if (md.isSome()) {
            try {
                let codePointString: String = input[md.getOrThrow().matchPosition().end..input.size - 1]
                let codePoint: Int64
                if (md.getOrThrow().matchPosition().end == 2) {
                    codePoint = Int64.parse(codePointString)
                } else {
                    codePoint = Int64.parse("0x" + codePointString)
                }
                if (codePoint == 0) {
                    return "\u{FFFD}"
                }

                return String(Rune(codePoint))
            } catch (e: IllegalArgumentException) {
                return "\u{FFFD}"
            }
        } else {
            let name: String = input[1..input.size - 1]
            let s: ?String = NAMED_CHARACTER_REFERENCES.get(name)
            return s ?? input
        }
    }

    @Frozen
    public static func readEntities(): HashMap<String, String> {
        return entities_dict
    }
}

public class Parsing {
    public static let CODE_BLOCK_INDENT: Int64 = 4

    public static func columnsToNextTabStop(column: Int64): Int64 {
        // Tab stop is 4
        return 4 - (column % 4)
    }
}

const HIGH_1_UInt8: UInt8 = 0b10000000 // 0x80
const HIGH_2_UInt8: UInt8 = 0b11000000 // 0xc0
const HIGH_3_UInt8: UInt8 = 0b11100000 // 0xe0
const HIGH_4_UInt8: UInt8 = 0b11110000 // 0xf0
const HIGH_5_UInt8: UInt8 = 0b11111000 // 0xf8
const HIGH_6_UInt8: UInt8 = 0b11111100 // 0xfc

class StringLineReader {
    StringLineReader(let input: InputStream) {
    }
    let buf: Array<UInt8> = [0]
    let buffer = ByteBuffer()
    let line = ArrayList<Byte>()
    /* 
     * return (行内容, 换行符长度)
     */
    func readln(): ?(String, Int64) {
        readFromSrc()
        if (buffer.bytes().size == 0) {
            return None
        }

        line.clear()
        var lineBreakSize = 0
        while (let Some(b) <- buffer.readByte()) {
            match (b) {
                case b'\r' =>
                    if (lineBreakSize != 0) {
                        buffer.seek(SeekPosition.Current(-1))
                        break
                    }
                    lineBreakSize++
                case b'\n' =>
                    lineBreakSize++
                    break
                case _ =>
                    if (lineBreakSize != 0) {
                        buffer.seek(SeekPosition.Current(-1))
                        break
                    }
                    line.add(b)
            }
        }
        return (unsafe { String.fromUtf8Unchecked(line.getRawArray()[..line.size]) }, lineBreakSize)
    }
    func readFromSrc(): Unit {
        while (input.read(buf) == 1) {
            buffer.write(buf)
        }
    }
}

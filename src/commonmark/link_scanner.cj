/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights resvered.
 */
package commonmark4cj.commonmark

public class LinkScanner {
    /**
     * Attempt to scan the contents of a link label (inside the brackets), stopping after the content or returning false.
     * The stopped position can bei either the closing {@code ]}, or the end of the line if the label continues on
     * the next line.
     */
    public static func scanLinkLabelContent(scanner: Scanner): Bool {
        while (scanner.hasNext()) {
            match (scanner.peek()) {
                case '\\' =>
                    scanner.next()
                    if (isEscapable(scanner.peek())) {
                        scanner.next()
                    }
                case ']' => return true
                case '[' =>
                    // spec: Unescaped square bracket characters are not allowed inside the opening and closing
                    // square brackets of link labels.
                    return false
                case _ => scanner.next()
            }
        }
        return true
    }

    /**
     * Attempt to scan a link destination, stopping after the destination or returning false.
     */
    public static func scanLinkDestination(scanner: Scanner): Bool {
        if (!scanner.hasNext()) {
            return false
        }

        if (scanner.next(b'<')) {
            while (scanner.hasNext()) {
                match (scanner.peek()) {
                    case '\\' =>
                        scanner.next()
                        if (isEscapable(scanner.peek())) {
                            scanner.next()
                        }
                    case '\n' | '<' => return false
                    case '>' =>
                        scanner.next()
                        return true
                    case _ => scanner.next()
                }
            }
            return false
        } else {
            return scanLinkDestinationWithBalancedParens(scanner)
        }
    }

    public static func scanLinkTitle(scanner: Scanner): Bool {
        if (!scanner.hasNext()) {
            return false
        }

        let endDelimiter: Byte = match (scanner.peek()) {
            case '"' => b'"'
            case '\'' => b'\''
            case '(' => b')'
            case _ => return false
        }
        scanner.next()

        if (!scanLinkTitleContent(scanner, endDelimiter)) {
            return false
        }
        if (!scanner.hasNext()) {
            return false
        }
        scanner.next()
        return true
    }

    public static func scanLinkTitleContent(scanner: Scanner, endDelimiter: Byte): Bool {
        while (scanner.hasNext()) {
            let c: Byte = scanner.peek()
            if (c == b'\\') {
                scanner.next()
                if (isEscapable(scanner.peek())) {
                    scanner.next()
                }
            } else if (c == endDelimiter) {
                return true
            } else if (endDelimiter == b')' && c == b'(') {
                // unescaped '(' in title within parens is invalid
                return false
            } else {
                scanner.next()
            }
        }
        return true
    }

    // spec: a nonempty sequence of characters that does not start with <, does not include ASCII space or control
    // characters, and includes parentheses only if (a) they are backslash-escaped or (b) they are part of a balanced
    // pair of unescaped parentheses
    private static func scanLinkDestinationWithBalancedParens(scanner: Scanner): Bool {
        var parens = 0
        var empty = true
        while (scanner.hasNext()) {
            let c = scanner.peek()
            match (c) {
                case ' ' => return !empty
                case '\\' =>
                    scanner.next()
                    if (isEscapable(scanner.peek())) {
                        scanner.next()
                    }
                case '(' =>
                    parens++
                    // Limit to 32 nested parens for pathological cases
                    if (parens > 32) {
                        return false
                    }
                    scanner.next()
                case ')' =>
                    if (parens == 0) {
                        return true
                    } else {
                        parens--
                    }
                    scanner.next()
                case _ =>
                    let char = scanner.peek()
                    // or control character
                    if (isISOControl(scanner)) {
                        return !empty
                    }
                    scanner.next()
            }
            empty = false
        }
        return true
    }

    private static func isISOControl(scanner: Scanner): Bool {
        let b = scanner.peek()
        // (0x00 <= codePoint <= 0x1F) || (0x7F <= codePoint <= 0x9F);
        if (0x00 <= b && b <= 0x1F) {
            return true
        }
        if (b == 0x7F) {
            return true
        }
        if (b == 194) {
            let pos = scanner.position()
            scanner.next()
            let b2 = scanner.peek()
            scanner.setPosition(pos)
            if (128 <= b2 && b2 <= 159) {
                return true
            }
        }
        return false
    }
}

func isEscapable(c: Byte): Bool {
    match (c) {
        case '!' | '"' | '#' | '$' | '%' | '&' | '\'' | '(' | ')' | '*' | '+' | ',' | '-' | '.' | '/' | ':' | ';' | '<'
            | '=' | '>' | '?' | '@' | '[' | '\\' | ']' | '^' | '_' | '`' | '{' | '|' | '}' | '~' => return true
        case _ => return false
    }
}

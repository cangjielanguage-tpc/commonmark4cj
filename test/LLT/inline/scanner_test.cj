
// DEPENDENCE: scanner.cj
// EXEC: cjc %import-path %L %l %f scanner.cj -Woff unused --test --debug-macro
// EXEC: ./main 
//--filter=*.t3 --show-all-output

internal import commonmark4cj.commonmark.*
internal import std.collection.*
internal import std.regex.*

@Test
func t1(): Unit {
    let lines = SourceLines.of(SourceLine.of("qazwsx", None))
    let scanner = Scanner.of(lines)
    println("${scanner.position().lineIndex}-${scanner.position().index}")
    println(scanner.peek())
    println(scanner.next(b'q'))
    println(scanner.peek())
    println(scanner.next(b'a'))
    println(scanner.peek())
    println(scanner.next(b'z'))
    println(scanner.peek())
    println(scanner.next(b'w'))
    println(scanner.peek())
    println(scanner.next(b's'))
    println("${scanner.position().lineIndex}-${scanner.position().index}")
    scanner.setPosition(SourcePosition(0, 0))
    println("${scanner.position().lineIndex}-${scanner.position().index}")
    println(scanner.peek())
}

@Test
func t2(): Unit {
    let urireg = Regex(#"^[a-zA-Z][a-zA-Z0-9.+-]{1,31}:[^<>\x00-\x20]*$"#)
    let got = urireg.matcher("http://www.example.com").find().isSome()
    println(got)
}

@Test
func t3(): Unit {
    let label2: String = "a\n" * 2
    let str = "[foo][" + label2 + "]"
    let lines = SourceLines.empty()
    for (l in str.trimAscii().lines()) {
        lines.addLine(SourceLine.of(l, None))
    }
    let scanner = Scanner.of(lines)
    for(l in scanner.lines) {
        println(l.getContent())
    }
    scanner.find(b']')
    scanner.next()
    scanner.next(b'[')
    scanLinkLabelContent(scanner)
}

func scanLinkLabelContent(scanner: Scanner): Bool {
    while (scanner.hasNext()) {
        match (scanner.peek()) {
            case b'\\' =>
                eprintln("11.1")
                scanner.next()
                if (isEscapable(Rune(UInt32(scanner.peek())))) {
                    scanner.next()
                }
            case b']' =>
                eprintln("11.2")
                return true
            case b'[' =>
                eprintln("11.3")
                // spec: Unescaped square bracket characters are not allowed inside the opening and closing
                // square brackets of link labels.
                return false
            case _ =>
                eprintln(
                    "11.4-${scanner.peek().toString().replace('\0', '\\0').replace('\n', '_')}-${scanner.position()}-${scanner.line.getContent()}")
                scanner.next()
        }
    }
    eprintln("11.5-${scanner.peek().toString().replace('\0', '\\0').replace('\n', '_')}-${scanner.position()}")
    return true
}

func isEscapable(c: Rune): Bool {
    match (c) {
        case '!' | '"' | '#' | '$' | '%' | '&' | '\'' | '(' | ')' | '*' | '+' | ',' | '-' | '.' | '/' | ':' | ';' | '<' | '=' | '>' | '?' | '@' | '[' | '\\' | ']' | '^' | '_' | '`' | '{' | '|' | '}' | '~' => return true
        case _ => return false
    }
}
type CharSequence= String
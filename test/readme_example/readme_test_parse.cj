// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import commonmark4cj.commonmark.*

main(): Int64 {
    let parser: Parser = Parser.builder().customBlockParserFactory(DashBlockParserFactory()).build()

    let document: Node = parser.parse("hey\n\n---\n")

    println(document.getFirstChild().getOrThrow().toString())
    println((document.getFirstChild().getOrThrow().getFirstChild().getOrThrow() as Text).getOrThrow().getLiteral())
    println(document.getLastChild().getOrThrow().toString())

    return 0
}

class DashBlockParserFactory <: AbstractBlockParserFactory {
    public override func tryStart(state: ParserState, matchedBlockParser: MatchedBlockParser): ?BlockStart {
        if (state.getLine().getContent() == ("---")) {
            return BlockStart.of(DashBlockParser())
        }
        return BlockStart.none()
    }
}

class DashBlock <: CustomBlock {
    public func getNodeType(): NodeType {
        "DashBlock"
    }
}

class DashBlockParser <: AbstractBlockParser {
    private var dash: DashBlock = DashBlock()

    public override func getBlock(): Block {
        return dash
    }

    public override func tryContinue(parserState: ParserState): ?BlockContinue {
        return BlockContinue.none()
    }
}

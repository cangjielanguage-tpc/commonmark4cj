/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 */

package commonmark4cj.table

class TableBlockParser <: AbstractBlockParser {
    private var block: TableBlock = TableBlock()
    private let columns: ArrayList<TableCellInfo>
    private let rowLines = ArrayList<SourceLine>()

    private var canHaveLazyContinuationLines_ = true

    init(columns: ArrayList<TableCellInfo>, headerLine: SourceLine) {
        this.columns = columns
        this.rowLines.add(headerLine)
    }

    public func canHaveLazyContinuationLines(): Bool {
        return canHaveLazyContinuationLines_
    }

    public func getBlock(): TableBlock {
        return block
    }

    public func tryContinue(state: ParserState): ?BlockContinue {
        let content = state.getLine().getContent()
        let pipe = content.indexOf(b'|', state.getNextNonSpaceIndex()) ?? -1
        if (pipe != -1) {
            if (pipe == state.getNextNonSpaceIndex()) {
                // If we *only* have a pipe character (and whitespace), that is not a valid table row and ends the table.
                if (Characters.skipSpaceTab(content, pipe + 1, content.size) == content.size) {
                    // We also don't want the pipe to be added via lazy continuation.
                    canHaveLazyContinuationLines_ = false
                    return BlockContinue.none()
                }
            }
            return BlockContinue.atIndex(state.getIndex())
        } else {
            return BlockContinue.none()
        }
    }

    public func addLine(line: SourceLine): Unit {
        rowLines.add(line)
    }

    public func parseInlines(inlineParser: InlineParser): Unit {
        let sourceSpans = block.getSourceSpans()

        let headerSourceSpan: ?SourceSpan = sourceSpans.get(0)
        var head: Node = TableHead()
        if (let Some(v) <- headerSourceSpan) {
            head.addSourceSpan(v)
        }
        block.appendChild(head)

        var headerRow: TableRow = TableRow()
        headerRow.setSourceSpans(head.getSourceSpans())
        head.appendChild(headerRow)

        let headerCells = split(rowLines[0])
        let headerColumns = headerCells.size
        for (i in 0..headerColumns) {
            let cell = headerCells[i]
            var tableCell: TableCell = parseCell(cell, i, inlineParser)
            tableCell.setHeader(true)
            headerRow.appendChild(tableCell)
        }

        var body: ?Node = None
        for (rowIndex in 2..rowLines.size) {
            let rowLine = rowLines[rowIndex]
            let sourceSpan = sourceSpans.get(rowIndex)
            var cells = split(rowLine)
            var row: TableRow = TableRow()
            if (let Some(v) <- sourceSpan) {
                row.addSourceSpan(v)
            }

            // Body can not have more columns than head
            for (i in 0..headerColumns) {
                let cell = cells.get(i) ?? SourceLine.of("", None)
                var tableCell: TableCell = parseCell(cell, i, inlineParser)
                row.appendChild(tableCell)
            }

            if (body.isNone()) {
                // It's valid to have a table without body. In that case, don't add an empty TableBody node.
                let v = TableBody()
                body = v
                block.appendChild(v)
            }
            body?.appendChild(row)
            if (let Some(v) <- sourceSpan) {
                body?.addSourceSpan(v)
            }
        }
    }

    private func parseCell(cell: SourceLine, column: Int64, inlineParser: InlineParser): TableCell {
        var tableCell: TableCell = TableCell()
        if (let Some(sourceSpan) <- cell.getSourceSpan()) {
            tableCell.addSourceSpan(sourceSpan)
        }

        if (column < columns.size) {
            if (let Some(cellInfo) <- columns.get(column)) {
                tableCell.setAlignment(cellInfo.getAlignment())
                tableCell.setWidth(cellInfo.getWidth())
            }
        }

        let content = cell.getContent()
        let start = Characters.skipSpaceTab(content, 0, content.size)
        let end = Characters.skipSpaceTabBackwards(content, content.size - 1, start)
        inlineParser.parse(SourceLines.of(cell.substring(start, end + 1)), tableCell)

        return tableCell
    }

    static func split(line: SourceLine): ArrayList<SourceLine> {
        var row: String = line.getContent()
        var nonSpace = Characters.skipSpaceTab(row, 0, row.size)
        var cellStart = nonSpace
        var cellEnd = row.size
        if (row[nonSpace] == b'|') {
            // This row has leading/trailing pipes - skip the leading pipe
            cellStart = nonSpace + 1
            // Strip whitespace from the end but not the pipe or we could miss an empty ("||") cell
            var nonSpaceEnd = Characters.skipSpaceTabBackwards(row, row.size - 1, cellStart)
            cellEnd = nonSpaceEnd + 1
        }
        var cells: ArrayList<SourceLine> = ArrayList()
        var sb: ArrayList<Byte> = ArrayList()
        var i: Int64 = cellStart
        while (i < cellEnd) {
            let c = row[i]
            match (c) {
                case '\\' =>
                    if (i + 1 < row.size && row[i + 1] == b'|') {
                        // Pipe is special for table parsing. An escaped pipe doesn't result in a new cell, but is
                        // passed down to inline parsing as an unescaped pipe. Note that that applies even for the `\|`
                        // in an input like `\\|` - in other words, table parsing doesn't support escaping backslashes.
                        sb.add(b'|')
                        i++
                    } else {
                        // Preserve backslash before other characters or at end of line.
                        sb.add(b'\\')
                    }
                case '|' =>
                    let content = StringFromArrayListByte(sb)
                    cells.add(SourceLine.of(content, line.substring(cellStart, i).getSourceSpan()))
                    sb.clear()
                    cellStart = i + 1
                case _ => sb.add(c)
            }
            i++
        }
        if (sb.size > 0) {
            let content = StringFromArrayListByte(sb)
            cells.add(SourceLine.of(content, line.substring(cellStart, line.getContent().size).getSourceSpan()))
        }
        return cells
    }

    // Examples of valid separators:
    //
    // |-
    // -|
    // |-|
    // -|-
    // |-|-|
    // --- | ---
    static func parseSeparator(s: String): ?ArrayList<TableCellInfo> {
        var columns: ArrayList<TableCellInfo> = ArrayList<TableCellInfo>()
        var pipes: Int64 = 0
        var valid: Bool = false
        var i: Int64 = 0
        var width: Int64 = 0
        while (i < s.size) {
            let c = s[i]
            match (c) {
                case '|' =>
                    i++
                    pipes++
                    if (pipes > 1) {
                        // More than one adjacent pipe not allowed
                        return None
                    }
                    // Need at lest one pipe, even for a one column table
                    valid = true
                case '-' | ':' =>
                    if (pipes == 0 && !columns.isEmpty()) {
                        // Need a pipe after the first column (first column doesn't need to start with one)
                        return None
                    }
                    var left: Bool = false
                    var right: Bool = false
                    if (c == b':') {
                        left = true
                        i++
                        width++
                    }
                    var haveDash: Bool = false
                    while (i < s.size && s[i] == b'-') {
                        i++
                        width++
                        haveDash = true
                    }
                    if (!haveDash) {
                        // Need at least one dash
                        return None
                    }
                    if (i < s.size && s[i] == b':') {
                        right = true
                        i++
                        width++
                    }
                    columns.add(TableCellInfo(getAlignment(left, right), width))
                    width = 0
                    // Next, need another pipe
                    pipes = 0
                case ' ' | '\t' =>
                    // White space is allowed between pipes and columns
                    i++
                case _ =>
                    // Any other character is invalid
                    return None
            }
        }
        if (!valid) {
            return None
        }
        return columns
    }

    private static func getAlignment(left: Bool, right: Bool): ?Alignment {
        if (left && right) {
            return Alignment.CENTER
        } else if (left) {
            return Alignment.LEFT
        } else if (right) {
            return Alignment.RIGHT
        } else {
            return None
        }
    }
}

class TableBlockFactory <: AbstractBlockParserFactory {
    public func tryStart(state: ParserState, matchedBlockParser: MatchedBlockParser): ?BlockStart {
        let paragraphLines = matchedBlockParser.getParagraphLines().getLines()
        if (paragraphLines.size >= 1 && paragraphLines.last.getOrThrow().getContent().contains('|')) {
            let line = state.getLine()
            let separatorLine = line.substring(state.getIndex(), line.getContent().size)
            let columns = TableBlockParser.parseSeparator(separatorLine.getContent())
            if (let Some(columns) <- columns && !columns.isEmpty()) {
                let paragraph = paragraphLines.last.getOrThrow()
                let headerCells = TableBlockParser.split(paragraph)
                if (columns.size >= headerCells.size) {
                    return BlockStart
                        .of(TableBlockParser(columns, paragraph))
                        .atIndex(state.getIndex())
                        .replaceParagraphLines(1)
                }
            }
        }
        return BlockStart.none()
    }
}

import { JsNode, SourceSpan } from "./JsNode"

export class JsNodeImpl implements JsNode {
  constructor() {
  }

  /* node info */
  nodeType: string = ""
  toStr: string = ""
  /* node tree */
  parent: JsNodeImpl | undefined = undefined
  firstChild: JsNodeImpl | undefined = undefined
  lastChild: JsNodeImpl | undefined = undefined
  prev: JsNodeImpl | undefined = undefined
  next: JsNodeImpl | undefined = undefined
  /* node attr */
  literal: string | undefined = undefined
  destination: string | undefined = undefined
  title: string | undefined = undefined
  label: string | undefined = undefined
  delimiter: string | undefined = undefined
  fenceChar: string | undefined = undefined
  fenceLength: number | undefined = undefined
  fenceIndent: number | undefined = undefined
  level: number | undefined = undefined
  bulletMarker: string | undefined = undefined
  startNumber: number | undefined = undefined
  info: string | undefined = undefined
  tight: boolean | undefined = undefined
  header: boolean | undefined = undefined
  alignment: string | undefined = undefined
  width: number | undefined = undefined
  isdone: boolean | undefined = undefined
  latex: string | undefined = undefined
  isClosed: boolean | undefined = undefined
  noteid: string | undefined = undefined
  blockIndex: number | undefined = undefined
  headIndex: number | undefined = undefined
  props: Map<string, string> | undefined = undefined // 用于存放Js行内自定义解析插件所产生的数据
  sourceSpans: SourceSpanImpl[] = []
  tagName: string | undefined = undefined
  content: string | undefined = undefined

  getNodeType(): string {
    return this.nodeType
  }

  toString(): string {
    return this.toStr
  }

  setParent(parent: JsNodeImpl | undefined) {
    this.parent = parent
  }

  setPrevious(prev: JsNodeImpl | undefined) {
    this.prev = prev
  }

  setNext(next: JsNodeImpl | undefined) {
    this.next = next
  }

  setFirstChild(firstChild: JsNodeImpl | undefined) {
    this.firstChild = firstChild
  }

  setLastChild(lastChild: JsNodeImpl | undefined) {
    this.lastChild = lastChild
  }

  appendChild(child: JsNodeImpl) {
    child.unlink()
    child.setParent(this)
    if (this.lastChild) {
      this.lastChild.next = child
      child.prev = this.lastChild
      this.lastChild = child
    } else {
      this.firstChild = child
      this.lastChild = child
    }
  }

  prependChild(child: JsNodeImpl) {
    child.unlink()
    child.setParent(this)
    if (this.firstChild) {
      this.firstChild.prev = child
      child.next = this.firstChild
      this.firstChild = child
    } else {
      this.firstChild = child
      this.lastChild = child
    }
  }

  unlink() {
    if (this.prev) {
      this.prev.next = this.next
    } else if (this.parent) {
      this.parent.firstChild = this.next
    }
    if (this.next) {
      this.next.prev = this.prev
    } else if (this.parent) {
      this.parent.lastChild = this.prev
    }
    this.parent = undefined
    this.next = undefined
    this.prev = undefined
  }

  insertAfter(sibling: JsNodeImpl) {
    sibling.unlink()
    sibling.next = this.next
    if (sibling.next) {
      sibling.next.prev = sibling
    }
    sibling.prev = this
    this.next = sibling
    sibling.parent = this.parent
    if (!sibling.next) {
      sibling.parent!.lastChild = sibling
    }
  }

  insertBefore(sibling: JsNodeImpl) {
    sibling.unlink()
    sibling.prev = this.prev
    if (sibling.prev) {
      sibling.prev.next = sibling
    }
    sibling.next = this
    this.prev = sibling
    sibling.parent = this.parent
    if (!sibling.prev) {
      sibling.parent!.firstChild = sibling
    }
  }

  getNext(): JsNodeImpl | undefined {
    return this.next
  }

  getPrevious(): JsNodeImpl | undefined {
    return this.prev
  }

  getFirstChild(): JsNodeImpl | undefined {
    return this.firstChild
  }

  getLastChild(): JsNodeImpl | undefined {
    return this.lastChild
  }

  getParent(): JsNodeImpl | undefined {
    return this.parent
  }

  getLiteral(): string | undefined {
    return this.literal
  }

  getDestination(): string | undefined {
    return this.destination
  }

  getTitle(): string | undefined {
    return this.title
  }

  getLabel(): string | undefined {
    return this.label
  }

  getDelimiter(): string | undefined {
    return this.delimiter
  }

  getOpeningDelimiter(): string | undefined {
    return this.delimiter
  }

  getClosingDelimiter(): string | undefined {
    return this.delimiter
  }

  getFenceChar(): string | undefined {
    return this.fenceChar
  }

  getFenceLength(): number | undefined {
    return this.fenceLength
  }

  getFenceIndent(): number | undefined {
    return this.fenceIndent
  }

  getLevel(): number | undefined {
    return this.level
  }

  getBulletMarker(): string | undefined {
    return this.bulletMarker
  }

  getStartNumber(): number | undefined {
    return this.startNumber
  }

  getInfo(): string | undefined {
    return this.info
  }

  isTight(): boolean | undefined {
    return this.tight
  }

  isHeader(): boolean | undefined {
    return this.header
  }

  getAlignment(): string | undefined {
    return this.alignment
  }

  getWidth(): number | undefined {
    return this.width
  }

  isDone(): boolean | undefined {
    return this.isdone
  }

  getLatex(): string | undefined {
    return this.latex
  }

  getNoteid(): string | undefined {
    return this.noteid
  }

  getBlockIndex(): number | undefined {
    return this.blockIndex
  }

  getHeadIndex(): number | undefined {
    return this.headIndex
  }

  getProps(): Map<string, string> | undefined {
    return this.props
  }

  putProp(k: string, v: string): void {
    let m = this.props ?? new Map<string, string>()
    m.set(k, v)
    this.props = m
  }

  getSourceSpans(): SourceSpanImpl[] {
    return this.sourceSpans
  }

  addSourceSpans(...numbers: Array<number>): void {
    for (let i = 3; i < numbers.length; i += 4) {
      let line: number = numbers[i-3]
      let column: number = numbers[i-2]
      let index: number = numbers[i-1]
      let length: number = numbers[i]
      this.sourceSpans.push(new SourceSpanImpl(line, column, index, length))
    }
  }

  reset(): void {
    this.unlink()
    this.nodeType = ""
    this.toStr = ""
    this.parent = undefined
    this.firstChild = undefined
    this.lastChild = undefined
    this.prev = undefined
    this.next = undefined
    this.literal = undefined
    this.destination = undefined
    this.title = undefined
    this.label = undefined
    this.delimiter = undefined
    this.fenceChar = undefined
    this.fenceLength = undefined
    this.fenceIndent = undefined
    this.level = undefined
    this.bulletMarker = undefined
    this.startNumber = undefined
    this.info = undefined
    this.tight = undefined
    this.header = undefined
    this.alignment = undefined
    this.props = undefined
    this.isdone = undefined
    this.latex = undefined
    this.isClosed = undefined
    this.noteid = undefined
    this.blockIndex = undefined
    this.headIndex = undefined
    this.sourceSpans = []
  }
}

export class SourceSpanImpl implements SourceSpan {
  line: number
  column: number
  index: number
  length: number

  constructor(line: number, column: number, index: number, length: number) {
    this.line = line
    this.column = column
    this.index = index
    this.length = length
  }

  getLineIndex(): number {
    return this.line
  }

  getColumnIndex(): number {
    return this.column
  }

  getInputIndex(): number {
    return this.index
  }

  getLength(): number {
    return this.length
  }
}
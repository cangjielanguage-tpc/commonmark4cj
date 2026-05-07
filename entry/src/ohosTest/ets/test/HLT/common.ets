import {
  JsNode as Node,
  JsNodeImpl,
  parseIntoJsNode,
  ParsedInline,
  Scanner,
  InlineContentParser,
  Options,
  JsNode,
  utf16Index2utf8Index,
  utf8Index2utf16Index,
  JsNodeSendableImpl
} from "@cangjie-tpc/commonmark_hybrid"
import { util } from "@kit.ArkTS"
import { hilog } from "@kit.PerformanceAnalysisKit"

let textDecoder = new util.TextDecoder()
let textEncoder = new util.TextEncoder()

export function getOptions(includeSourceSpans: number, cmInlineTags: string[], customParsers: InlineContentParser[]): Options {
  return {
    jsNodeFactory: () => new JsNodeSendableImpl(),
    includeSourceSpans: includeSourceSpans,
    cmInlineTags: cmInlineTags,
    customParsers: customParsers
  }
}
/* 自定义行内解析 */
export class MyParser implements InlineContentParser {
  getTriggerCharacters(): Array<string> {
    return ['a']
  }

  tryParse(scanner: Scanner): undefined | ParsedInline {
    // hilog.error(0, 'mod', 'MyParser.tryParse')
    let str = ''
    let line :string= scanner.lines[scanner.lineIndex]
    let i :number= utf8Index2utf16Index(line, scanner.index) + 1
    for (; i < line.length; i++) {
      if (line[i] == 'a') {
        i++
        break
      }
      str += line[i]
    }
    let props = new Map<string, string>()
    props.set('str', str)
    return {
      node: {
        nodeType: 'anode',
        props: props
      },
      index: utf16Index2utf8Index(line, i),
      lineIndex: scanner.lineIndex
    }
  }
}

//
const TAG = 'InsertImageParser'
export class InsertImageParser implements InlineContentParser {
  static readonly PARAM_KEY = "key";

  private static readonly TAG_START = '<INSERT_IMAGE'
  private static readonly TAG_END = '>'

  getTriggerCharacters(): string[] {
    return ["<"];
  }

  tryParse(scanner: Scanner): ParsedInline | undefined {
    let line:string = scanner.lines[scanner.lineIndex]
    let start = utf8Index2utf16Index(line, scanner.index)
    let str = line.substring(start)
    if (str.startsWith(InsertImageParser.TAG_START)) {
      const endIndex = str.indexOf(InsertImageParser.TAG_END)
      if (endIndex === -1) {
        return undefined
      }
      str = str.substring(0 ,endIndex + 1)
      const firstQuote = str.indexOf('"')
      const lastQuote = str.lastIndexOf('"')
      const id = str.substring(firstQuote + 1, lastQuote)
      hilog.debug(0,TAG, `str = ${str}, id = ${id}`)
      const map = new Map<string, string>()
      map.set(InsertImageParser.PARAM_KEY, id)

      return {
        node: {
          nodeType: "NodeType.InsertImage",
          props: map
        } ,
        index: utf16Index2utf8Index(line, start + endIndex + 1),
        lineIndex: scanner.lineIndex
      }
    } else {
      return undefined
    }

  }
}


export interface JsNodePool {
  getJsNode(): JsNode
}

export class JsNodePoolImpl implements JsNodePool {
  generator: Array<JsNode> = []

  constructor(nodeTree: JsNode) {
    traverseTree(nodeTree, this.generator)
  }
  put(nodeTree: JsNode) {
    traverseTree(nodeTree, this.generator)
  }

  /**
   * 将节点树中的Node依次取出,若无则返回新Node
   * @returns
   */
  getJsNode(): JsNode {
    return this.generator.pop() ?? new JsNodeSendableImpl()
  }
}

/**
 * 取出所有可用节点
 * @param node
 * @param arr
 */
export function traverseTree(node: JsNode | undefined, arr: Array<JsNode>) {
  if (node) {
    let child:JsNode|undefined = node.getFirstChild()
    let next:JsNode|undefined = node.getNext()
    arr.push(node)
    traverseTree(child, arr)
    traverseTree(next, arr)
  }
}


export function printNode(node: JsNode): string {
  node = node as JsNode
  if (node) {
    let current: JsNode | undefined = node
    while (current?.getParent()) {
      current = (current as JsNode).getParent()
    }
    let builder = Array<string>()
    printNodeDep(current, 0, builder)
    return builder.join('')
  }
  return ''
}

function printNodeDep(node: JsNode | undefined, dep: number, builder: Array<string>) {
  node = node as JsNode
  if (node) {
    let str = node.toString()
    let sss = node.getSourceSpans().map((v) => JSON.stringify(v)).join(',')
    let sssize = node.getSourceSpans().length
    builder.push(`${' '.repeat(dep)}${str}${sssize}:[${sss}]\n`)
    let child = node.getFirstChild()
    printNodeDep(child, dep + 4, builder)
    let next = node.getNext()
    printNodeDep(next, dep, builder)
  }
}





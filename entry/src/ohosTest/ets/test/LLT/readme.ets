import {
  JsNode as Node,
  JsNodeImpl,
  parseIntoJsNode,
  ParsedInline,
  Scanner,
  InlineContentParser,
  Options,
  printNode,
  utf8Index2utf16Index,
  utf16Index2utf8Index
} from "@cangjie-tpc/commonmark_hybrid"
import { hilog } from "@kit.PerformanceAnalysisKit";

/* 自定义行内解析 */
class MyParser implements InlineContentParser {
  getTriggerCharacters(): Array<string> {
    return ['a']
  }

  tryParse(scanner: Scanner): undefined | ParsedInline {
    // hilog.error(0, 'mod', 'MyParser.tryParse')
    let str = ''
    let line = scanner.lines[scanner.lineIndex]
    let i = utf8Index2utf16Index(line, scanner.index) + 1
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

export default async function parse(): Promise<void> {
  let markdownString = "😀我0123a56a89"
  let myParser: InlineContentParser = new MyParser()
  let opt: Options = {
    includeSourceSpans: 0,
    customParsers: [myParser],
    jsNodeFactory: () => new JsNodeImpl(),
    cmInlineTags: []
  }
  let node = await parseIntoJsNode(markdownString, opt)
  let nodeTreeStr = printNode(node)
  hilog.info(0, '', nodeTreeStr)
}
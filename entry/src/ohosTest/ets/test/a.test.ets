import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import {
  JsNode,
  ParsedInline,
  InlineContentParser,
  Scanner,
  Options,
  parseIntoJsNode,
  cjLib,
  HybridParser,
  printNode,
  utf16Index2utf8Index,
  utf8Index2utf16Index,
  JsNodeImpl,
  JsNodeSendableImpl,
} from '@cangjie-tpc/commonmark_hybrid';
import { splitTextToArr } from '@cangjie-tpc/commonmark_hybrid';

function opt(includeSourceSpans: number, cmInlineTags: string[]): Options {
  return {
    jsNodeFactory: () => new JsNodeImpl(),
    includeSourceSpans: includeSourceSpans,
    cmInlineTags: cmInlineTags,
    customParsers: undefined
  }
}

export default function aTest() {
  describe('aTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })
    it('htmltag1', 0, async () => {
      let md = `asd<cmtag.inline.asd k1 k2=v2 k3='v3' k4="v4"/>markdown文本1</cmtag.inline.asd>markdown文本2`
      let doc = await parseIntoJsNode(md, opt(0, ['cmtag.inline.asd']))
      let str = printNode(doc)
      console.error(str)
      let p: JsNode = doc.getFirstChild()!
      let node0: JsNode = p.getFirstChild()!
      let node1: JsNode = node0.getNext()!
      let node2: JsNode = node1.getNext()!
      expect(node1.getNodeType()).assertEqual("CustomTag")
      expect(node2.getNodeType()).assertEqual("Text")
      expect(node2.getNext()).assertEqual(undefined)
      let props = node1.getProps()!
      expect(props.size).assertEqual(4)
      expect(props.get('k1')).assertEqual('')
      expect(props.get('k2')).assertEqual('v2')
      expect(props.get('k3')).assertEqual('v3')
      expect(props.get('k4')).assertEqual('v4')
    })
    it('htmltag2', 0, async () => {
      let md = `<cmtag.inline.asd k1 k2=v2 k3='v3' k4="v4">markdown文本1</cmtag.inline.asd>markdown文本2`
      let doc = await parseIntoJsNode(md, opt(0, ['cmtag.inline.asd']))
      let str = printNode(doc)
      console.error(str)
      let p: JsNode = doc.getFirstChild()!
      let node0: JsNode = p.getFirstChild()!
      let node1: JsNode = node0.getNext()!
      expect(node0.getNodeType()).assertEqual("CustomTag")
      expect(node1.getNodeType()).assertEqual("Text")
      expect(node1.getNext()).assertEqual(undefined)
      let props = node0.getProps()!
      expect(props.size).assertEqual(4)
      expect(props.get('k1')).assertEqual('')
      expect(props.get('k2')).assertEqual('v2')
      expect(props.get('k3')).assertEqual('v3')
      expect(props.get('k4')).assertEqual('v4')
    })
    it('htmltag3', 0, async () => {
      let md = `<INSERT_IMAGE/><^moonLoading^/><KIMI_REF/>`
      let options: Options = {
        jsNodeFactory: () => new JsNodeSendableImpl(),
        includeSourceSpans: 0,
        cmInlineTags: ['INSERT_IMAGE', '^moonLoading^', 'KIMI_REF'],
        customParsers: undefined
      }
      let parser = new cjLib.HybridParser(options)
      let doc = await parser.parse(md)
      let str = printNode(doc)
      console.error(str)
      let p: JsNode = doc.getFirstChild()!
      let node0: JsNode = p.getFirstChild()!
      let node1: JsNode = node0.getNext()!
      let node2: JsNode = node1.getNext()!
      expect(node0.getNodeType()).assertEqual("CustomTag")
      expect(node1.getNodeType()).assertEqual("CustomTag")
      expect(node2.getNodeType()).assertEqual("CustomTag")
      expect(node0['tagName']).assertEqual("INSERT_IMAGE")
      expect(node1['tagName']).assertEqual("^moonLoading^")
      expect(node2['tagName']).assertEqual("KIMI_REF")
    })
    it('splitTextToArr', 0, async () =>{
      let message = splitTextToArr('\\p{Han}', '0一1二2三3四4')
      console.error(message.toString())
      expect(message.toString()).assertEqual('一,二,三,四')
    })
    it('splitTextToArr1', 0, async () =>{
      // let message = splitTextToArr('[\\p{Han}]|\\p{L}+\\p{N}*|\\p{N}+|[^\\p{L}\\p{N}]', 'AI在彩票领域能做什么？')
      let message = splitTextToArr('\\p{Han}|\\p{L}\\p{N}*|\\p{N}+|[^\\p{L}\\p{N}]', 'AI在彩票领域能做什么？')
      console.error(message.toString())
      expect(message.toString()).assertEqual('A,I,在,彩,票,领,域,能,做,什,么,？')
    })
    it('footnote1', 0, async () =>{
      let md = `- [^2^]: [异环NTE：免费开放世界RPG封闭测试](https://cg.163.com/static/content/69895252326700b55b0d178b)
- [^1^]: [百度百科 - 异环](https://baike.baidu.com/item/异环)`
      let options: Options = {
        jsNodeFactory: () => new JsNodeSendableImpl(),
        includeSourceSpans: 0,
        cmInlineTags: ['INSERT_IMAGE', '^moonLoading^', 'KIMI_REF'],
        customParsers: undefined
      }
      let parser = new cjLib.HybridParser(options)
      let doc = await parser.parse(md)
      let str = printNode(doc)
      console.error(str)
      let p: JsNode = doc.getFirstChild()!
      let node0: JsNode = p.getFirstChild()!.getFirstChild()!
      let node1: JsNode = p.getLastChild()!.getFirstChild()!
      expect(node0.getNodeType()).assertEqual("FootnoteBlock")
      expect(node0.getFirstChild()!.getLastChild()!.getDestination()).assertEqual("https://cg.163.com/static/content/69895252326700b55b0d178b")
      expect(node1.getNodeType()).assertEqual("FootnoteBlock")
      expect(node1.getFirstChild()!.getLastChild()!.getDestination()).assertEqual("https://baike.baidu.com/item/异环")
    })
    it('footnote2', 0, async () =>{
      let md = `## 参考资料

- [^1^]: [百度百科 - 异环](https://baike.baidu.com/item/异环/64656910)
- [^2^]: [异环NTE：免费开放世界RPG封闭测试](https://cg.163.com/static/content/69895252326700b55b0d178b)
- [^3^]: [异环WIKI - 哔哩哔哩](https://wiki.biligame.com/yh/首页)
- [^4^]: [完美世界收获"二连板" 自研游戏《异环》测试表现亮眼](https://www.stcn.com/article/detail/3635940.html)
- [^5^]: [德国科隆，进入"中国时间"](http://mp.weixin.qq.com/s?__biz=MjM5MjMwMjcyMA==)`
      let options: Options = {
        jsNodeFactory: () => new JsNodeSendableImpl(),
        includeSourceSpans: 0,
        cmInlineTags: ['INSERT_IMAGE', '^moonLoading^', 'KIMI_REF'],
        customParsers: undefined
      }
      let parser = new cjLib.HybridParser(options)
      let doc = await parser.parse(md)
      let str = printNode(doc)
      console.error(str)
    })
  })
}

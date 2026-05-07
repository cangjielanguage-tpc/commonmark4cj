import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import {
  InlineContentParser,
  ParsedInline,
  utf16Index2utf8Index,
  Scanner,
  utf8Index2utf16Index,
  printNode,
  JsNode
} from '@cangjie-tpc/commonmark_hybrid';
import { parseIntoJsNode } from '../../../../main/ets/pages/md'
import readme from './readme'

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('assertContain', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let a = 'abc';
      let b = 'b';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertContain(b);
      expect(a).assertEqual(a);
    })
    it('readme', 0, async () => {await readme()})
    it('test_parse0_001', 0, async () => {
      let md = '我0123a56a89'
      let testNode:JsNode = await parseIntoJsNode(md, 0)
      expect(testNode.getNodeType()).assertEqual("Document")
      expect(testNode.getPrevious()).assertEqual(undefined)
      expect(testNode.getFirstChild()?.getNodeType()).assertEqual("Paragraph")
      expect(testNode.getLastChild()?.getNodeType()).assertEqual("Paragraph")
      expect(testNode.getParent()?.getNodeType()).assertEqual(undefined)
      expect(testNode.getNext()?.getNodeType()).assertEqual(undefined)
      expect(testNode.getLiteral()).assertEqual(undefined)
      expect(testNode.getDestination()).assertEqual(undefined)
      expect(testNode.getTitle()).assertEqual(undefined)
      expect(testNode.getLabel()).assertEqual(undefined)
      expect(testNode.getOpeningDelimiter()).assertEqual(undefined)
      expect(testNode.getClosingDelimiter()).assertEqual(undefined)
      expect(testNode.getFenceChar()).assertEqual(undefined)
      expect(testNode.getFenceLength()).assertEqual(undefined)
      expect(testNode.getFenceIndent()).assertEqual(undefined)
      expect(testNode.getInfo()).assertEqual(undefined)
      expect(testNode.isTight()).assertEqual(undefined)
      expect(testNode.getBulletMarker()).assertEqual(undefined)
      expect(testNode.getStartNumber()).assertEqual(undefined)
      expect(testNode.getDelimiter()).assertEqual(undefined)
    })
    it('test_parse0_002', 0, async () => {
      let md = '我0123a56a89'
      let node :JsNode= await parseIntoJsNode(md, 0)
      let testNode = node.getFirstChild()
      if (testNode == undefined) {
        expect().assertFail()
      } else {
        expect(testNode.getNodeType()).assertEqual("Paragraph")
        expect(testNode.getPrevious()).assertEqual(undefined)
        expect(testNode.getFirstChild()?.getNodeType()).assertEqual("Text")
        expect(testNode.getLastChild()?.getNodeType()).assertEqual("Text")
        expect(testNode.getParent()?.getNodeType()).assertEqual("Document")
        expect(testNode.getNext()?.getNodeType()).assertEqual(undefined)
        expect(testNode.getLiteral()).assertEqual(undefined)
        expect(testNode.getDestination()).assertEqual(undefined)
        expect(testNode.getTitle()).assertEqual(undefined)
        expect(testNode.getLabel()).assertEqual(undefined)
        expect(testNode.getOpeningDelimiter()).assertEqual(undefined)
        expect(testNode.getClosingDelimiter()).assertEqual(undefined)
        expect(testNode.getFenceChar()).assertEqual(undefined)
        expect(testNode.getFenceLength()).assertEqual(undefined)
        expect(testNode.getFenceIndent()).assertEqual(undefined)
        expect(testNode.getInfo()).assertEqual(undefined)
        expect(testNode.isTight()).assertEqual(undefined)
        expect(testNode.getBulletMarker()).assertEqual(undefined)
        expect(testNode.getStartNumber()).assertEqual(undefined)
        expect(testNode.getDelimiter()).assertEqual(undefined)
      }
    })
    it('test_parse0_003', 0, async () => {
      let md = '我0123a56a89'
      let node01 :JsNode= await parseIntoJsNode(md, 0)
      let node02 :JsNode|undefined= node01.getFirstChild()
      if (node02 == undefined || node02.getFirstChild() == undefined) {
        expect().assertFail()
      } else {
        let testNode = node02.getFirstChild()
        if (testNode == undefined) {
          expect().assertFail()
        } else {
          expect(testNode.getNodeType()).assertEqual("Text")
          expect(testNode.getPrevious()).assertEqual(undefined)
          expect(testNode.getFirstChild()?.getNodeType()).assertEqual(undefined)
          expect(testNode.getLastChild()?.getNodeType()).assertEqual(undefined)
          expect(testNode.getParent()?.getNodeType()).assertEqual("Paragraph")
          expect(testNode.getNext()?.getNodeType()).assertEqual(undefined)
          expect(testNode.getLiteral()).assertEqual("我0123a56a89")
          expect(testNode.getDestination()).assertEqual(undefined)
          expect(testNode.getTitle()).assertEqual(undefined)
          expect(testNode.getLabel()).assertEqual(undefined)
          expect(testNode.getOpeningDelimiter()).assertEqual(undefined)
          expect(testNode.getClosingDelimiter()).assertEqual(undefined)
          expect(testNode.getFenceChar()).assertEqual(undefined)
          expect(testNode.getFenceLength()).assertEqual(undefined)
          expect(testNode.getFenceIndent()).assertEqual(undefined)
          expect(testNode.getInfo()).assertEqual(undefined)
          expect(testNode.isTight()).assertEqual(undefined)
          expect(testNode.getBulletMarker()).assertEqual(undefined)
          expect(testNode.getStartNumber()).assertEqual(undefined)
          expect(testNode.getDelimiter()).assertEqual(undefined)
        }
      }
    })
    it('test_parse1_emptyParser_001', 0, async () => {
      let md = '我0123a56a89'
      let myPaser = new MyParser()
      let testNode : JsNode= await parseIntoJsNode(md, 0, myPaser)
      expect(testNode.getNodeType()).assertEqual("Document")
      expect(testNode.getPrevious()).assertEqual(undefined)
      expect(testNode.getFirstChild()?.getNodeType()).assertEqual("Paragraph")
      expect(testNode.getLastChild()?.getNodeType()).assertEqual("Paragraph")
      expect(testNode.getParent()?.getNodeType()).assertEqual(undefined)
      expect(testNode.getNext()?.getNodeType()).assertEqual(undefined)
      expect(testNode.getLiteral()).assertEqual(undefined)
      expect(testNode.getDestination()).assertEqual(undefined)
      expect(testNode.getTitle()).assertEqual(undefined)
      expect(testNode.getLabel()).assertEqual(undefined)
      expect(testNode.getOpeningDelimiter()).assertEqual(undefined)
      expect(testNode.getClosingDelimiter()).assertEqual(undefined)
      expect(testNode.getFenceChar()).assertEqual(undefined)
      expect(testNode.getFenceLength()).assertEqual(undefined)
      expect(testNode.getFenceIndent()).assertEqual(undefined)
      expect(testNode.getInfo()).assertEqual(undefined)
      expect(testNode.isTight()).assertEqual(undefined)
      expect(testNode.getBulletMarker()).assertEqual(undefined)
      expect(testNode.getStartNumber()).assertEqual(undefined)
      expect(testNode.getDelimiter()).assertEqual(undefined)
    })
    it('test_parse1_emptyParser_002', 0, async () => {
      let md = '我0123a56a89'
      let myPaser = new MyParser()
      let node :JsNode= await parseIntoJsNode(md, 0, myPaser)
      let testNode = node.getFirstChild()
      if (testNode == undefined) {
        expect().assertFail()
      } else {
        expect(testNode.getNodeType()).assertEqual("Paragraph")
        expect(testNode.getPrevious()).assertEqual(undefined)
        expect(testNode.getFirstChild()?.getNodeType()).assertEqual("Text")
        expect(testNode.getLastChild()?.getNodeType()).assertEqual("Text")
        expect(testNode.getParent()?.getNodeType()).assertEqual("Document")
        expect(testNode.getNext()?.getNodeType()).assertEqual(undefined)
        expect(testNode.getLiteral()).assertEqual(undefined)
        expect(testNode.getDestination()).assertEqual(undefined)
        expect(testNode.getTitle()).assertEqual(undefined)
        expect(testNode.getLabel()).assertEqual(undefined)
        expect(testNode.getOpeningDelimiter()).assertEqual(undefined)
        expect(testNode.getClosingDelimiter()).assertEqual(undefined)
        expect(testNode.getFenceChar()).assertEqual(undefined)
        expect(testNode.getFenceLength()).assertEqual(undefined)
        expect(testNode.getFenceIndent()).assertEqual(undefined)
        expect(testNode.getInfo()).assertEqual(undefined)
        expect(testNode.isTight()).assertEqual(undefined)
        expect(testNode.getBulletMarker()).assertEqual(undefined)
        expect(testNode.getStartNumber()).assertEqual(undefined)
        expect(testNode.getDelimiter()).assertEqual(undefined)
      }
    })
    it('test_parse1_emptyParser_003', 0, async () => {
      let md = '我0123a56a89'
      let myPaser = new MyParser()
      let node01 :JsNode= await parseIntoJsNode(md, 0, myPaser)
      let node02 = node01.getFirstChild()
      if (node02 == undefined || node02.getFirstChild() == undefined) {
        expect().assertFail()
      } else {
        let testNode = node02.getFirstChild()
        if (testNode == undefined) {
          expect().assertFail()
        } else {
          expect(testNode.getNodeType()).assertEqual("Text")
          expect(testNode.getPrevious()).assertEqual(undefined)
          expect(testNode.getFirstChild()?.getNodeType()).assertEqual(undefined)
          expect(testNode.getLastChild()?.getNodeType()).assertEqual(undefined)
          expect(testNode.getParent()?.getNodeType()).assertEqual("Paragraph")
          expect(testNode.getNext()?.getNodeType()).assertEqual("anode")
          expect(testNode.getLiteral()).assertEqual("我0123")
          expect(testNode.getDestination()).assertEqual(undefined)
          expect(testNode.getTitle()).assertEqual(undefined)
          expect(testNode.getLabel()).assertEqual(undefined)
          expect(testNode.getOpeningDelimiter()).assertEqual(undefined)
          expect(testNode.getClosingDelimiter()).assertEqual(undefined)
          expect(testNode.getFenceChar()).assertEqual(undefined)
          expect(testNode.getFenceLength()).assertEqual(undefined)
          expect(testNode.getFenceIndent()).assertEqual(undefined)
          expect(testNode.getInfo()).assertEqual(undefined)
          expect(testNode.isTight()).assertEqual(undefined)
          expect(testNode.getBulletMarker()).assertEqual(undefined)
          expect(testNode.getStartNumber()).assertEqual(undefined)
          expect(testNode.getDelimiter()).assertEqual(undefined)
        }
      }
    })
    it('test_parse1_notEmptyParser_001', 0, async () => {
      let md = '<a>fsfsfsddfdsfabd</a>'
      let myPaser = new MyParser()
      let testNode:JsNode= await parseIntoJsNode(md, 0, myPaser)
      expect(testNode.getNodeType()).assertEqual("Document")
      expect(testNode.getPrevious()).assertEqual(undefined)
      expect(testNode.getFirstChild()?.getNodeType()).assertEqual("Paragraph")
      expect(testNode.getLastChild()?.getNodeType()).assertEqual("Paragraph")
      expect(testNode.getParent()?.getNodeType()).assertEqual(undefined)
      expect(testNode.getNext()?.getNodeType()).assertEqual(undefined)
      expect(testNode.getLiteral()).assertEqual(undefined)
      expect(testNode.getDestination()).assertEqual(undefined)
      expect(testNode.getTitle()).assertEqual(undefined)
      expect(testNode.getLabel()).assertEqual(undefined)
      expect(testNode.getOpeningDelimiter()).assertEqual(undefined)
      expect(testNode.getClosingDelimiter()).assertEqual(undefined)
      expect(testNode.getFenceChar()).assertEqual(undefined)
      expect(testNode.getFenceLength()).assertEqual(undefined)
      expect(testNode.getFenceIndent()).assertEqual(undefined)
      expect(testNode.getInfo()).assertEqual(undefined)
      expect(testNode.isTight()).assertEqual(undefined)
      expect(testNode.getBulletMarker()).assertEqual(undefined)
      expect(testNode.getStartNumber()).assertEqual(undefined)
      expect(testNode.getDelimiter()).assertEqual(undefined)
    })
    it('test_parse1_notEmptyParser_002', 0, async () => {
      let md = '<a>fsfsfsddfdsfbd</a>'
      let myPaser = new MyParser()
      let node:JsNode= await parseIntoJsNode(md, 0, myPaser)
      console.error(printNode(node))
      let testNode = node.getFirstChild()
      if (testNode == undefined) {
        expect().assertFail()
      } else {
        expect(testNode.getNodeType()).assertEqual("Paragraph")
        expect(testNode.getPrevious()).assertEqual(undefined)
        expect(testNode.getFirstChild()?.getNodeType()).assertEqual("HtmlInline")
        expect(testNode.getLastChild()?.getNodeType()).assertEqual("HtmlInline")
        expect(testNode.getParent()?.getNodeType()).assertEqual("Document")
        expect(testNode.getNext()?.getNodeType()).assertEqual(undefined)
        expect(testNode.getLiteral()).assertEqual(undefined)
        expect(testNode.getDestination()).assertEqual(undefined)
        expect(testNode.getTitle()).assertEqual(undefined)
        expect(testNode.getLabel()).assertEqual(undefined)
        expect(testNode.getOpeningDelimiter()).assertEqual(undefined)
        expect(testNode.getClosingDelimiter()).assertEqual(undefined)
        expect(testNode.getFenceChar()).assertEqual(undefined)
        expect(testNode.getFenceLength()).assertEqual(undefined)
        expect(testNode.getFenceIndent()).assertEqual(undefined)
        expect(testNode.getInfo()).assertEqual(undefined)
        expect(testNode.isTight()).assertEqual(undefined)
        expect(testNode.getBulletMarker()).assertEqual(undefined)
        expect(testNode.getStartNumber()).assertEqual(undefined)
        expect(testNode.getDelimiter()).assertEqual(undefined)
      }
    })
    it('test_parse1_notEmptyParser_003', 0, async () => {
      let md = '<a>fsfsfsddfdsfabd</a>'
      let myPaser = new MyParser()
      let node01:JsNode = await parseIntoJsNode(md, 0, myPaser)
      let node02 = node01.getFirstChild()
      if (node02 == undefined || node02.getFirstChild() == undefined) {
        expect().assertFail()
      } else {
        let testNode = node02.getFirstChild()
        if (testNode == undefined) {
          expect().assertFail()
        } else {
          expect(testNode.getNodeType()).assertEqual("HtmlInline")
          expect(testNode.getPrevious()).assertEqual(undefined)
          expect(testNode.getFirstChild()?.getNodeType()).assertEqual(undefined)
          expect(testNode.getLastChild()?.getNodeType()).assertEqual(undefined)
          expect(testNode.getParent()?.getNodeType()).assertEqual("Paragraph")
          expect(testNode.getNext()?.getNodeType()).assertEqual("Text")
          expect(testNode.getLiteral()).assertEqual("<a>")
          expect(testNode.getDestination()).assertEqual(undefined)
          expect(testNode.getTitle()).assertEqual(undefined)
          expect(testNode.getLabel()).assertEqual(undefined)
          expect(testNode.getOpeningDelimiter()).assertEqual(undefined)
          expect(testNode.getClosingDelimiter()).assertEqual(undefined)
          expect(testNode.getFenceChar()).assertEqual(undefined)
          expect(testNode.getFenceLength()).assertEqual(undefined)
          expect(testNode.getFenceIndent()).assertEqual(undefined)
          expect(testNode.getInfo()).assertEqual(undefined)
          expect(testNode.isTight()).assertEqual(undefined)
          expect(testNode.getBulletMarker()).assertEqual(undefined)
          expect(testNode.getStartNumber()).assertEqual(undefined)
          expect(testNode.getDelimiter()).assertEqual(undefined)
        }
      }
    })
    it('test_parse1_notEmptyParser_004', 0, async () => {
      let md = '<a>fsfsfsddfdsfabd</a>'
      let node01:JsNode = await parseIntoJsNode(md, 0)
      let node02 = node01.getFirstChild()
      if (node02 == undefined || node02.getFirstChild() == undefined) {
        expect().assertFail()
      } else {
        let testNode = node02.getFirstChild()
        if (testNode == undefined) {
          expect().assertFail()
        } else {
          expect(testNode.getNodeType()).assertEqual("HtmlInline")
          expect(testNode.getPrevious()).assertEqual(undefined)
          expect(testNode.getFirstChild()?.getNodeType()).assertEqual(undefined)
          expect(testNode.getLastChild()?.getNodeType()).assertEqual(undefined)
          expect(testNode.getParent()?.getNodeType()).assertEqual("Paragraph")
          expect(testNode.getNext()?.getNodeType()).assertEqual("Text")
          expect(testNode.getLiteral()).assertEqual("<a>")
          expect(testNode.getDestination()).assertEqual(undefined)
          expect(testNode.getTitle()).assertEqual(undefined)
          expect(testNode.getLabel()).assertEqual(undefined)
          expect(testNode.getOpeningDelimiter()).assertEqual(undefined)
          expect(testNode.getClosingDelimiter()).assertEqual(undefined)
          expect(testNode.getFenceChar()).assertEqual(undefined)
          expect(testNode.getFenceLength()).assertEqual(undefined)
          expect(testNode.getFenceIndent()).assertEqual(undefined)
          expect(testNode.getInfo()).assertEqual(undefined)
          expect(testNode.isTight()).assertEqual(undefined)
          expect(testNode.getBulletMarker()).assertEqual(undefined)
          expect(testNode.getStartNumber()).assertEqual(undefined)
          expect(testNode.getDelimiter()).assertEqual(undefined)
        }
      }
    })
    it('test_parse1_notEmptyParser_005', 0, async () => {
      let md = '<INSERT_IMAGE id="123456" />'
      let myPaser = new InsertImageParser()
      let node01 :JsNode= await parseIntoJsNode(md, 0, myPaser)
      let node02 = node01.getFirstChild()
      if (node02 == undefined || node02.getFirstChild() == undefined) {
        expect().assertFail()
      } else {
        let testNode = node02.getFirstChild()
        if (testNode == undefined) {
          expect().assertFail()
        } else {
          expect(testNode.getNodeType()).assertEqual("InsertImage")
          expect(testNode.getPrevious()).assertEqual(undefined)
          expect(testNode.getFirstChild()?.getNodeType()).assertEqual(undefined)
          expect(testNode.getLastChild()?.getNodeType()).assertEqual(undefined)
          expect(testNode.getParent()?.getNodeType()).assertEqual("Paragraph")
          expect(testNode.getNext()?.getNodeType()).assertEqual(undefined)
          expect(testNode.getLiteral()).assertEqual(undefined)
          expect(testNode.getDestination()).assertEqual(undefined)
          expect(testNode.getTitle()).assertEqual(undefined)
          expect(testNode.getLabel()).assertEqual(undefined)
          expect(testNode.getOpeningDelimiter()).assertEqual(undefined)
          expect(testNode.getClosingDelimiter()).assertEqual(undefined)
          expect(testNode.getFenceChar()).assertEqual(undefined)
          expect(testNode.getFenceLength()).assertEqual(undefined)
          expect(testNode.getFenceIndent()).assertEqual(undefined)
          expect(testNode.getInfo()).assertEqual(undefined)
          expect(testNode.isTight()).assertEqual(undefined)
          expect(testNode.getBulletMarker()).assertEqual(undefined)
          expect(testNode.getStartNumber()).assertEqual(undefined)
          expect(testNode.getDelimiter()).assertEqual(undefined)
        }
      }
    })
    it('test_parse1_notEmptyParser_006', 0, async () => {
      let md = '<INSERT_IMAGE id="123456" />'
      let node01:JsNode = await parseIntoJsNode(md, 0)
      let node02 = node01.getFirstChild()
      if (node02 == undefined || node02.getFirstChild() == undefined) {
        expect().assertFail()
      } else {
        let testNode = node02.getFirstChild()
        if (testNode == undefined) {
          expect().assertFail()
        } else {
          expect(testNode.getNodeType()).assertEqual("InsertImage")
          expect(testNode.getPrevious()).assertEqual(undefined)
          expect(testNode.getFirstChild()?.getNodeType()).assertEqual(undefined)
          expect(testNode.getLastChild()?.getNodeType()).assertEqual(undefined)
          expect(testNode.getParent()?.getNodeType()).assertEqual("Paragraph")
          expect(testNode.getNext()?.getNodeType()).assertEqual(undefined)
          expect(testNode.getLiteral()).assertEqual(undefined)
          expect(testNode.getDestination()).assertEqual(undefined)
          expect(testNode.getTitle()).assertEqual(undefined)
          expect(testNode.getLabel()).assertEqual(undefined)
          expect(testNode.getOpeningDelimiter()).assertEqual(undefined)
          expect(testNode.getClosingDelimiter()).assertEqual(undefined)
          expect(testNode.getFenceChar()).assertEqual(undefined)
          expect(testNode.getFenceLength()).assertEqual(undefined)
          expect(testNode.getFenceIndent()).assertEqual(undefined)
          expect(testNode.getInfo()).assertEqual(undefined)
          expect(testNode.isTight()).assertEqual(undefined)
          expect(testNode.getBulletMarker()).assertEqual(undefined)
          expect(testNode.getStartNumber()).assertEqual(undefined)
          expect(testNode.getDelimiter()).assertEqual(undefined)
        }
      }
    })
  })
}


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

const TAG = 'InsertImageParser'

export class InsertImageParser implements InlineContentParser {
  static readonly PARAM_KEY = "key";
  private static readonly TAG_START = '<INSERT_IMAGE'
  private static readonly TAG_END = '>'

  getTriggerCharacters(): string[] {
    return ["<"];
  }

  tryParse(scanner: Scanner): ParsedInline | undefined {
    let line = scanner.lines[scanner.lineIndex]
    let start = utf8Index2utf16Index(line, scanner.index)
    let str = line.substring(start)
    if (str.startsWith(InsertImageParser.TAG_START)) {
      const endIndex = str.indexOf(InsertImageParser.TAG_END)
      if (endIndex === -1) {
        return undefined
      }
      str = str.substring(0, endIndex + 1)
      const firstQuote = str.indexOf('"')
      const lastQuote = str.lastIndexOf('"')
      const id = str.substring(firstQuote + 1, lastQuote)
      hilog.debug(0, TAG, `str = ${str}, id = ${id}`)
      const map = new Map<string, string>()
      map.set(InsertImageParser.PARAM_KEY, id)

      return {
        node: {
          nodeType: "NodeType.InsertImage",
          props: map
        },
        index: utf16Index2utf8Index(line, start + endIndex + 1),
        lineIndex: scanner.lineIndex
      }
    } else {
      return undefined
    }

  }
}
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, SysTestKit } from '@ohos/hypium';
import { cjLib, InlineContentParser, JsNode, JsNodeSendableImpl } from '@cangjie-tpc/commonmark_hybrid';
import {
  strAudio,
  strBanner,
  strBlockRerference,
  strCombinedCodeBlock,
  strDivider,
  strFencedCodeBlock,
  strformula,
  strHeadline01,
  strImage,
  strIndentedCodeBlock,
  strInlineCode,
  strLinebreak,
  strLink,
  strList,
  strParagraph,
  strTable,
  strVideo
} from './mockdata/mockDataComplex';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { getOptions, traverseTree } from './common';
import { ArrayList } from '@kit.ArkTS';


let cmInlineTags: string[] = []
let customParsers: InlineContentParser[] = []

export default function HybridParserTest() {
  describe('HybridParserTest', () => {
    let allNodes: Array<JsNode> = []
    beforeAll(async () => {})
    beforeEach(() => {})
    afterEach(() => {})
    afterAll(() => {})

    // strBanner
    it('test_strBanner_includeSourceSpans_0_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(0, cmInlineTags, customParsers))
      let curNode = await parser.parse(strBanner) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(37)
    })
    it('test_strBanner_includeSourceSpans_0_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(0, cmInlineTags, customParsers))
      let curNode = await parser.parse(strBanner) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let i = 0; i < allNodes.length; i += 1) {
        expect(allNodes[i].getSourceSpans().length).assertEqual(0)
      }
    })
    it('test_strBanner_includeSourceSpans_1_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(1, cmInlineTags, customParsers))
      let spanNum0 = [0, 6, 9, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 23, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36]
      let spanNum1 = [1, 2, 4, 5, 8, 10, 21, 22, 24, 25, 26]
      let spanNum2 = [7]
      let spanNum4 = [3]
      let curNode = await parser.parse(strBanner) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(37)
      expect(spanNum0.length + spanNum1.length + spanNum2.length + spanNum4.length).assertEqual(allNodes.length)
    })
    it('test_strBanner_includeSourceSpans_1_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(1, cmInlineTags, customParsers))
      let spanNum0 = [0, 6, 9, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 23, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36]
      let spanNum1 = [1, 2, 4, 5, 8, 10, 21, 22, 24, 25, 26]
      let spanNum2 = [7]
      let spanNum4 = [3]
      let curNode = await parser.parse(strBanner) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let index of spanNum0) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(0)
      }
      for (let index of spanNum1) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(1)
      }
      for (let index of spanNum2) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(2)
      }
      for (let index of spanNum4) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(4)
      }
    })
    it('test_strBanner_includeSourceSpans_2_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let spanNum0 = [0]
      let spanNum1 =
        [1, 2, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31,
          32, 33, 34, 35, 36]
      let spanNum2 = [7]
      let spanNum4 = [3]
      let curNode = await parser.parse(strBanner) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(37)
      expect(spanNum0.length + spanNum1.length + spanNum2.length + spanNum4.length).assertEqual(allNodes.length)
    })
    it('test_strBanner_includeSourceSpans_2_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let spanNum0 = [0]
      let spanNum1 =
        [1, 2, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31,
          32, 33, 34, 35, 36]
      let spanNum2 = [7]
      let spanNum4 = [3]
      let curNode = await parser.parse(strBanner) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let index of spanNum0) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(0)
      }
      for (let index of spanNum1) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(1)
      }
      for (let index of spanNum2) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(2)
      }
      for (let index of spanNum4) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(4)
      }
    })

    // strHeadline01
    it('test_strHeadline01_includeSourceSpans_0_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(0, cmInlineTags, customParsers))
      let curNode = await parser.parse(strHeadline01) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(17)
    })
    it('test_strHeadline01_includeSourceSpans_0_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(0, cmInlineTags, customParsers))
      let curNode = await parser.parse(strHeadline01) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let i = 0; i < allNodes.length; i += 1) {
        expect(allNodes[i].getSourceSpans().length).assertEqual(0)
      }
    })
    it('test_strHeadline01_includeSourceSpans_1_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(1, cmInlineTags, customParsers))
      let spanNum0 = [0, 14, 16]
      let spanNum1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
      let spanNum2 = [13, 15]
      let curNode = await parser.parse(strHeadline01) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(17)
      expect(spanNum0.length + spanNum1.length + spanNum2.length).assertEqual(allNodes.length)
    })
    it('test_strHeadline01_includeSourceSpans_1_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(1, cmInlineTags, customParsers))
      let spanNum0 = [0, 14, 16]
      let spanNum1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
      let spanNum2 = [13, 15]
      let curNode = await parser.parse(strHeadline01) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let index of spanNum0) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(0)
      }
      for (let index of spanNum1) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(1)
      }
      for (let index of spanNum2) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(2)
      }
    })
    it('test_strHeadline01_includeSourceSpans_2_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let spanNum0 = [0]
      let spanNum1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 16]
      let spanNum2 = [13, 15]
      let curNode = await parser.parse(strHeadline01) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(17)
      expect(spanNum0.length + spanNum1.length + spanNum2.length).assertEqual(allNodes.length)
    })
    it('test_strHeadline01_includeSourceSpans_2_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let spanNum0 = [0]
      let spanNum1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 16]
      let spanNum2 = [13, 15]
      let curNode = await parser.parse(strHeadline01) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let index of spanNum0) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(0)
      }
      for (let index of spanNum1) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(1)
      }
      for (let index of spanNum2) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(2)
      }
    })

    // strParagraph
    it('test_strParagraph_includeSourceSpans_0_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(0, cmInlineTags, customParsers))
      let curNode = await parser.parse(strParagraph) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(15)
    })
    it('test_strParagraph_includeSourceSpans_0_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(0, cmInlineTags, customParsers))
      let curNode = await parser.parse(strParagraph) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let i = 0; i < allNodes.length; i += 1) {
        expect(allNodes[i].getSourceSpans().length).assertEqual(0)
      }
    })
    it('test_strParagraph_includeSourceSpans_1_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(1, cmInlineTags, customParsers))
      let spanNum0 = [0, 2, 4, 6, 8, 10, 12, 14]
      let spanNum1 = [1, 3, 5, 7, 9, 11, 13]
      let curNode = await parser.parse(strParagraph) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(15)
      expect(spanNum0.length + spanNum1.length).assertEqual(allNodes.length)
    })
    it('test_strParagraph_includeSourceSpans_1_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(1, cmInlineTags, customParsers))
      let spanNum0 = [0, 2, 4, 6, 8, 10, 12, 14]
      let spanNum1 = [1, 3, 5, 7, 9, 11, 13]
      let curNode = await parser.parse(strParagraph) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let index of spanNum0) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(0)
      }
      for (let index of spanNum1) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(1)
      }
    })
    it('test_strParagraph_includeSourceSpans_2_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let spanNum0 = [0]
      let spanNum1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
      let curNode = await parser.parse(strParagraph) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(15)
    })
    it('test_strParagraph_includeSourceSpans_2_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let spanNum0 = [0]
      let spanNum1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
      let curNode = await parser.parse(strParagraph) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let index of spanNum0) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(0)
      }
      for (let index of spanNum1) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(1)
      }
    })

    // strDivider
    it('test_strDivider_includeSourceSpans_0_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(0, cmInlineTags, customParsers))
      let curNode = await parser.parse(strDivider) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(15)
    })
    it('test_strDivider_includeSourceSpans_0_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(0, cmInlineTags, customParsers))
      let curNode = await parser.parse(strDivider) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let i = 0; i < allNodes.length; i += 1) {
        expect(allNodes[i].getSourceSpans().length).assertEqual(0)
      }
    })
    it('test_strDivider_includeSourceSpans_1_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(1, cmInlineTags, customParsers))
      let spanNum0 = [0, 2, 5, 8, 11, 14]
      let spanNum1 = [1, 3, 4, 6, 7, 9, 10, 12, 13]
      let curNode = await parser.parse(strDivider) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(15)
      expect(spanNum0.length + spanNum1.length).assertEqual(allNodes.length)
    })
    it('test_strDivider_includeSourceSpans_1_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(1, cmInlineTags, customParsers))
      let spanNum0 = [0, 2, 5, 8, 11, 14]
      let spanNum1 = [1, 3, 4, 6, 7, 9, 10, 12, 13]
      let curNode = await parser.parse(strDivider) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let index of spanNum0) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(0)
      }
      for (let index of spanNum1) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(1)
      }
    })
    it('test_strDivider_includeSourceSpans_2_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let spanNum0 = [0]
      let spanNum1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
      let curNode = await parser.parse(strDivider) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(15)
      expect(spanNum0.length + spanNum1.length).assertEqual(allNodes.length)
    })
    it('test_strDivider_includeSourceSpans_2_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let spanNum0 = [0]
      let spanNum1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
      let curNode = await parser.parse(strDivider) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let index of spanNum0) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(0)
      }
      for (let index of spanNum1) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(1)
      }
    })

    // strLinebreak
    it('test_strLinebreak_includeSourceSpans_0_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(0, cmInlineTags, customParsers))
      let curNode = await parser.parse(strLinebreak) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(9)
    })
    it('test_strLinebreak_includeSourceSpans_0_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(0, cmInlineTags, customParsers))
      let curNode = await parser.parse(strLinebreak) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let i = 0; i < allNodes.length; i += 1) {
        expect(allNodes[i].getSourceSpans().length).assertEqual(0)
      }
    })
    it('test_strLinebreak_includeSourceSpans_1_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(1, cmInlineTags, customParsers))
      let spanNum0 = [0, 2, 3, 4, 6, 7, 8]
      let spanNum2 = [1, 5]
      let curNode = await parser.parse(strLinebreak) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(9)
      expect(spanNum0.length + spanNum2.length).assertEqual(allNodes.length)
    })
    it('test_strLinebreak_includeSourceSpans_1_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(1, cmInlineTags, customParsers))
      let spanNum0 = [0, 2, 3, 4, 6, 7, 8]
      let spanNum2 = [1, 5]
      let curNode = await parser.parse(strLinebreak) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let index of spanNum0) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(0)
      }
      for (let index of spanNum2) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(2)
      }
    })
    it('test_strLinebreak_includeSourceSpans_2_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let spanNum0 = [0, 3, 7]
      let spanNum1 = [2, 4, 6, 8]
      let spanNum2 = [1, 5]
      let curNode = await parser.parse(strLinebreak) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(9)
      expect(spanNum0.length + spanNum1.length + spanNum2.length).assertEqual(allNodes.length)
    })
    it('test_strLinebreak_includeSourceSpans_2_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let spanNum0 = [0, 3, 7]
      let spanNum1 = [2, 4, 6, 8]
      let spanNum2 = [1, 5]
      let curNode = await parser.parse(strLinebreak) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let index of spanNum0) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(0)
      }
      for (let index of spanNum1) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(1)
      }
      for (let index of spanNum2) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(2)
      }
    })

    // strformula
    it('test_strformula_includeSourceSpans_0_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(0, cmInlineTags, customParsers))
      let curNode = await parser.parse(strformula) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(4)
    })
    it('test_strformula_includeSourceSpans_0_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(0, cmInlineTags, customParsers))
      let curNode = await parser.parse(strformula) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let i = 0; i < allNodes.length; i += 1) {
        expect(allNodes[i].getSourceSpans().length).assertEqual(0)
      }
    })
    it('test_strformula_includeSourceSpans_1_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(1, cmInlineTags, customParsers))
      let spanNum0 = [0, 3]
      let spanNum1 = [2, 1]
      let curNode = await parser.parse(strformula) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(4)
    })
    it('test_strformula_includeSourceSpans_1_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(1, cmInlineTags, customParsers))
      let spanNum0 = [0]
      let spanNum1 = [2, 1, 3]
      let curNode = await parser.parse(strformula) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let index of spanNum0) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(0)
      }
      for (let index of spanNum1) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(1)
      }
    })
    it('test_strformula_includeSourceSpans_2_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let spansNum0 = [0, 3]
      let spansNum1 = [2, 1]
      let curNode = await parser.parse(strformula) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(4)
      expect(spansNum0.length + spansNum1.length).assertEqual(allNodes.length)
    })
    it('test_strformula_includeSourceSpans_2_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let spansNum0 = [0]
      let spansNum1 = [2, 1, 3]
      let curNode = await parser.parse(strformula) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let index of spansNum0) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(0)
      }
      for (let index of spansNum1) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(1)
      }
    })

    // strTable
    it('test_strTable_includeSourceSpans_0_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(0, cmInlineTags, customParsers))
      let curNode = await parser.parse(strTable) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(351)
    })
    it('test_strTable_includeSourceSpans_0_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(0, cmInlineTags, customParsers))
      let curNode = await parser.parse(strTable) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let i = 0; i < allNodes.length; i += 1) {
        expect(allNodes[i].getSourceSpans().length).assertEqual(0)
      }
    })
    it('test_strTable_includeSourceSpans_1_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(1, cmInlineTags, customParsers))
      let spansNum0 =
        [0, 6, 7, 8, 9, 10, 11, 14, 15, 16, 17, 18, 19, 21, 22, 23, 24, 25, 26, 27, 29, 30, 31, 32, 33, 34, 40, 41, 42,
          43, 44, 45, 46, 47, 50, 51, 52, 53, 54, 55, 56, 57, 64, 65, 66, 67, 68, 69, 72, 73, 74, 75, 76, 77, 79, 80,
          81, 82, 83, 84, 86, 87, 88, 89, 90, 91, 97, 98, 99, 100, 103, 104, 105, 106, 107, 108, 110, 111, 112, 113,
          119, 120, 121, 122, 125, 126, 127, 128, 130, 131, 132, 133, 135, 136, 137, 138, 144, 145, 146, 147, 148, 149,
          152, 153, 154, 155, 156, 157, 159, 160, 161, 162, 163, 164, 166, 167, 168, 169, 170, 171, 177, 178, 179, 180,
          181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202,
          205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226,
          227, 228, 229, 230, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249,
          250, 251, 252, 253, 254, 255, 256, 257, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272,
          273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 290, 291, 292, 293, 294, 295, 298, 299, 300, 301,
          302, 303, 305, 306, 307, 308, 309, 310, 312, 313, 314, 315, 316, 317, 323, 324, 325, 326, 327, 328, 331, 332,
          333, 334, 335, 336, 338, 339, 340, 341, 342, 343, 345, 346, 347, 348, 349, 350]
      let spansNum1 =
        [1, 2, 4, 5, 13, 20, 28, 35, 36, 38, 39, 48, 49, 58, 59, 60, 62, 63, 71, 78, 85, 92, 93, 95, 96, 102, 109, 114,
          115, 117, 118, 124, 129, 134, 139, 140, 142, 143, 151, 158, 165, 172, 173, 175, 176, 204, 231, 258, 285, 286,
          288, 289, 297, 304, 311, 318, 319, 321, 322, 330, 337, 344]
      let spansNum2 = [101]
      let spansNum3 = [12, 37, 70, 123, 150, 203, 296, 329]
      let spansNum4 = [94]
      let spansNum5 = [3, 61, 116, 141, 174, 287, 320]
      let curNode = await parser.parse(strTable) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(351)
      expect(spansNum0.length + spansNum1.length + spansNum2.length + spansNum3.length + spansNum4.length +
      spansNum5.length).assertEqual(allNodes.length)
    })
    it('test_strTable_includeSourceSpans_1_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(1, cmInlineTags, customParsers))
      let spansNum0 =
        [0, 6, 7, 8, 9, 10, 11, 14, 15, 16, 17, 18, 19, 21, 22, 23, 24, 25, 26, 27, 29, 30, 31, 32, 33, 34, 40, 41, 42,
          43, 44, 45, 46, 47, 50, 51, 52, 53, 54, 55, 56, 57, 64, 65, 66, 67, 68, 69, 72, 73, 74, 75, 76, 77, 79, 80,
          81, 82, 83, 84, 86, 87, 88, 89, 90, 91, 97, 98, 99, 100, 103, 104, 105, 106, 107, 108, 110, 111, 112, 113,
          119, 120, 121, 122, 125, 126, 127, 128, 130, 131, 132, 133, 135, 136, 137, 138, 144, 145, 146, 147, 148, 149,
          152, 153, 154, 155, 156, 157, 159, 160, 161, 162, 163, 164, 166, 167, 168, 169, 170, 171, 177, 178, 179, 180,
          181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202,
          205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226,
          227, 228, 229, 230, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249,
          250, 251, 252, 253, 254, 255, 256, 257, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272,
          273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 290, 291, 292, 293, 294, 295, 298, 299, 300, 301,
          302, 303, 305, 306, 307, 308, 309, 310, 312, 313, 314, 315, 316, 317, 323, 324, 325, 326, 327, 328, 331, 332,
          333, 334, 335, 336, 338, 339, 340, 341, 342, 343, 345, 346, 347, 348, 349, 350]
      let spansNum1 =
        [1, 2, 4, 5, 13, 20, 28, 35, 36, 38, 39, 48, 49, 58, 59, 60, 62, 63, 71, 78, 85, 92, 93, 95, 96, 102, 109, 114,
          115, 117, 118, 124, 129, 134, 139, 140, 142, 143, 151, 158, 165, 172, 173, 175, 176, 204, 231, 258, 285, 286,
          288, 289, 297, 304, 311, 318, 319, 321, 322, 330, 337, 344]
      let spansNum2 = [101]
      let spansNum3 = [12, 37, 70, 123, 150, 203, 296, 329]
      let spansNum4 = [94]
      let spansNum5 = [3, 61, 116, 141, 174, 287, 320]
      let curNode = await parser.parse(strTable) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let index of spansNum0) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(0)
      }
      for (let index of spansNum1) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(1)
      }
      for (let index of spansNum2) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(2)
      }
      for (let index of spansNum3) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(3)
      }
      for (let index of spansNum4) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(4)
      }
      for (let index of spansNum5) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(5)
      }
    })
    it('test_strTable_includeSourceSpans_2_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let curNode = await parser.parse(strTable) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(351)
    })
    it('test_strTable_includeSourceSpans_2_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let spansNum0 = [0]
      let spansNum1 =
        [1, 2, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32,
          33, 34, 35, 36, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60,
          62, 63, 64, 65, 66, 67, 68, 69, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89,
          90, 91, 92, 93, 95, 96, 97, 98, 99, 100, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115,
          117, 118, 119, 120, 121, 122, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139,
          140, 142, 143, 144, 145, 146, 147, 148, 149, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163,
          164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186,
          187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 204, 205, 206, 207, 208, 209,
          210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231,
          232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253,
          254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275,
          276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 288, 289, 290, 291, 292, 293, 294, 295, 297, 298, 299,
          300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 321, 322,
          323, 324, 325, 326, 327, 328, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345,
          346, 347, 348, 349, 350]
      let spansNum2 = [101]
      let spansNum3 = [12, 37, 70, 123, 150, 203, 296, 329]
      let spansNum4 = [94]
      let spansNum5 = [3, 61, 116, 141, 174, 287, 320]
      let curNode = await parser.parse(strTable) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let index of spansNum0) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(0)
      }
      for (let index of spansNum1) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(1)
      }
      for (let index of spansNum2) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(2)
      }
      for (let index of spansNum3) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(3)
      }
      for (let index of spansNum4) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(4)
      }
      for (let index of spansNum5) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(5)
      }
    })

    // strLink
    it('test_strLink_includeSourceSpans_0_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(0, cmInlineTags, customParsers))
      let curNode = await parser.parse(strLink) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(53)
    })
    it('test_strLink_includeSourceSpans_0_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(0, cmInlineTags, customParsers))
      let curNode = await parser.parse(strLink) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let i = 0; i < allNodes.length; i += 1) {
        expect(allNodes[i].getSourceSpans().length).assertEqual(0)
      }
    })
    it('test_strLink_includeSourceSpans_1_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(1, cmInlineTags, customParsers))
      let spansNum0 = [0, 2, 4, 5, 7, 8, 9, 10, 12, 13, 15, 16, 17, 23, 27, 28,29,30, 33, 34, 37, 38, 39,40,41, 42, 45, 46, 47,48,49,50]
      let spansNum1 = [1, 3, 6, 11, 14,  18, 19, 20,21, 22, 25, 26, 31, 32, 35, 36, 51, 52]
      let spansNum2 = [43, 44]
      let spansNum5 = [24]
      let curNode = await parser.parse(strLink) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(53)
      expect(spansNum0.length + spansNum1.length + spansNum2.length + spansNum5.length).assertEqual(allNodes.length)
    })
    it('test_strLink_includeSourceSpans_1_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(1, cmInlineTags, customParsers))
      let spansNum0 = [0, 2, 4, 5, 7, 8, 9, 10, 12, 13, 15, 16, 17, 23, 27, 28,29,30, 33, 34, 37, 38, 39,40,41, 42, 45, 46, 47,48,49,50]
      let spansNum1 = [1, 3, 6, 11, 14,  18, 19, 20,21, 22, 25, 26, 31, 32, 35, 36, 51, 52]
      let spansNum2 = [43, 44]
      let spansNum5 = [24]
      let curNode = await parser.parse(strLink) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let index of spansNum0) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(0)
      }
      for (let index of spansNum1) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(1)
      }
      for (let index of spansNum2) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(2)
      }
      for (let index of spansNum5) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(5)
      }
    })
    it('test_strLink_includeSourceSpans_2_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let spansNum0 = [0, 2, 4, 5, 7, 8, 9, 10, 12, 13, 15, 16, 17, 23, 27, 28,29,30, 33, 34, 37, 38, 39,40,41, 42, 45, 46, 47,48,49,50]
      let spansNum1 = [1, 3, 6, 11, 14,  18, 19, 20,21, 22, 25, 26, 31, 32, 35, 36, 51, 52]
      let spansNum2 = [43, 44]
      let spansNum5 = [24]
      let curNode = await parser.parse(strLink) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(53)
      expect(spansNum0.length + spansNum1.length + spansNum2.length + spansNum5.length).assertEqual(allNodes.length)
    })
    it('test_strLink_includeSourceSpans_2_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let spansNum0 = [0, 12,13,15, 16,17,49]
      let spansNum1 = [1,2,3,4, 5,6,7,8,9,10,11,14,18,19,20,21,22, 23,25, 26,27, 28, 29, 30,31, 32,33,34,35, 36, 37,38,39,40,41,42,45,46,47,48, 50, 51,52]
      let spansNum2 = [43, 44]
      let spansNum5 = [24]
      let curNode = await parser.parse(strLink) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let index of spansNum0) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(0)
      }
      for (let index of spansNum1) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(1)
      }
      for (let index of spansNum2) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(2)
      }
      for (let index of spansNum5) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(5)
      }
    })

    // strBlockRerference
    it('test_strBlockRerference_includeSourceSpans_0_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(0, cmInlineTags, customParsers))
      let curNode = await parser.parse(strBlockRerference) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(34)
    })
    it('test_strBlockRerference_includeSourceSpans_0_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(0, cmInlineTags, customParsers))
      let curNode = await parser.parse(strBlockRerference) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let i = 0; i < allNodes.length; i += 1) {
        expect(allNodes[i].getSourceSpans().length).assertEqual(0)
      }
    })
    it('test_strBlockRerference_includeSourceSpans_1_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(1, cmInlineTags, customParsers))
      let spansNum0 = [0, 2, 5, 7, 9, 11, 13, 15, 18, 21, 24, 27, 30, 33]
      let spansNum1 = [1, 4, 6, 8, 10, 12, 14, 17, 20, 23, 26, 29, 32]
      let spansNum2 = [31]
      let spansNum4 = [28]
      let spansNum6 = [25]
      let spansNum8 = [22]
      let spansNum9 = [3]
      let spansNum10 = [19]
      let spansNum11 = [16]
      let curNode = await parser.parse(strBlockRerference) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(34)
      expect(spansNum0.length + spansNum1.length + spansNum2.length + spansNum4.length + spansNum6.length +
      spansNum8.length + spansNum9.length + spansNum10.length + spansNum11.length).assertEqual(allNodes.length)
    })
    it('test_strBlockRerference_includeSourceSpans_1_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(1, cmInlineTags, customParsers))
      let spansNum0 = [0, 2, 5, 7, 9, 11, 13, 15, 18, 21, 24, 27, 30, 33]
      let spansNum1 = [1, 4, 6, 8, 10, 12, 14, 17, 20, 23, 26, 29, 32]
      let spansNum2 = [31]
      let spansNum4 = [28]
      let spansNum6 = [25]
      let spansNum8 = [22]
      let spansNum9 = [3]
      let spansNum10 = [19]
      let spansNum11 = [16]
      let curNode = await parser.parse(strBlockRerference) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let index of spansNum0) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(0)
      }
      for (let index of spansNum1) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(1)
      }
      for (let index of spansNum2) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(2)
      }
      for (let index of spansNum4) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(4)
      }
      for (let index of spansNum6) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(6)
      }
      for (let index of spansNum8) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(8)
      }
      for (let index of spansNum9) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(9)
      }
      for (let index of spansNum10) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(10)
      }
      for (let index of spansNum11) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(11)
      }
    })
    it('test_strBlockRerference_includeSourceSpans_2_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let spansNum0 = [0]
      let spansNum1 = [1, 2, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 17, 18, 20, 21, 23, 24, 26, 27, 29, 30, 32, 33]
      let spansNum2 = [31]
      let spansNum4 = [28]
      let spansNum6 = [25]
      let spansNum8 = [22]
      let spansNum9 = [3]
      let spansNum10 = [19]
      let spansNum11 = [16]
      let curNode = await parser.parse(strBlockRerference) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(34)
      expect(spansNum0.length + spansNum1.length + spansNum2.length + spansNum4.length + spansNum6.length +
      spansNum8.length + spansNum9.length + spansNum10.length + spansNum11.length).assertEqual(allNodes.length)
    })
    it('test_strBlockRerference_includeSourceSpans_2_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let spansNum0 = [0]
      let spansNum1 = [1, 2, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 17, 18, 20, 21, 23, 24, 26, 27, 29, 30, 32, 33]
      let spansNum2 = [31]
      let spansNum4 = [28]
      let spansNum6 = [25]
      let spansNum8 = [22]
      let spansNum9 = [3]
      let spansNum10 = [19]
      let spansNum11 = [16]
      let curNode = await parser.parse(strBlockRerference) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let index of spansNum0) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(0)
      }
      for (let index of spansNum1) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(1)
      }
      for (let index of spansNum2) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(2)
      }
      for (let index of spansNum4) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(4)
      }
      for (let index of spansNum6) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(6)
      }
      for (let index of spansNum8) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(8)
      }
      for (let index of spansNum9) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(9)
      }
      for (let index of spansNum10) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(10)
      }
      for (let index of spansNum11) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(11)
      }
    })
    // strList
    it('test_strList_includeSourceSpans_0_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(0, cmInlineTags, customParsers))
      let curNode = await parser.parse(strList) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(85)
    })
    it('test_strList_includeSourceSpans_0_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(0, cmInlineTags, customParsers))
      let curNode = await parser.parse(strList) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let i = 0; i < allNodes.length; i += 1) {
        expect(allNodes[i].getSourceSpans().length).assertEqual(0)
      }
    })
    it('test_strList_includeSourceSpans_1_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(1, cmInlineTags, customParsers))
      let spansNum0 = [0, 6, 9, 12, 15, 18, 21, 27, 30, 33, 36, 39, 42, 48, 51, 54, 57, 60, 63, 69, 72, 75, 78, 81, 84]
      let spansNum1 = [1, 2, 4, 5, 7, 8, 10, 11, 13, 14, 16, 17, 19, 20, 22, 23, 25, 26, 28, 29, 31, 32, 34, 35, 37, 38, 40, 41, 43, 44, 46, 47, 49, 50, 52, 53, 55, 56, 58, 59, 61, 62, 64, 65, 67, 68, 70, 71, 73, 74, 76, 77, 79, 80, 82, 83]
      let spansNum6 = [3, 24, 45, 66]
      let curNode = await parser.parse(strList) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(85)
      expect(spansNum0.length + spansNum1.length + spansNum6.length).assertEqual(allNodes.length)
    })
    it('test_strList_includeSourceSpans_1_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(1, cmInlineTags, customParsers))
      let spansNum0 = [0, 6, 9, 12, 15, 18, 21, 27, 30, 33, 36, 39, 42, 48, 51, 54, 57, 60, 63, 69, 72, 75, 78, 81, 84]
      let spansNum1 = [1, 2, 4, 5, 7, 8, 10, 11, 13, 14, 16, 17, 19, 20, 22, 23, 25, 26, 28, 29, 31, 32, 34, 35, 37, 38, 40, 41, 43, 44, 46, 47, 49, 50, 52, 53, 55, 56, 58, 59, 61, 62, 64, 65, 67, 68, 70, 71, 73, 74, 76, 77, 79, 80, 82, 83]
      let spansNum6 = [3, 24, 45, 66]
      let curNode = await parser.parse(strList) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let index of spansNum0) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(0)
      }
      for (let index of spansNum1) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(1)
      }
      for (let index of spansNum6) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(6)
      }
    })
    it('test_strList_includeSourceSpans_2_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let spansNum0 = [0]
      let spansNum1 = [1, 2, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84]
      let spansNum6 = [3, 24, 45, 66]
      let curNode = await parser.parse(strList) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(85)
      expect(spansNum0.length + spansNum1.length + spansNum6.length).assertEqual(allNodes.length)
    })
    it('test_strList_includeSourceSpans_2_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let spansNum0 = [0]
      let spansNum1 = [1, 2, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84]
      let spansNum6 = [3, 24, 45, 66]
      let curNode = await parser.parse(strList) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let index of spansNum0) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(0)
      }
      for (let index of spansNum1) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(1)
      }
      for (let index of spansNum6) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(6)
      }
    })
    // strInlineCode
    it('test_strInlineCode_includeSourceSpans_0_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(0, cmInlineTags, customParsers))
      let curNode = await parser.parse(strInlineCode) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(85)
    })
    it('test_strInlineCode_includeSourceSpans_0_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(0, cmInlineTags, customParsers))
      let curNode = await parser.parse(strInlineCode) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let i = 0; i < allNodes.length; i += 1) {
        expect(allNodes[i].getSourceSpans().length).assertEqual(0)
      }
    })
    it('test_strInlineCode_includeSourceSpans_1_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(1, cmInlineTags, customParsers))
      let spansNum0 = [0, 2, 4, 5, 6, 12, 13, 14, 22, 23, 24, 27, 28, 29, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84]
      let spansNum1 = [1, 3, 7, 8, 9, 10, 11, 15, 16, 17, 18, 20, 21, 25, 26, 31, 32, 46, 59, 72]
      let spansNum2 = [19]
      let spansNum3 = [45]
      let spansNum5 = [30]
      let curNode = await parser.parse(strInlineCode) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(85)
      expect(spansNum0.length + spansNum1.length + spansNum2.length + spansNum3.length + spansNum5.length).assertEqual(85)
    })
    it('test_strInlineCode_includeSourceSpans_1_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(1, cmInlineTags, customParsers))
      let spansNum0 = [0, 2, 4, 5, 6, 12, 13, 14, 22, 23, 24, 27, 28, 29, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84]
      let spansNum1 = [1, 3, 7, 8, 9, 10, 11, 15, 16, 17, 18, 20, 21, 25, 26, 31, 32, 46, 59, 72]
      let spansNum2 = [19]
      let spansNum3 = [45]
      let spansNum5 = [30]
      let curNode = await parser.parse(strInlineCode) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let index of spansNum0) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(0)
      }
      for (let index of spansNum1) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(1)
      }
      for (let index of spansNum2) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(2)
      }
      for (let index of spansNum3) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(3)
      }
      for (let index of spansNum5) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(5)
      }
    })
    it('test_strInlineCode_includeSourceSpans_2_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let spansNum0 = [0]
      let spansNum1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84]
      let spansNum2 = [19]
      let spansNum3 = [45]
      let spansNum5 = [30]
      let curNode = await parser.parse(strInlineCode) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(85)
      expect(spansNum0.length + spansNum1.length + spansNum2.length + spansNum3.length + spansNum5.length).assertEqual(85)
    })
    it('test_strInlineCode_includeSourceSpans_2_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let spansNum0 = [0]
      let spansNum1 =
        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 31, 32,
          33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60,
          61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84]
      let spansNum2 = [19]
      let spansNum3 = [45]
      let spansNum5 = [30]
      let curNode = await parser.parse(strInlineCode) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let index of spansNum0) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(0)
      }
      for (let index of spansNum1) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(1)
      }
      for (let index of spansNum2) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(2)
      }
      for (let index of spansNum3) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(3)
      }
      for (let index of spansNum5) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(5)
      }
    })
    // strIndentedCodeBlock
    it('test_strIndentedCodeBlock_includeSourceSpans_0_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(0, cmInlineTags, customParsers))
      let curNode = await parser.parse(strIndentedCodeBlock) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(4)
    })
    it('test_strIndentedCodeBlock_includeSourceSpans_0_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(0, cmInlineTags, customParsers))
      let curNode = await parser.parse(strIndentedCodeBlock) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let i = 0; i < allNodes.length; i += 1) {
        expect(allNodes[i].getSourceSpans().length).assertEqual(0)
      }
    })
    it('test_strIndentedCodeBlock_includeSourceSpans_1_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(1, cmInlineTags, customParsers))
      let spansNum0 = [0, 2]
      let spansNum1 = [1]
      let spansNum6 = [3]
      let curNode = await parser.parse(strIndentedCodeBlock) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(4)
      expect(spansNum0.length + spansNum1.length + spansNum6.length).assertEqual(allNodes.length)
    })
    it('test_strIndentedCodeBlock_includeSourceSpans_1_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(1, cmInlineTags, customParsers))
      let spansNum0 = [0, 2]
      let spansNum1 = [1]
      let spansNum6 = [3]
      let curNode = await parser.parse(strIndentedCodeBlock) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let index of spansNum0) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(0)
      }
      for (let index of spansNum1) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(1)
      }
      for (let index of spansNum6) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(6)
      }
    })
    it('test_strIndentedCodeBlock_includeSourceSpans_2_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let spansNum0 = [0]
      let spansNum1 = [1, 2]
      let spansNum6 = [3]
      let curNode = await parser.parse(strIndentedCodeBlock) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(4)
      expect(spansNum0.length + spansNum1.length + spansNum6.length).assertEqual(allNodes.length)
    })
    it('test_strIndentedCodeBlock_includeSourceSpans_2_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let spansNum0 = [0]
      let spansNum1 = [1, 2]
      let spansNum6 = [3]
      let curNode = await parser.parse(strIndentedCodeBlock) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let index of spansNum0) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(0)
      }
      for (let index of spansNum1) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(1)
      }
      for (let index of spansNum6) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(6)
      }
    })
    // strFencedCodeBlock
    it('test_strFencedCodeBlock_includeSourceSpans_0_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(0, cmInlineTags, customParsers))
      let curNode = await parser.parse(strFencedCodeBlock) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(2)
    })
    it('test_strFencedCodeBlock_includeSourceSpans_0_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(0, cmInlineTags, customParsers))
      let curNode = await parser.parse(strFencedCodeBlock) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let i = 0; i < allNodes.length; i += 1) {
        expect(allNodes[i].getSourceSpans().length).assertEqual(0)
      }
    })
    it('test_strFencedCodeBlock_includeSourceSpans_1_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(1, cmInlineTags, customParsers))
      let spansNum0 = [0]
      let spansNum8 = [1]
      let curNode = await parser.parse(strFencedCodeBlock) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(2)
      expect(spansNum0.length + spansNum8.length).assertEqual(allNodes.length)
    })
    it('test_strFencedCodeBlock_includeSourceSpans_1_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(1, cmInlineTags, customParsers))
      let spansNum0 = [0]
      let spansNum8 = [1]
      let curNode = await parser.parse(strFencedCodeBlock) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let index of spansNum0) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(0)
      }
      for (let index of spansNum8) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(8)
      }
    })
    it('test_strFencedCodeBlock_includeSourceSpans_2_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let spansNum0 = [0]
      let spansNum8 = [1]
      let curNode = await parser.parse(strFencedCodeBlock) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(2)
      expect(spansNum0.length + spansNum8.length).assertEqual(allNodes.length)
    })
    it('test_strFencedCodeBlock_includeSourceSpans_2_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let spansNum0 = [0]
      let spansNum8 = [1]
      let curNode = await parser.parse(strFencedCodeBlock) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let index of spansNum0) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(0)
      }
      for (let index of spansNum8) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(8)
      }
    })

    // strCombinedCodeBlock
    it('test_strCombinedCodeBlock_includeSourceSpans_0_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(0, cmInlineTags, customParsers))
      let curNode = await parser.parse(strCombinedCodeBlock) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(5)
    })
    it('test_strCombinedCodeBlock_includeSourceSpans_0_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(0, cmInlineTags, customParsers))
      let curNode = await parser.parse(strCombinedCodeBlock) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let i = 0; i < allNodes.length; i += 1) {
        expect(allNodes[i].getSourceSpans().length).assertEqual(0)
      }
    })
    it('test_strCombinedCodeBlock_includeSourceSpans_1_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(1, cmInlineTags, customParsers))
      let spansNum0 = [0]
      let spansNum3 = [2]
      let spansNum4 = [3]
      let spansNum7 = [1, 4]
      let curNode = await parser.parse(strCombinedCodeBlock) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(5)
      expect(spansNum0.length + spansNum3.length + spansNum4.length + spansNum7.length).assertEqual(allNodes.length)
    })
    it('test_strCombinedCodeBlock_includeSourceSpans_1_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(1, cmInlineTags, customParsers))
      let spansNum0 = [0]
      let spansNum3 = [2]
      let spansNum4 = [3]
      let spansNum7 = [1, 4]
      let curNode = await parser.parse(strCombinedCodeBlock) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let index of spansNum0) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(0)
      }
      for (let index of spansNum3) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(3)
      }
      for (let index of spansNum4) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(4)
      }
      for (let index of spansNum7) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(7)
      }
    })
    it('test_strCombinedCodeBlock_includeSourceSpans_2_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let spansNum0 = [0]
      let spansNum3 = [2]
      let spansNum4 = [3]
      let spansNum7 = [1, 4]
      let curNode = await parser.parse(strCombinedCodeBlock) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(5)
      expect(spansNum0.length + spansNum3.length + spansNum4.length + spansNum7.length).assertEqual(allNodes.length)
    })
    it('test_strCombinedCodeBlock_includeSourceSpans_2_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let spansNum0 = [0]
      let spansNum3 = [2]
      let spansNum4 = [3]
      let spansNum7 = [1, 4]
      let curNode = await parser.parse(strCombinedCodeBlock) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let index of spansNum0) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(0)
      }
      for (let index of spansNum3) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(3)
      }
      for (let index of spansNum4) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(4)
      }
      for (let index of spansNum7) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(7)
      }
    })
    // strAudio
    it('test_strAudio_includeSourceSpans_0_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(0, cmInlineTags, customParsers))
      let curNode = await parser.parse(strAudio) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(9)
    })
    it('test_strAudio_includeSourceSpans_0_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(0, cmInlineTags, customParsers))
      let curNode = await parser.parse(strAudio) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let i = 0; i < allNodes.length; i += 1) {
        expect(allNodes[i].getSourceSpans().length).assertEqual(0)
      }
    })
    it('test_strAudio_includeSourceSpans_1_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(1, cmInlineTags, customParsers))
      let spansNum0 = [0, 2, 4, 6, 7, 8]
      let spansNum1 = [1, 3]
      let spansNum2 = [5]
      let curNode = await parser.parse(strAudio) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(9)
      expect(spansNum0.length + spansNum1.length + spansNum2.length).assertEqual(allNodes.length)
    })
    it('test_strAudio_includeSourceSpans_1_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(1, cmInlineTags, customParsers))
      let spansNum0 = [0, 2, 4, 6, 7, 8]
      let spansNum1 = [1, 3]
      let spansNum2 = [5]
      let curNode = await parser.parse(strAudio) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let index of spansNum0) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(0)
      }
      for (let index of spansNum1) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(1)
      }
      for (let index of spansNum2) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(2)
      }
    })
    it('test_strAudio_includeSourceSpans_2_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let spansNum0 = [0, 7]
      let spansNum1 = [1, 2, 3, 4, 6, 8]
      let spansNum2 = [5]
      let curNode = await parser.parse(strAudio) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(9)
      expect(spansNum0.length + spansNum1.length + spansNum2.length).assertEqual(allNodes.length)
    })
    it('test_strAudio_includeSourceSpans_2_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let spansNum0 = [0, 7]
      let spansNum1 = [1, 2, 3, 4, 6, 8]
      let spansNum2 = [5]
      let curNode = await parser.parse(strAudio) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let index of spansNum0) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(0)
      }
      for (let index of spansNum1) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(1)
      }
      for (let index of spansNum2) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(2)
      }
    })
    // strVideo
    it('test_strVideo_includeSourceSpans_0_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(0, cmInlineTags, customParsers))
      let curNode = await parser.parse(strVideo) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(7)
    })
    it('test_strVideo_includeSourceSpans_0_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(0, cmInlineTags, customParsers))
      let curNode = await parser.parse(strVideo) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let i = 0; i < allNodes.length; i += 1) {
        expect(allNodes[i].getSourceSpans().length).assertEqual(0)
      }
    })
    it('test_strVideo_includeSourceSpans_1_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(1, cmInlineTags, customParsers))
      let spansNum0 = [0, 2, 4, 6]
      let spansNum1 = [1, 3, 5]
      let curNode = await parser.parse(strVideo) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(7)
      expect(spansNum0.length + spansNum1.length).assertEqual(allNodes.length)
    })
    it('test_strVideo_includeSourceSpans_1_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(1, cmInlineTags, customParsers))
      let spansNum0 = [0, 2, 4, 6]
      let spansNum1 = [1, 3, 5]
      let curNode = await parser.parse(strVideo) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let index of spansNum0) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(0)
      }
      for (let index of spansNum1) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(1)
      }
    })
    it('test_strVideo_includeSourceSpans_2_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let spansNum0 = [0]
      let spansNum1 = [1, 2, 3, 4, 5, 6]
      let curNode = await parser.parse(strVideo) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(7)
      expect(spansNum0.length + spansNum1.length).assertEqual(allNodes.length)
    })
    it('test_strVideo_includeSourceSpans_2_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let spansNum0 = [0]
      let spansNum1 = [1, 2, 3, 4, 5, 6]
      let curNode = await parser.parse(strVideo) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let index of spansNum0) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(0)
      }
      for (let index of spansNum1) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(1)
      }
    })
    // strImage
    it('test_strImage_includeSourceSpans_0_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(0, cmInlineTags, customParsers))
      let curNode = await parser.parse(strImage) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(89)
    })
    it('test_strImage_includeSourceSpans_0_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(0, cmInlineTags, customParsers))
      let curNode = await parser.parse(strImage) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let i = 0; i < allNodes.length; i += 1) {
        expect(allNodes[i].getSourceSpans().length).assertEqual(0)
      }
    })
    it('test_strImage_includeSourceSpans_1_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(1, cmInlineTags, customParsers))
      let spansNum0 = [0, 2, 4, 5, 6, 8, 9, 10, 11, 13, 15, 16, 18, 19, 21, 22, 24, 26, 27, 29, 30, 32, 33, 35, 36, 37, 38, 40, 41, 42, 43, 45, 46, 47, 48, 50, 52, 53, 54, 56, 57, 58, 60, 61, 62, 63, 65, 66, 67, 68, 70, 72, 73, 74, 76, 77, 78, 80, 81, 82, 83, 85, 86, 87, 88]
      let spansNum1 = [1, 3, 7, 12, 14, 17, 20, 23, 25, 28, 31, 34, 39, 44, 49, 51, 55, 59, 64, 69, 71, 75, 79, 84]
      let curNode = await parser.parse(strImage) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(89)
      expect(spansNum0.length + spansNum1.length).assertEqual(allNodes.length)
    })
    it('test_strImage_includeSourceSpans_1_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(1, cmInlineTags, customParsers))
      let spansNum0 = [0, 2, 4, 5, 6, 8, 9, 10, 11, 13, 15, 16, 18, 19, 21, 22, 24, 26, 27, 29, 30, 32, 33, 35, 36, 37, 38, 40, 41, 42, 43, 45, 46, 47, 48, 50, 52, 53, 54, 56, 57, 58, 60, 61, 62, 63, 65, 66, 67, 68, 70, 72, 73, 74, 76, 77, 78, 80, 81, 82, 83, 85, 86, 87, 88]
      let spansNum1 = [1, 3, 7, 12, 14, 17, 20, 23, 25, 28, 31, 34, 39, 44, 49, 51, 55, 59, 64, 69, 71, 75, 79, 84]
      let curNode = await parser.parse(strImage) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let index of spansNum0) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(0)
      }
      for (let index of spansNum1) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(1)
      }
    })
    it('test_strImage_includeSourceSpans_2_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let spansNum0 = [0]
      let spansNum1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88]
      let curNode = await parser.parse(strImage) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(89)
      expect(spansNum0.length + spansNum1.length).assertEqual(allNodes.length)
    })
    it('test_strImage_includeSourceSpans_2_sourceSpanCount', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let spansNum0 = [0]
      let spansNum1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88]
      let curNode = await parser.parse(strImage) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      for (let index of spansNum0) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(0)
      }
      for (let index of spansNum1) {
        let spans = allNodes[index].getSourceSpans()
        expect(spans.length).assertEqual(1)
      }
    })
  })
}



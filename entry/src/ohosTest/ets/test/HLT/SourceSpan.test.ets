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

export default function SourceSpanTest() {
  describe('SourceSpanTest', () => {
    let allNodes: Array<JsNode> = []
    beforeAll(async () => {})
    beforeEach(() => {})
    afterEach(() => {})
    afterAll(() => {})
    // strCombinedCodeBlock
    it('test_strCombinedCodeBlock_includeSourceSpans_0_countNode', "Level 1", async () => {
      let parser = new cjLib.HybridParser(getOptions(2, cmInlineTags, customParsers))
      let curNode = await parser.parse(strCombinedCodeBlock) as JsNode
      allNodes = []
      traverseTree(curNode, allNodes)
      expect(allNodes.length).assertEqual(5)
      expect(allNodes[0].getSourceSpans().length).assertEqual(0)
      console.error("allNodes[0].getSourceSpans()",allNodes[0].getSourceSpans().length)
      console.error("allNodes[1].getSourceSpans()",allNodes[1].getSourceSpans().length)
      expect(allNodes[1].getSourceSpans()[0].getLineIndex()).assertEqual(0)
      expect(allNodes[1].getSourceSpans()[0].getColumnIndex()).assertEqual(0)
      expect(allNodes[1].getSourceSpans()[0].getInputIndex()).assertEqual(0)
      expect(allNodes[1].getSourceSpans()[0].getLength()).assertEqual(10)

      expect(allNodes[1].getSourceSpans()[1].getLineIndex()).assertEqual(1)
      expect(allNodes[1].getSourceSpans()[1].getColumnIndex()).assertEqual(0)
      expect(allNodes[1].getSourceSpans()[1].getInputIndex()).assertEqual(11)
      expect(allNodes[1].getSourceSpans()[1].getLength()).assertEqual(19)

      expect(allNodes[1].getSourceSpans()[2].getLineIndex()).assertEqual(2)
      expect(allNodes[1].getSourceSpans()[2].getColumnIndex()).assertEqual(0)
      expect(allNodes[1].getSourceSpans()[2].getInputIndex()).assertEqual(31)
      expect(allNodes[1].getSourceSpans()[2].getLength()).assertEqual(44)

      expect(allNodes[1].getSourceSpans()[3].getLineIndex()).assertEqual(3)
      expect(allNodes[1].getSourceSpans()[3].getColumnIndex()).assertEqual(0)
      expect(allNodes[1].getSourceSpans()[3].getInputIndex()).assertEqual(76)
      expect(allNodes[1].getSourceSpans()[3].getLength()).assertEqual(41)

      expect(allNodes[1].getSourceSpans()[4].getLineIndex()).assertEqual(4)
      expect(allNodes[1].getSourceSpans()[4].getColumnIndex()).assertEqual(0)
      expect(allNodes[1].getSourceSpans()[4].getInputIndex()).assertEqual(118)
      expect(allNodes[1].getSourceSpans()[4].getLength()).assertEqual(5)

      expect(allNodes[1].getSourceSpans()[5].getLineIndex()).assertEqual(5)
      expect(allNodes[1].getSourceSpans()[5].getColumnIndex()).assertEqual(0)
      expect(allNodes[1].getSourceSpans()[5].getInputIndex()).assertEqual(124)
      expect(allNodes[1].getSourceSpans()[5].getLength()).assertEqual(1)

      expect(allNodes[1].getSourceSpans()[6].getColumnIndex()).assertEqual(0)
      expect(allNodes[1].getSourceSpans()[6].getInputIndex()).assertEqual(126)
      expect(allNodes[1].getSourceSpans()[6].getLength()).assertEqual(3)
      expect(allNodes[1].getSourceSpans()[6].getLineIndex()).assertEqual(6)

    })
  })
}



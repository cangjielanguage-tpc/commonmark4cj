import { InlineContentParser,parseIntoJsNode ,JsNode,utf16Index2utf8Index} from "@cangjie-tpc/commonmark_hybrid"
import { beforeEach,afterAll,expect,it ,afterEach,beforeAll,describe, Level} from "@ohos/hypium"
import { getOptions, MyParser } from "./common"

let cmInlineTags: string[]=[]
let customParsers: InlineContentParser[]=[]

export default function CustomParserTest() {
  describe('CustomParserTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
      cmInlineTags=[]
      customParsers=[]
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
    it('CustomParserTest_Match_001', 0, async () => {
      let md = '我0123a56a89'
      let myPaser=new MyParser()
      customParsers=[myPaser]
      //测试节点是根节点
      let testNode = await parseIntoJsNode(md,getOptions(0,cmInlineTags,customParsers))
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
    it('CustomParserTest_Match_002', 0, async () => {
      let md = '我0123a56a89'
      let myPaser=new MyParser()
      customParsers=[myPaser]
      let node = await parseIntoJsNode(md,getOptions(0,cmInlineTags,customParsers))
      //测试节点是第一个子节点
      let testNode=node.getFirstChild()
      if(testNode ==undefined){
        expect().assertFail()
      }else{
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
      }})
    it('CustomParserTest_Match_003', 0, async () => {
      let md = '我0123a56a89'
      let myPaser=new MyParser()
      customParsers=[myPaser]
      let node01 = await parseIntoJsNode(md,getOptions(0,cmInlineTags,customParsers))
      let node02=node01.getFirstChild()
      if(node02==undefined || node02.getFirstChild()==undefined){
        expect().assertFail()
      }else{
        //测试节点是子节点的子节点
        let testNode = node02.getFirstChild()
        if(testNode==undefined) {
          expect().assertFail()
        }else{
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

    it('CustomParserTest_Match_004', 0, async () => {
      let md = '<a>fsfsfsddfdsfabd</a>'
      let myPaser=new MyParser()
      customParsers=[myPaser]
      //测试节点是根节点
      let testNode = await parseIntoJsNode(md,getOptions(0,cmInlineTags,customParsers))
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
    it('CustomParserTest_Match_005', 0, async () => {
      let md = '<a>fsfsfsddfdsfabd</a>'
      let myPaser=new MyParser()
      customParsers=[myPaser]
      let node = await parseIntoJsNode(md,getOptions(0,cmInlineTags,customParsers))
      //测试节点是第一个子节点
      let testNode=node.getFirstChild()
      if(testNode ==undefined){
        expect().assertFail()
      }else{
        expect(testNode.getNodeType()).assertEqual("Paragraph")
        expect(testNode.getPrevious()).assertEqual(undefined)
        expect(testNode.getFirstChild()?.getNodeType()).assertEqual("HtmlInline")
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
      }})
    it('CustomParserTest_Match_006', 0, async () => {
      let md = '<a>fsfsfsddfdsfabd</a>'
      let myPaser=new MyParser()
      customParsers=[myPaser]
      let node01 = await parseIntoJsNode(md,getOptions(0,cmInlineTags,customParsers))
      let node02=node01.getFirstChild()
      if(node02==undefined || node02.getFirstChild()==undefined){
        expect().assertFail()
      }else{
        //测试子节点的第一个子节点
        let testNode = node02.getFirstChild()
        if(testNode==undefined) {
          expect().assertFail()
        }else{
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
    it('CustomParserTest_NotMatch_001', 0, async () => {
      let md = '<INSERT_IMAGE id="123456" />'
      let myPaser=new MyParser()
      customParsers=[myPaser]
      //测试节点是根节点
      let testNode = await parseIntoJsNode(md,getOptions(0,cmInlineTags,customParsers))
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
    it('CustomParserTest_NotMatch_002', 0, async () => {
      let md = '<INSERT_IMAGE id="123456" />'
      let myPaser=new MyParser()
      customParsers=[myPaser]
      cmInlineTags=[]
      let node = await parseIntoJsNode(md,getOptions(0,cmInlineTags,customParsers))
      //测试节点是第一个子节点
      let testNode=node.getFirstChild()
      if(testNode ==undefined){
        expect().assertFail()
      }else{
        expect(testNode.getNodeType()).assertEqual("Paragraph")
        expect(testNode.getPrevious()).assertEqual(undefined)
        expect(testNode.getFirstChild()?.getNodeType()).assertEqual("InsertImage")
        expect(testNode.getLastChild()?.getNodeType()).assertEqual("InsertImage")
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
      }})
    it('CustomParserTest_NotMatch_003', 0, async () => {
      let md = '<INSERT_IMAGE id="123456" />'
      let myPaser=new MyParser()
      customParsers=[myPaser]
      let node01 = await parseIntoJsNode(md,getOptions(0,cmInlineTags,customParsers))
      let node02=node01.getFirstChild()
      if(node02==undefined || node02.getFirstChild()==undefined){
        expect().assertFail()
      }else{
        //测试节点是子节点的子节点
        let testNode = node02.getFirstChild()
        if(testNode==undefined) {
          expect().assertFail()
        }else{
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



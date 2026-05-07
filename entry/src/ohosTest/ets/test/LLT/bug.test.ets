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
import { errjson } from './md1';
import { err2 } from './md2';
import { md_latex_1 } from './md3';

export default function bugTest() {
  describe('bugTest', () => {
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
    it('bug1', 0, async () => {
      let doc:JsNode = await parseIntoJsNode(errjson, 2)
      let str = printNode(doc)
      console.error(str)
    })
    it('bug2', 0, async () => {
      let doc:JsNode = await parseIntoJsNode(err2, 2)
      let str = printNode(doc)
      console.error(str)
    })
    it('bugLatex1', 0, async () => {
      let md = `\\[
asd
\\]`
      let doc:JsNode = await parseIntoJsNode(md, 2)
      let str = printNode(doc)
      console.error(md)
      console.error(str)
      let latex: JsNode = doc.getFirstChild()!
      expect(latex.getNodeType()).assertEqual("LatexMathBlock")
      expect(latex['latex']).assertEqual("asd")
    })
    it('bugLatex2', 0, async () => {
      let md = `$$
asd
$$`
      let doc :JsNode= await parseIntoJsNode(md, 2)
      let str = printNode(doc)
      console.error(str)
      let latex: JsNode = doc.getFirstChild()!
      expect(latex.getNodeType()).assertEqual("LatexMathBlock")
      expect(latex['latex']).assertEqual("asd")
    })
    it('bugLatex3', 0, async () => {
      let md = `4. $$a$$ 应该渲染成 $b$`
      let doc:JsNode = await parseIntoJsNode(md, 2)
      let str = printNode(doc)
      console.error(str)
      let p : JsNode|undefined= doc.getFirstChild()?.getFirstChild()?.getFirstChild()
      let latexa: JsNode = p?.getFirstChild()!
      expect(latexa.getNodeType()).assertEqual("LatexMathNode")
      let latexb: JsNode = p?.getLastChild()!
      expect(latexb['latex']).assertEqual("b")
    })
    it('bugLatex_isCosed', 0, async () => {
      let md = `
- **原理**：矩阵乘法在对角矩阵上是对角线元素对应相乘
  $$ D D^{-1} = \text{diag}(d_1 \cdot \frac{1}{d_1}, d_2 \cdot \frac{1}{d_2}, \dots, d_n \cdot \frac{1}{d_n}) = \text{diag}(1, 1, \dots, 1) = I_n $$
- **结论**：逆矩阵确实存在，且为 $D^{-1} = \text{diag}(d_1^{-1}, d_2^{-1}, \dots, d_n^{-1})$


- **对角矩阵的乘法特点**：两个对角矩阵相乘，结果仍是对角矩阵，且**对角线元素就是对应位置元素的乘积**
  $$\begin{pmatrix} a_1 & 0 \\ 0 & a_2 \end{pmatrix} \begin{pmatrix} b_1 & 0 \\ 0 & b_2 \end{pmatrix} = \begin{pmatrix} a_1b_1 & 0 \\ 0 & a_2b_2 \end{pmatrix}$$`
      let doc :JsNode= await parseIntoJsNode(md, 2)
      let str = printNode(doc)
      console.error(str)
      let list = doc.getFirstChild()!
      let latexb1: JsNode = list.getFirstChild()?.getLastChild()!
      expect(latexb1.getNodeType()).assertEqual("LatexMathBlock")
      expect(latexb1[`isClosed`]).assertEqual(true)
      let latex2: JsNode = list.getFirstChild()?.getNext()?.getFirstChild()?.getLastChild()!
      expect(latex2.getNodeType()).assertEqual("LatexMathNode")
      let latexb2: JsNode = list.getLastChild()?.getLastChild()!
      expect(latexb2.getNodeType()).assertEqual("LatexMathBlock")
      expect(latexb2[`isClosed`]).assertEqual(true)
    })
    it('table1', 0, async () => {
      let md = `| h1 | h2 | h3 | h4 |
|:---|---:|:---:|
| a | b | c | d |`
      let doc :JsNode= await parseIntoJsNode(md, 2)
      let str = printNode(doc)
      console.error(str)
      let table: JsNode = doc.getFirstChild()!
      let head: JsNode = doc.getFirstChild()?.getFirstChild()?.getFirstChild()!
      let body1: JsNode = doc.getFirstChild()?.getLastChild()?.getFirstChild()!
      expect(table.getNodeType()).assertEqual("TableBlock")
      expect(head.getFirstChild()!['alignment']).assertEqual("LEFT")
      expect(head.getFirstChild()!['width']).assertEqual(4)
      expect(head.getLastChild()!['alignment']).assertEqual(undefined)
      expect(head.getLastChild()!['width']).assertEqual(0)
      expect(head.getLastChild()?.getPrevious()!['alignment']).assertEqual("CENTER")
      expect(head.getLastChild()?.getPrevious()!['width']).assertEqual(5)
      expect(body1.getFirstChild()!['alignment']).assertEqual("LEFT")
      expect(body1.getFirstChild()!['width']).assertEqual(4)
      expect(body1.getLastChild()!['alignment']).assertEqual(undefined)
      expect(body1.getLastChild()!['width']).assertEqual(0)
      expect(body1.getLastChild()?.getPrevious()!['alignment']).assertEqual("CENTER")
      expect(body1.getLastChild()?.getPrevious()!['width']).assertEqual(5)
    })
    it('auto_link1', 0, async () => {
      let md = `在：https://biso6df2x4pkw.ok.kimi.link 啊在：https://biso6df2x4pkw.ok.kimi.link 啊`
      let doc:JsNode = await parseIntoJsNode(md, 2)
      let str = printNode(doc)
      console.error(str)
      let p: JsNode = doc.getFirstChild()!
      let text0: JsNode = p.getFirstChild()!
      let link1: JsNode = text0.getNext()!
      let text2: JsNode = link1.getNext()!
      let link3: JsNode = text2.getNext()!
      let text4: JsNode = p.getLastChild()!
      expect(text0.getNodeType()).assertEqual("Text")
      expect(link1.getNodeType()).assertEqual("Link")
      expect(text2.getNodeType()).assertEqual("Text")
      expect(link3.getNodeType()).assertEqual("Link")
      expect(text4.getNodeType()).assertEqual("Text")
    })
    it('auto_link2', 0, async () => {
      let md = `已部署至https://7sncmf6ezkojw.ok.kimi.link，可直接访问查看完`
      let doc:JsNode = await parseIntoJsNode(md, 2)
      let str = printNode(doc)
      console.error(str)
      let p: JsNode = doc.getFirstChild()!
      let text0: JsNode = p.getFirstChild()!
      let link1: JsNode = text0.getNext()!
      let text2: JsNode = link1.getNext()!
      expect(text0.getNodeType()).assertEqual("Text")
      expect(text0.getLiteral()).assertEqual("已部署至")
      expect(link1.getNodeType()).assertEqual("Link")
      expect(link1.getDestination()).assertEqual("https://7sncmf6ezkojw.ok.kimi.link")
      expect(text2.getNodeType()).assertEqual("Text")
      expect(text2.getLiteral()).assertEqual("，可直接访问查看完")
    })
    it('delimiter1', 0, async () => {
      let md = `**WARNING：**DON'T TOUCH THE CHILD # NOT WORKING`
      let doc: JsNode = await parseIntoJsNode(md, 2)
      let str = printNode(doc)
      console.error(str)
      let p: JsNode = doc.getFirstChild()!
      let strong0: JsNode = p.getFirstChild()!
      let text1: JsNode = strong0.getNext()!
      expect(strong0.getNodeType()).assertEqual("StrongEmphasis")
      expect(strong0.getFirstChild()!.getLiteral()).assertEqual("WARNING：")
      expect(text1.getNodeType()).assertEqual("Text")
      expect(text1.getLiteral()).assertEqual("DON'T TOUCH THE CHILD # NOT WORKING")
    })
    it('delimiter2', 0, async () => {
      let md = `**WARNING,**DON'T TOUCH THE CHILD # NOT WORKING`
      let doc: JsNode = await parseIntoJsNode(md, 2)
      let str = printNode(doc)
      console.error(str)
      let p: JsNode = doc.getFirstChild()!
      let strong0: JsNode = p.getFirstChild()!
      let text00: JsNode = strong0.getFirstChild()!
      expect(strong0.getNodeType()).assertEqual("StrongEmphasis")
      expect(text00.getNodeType()).assertEqual("Text")
      expect(text00.getLiteral()).assertEqual("WARNING,")
    })
    it('delimiter3', 0, async () => {
      let md = `**[阿克西奥斯]**（/ˈæksɪɒs/）`
      let doc:JsNode = await parseIntoJsNode(md, 2)
      let str = printNode(doc)
      console.error(str)
      let p: JsNode = doc.getFirstChild()!
      let strong0: JsNode = p.getFirstChild()!
      let text1: JsNode = p.getLastChild()!
      expect(strong0.getNodeType()).assertEqual("StrongEmphasis")
      expect(strong0.getFirstChild()!.getNodeType()).assertEqual("Text")
      expect(strong0.getFirstChild()!.getLiteral()).assertEqual("[阿克西奥斯]")
      expect(text1.getNodeType()).assertEqual("Text")
      expect(text1.getLiteral()).assertEqual("（/ˈæksɪɒs/）")
    })
    it('formula1', 0, async () => {
      let md = `设 $V$ 是`
      md = md_latex_1
      md = `设 $V$ 是三维空间中的有界闭区域，其边界 $\partial V$ 是光滑（或分片光滑）的闭合曲面，$\mathbf{F}(x,y,z) = (P, Q, R)$ 是在 $V$ 上连续可微的向量场，则：

$$
\iint_{\partial V} \mathbf{F} \cdot d\mathbf{S} = \iiint_V (\nabla \cdot \mathbf{F}) \, dV
$$`
      let doc: JsNode = await parseIntoJsNode(md, 2)
      let str = printNode(doc)
      console.error(str)
      let p: JsNode = doc.getFirstChild()!
      let text0: JsNode = p.getFirstChild()!
      let latex1: JsNode = text0.getNext()!
      let text2: JsNode = latex1.getNext()!
      let latex3: JsNode = text2.getNext()!
      let text4: JsNode = latex3.getNext()!
      let latex5: JsNode = text4.getNext()!
      let text6: JsNode = latex5.getNext()!
      let latex7: JsNode = text6.getNext()!
      let text8: JsNode = latex7.getNext()!
      expect(text0.getNodeType()).assertEqual(`Text`)
      expect(latex1.getNodeType()).assertEqual(`LatexMathNode`)
      expect(latex1.getLatex()).assertEqual(`V`)
      expect(text2.getNodeType()).assertEqual(`Text`)
      expect(latex3.getNodeType()).assertEqual(`LatexMathNode`)
      expect(latex3.getLatex()).assertEqual(`\partial V`)
      expect(text4.getNodeType()).assertEqual(`Text`)
      expect(latex5.getNodeType()).assertEqual(`LatexMathNode`)
      expect(latex5.getLatex()).assertEqual(`\mathbf{F}(x,y,z) = (P, Q, R)`)
      expect(text6.getNodeType()).assertEqual(`Text`)
      expect(latex7.getNodeType()).assertEqual(`LatexMathNode`)
      expect(latex7.getLatex()).assertEqual(`V`)
      expect(text8.getNodeType()).assertEqual(`Text`)
      let latexBlock: JsNode = doc.getLastChild()!
      expect(latexBlock.getNodeType()).assertEqual(`LatexMathBlock`)
      expect(latexBlock.getLatex()).assertEqual(`\iint_{\partial V} \mathbf{F} \cdot d\mathbf{S} = \iiint_V (\nabla \cdot \mathbf{F}) \, dV`)
    })
  })
}

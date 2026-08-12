import {
  JsNode,
  JsNodeSendableImpl,
  InlineContentParser,
  Options,
  parseIntoJsNode as parseIntoJsNodeHybrid,
} from '@cangjie-tpc/commonmark_hybrid';

export {
  JsNode,
  JsNodeSendableImpl,
  InlineContentParser,
  ParsedInline,
  Options,
  Scanner,
  printNode,
  utf16Index2utf8Index,
  utf8Index2utf16Index,
  cjLib
} from '@cangjie-tpc/commonmark_hybrid';

export async function parseIntoJsNode(md: string, includeSourceSpans: number,
  ...customParsers: Array<InlineContentParser>): Promise<JsNode> {
  return parseIntoJsNodeHybrid(md, {
    includeSourceSpans: includeSourceSpans,
    customParsers: customParsers,
    jsNodeFactory: () => new JsNodeSendableImpl(),
    cmInlineSelfCloseTags: [],
    cmInlineOpenCloseTags: []
  })
}

export function opt(jsNodeFactory: () => JsNode, includeSourceSpans: number): Options {
  return {
    includeSourceSpans: includeSourceSpans,
    jsNodeFactory: jsNodeFactory,
    cmInlineSelfCloseTags: [],
    cmInlineOpenCloseTags: [],
    customParsers: undefined
  }
}
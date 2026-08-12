/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */
import { InlineContentParser } from "./InlineContentParser"
import { JsNode } from "./JsNode"

/*
 * markdown初始化选项
 */
export interface Options {
  /*
   * 用于JsNode复用
   */
  jsNodeFactory: () => JsNode
  /*
   * 是否包含SourceSpan信息 0:不包含(默认) 1:仅Block节点 2:全部节点
   */
  includeSourceSpans: number
  /*
   * 自定义行内自封闭标签
   */
  cmInlineSelfCloseTags?: Array<string>
  /*
   * 自定义行内开闭标签
   */
  cmInlineOpenCloseTags?: Array<string>
  /*
   * 使用js编写自定义解析
   */
  customParsers: Array<InlineContentParser> | undefined
}
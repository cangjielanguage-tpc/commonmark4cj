/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package commonmark_hybrid

internal import commonmark4cj.commonmark.*
internal import commonmark4cj.commonmark.Node as MdNode
internal import commonmark4cj.commonmark.{Text as MdText, HtmlInline as MdHtmlInline, Image as MdImage, Code as MdCode, 
    LinkReferenceDefinition as MdLinkReferenceDefinition, Link as MdLink, StrongEmphasis as MdStrongEmphasis, Emphasis as MdEmphasis, 
    HtmlBlock as MdHtmlBlock, IndentedCodeBlock as MdIndentedCodeBlock, FencedCodeBlock as MdFencedCodeBlock, Heading as MdHeading, 
    ListBlock as MdListBlock, BulletList as MdBulletList, OrderedList as MdOrderedList}
internal import commonmark4cj.table.*
internal import commonmark4cj.strikethrough.*
internal import markdown.core.*
internal import markdown.plugin.*
internal import std.collection.*

let PARSER = Parser.builder().extensions([TablesExtension.create()]).build()

let EXPORT_MODULE = JSModule.registerModule {
    runtime, exports =>
    exports["parseIntoJsNode"] = runtime.function(parseIntoJsNode).toJSValue()
//    exports["parse2Json"] = runtime.function(parse2Json).toJSValue()

    exports["testCJ"] = runtime.function(testCJ).toJSValue()
    exports["splitTextToArr"] = runtime.function(splitTextToArr).toJSValue()
}

func getStackTrace(thrown: ?Exception): String {
    var res: String = ""
    match (thrown) {
        case None => return res
        case Some(v) =>
            res = "\n${v.toString()}\n"
            var arr = v.getStackTrace()
            for (line in arr) {
                res += "      at ${line.declaringClass}.${line.methodName}(${line.fileName}:${line.lineNumber})\n"
            }
            return res
    }
}
func getStackTrace(thrown: ?Error): String {
    var res: String = ""
    match (thrown) {
        case None => return res
        case Some(v) =>
            res = "\n${v.toString()}\n"
            var arr = v.getStackTrace()
            for (line in arr) {
                res += "      at ${line.declaringClass}.${line.methodName}(${line.fileName}:${line.lineNumber})\n"
            }
            return res
    }
}

func getStrArr(context: JSContext, jsValue: JSValue): Array<String> {
    return if (jsValue.isArray()) {
    	JSArrayEx<String>.fromJSValue(context, jsValue).toArray()
    } else {
    	[]
    }
}
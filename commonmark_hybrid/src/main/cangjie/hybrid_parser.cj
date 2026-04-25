/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package commonmark_hybrid

import ohos.ark_interop_macro.Interop
import ohos.hilog.Hilog

public class HybridParser <: SharedObject & JSInteropType<HybridParser> {
    static init() {
        JSModule.registerClass("HybridParser") {
            context =>
                let clazz = context.clazz(jsConstructor)
                clazz.addMethod("parse", context.function(parse_ArkTS_Interop_Identifier))
                return clazz
        }
    }

    public HybridParser(let parser: Markdown, let jsNodeFactory: JSFunction) {}

    public static func jsConstructor(context: JSContext, callInfo: JSCallInfo): JSValue {
        JSCurrentJSContext.set(context)
        let opt = callInfo[0].asObject()
        let jsNodeFactory = opt['jsNodeFactory'].asFunction()
        let includeSourceSpans = Int64.fromJSValue(context, opt['includeSourceSpans'])
        let cmInlineTags: Array<String> = JSArrayEx<String>.fromJSValue(context, opt['cmInlineTags']).toArray()
        let parser = Markdown
            .builder()
            .usePlugin(TaskListPlugin.create()) // 任务列表插件
            .usePlugin(StrikethroughPlugin.create()) // 删除线插件
            .usePlugin(TablePlugin.create()) // 表格插件
            .usePlugin(LatexMathPluginV2.create()) // 数学公式
            .usePlugin(FootnotePlugin.create()) // 脚注
            .usePlugin(LinkifyPlugin.create()) // 自动网址链接
            .usePlugin(TocPlugin.create()) // TOC列表插件
            .usePlugin(Kimi_Inline_Parser)
            .usePlugin(KimiPlugin())
            .usePlugin(CustomTagPlugin(cmInlineTags))
            .includeSourceSpans(includeSourceSpans)
            .build()
        let clazz = HybridParser(parser, jsNodeFactory)

        JSCurrentJSContext.unset()
        let thisArg = callInfo.thisArg
        let thisObject = thisArg.asObject(context)
        let jsExternal = context.external(clazz)
        thisObject.attachCJObject(jsExternal)
        return thisObject.toJSValue()
    }

    public func parse(md: String, context: JSContext): JSValue {
        let promise = context.promiseCapability()
        spawn {
            try {
                let doc: MdNode = parser.parse(md)
                context.postJSTask {
                    try {
                        let jsNodeTreeBuilder = JsNodeBuilder(jsNodeFactory, context)
                        let RET = jsNodeTreeBuilder.buildNode(doc).toJSValue()
                        promise.resolve(RET)
                    } catch (e: Exception) {
                        promise.reject(context.string(e.toString()).toJSValue())
                        Hilog.error(0, 'hybrid Exception 3.1', getStackTrace(e))
                    }
                }
            } catch (e: Exception) {
                throw e
                context.postJSTask {
                    promise.reject(context.string(e.toString()).toJSValue())
                    Hilog.error(0, 'hybrid Exception 2.1', getStackTrace(e))
                }
            }
        }
        return promise.toJSValue()
    }

    public static func parse_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
        try {
            let thisArg = callInfo.thisArg
            let thisObject = thisArg.asObject(context)
            let jsExternal = thisObject.getAttachInfo() ?? throw Exception("class: get external failed.")
            let clazz = jsExternal.cast<HybridParser>() ?? throw Exception("class: get clazz failed.")

            let arg1754444626731223400 = String.fromJSValue(context, callInfo[0])

            JSCurrentJSContext.set(context)
            let RET = clazz.parse(arg1754444626731223400, context)
            JSCurrentJSContext.unset()
            return RET
        } catch (e: Exception) {
            Hilog.error(0, 'hybrid Exception 1.1', e.toString())
        }
        return context.undefined().toJSValue()
    }

    public func toJSValue(context: JSContext): JSValue {
        let ext = context.external(this)
        let obj = context.object()

        obj["parse"] = context.function(parse_ArkTS_Interop_Identifier).toJSValue()

        obj.attachCJObject(ext)
        obj.toJSValue()
    }

    public static func fromJSValue(context: JSContext, input: JSValue): HybridParser {
        let jsObj = input.asObject(context)
        let jsExt = jsObj.getAttachInfo() ?? throw Exception("class: get external failed.")
        let obj = jsExt.cast<HybridParser>() ?? throw Exception("class: get clazz failed.")
        return obj
    }
    public static func toArkTsType(): String {
        "class"
    }
}

/**
@Interop[ArkTS]
public class HybridParser{
    public init() {

    }
    public func parse(md:String):String{
        throw Exception()
    }
}
 */

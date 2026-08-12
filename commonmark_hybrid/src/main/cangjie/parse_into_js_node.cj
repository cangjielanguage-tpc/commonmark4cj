package commonmark_hybrid

extend JSObject {
    func set<T>(name: String, value: Option<T>, context: JSContext): Unit {
        match (value) {
            case Some(v: String) => this[name] = context.string(v).toJSValue()
            case Some(v: Rune) => this[name] = context.string(v.toString()).toJSValue()
            case Some(v: Int64) => this[name] = context.number(Float64(v)).toJSValue()
            case Some(v: Bool) => this[name] = context.boolean(v).toJSValue()
            case Some(v: JSValue) => this[name] = v
            case _ => this[name] = context.undefined().toJSValue()
        }
    }
}

class JsNodeBuilder {
    JsNodeBuilder(let jsNodeConstructor: JSFunction, let context: JSContext) {}

    func buildJsNode(instance: MdNode): JSObject {
        let jsNode = jsNodeConstructor.call().asObject()
        jsNode.set('nodeType', instance.getNodeType(), context)
        jsNode.set('toStr', instance.toString(), context)
        setSourceSpans(instance, jsNode)

        match (instance) {
            case v: JsInlineNode => for ((k, v) in v.props) {
                jsNode.callMethod('putProp', context.string(k).toJSValue(), context.string(v).toJSValue())
            }
            case v: TaskListItem => jsNode.set('isdone', v.isDone(), context)
            case v: LatexMathBlock =>
                jsNode.set('latex', v.latex, context)
                jsNode.set('isClosed', v.isClosed, context)
            case v: LatexMathNode => jsNode.set('latex', v.latex, context)
            case v: Footnote =>
                jsNode.set('noteid', v.noteid, context)
                jsNode.set('blockIndex', v.block?.blockIndex ?? -1, context)
            case v: FootnoteBlock =>
                jsNode.set('noteid', v.noteid, context)
                jsNode.set('blockIndex', v.blockIndex, context)
            case v: HeadLink => jsNode.set('headIndex', v.headIndex, context)
            case v: MdText => jsNode.set('literal', v.getLiteral(), context)
            case v: MdHtmlInline => jsNode.set('literal', v.getLiteral(), context)
            case v: MdImage =>
                jsNode.set('destination', v.getDestination(), context)
                jsNode.set('title', v.getTitle(), context)
            case v: MdCode => jsNode.set('literal', v.getLiteral(), context)
            case v: MdLinkReferenceDefinition =>
                jsNode.set('label', v.getLabel(), context)
                jsNode.set('destination', v.getDestination(), context)
                jsNode.set('title', v.getTitle(), context)
            case v: MdLink =>
                jsNode.set('destination', v.getDestination(), context)
                jsNode.set('title', v.getTitle(), context)
            case v: MdStrongEmphasis => jsNode.set('delimiter', v.getOpeningDelimiter(), context)
            case v: MdEmphasis => jsNode.set('delimiter', v.getOpeningDelimiter(), context)
            case v: MdHtmlBlock => jsNode.set('literal', v.getLiteral(), context)
            case v: MdIndentedCodeBlock => jsNode.set('literal', v.getLiteral(), context)
            case v: MdFencedCodeBlock =>
                jsNode.set('fenceChar', v.getFenceChar(), context)
                jsNode.set('fenceLength', v.getFenceLength(), context)
                jsNode.set('fenceIndent', v.getFenceIndent(), context)
                jsNode.set('info', v.getInfo(), context)
                jsNode.set('literal', v.getLiteral(), context)
            case v: MdHeading => jsNode.set('level', v.getLevel(), context)
            case v: MdBulletList =>
                jsNode.set('tight', v.isTight(), context)
                jsNode.set('bulletMarker', v.getBulletMarker(), context)
            case v: MdOrderedList =>
                jsNode.set('tight', v.isTight(), context)
                jsNode.set('startNumber', v.getStartNumber(), context)
                jsNode.set('delimiter', v.getDelimiter(), context)
            case v: TableCell =>
                jsNode.set('header', v.isHeader(), context)
                jsNode.set('alignment', v.getAlignment()?.toString(), context)
                jsNode.set('width', v.getWidth(), context)
            case v: CustomTag =>
                jsNode.set('tagName', v.tagName, context)
                jsNode.set('content', v.content, context)
                for ((key, value) in v.tagAttrs) {
                    jsNode.callMethod('putProp', context.string(key).toJSValue(), context.string(value).toJSValue())
                }
            case _ => ()
        }
        jsNode
    }

    func buildNode(n: MdNode): JSObject {
        let nodeProxy = buildJsNode(n)
        visitNode(n.getFirstChild(), nodeProxy)
        nodeProxy
    }

    func visitNode(node: ?MdNode, parentProxy: JSObject): Unit {
        let current = node ?? return
        let next = current.getNext()
        let currentProxy = buildJsNode(current)
        parentProxy.callMethod('appendChild', currentProxy.toJSValue())
        visitNode(current.getFirstChild(), currentProxy)
        visitNode(next, parentProxy)
    }

    func setSourceSpans(instance: MdNode, jsNode: JSObject): Unit {
        let sourceSpans = instance.getSourceSpans()
        // 50个一组 批量添加SourceSpan
        for (start in 0..sourceSpans.size : 50) {
            let end = min(start + 50, sourceSpans.size)
            let sourceSpansFlatten = Array<JSValue>((end - start) * 4) {
                i =>
                    let spanIndex = start + i / 4
                    let span = sourceSpans[spanIndex]
                    match (i % 4) {
                        case 0 => context.number(Float64(span.getLineIndex())).toJSValue()
                        case 1 => context.number(Float64(span.getColumnIndex())).toJSValue()
                        case 2 => context.number(Float64(span.getInputIndex())).toJSValue()
                        case _ => context.number(Float64(span.getLength())).toJSValue()
                    }
            }
            jsNode.callMethod('addSourceSpans', sourceSpansFlatten)
        }
    }
}

public func parseIntoJsNode(context: JSContext, callInfo: JSCallInfo): JSValue {
    let md = callInfo[0].toString(context)
    let opt = callInfo[1].asObject()
    let jsNodeFactory = opt['jsNodeFactory'].asFunction()
    let builder = JsNodeBuilder(jsNodeFactory, context)
    let includeSourceSpans: Int = Int64.fromJSValue(context, opt['includeSourceSpans'])
    let cmInlineSelfCloseTags: Array<String> = getStrArr(context, opt['cmInlineSelfCloseTags'])
    let cmInlineOpenCloseTags: Array<String> = getStrArr(context, opt['cmInlineOpenCloseTags'])
    let customParsers = getCustomParsers(opt['customParsers'], context)

    let promise = context.promiseCapability()
    spawn {
        let markdownBuilder: MarkdownBuilder = Markdown
            .builder()
            // 任务列表插件
            .usePlugin(TaskListPlugin.create())
            // 删除线插件
            .usePlugin(StrikethroughPlugin.create())
            // 表格插件
            .usePlugin(TablePlugin.create())
            // 数学公式
            .usePlugin(LatexMathPluginV2.create())
            // 脚注
            .usePlugin(FootnotePlugin.create())
            // 自动网址链接
            .usePlugin(LinkifyPlugin.create())
            // TOC列表插件
            .usePlugin(TocPlugin.create())
            .usePlugin(Kimi_Inline_Parser)
            .usePlugin(KimiPlugin())
            .usePlugin(CustomOpenCloseTagPlugin(cmInlineOpenCloseTags))
            .usePlugin(CustomTagPlugin(cmInlineSelfCloseTags))
            .includeSourceSpans(includeSourceSpans)
        if (let Some(v) <- customParsers) {
            markdownBuilder.usePlugin(v)
        }
        let parser = markdownBuilder.build()
        let doc: MdNode = parser.parse(md)

        context.postJSTask {
            let RET = builder.buildNode(doc).toJSValue()
            promise.resolve(RET)
        }
    }
    return promise.toJSValue()
}

func getCustomParsers(param: JSValue, ctx: JSContext): ?JsPlugin {
    if (param.isUndefined() || param.isNull()) {
        return None
    }
    let arr = param.asArray()
    let factories = Array<JsInlineContentParserFactory>(arr.size) {
        i => JsInlineContentParserFactory(arr[i].asObject(), ctx)
    }
    return JsPlugin(factories)
}

func getCtx(): JSContext {
    let box: Array<?JSContext> = [None]
    JSModule.registerModule(
        {
            ctx, exports =>
                box[0] = ctx
                exports
        }
    )
    return box[0].getOrThrow()
}

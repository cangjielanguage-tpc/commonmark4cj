/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 */

/**
 * Core of commonmark (implementation of CommonMark for parsing markdown and rendering to HTML)
 */
package commonmark4cj.commonmark

internal import std.collection.*
internal import std.convert.*
internal import std.io.*
internal import std.regex.*
internal import std.unicode.*

extend<T> Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}

let NULL_CHAR: Rune = '\u{0}'
let EMPTY_STRING: String = ""
let EMPTY_MAP: HashMap<String, String> = HashMap()
let STRINGBUILDER_CAPACITY: Int64 = 256

type CharSequence = String

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

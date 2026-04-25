/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 */

/**
 * commonmark extension for GFM strikethrough using ~~ (GitHub Flavored Markdown)
 */
package commonmark4cj.table

internal import commonmark4cj.commonmark.*
internal import std.collection.*

extend<T> Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}

func StringFromArrayListByte(sb: ArrayList<Byte>): String {
    unsafe { String.fromUtf8Unchecked(sb.getRawArray()[..sb.size]) }
}

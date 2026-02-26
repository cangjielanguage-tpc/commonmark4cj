/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package commonmark_hybrid

import std.regex.*

class KimiPlugin <: AbstractMarkdownPlugin {
    KimiPlugin() {
    }

    public func configureParser(_: ParserBuilder): Unit {
        Characters.isPunctuationCodePoint = {
            codePoint: Rune =>
            /* delimiter 不判断任何标点 */
            return false
            /*
             * An ASCII punctuation character is
             * ! " # $ % & ' ( ) * + , - . / (U+21–2F)
             * : ; < = > ? @                 (U+3A–40)
             * [ \ ] ^ _ `                   (U+5B–60)
             * { | } ~                       (U+7B–7E)
             * delimiter 只判断ascii标点
            match {
                case r'!' <= codePoint && codePoint <= r'.' => return true
                case r':' <= codePoint && codePoint <= r'@' => return true
                case r'[' <= codePoint && codePoint <= r'`' => return true
                case r'{' <= codePoint && codePoint <= r'~' => return true
                case _ => return false
            }
             */
        }
        LinkifyVisitor.urlreg = Regex(#"https?://[!*'();:@&=+$,/?#[\]a-zA-Z0-9-_.~\p{Han}]+"#, Unicode)
    }

    public func getClassType(): String {
        'KimiPlugin'
    }
}

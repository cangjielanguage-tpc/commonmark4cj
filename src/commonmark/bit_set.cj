/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 */

package commonmark4cj.commonmark

/*
 * 对 ASCII 字符使用位图存储，对非 ASCII 字符使用 HashSet 存储
 */
public class BitSet {
    let words: Array<UInt64> = [0, 0] // 64*2 覆盖ASCII
    private var _rset: ?HashSet<Rune> = None
    prop rset: HashSet<Rune> { // 超出ASCII 情况较少 使用set
        get() {
            if (let Some(v) <- _rset) {
                v
            } else {
                let data = HashSet<Rune>()
                this._rset = data
                data
            }
        }
    }

    /*
     * 与 Scanner 集成，先检查字节，再根据需要检查 Rune
     */
    public func get(scanner: Scanner): Bool {
        let b: Byte = scanner.peek()
        if (get(b)) {
            return true
        } else if (rset.isEmpty()) {
            return false
        } else if (b >> 5 != 0b110) {
            // 只支持Latin范围内
            return false
        } else {
            let r: Rune = scanner.peekRune()
            return rset.contains(r)
        }
    }
    /*
     * 检查 ASCII 字节
     */
    public func get(b: Byte): Bool {
        if (b < 64) {
            return (words[0] >> b & 1) == 1
        } else if (b < 128) {
            return (words[1] >> (b % 64) & 1) == 1
        }
        return false
    }
    /*
     * 检查Rune
     */
    public func get(r: Rune): Bool {
        if (r.isAscii()) {
            return get(UInt8(UInt32(r)))
        } else if (rset.isEmpty()) {
            return false
        } else {
            return rset.contains(r)
        }
    }

    /*
     * 设置Rune
     */
    public func set(r: Rune): Unit {
        let rint = UInt32(r)
        if (rint < 64) {
            words[0] |= (1u64 << rint)
        } else if (rint < 128) {
            words[1] |= (1u64 << (rint % 64))
        } else {
            rset.add(r)
        }
    }

    /*
     * 设置ascii字节
     */
    public func set(b: Byte): Unit {
        if (b < 64) {
            words[0] |= (1u64 << b)
        } else if (b < 128) {
            words[1] |= (1u64 << (b % 64))
        } else {
            throw IllegalArgumentException("Not ASCII Byte")
        }
    }

    public func clone(): BitSet {
        let newSet = BitSet()
        for (i in 0..words.size) {
            newSet.words[i] = this.words[i]
        }
        if (let Some(v) <- _rset) {
            newSet.rset.add(all: v)
        }
        return newSet
    }
}

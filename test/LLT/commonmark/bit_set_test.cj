// EXEC: cjc %import-path %L %l %f --test
// EXEC: ./main

package commonmark

import commonmark4cj.commonmark.*
import std.unittest.*
import std.unittest.testmacro.*

@Test
public class BitSetTest {
    @TestCase
    func test1(): Unit {
        let bb = BitSet()
        let f = {
            => /* for (word in bb.words) {
                println(word.format("064b"))
            } */
        }
        f()
        bb.set(0)
        bb.set(2)
        bb.set(4)
        f()
        println(bb.get(0))
        println(bb.get(1))
        println(bb.get(2))
        println(bb.get(3))
        println(bb.get(4))
        f()
        bb.set(63)
        f()
        bb.set(64)
        f()
    }

    @TestCase
    func bitset_01(): Unit {
        var bit = BitSet()
        @Assert(bit.get(0),false)
        bit.set(20)
        @Assert(bit.get(20),true)
    }

    @TestCase
    func bitset_02(): Unit {
        try {
            var bit = BitSet()
            @Assert(bit.get(922337),false)
            bit.set(922337)
            @Assert(bit.get(922337),true)
        } catch (e: NegativeArraySizeException) {
            @Assert(e.toString(),"NegativeArraySizeException: size < 0: -64")
        }
    }

    @TestCase
    func bitset_03(): Unit {
        var bit = BitSet()
        @Assert(bit.get(214748),false)
        bit.set(214748)
        @Assert(bit.get(214748),true)
    }

    @TestCase
    func bitset_04(): Unit {
        var bit = BitSet()
        @Assert(bit.get(21474),false)
        bit.set(21474)
        @Assert(bit.get(21474),true)
    }

    @TestCase
    func bitset_05(): Unit {
        var bit = BitSet()
        @Assert(bit.get(21474),false)
        bit.set(0)
        @Assert(bit.get(0),true)
    }

    @TestCase
    func bitset_06(): Unit {
        var bit = BitSet()
        @Assert(bit.get(214748),false)
        bit.set(214748)
        @Assert(bit.get(214748),true)
    }

    @TestCase
    func bitset_07(): Unit {
        try {
            var bit = BitSet()
            @Assert(bit.get(214748),false)
            bit.set(-214748)
        } catch (e: IllegalArgumentException) {
        }
    }

    @TestCase
    func bitset_08(): Unit {
        var bit = BitSet()
        bit.set(214748)
        @Assert(bit.get(214748),true)
    }

    @TestCase
    func bitset_09(): Unit {
        var bit = BitSet()
        bit.set(214748)
        @Assert(bit.get(0),false)
    }

    @TestCase
    func bitset_10(): Unit {
        var bit = BitSet()
        bit.set(214748)
        @Assert(bit.get(26),false)
    }

    @TestCase
    func bitset_11(): Unit {
        var bit = BitSet()
        var bit1 = BitSet()
        bit1.set(1)
        @Assert(bit.get(1),false)
        // bit.or(bit1)
        // @Assert(bit.get(1),true)
    }
}

let BitSet_max_int: Int64 = Int64(UInt32.Max)

extend BitSet {
    func get(i: Int64): Bool {
        let r = validate(i)
        return this.get(r)
    }
    func set(i: Int64): Unit {
        let r = validate(i)
        return this.set(r)
    }

    @OverflowWrapping
    func validate(i: Int64): Rune {
        let u32 = UInt32(i)
        if (Int64(u32) != i) {
            throw IllegalArgumentException("BitSet only support ASCII-Byte and Rune-UInt32")
        }
        return Rune(u32)
    }
}

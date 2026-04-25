import commonmark4cj.commonmark.*
import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import std.reflect.*
import std.collection.*
import std.fs.*

func assertEquals<T>(msg: String, expected: T, actual: T): Unit where T <: Equatable<T> {
    if (expected != actual) {
        throw Exception(msg)
    }
}

func assertEquals<T>(expected: T, actual: T): Unit where T <: Equatable<T> {
    @PowerAssert(expected == actual)
}

func assertNotEquals<T>(expected: T, actual: T): Unit where T <: Equatable<T> {
    @PowerAssert(expected != actual)
}

func assertNull<T>(any: ?T): Unit {
    if (any.isSome()) {
        throw Exception("expected null, but was:Some()")
    }
}

extend<T> Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}

public class Strings {
    public static func repeat(s: String, count: Int64): String {
        var sb: StringBuilder = StringBuilder(s.toRuneArray().size * count)
        for (_ in 0..count) {
            sb.append(s)
        }
        return sb.toString()
    }
}

public class Example {
    private var filename: String
    private var section: String
    private var info: String
    private var exampleNumber: Int64
    private var source: String
    private var html: String

    public init(filename: String, section: String, info: String, exampleNumber: Int64, source: String, html: String) {
        this.filename = filename
        this.section = section
        this.info = info
        this.exampleNumber = exampleNumber
        this.source = source
        this.html = html
    }

    public func getInfo(): String {
        return info
    }

    public func getSource(): String {
        return source
    }

    public func getHtml(): String {
        return html
    }

    public func toString(): String {
        return "File \"" + filename + "\" section \"" + section + "\" example ${exampleNumber}"
    }
}

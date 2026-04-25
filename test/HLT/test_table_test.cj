// 3rd_party_lib:commonmark4cj/build/release/commonmark4cj
// 3rd_party_lib_ohos:commonmark4cj/build/aarch64-linux-ohos/commonmark4cj
// dependence: z_test.cj

import commonmark4cj.commonmark.*
import commonmark4cj.table.*
import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import std.collection.*
import std.regex.{Regex, Matcher, MatchData, RegexOption, Position}

@Test
public class TableTT {
    @TestCase
    func mustHaveHeaderAndSeparator(): Unit {
        let tt: TablesTest = TablesTest()
        @PowerAssert(tt.assertRendering("Abc|Def", "<p>Abc|Def</p>\n") == true)
        @PowerAssert(tt.assertRendering("Abc | Def", "<p>Abc | Def</p>\n") == true)
    }

    @TestCase
    func separatorMustBeOneOrMore(): Unit {
        let tt: TablesTest = TablesTest()
        @PowerAssert(tt.assertRendering("Abc|Def\n-|-", "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th>Abc</th>\n" +
                "<th>Def</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "</table>\n") == true)
        @PowerAssert(tt.assertRendering("Abc|Def\n--|--", "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th>Abc</th>\n" +
                "<th>Def</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "</table>\n") == true)
    }

    @TestCase
    func separatorMustNotContainInvalidChars(): Unit {
        let tt: TablesTest = TablesTest()
        @PowerAssert(tt.assertRendering("Abc|Def\n |-a-|---", "<p>Abc|Def\n|-a-|---</p>\n") == true)
        @PowerAssert(tt.assertRendering("Abc|Def\n |:--a|---", "<p>Abc|Def\n|:--a|---</p>\n") == true)
        @PowerAssert(tt.assertRendering("Abc|Def\n |:--a--:|---", "<p>Abc|Def\n|:--a--:|---</p>\n") == true)
    }

    @TestCase
    func separatorCanHaveLeadingSpaceThenPipe(): Unit {
        let tt: TablesTest = TablesTest()
        @PowerAssert(tt.assertRendering("Abc|Def\n |---|---", "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th>Abc</th>\n" +
                "<th>Def</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "</table>\n") == true)
        @PowerAssert(tt.assertRendering("Abc|Def\n---||---", "<p>Abc|Def\n---||---</p>\n") == true)
        @PowerAssert(tt.assertRendering("Abc|Def\n|--- ---", "<p>Abc|Def\n|--- ---</p>\n") == true)
        @PowerAssert(tt.assertRendering("No\nAbc|Def\n---|---", "<p>No</p>\n<table>\n<thead>\n<tr>\n<th>Abc</th>\n<th>Def</th>\n</tr>\n</thead>\n</table>\n") == true)
        @PowerAssert(tt.assertRendering("Abc|Def\n---|---", "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th>Abc</th>\n" +
                "<th>Def</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "</table>\n") == true)
        let expected = "<table>\n" + "<thead>\n" + "<tr>\n" + "<th>Abc</th>\n" + "</tr>\n" + "</thead>\n" + "</table>\n"
        @PowerAssert(tt.assertRendering("|Abc\n|---\n", expected) == true)

        @PowerAssert(tt.assertRendering("|Abc|\n|---|\n", expected) == true)
        @PowerAssert(tt.assertRendering("Abc|\n---|\n", expected) == true)
        @PowerAssert(tt.assertRendering("|Abc\n---\n", "<h2>|Abc</h2>\n") == true)
        @PowerAssert(tt.assertRendering("Abc\n|---\n", "<p>Abc\n|---</p>\n") == true)

        let expected2 = "<table>\n" + "<thead>\n" + "<tr>\n" + "<th>Abc</th>\n" + "</tr>\n" + "</thead>\n" + "<tbody>\n" +
            "<tr>\n" + "<td>1</td>\n" + "</tr>\n" + "</tbody>\n" + "</table>\n"
        @PowerAssert(tt.assertRendering("|Abc\n|---\n|1", expected2) == true)

        @PowerAssert(tt.assertRendering("|Abc|\n|---|\n|1|", expected2) == true)
        @PowerAssert(tt.assertRendering("Abc|\n---|\n1|", expected2) == true)
        @PowerAssert(tt.assertRendering("|Abc\n---\n|1", "<h2>|Abc</h2>\n<p>|1</p>\n") == true)

        @PowerAssert(tt.assertRendering("Abc|Def\n---|---\n1|2", "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th>Abc</th>\n" +
                "<th>Def</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "<tbody>\n" +
                "<tr>\n" +
                "<td>1</td>\n" +
                "<td>2</td>\n" +
                "</tr>\n" +
                "</tbody>\n" +
                "</table>\n") == true)

        @PowerAssert(tt.assertRendering("Abc|Def|Ghi\n---|---\n1|2|3", "<p>Abc|Def|Ghi\n---|---\n1|2|3</p>\n") == true)

        @PowerAssert(tt.assertRendering(" Abc  | Def \n --- | --- \n 1 | 2 ", "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th>Abc</th>\n" +
                "<th>Def</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "<tbody>\n" +
                "<tr>\n" +
                "<td>1</td>\n" +
                "<td>2</td>\n" +
                "</tr>\n" +
                "</tbody>\n" +
                "</table>\n") == true)

        @PowerAssert(tt.assertRendering("Abc|Def\n---|---\n    1|2", "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th>Abc</th>\n" +
                "<th>Def</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "<tbody>\n" +
                "<tr>\n" +
                "<td>1</td>\n" +
                "<td>2</td>\n" +
                "</tr>\n" +
                "</tbody>\n" +
                "</table>\n") == true)

        @PowerAssert(tt.assertRendering("|Abc|Def|\n|---|---|\n|1|2|", "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th>Abc</th>\n" +
                "<th>Def</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "<tbody>\n" +
                "<tr>\n" +
                "<td>1</td>\n" +
                "<td>2</td>\n" +
                "</tr>\n" +
                "</tbody>\n" +
                "</table>\n") == true)

        @PowerAssert(tt.assertRendering("*Abc*|Def\n---|---\n1|2", "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th><em>Abc</em></th>\n" +
                "<th>Def</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "<tbody>\n" +
                "<tr>\n" +
                "<td>1</td>\n" +
                "<td>2</td>\n" +
                "</tr>\n" +
                "</tbody>\n" +
                "</table>\n") == true)

        @PowerAssert(tt.assertRendering("Abc|Def\n---|---\n1\\|2|20", "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th>Abc</th>\n" +
                "<th>Def</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "<tbody>\n" +
                "<tr>\n" +
                "<td>1|2</td>\n" +
                "<td>20</td>\n" +
                "</tr>\n" +
                "</tbody>\n" +
                "</table>\n") == true)

        @PowerAssert(tt.assertRendering("Abc|Def\n---|---\n1\\\\|2", "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th>Abc</th>\n" +
                "<th>Def</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "<tbody>\n" +
                "<tr>\n" +
                "<td>1|2</td>\n" +
                "<td></td>\n" +
                "</tr>\n" +
                "</tbody>\n" +
                "</table>\n") == true)

        @PowerAssert(tt.assertRendering("Abc|Def\n---|---\n1|\\`not code`", "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th>Abc</th>\n" +
                "<th>Def</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "<tbody>\n" +
                "<tr>\n" +
                "<td>1</td>\n" +
                "<td>`not code`</td>\n" +
                "</tr>\n" +
                "</tbody>\n" +
                "</table>\n") == true)

        @PowerAssert(tt.assertRendering("Abc|Def\n---|---\n1|2\\", "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th>Abc</th>\n" +
                "<th>Def</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "<tbody>\n" +
                "<tr>\n" +
                "<td>1</td>\n" +
                "<td>2\\</td>\n" +
                "</tr>\n" +
                "</tbody>\n" +
                "</table>\n") == true)

        @PowerAssert(tt.assertRendering("Abc|Def\n:-|-\n1|2", "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th align=\"left\">Abc</th>\n" +
                "<th>Def</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "<tbody>\n" +
                "<tr>\n" +
                "<td align=\"left\">1</td>\n" +
                "<td>2</td>\n" +
                "</tr>\n" +
                "</tbody>\n" +
                "</table>\n") == true)

        @PowerAssert(tt.assertRendering("Abc|Def\n:-|-\n1|2", "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th align=\"left\">Abc</th>\n" +
                "<th>Def</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "<tbody>\n" +
                "<tr>\n" +
                "<td align=\"left\">1</td>\n" +
                "<td>2</td>\n" +
                "</tr>\n" +
                "</tbody>\n" +
                "</table>\n") == true)

        @PowerAssert(tt.assertRendering("Abc|Def\n:---|---\n1|2", "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th align=\"left\">Abc</th>\n" +
                "<th>Def</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "<tbody>\n" +
                "<tr>\n" +
                "<td align=\"left\">1</td>\n" +
                "<td>2</td>\n" +
                "</tr>\n" +
                "</tbody>\n" +
                "</table>\n") == true)
        @PowerAssert(tt.assertRendering("Abc|Def\n-:|-\n1|2", "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th align=\"right\">Abc</th>\n" +
                "<th>Def</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "<tbody>\n" +
                "<tr>\n" +
                "<td align=\"right\">1</td>\n" +
                "<td>2</td>\n" +
                "</tr>\n" +
                "</tbody>\n" +
                "</table>\n") == true)
        @PowerAssert(tt.assertRendering("Abc|Def\n--:|--\n1|2", "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th align=\"right\">Abc</th>\n" +
                "<th>Def</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "<tbody>\n" +
                "<tr>\n" +
                "<td align=\"right\">1</td>\n" +
                "<td>2</td>\n" +
                "</tr>\n" +
                "</tbody>\n" +
                "</table>\n") == true)
        @PowerAssert(tt.assertRendering("Abc|Def\n---:|---\n1|2", "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th align=\"right\">Abc</th>\n" +
                "<th>Def</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "<tbody>\n" +
                "<tr>\n" +
                "<td align=\"right\">1</td>\n" +
                "<td>2</td>\n" +
                "</tr>\n" +
                "</tbody>\n" +
                "</table>\n") == true)
        @PowerAssert(tt.assertRendering("Abc|Def\n:-:|-\n1|2", "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th align=\"center\">Abc</th>\n" +
                "<th>Def</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "<tbody>\n" +
                "<tr>\n" +
                "<td align=\"center\">1</td>\n" +
                "<td>2</td>\n" +
                "</tr>\n" +
                "</tbody>\n" +
                "</table>\n") == true)
        @PowerAssert(tt.assertRendering("Abc|Def\n:--:|--\n1|2", "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th align=\"center\">Abc</th>\n" +
                "<th>Def</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "<tbody>\n" +
                "<tr>\n" +
                "<td align=\"center\">1</td>\n" +
                "<td>2</td>\n" +
                "</tr>\n" +
                "</tbody>\n" +
                "</table>\n") == true)

        @PowerAssert(tt.assertRendering("Abc|Def\n:---:|---\n1|2", "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th align=\"center\">Abc</th>\n" +
                "<th>Def</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "<tbody>\n" +
                "<tr>\n" +
                "<td align=\"center\">1</td>\n" +
                "<td>2</td>\n" +
                "</tr>\n" +
                "</tbody>\n" +
                "</table>\n") == true)
        @PowerAssert(tt.assertRendering("Abc|Def\n---|:---:\n1|2", "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th>Abc</th>\n" +
                "<th align=\"center\">Def</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "<tbody>\n" +
                "<tr>\n" +
                "<td>1</td>\n" +
                "<td align=\"center\">2</td>\n" +
                "</tr>\n" +
                "</tbody>\n" +
                "</table>\n") == true)

        @PowerAssert(tt.assertRendering("Abc|Def\n :--- |---\n1|2", "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th align=\"left\">Abc</th>\n" +
                "<th>Def</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "<tbody>\n" +
                "<tr>\n" +
                "<td align=\"left\">1</td>\n" +
                "<td>2</td>\n" +
                "</tr>\n" +
                "</tbody>\n" +
                "</table>\n") == true)
        @PowerAssert(tt.assertRendering("Abc|Def\n: ---|---", "<p>Abc|Def\n: ---|---</p>\n") == true)
        @PowerAssert(tt.assertRendering("Abc|Def\n--- :|---", "<p>Abc|Def\n--- :|---</p>\n") == true)
        @PowerAssert(tt.assertRendering("Abc|Def\n---|: ---", "<p>Abc|Def\n---|: ---</p>\n") == true)
        @PowerAssert(tt.assertRendering("Abc|Def\n---|--- :", "<p>Abc|Def\n---|--- :</p>\n") == true)

        @PowerAssert(tt.assertRendering("Abc|Def\n---|---\n1|2|3", "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th>Abc</th>\n" +
                "<th>Def</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "<tbody>\n" +
                "<tr>\n" +
                "<td>1</td>\n" +
                "<td>2</td>\n" +
                "</tr>\n" +
                "</tbody>\n" +
                "</table>\n") == true)
        @PowerAssert(tt.assertRendering("Abc|Def|Ghi\n---|---|---\n1|2", "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th>Abc</th>\n" +
                "<th>Def</th>\n" +
                "<th>Ghi</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "<tbody>\n" +
                "<tr>\n" +
                "<td>1</td>\n" +
                "<td>2</td>\n" +
                "<td></td>\n" +
                "</tr>\n" +
                "</tbody>\n" +
                "</table>\n") == true)

        @PowerAssert(tt.assertRendering("> Abc|Def\n> ---|---\n> 1|2", "<blockquote>\n" +
                "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th>Abc</th>\n" +
                "<th>Def</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "<tbody>\n" +
                "<tr>\n" +
                "<td>1</td>\n" +
                "<td>2</td>\n" +
                "</tr>\n" +
                "</tbody>\n" +
                "</table>\n" +
                "</blockquote>\n") == true)
        @PowerAssert(tt.assertRendering("Abc|Def\n---|---\n1|2\nlazy", "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th>Abc</th>\n" +
                "<th>Def</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "<tbody>\n" +
                "<tr>\n" +
                "<td>1</td>\n" +
                "<td>2</td>\n" +
                "</tr>\n" +
                "<tr>\n" +
                "<td>lazy</td>\n" +
                "<td></td>\n" +
                "</tr>\n" +
                "</tbody>\n" +
                "</table>\n") == true)

        @PowerAssert(tt.assertRendering("||Alveolar|Bilabial\n" +
                        "|:--|:-:|:-:\n" +
                        "|**Plosive**|t, d|b\n" +
                        "|**Tap**|ɾ|",
                "<table>\n" +
                        "<thead>\n" +
                        "<tr>\n" +
                        "<th align=\"left\"></th>\n" +
                        "<th align=\"center\">Alveolar</th>\n" +
                        "<th align=\"center\">Bilabial</th>\n" +
                        "</tr>\n" +
                        "</thead>\n" +
                        "<tbody>\n" +
                        "<tr>\n" +
                        "<td align=\"left\"><strong>Plosive</strong></td>\n" +
                        "<td align=\"center\">t, d</td>\n" +
                        "<td align=\"center\">b</td>\n" +
                        "</tr>\n" +
                        "<tr>\n" +
                        "<td align=\"left\"><strong>Tap</strong></td>\n" +
                        "<td align=\"center\">ɾ</td>\n" +
                        "<td align=\"center\"></td>\n" +
                        "</tr>\n" +
                        "</tbody>\n" +
                        "</table>\n") == true)
    }

    @TestCase
    func stringTest(): Unit {
        let s = "ɾ"
        let cArray = s.toRuneArray()
        @PowerAssert(s.size == 2)
        @PowerAssert(cArray.size == 1)

        @PowerAssert(s.toArray() == [UInt8(201), UInt8(190)])
        @PowerAssert(cArray == [r'ɾ'])
    }

    @TestCase
    func testTablesSpec(): Unit {
        let tt: TablesTest = TablesTest()
        @PowerAssert(tt.assertRendering("| foo | bar |\n| --- | --- |\n| baz | bim |\n", "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th>foo</th>\n" +
                "<th>bar</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "<tbody>\n" +
                "<tr>\n" +
                "<td>baz</td>\n" +
                "<td>bim</td>\n" +
                "</tr>\n" +
                "</tbody>\n" +
                "</table>\n"))

        @PowerAssert(tt.assertRendering("| abc | defghi |\n:-: | -----------:\nbar | baz\n", "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th align=\"center\">abc</th>\n" +
                "<th align=\"right\">defghi</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "<tbody>\n" +
                "<tr>\n" +
                "<td align=\"center\">bar</td>\n" +
                "<td align=\"right\">baz</td>\n" +
                "</tr>\n" +
                "</tbody>\n" +
                "</table>\n"))

        @PowerAssert(tt.assertRendering("| f\\|oo  |\n| ------ |\n| b `\\|` az |\n| b **\\|** im |\n", "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th>f|oo</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "<tbody>\n" +
                "<tr>\n" +
                "<td>b <code>|</code> az</td>\n" +
                "</tr>\n" +
                "<tr>\n" +
                "<td>b <strong>|</strong> im</td>\n" +
                "</tr>\n" +
                "</tbody>\n" +
                "</table>\n"))

        @PowerAssert(tt.assertRendering("| abc | def |\n| --- | --- |\n| bar | baz |\n> bar\n", "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th>abc</th>\n" +
                "<th>def</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "<tbody>\n" +
                "<tr>\n" +
                "<td>bar</td>\n" +
                "<td>baz</td>\n" +
                "</tr>\n" +
                "</tbody>\n" +
                "</table>\n" +
                "<blockquote>\n" +
                "<p>bar</p>\n" +
                "</blockquote>\n"))

        @PowerAssert(tt.assertRendering("| abc | def |\n| --- | --- |\n| bar | baz |\nbar\n\nbar\n", "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th>abc</th>\n" +
                "<th>def</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "<tbody>\n" +
                "<tr>\n" +
                "<td>bar</td>\n" +
                "<td>baz</td>\n" +
                "</tr>\n" +
                "<tr>\n" +
                "<td>bar</td>\n" +
                "<td></td>\n" +
                "</tr>\n" +
                "</tbody>\n" +
                "</table>\n" +
                "<p>bar</p>\n"))

        @PowerAssert(tt.assertRendering("| abc | def |\n| --- |\n| bar |\n", "<p>| abc | def |\n" +
                "| --- |\n" +
                "| bar |</p>\n"))

        @PowerAssert(tt.assertRendering("| abc | def |\n| --- | --- |\n| bar |\n| bar | baz | boo |\n", "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th>abc</th>\n" +
                "<th>def</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "<tbody>\n" +
                "<tr>\n" +
                "<td>bar</td>\n" +
                "<td></td>\n" +
                "</tr>\n" +
                "<tr>\n" +
                "<td>bar</td>\n" +
                "<td>baz</td>\n" +
                "</tr>\n" +
                "</tbody>\n" +
                "</table>\n"))

        @PowerAssert(tt.assertRendering("| abc | def |\n| --- | --- |\n", "<table>\n" +
                "<thead>\n" +
                "<tr>\n" +
                "<th>abc</th>\n" +
                "<th>def</th>\n" +
                "</tr>\n" +
                "</thead>\n" +
                "</table>\n"))
    }

    @TestCase
    func TestTablesTextContent(): Unit {
        let tt: TablesTextContentTest = TablesTextContentTest()
        @PowerAssert(tt.assertRendering("Abc|Def\n---|---", "Abc| Def\n"))

        let expected = "Abc\n"
        @PowerAssert(tt.assertRendering("|Abc\n|---\n", expected))
        @PowerAssert(tt.assertRendering("|Abc|\n|---|\n", expected))
        @PowerAssert(tt.assertRendering("Abc|\n---|\n", expected))
        @PowerAssert(tt.assertRendering("|Abc\n---\n", "|Abc"))
        @PowerAssert(tt.assertRendering("Abc\n|---\n", "Abc\n|---"))

        let expected2 = "Abc\n1\n"
        @PowerAssert(tt.assertRendering("|Abc\n|---\n|1", expected2))
        @PowerAssert(tt.assertRendering("|Abc|\n|---|\n|1|", expected2))
        @PowerAssert(tt.assertRendering("Abc|\n---|\n1|", expected2))
        @PowerAssert(tt.assertRendering("|Abc\n---\n|1", "|Abc\n|1"))

        @PowerAssert(tt.assertRendering("Abc|Def\n---|---\n1|2", "Abc| Def\n1| 2\n"))

        @PowerAssert(tt.assertRendering("Abc|Def|Ghi\n---|---\n1|2|3", "Abc|Def|Ghi\n---|---\n1|2|3"))

        @PowerAssert(tt.assertRendering(" Abc  | Def \n --- | --- \n 1 | 2 ", "Abc| Def\n1| 2\n"))

        @PowerAssert(tt.assertRendering("Abc|Def\n---|---\n    1|2", "Abc| Def\n1| 2\n"))

        @PowerAssert(tt.assertRendering("|Abc|Def|\n|---|---|\n|1|2|", "Abc| Def\n1| 2\n"))

        @PowerAssert(tt.assertRendering("*Abc*|Def\n---|---\n1|2", "Abc| Def\n1| 2\n"))

        @PowerAssert(tt.assertRendering("Abc|Def\n---|---\n1\\|2|20", "Abc| Def\n1|2| 20\n"))

        @PowerAssert(tt.assertRendering("Abc|Def\n:---|---\n1|2", "Abc| Def\n1| 2\n"))

        @PowerAssert(tt.assertRendering("Abc|Def\n---:|---\n1|2", "Abc| Def\n1| 2\n"))

        @PowerAssert(tt.assertRendering("Abc|Def\n:---:|---\n1|2", "Abc| Def\n1| 2\n"))

        @PowerAssert(tt.assertRendering("Abc|Def\n---|:---:\n1|2", "Abc| Def\n1| 2\n"))

        @PowerAssert(tt.assertRendering("Abc|Def\n :--- |---\n1|2", "Abc| Def\n1| 2\n"))

        @PowerAssert(tt.assertRendering("Abc|Def\n: ---|---", "Abc|Def\n: ---|---"))
        @PowerAssert(tt.assertRendering("Abc|Def\n--- :|---", "Abc|Def\n--- :|---"))
        @PowerAssert(tt.assertRendering("Abc|Def\n---|: ---", "Abc|Def\n---|: ---"))
        @PowerAssert(tt.assertRendering("Abc|Def\n---|--- :", "Abc|Def\n---|--- :"))

        @PowerAssert(tt.assertRendering("Abc|Def\n---|---\n1|2|3", "Abc| Def\n1| 2\n"))

        @PowerAssert(tt.assertRendering("Abc|Def|Ghi\n---|---|---\n1|2", "Abc| Def| Ghi\n1| 2| \n"))

        @PowerAssert(tt.assertRendering("> Abc|Def\n> ---|---\n> 1|2", "«\nAbc| Def\n1| 2\n»"))

        @PowerAssert(tt.assertRendering("Abc|Def\n---|---\n1|2\nlazy", "Abc| Def\n1| 2\nlazy| \n"))
    }
}

public abstract class RenderingTestCase {
    protected func render(source: String): String

    public func assertRendering(source: String, expectedResult: String): Bool {
        let renderedContent: String = render(source)
        // include source for better assertion errors
        let expected: String = showTabs(expectedResult + "\n\n" + source)
        let actual: String = showTabs(renderedContent + "\n\n" + source)
        return expected.toString() == actual.toString()
    }

    private static func showTabs(s: String): String {
        // Tabs are shown as "rightwards arrow" for easier comparison
        return s.replace("\t", "\u{2192}")
    }
}

public class TablesTest <: RenderingTestCase {
    private static let EXTENSIONS: Array<Extension> = [TablesExtension.create()]
    private static let PARSER: Parser = Parser.builder().extensions(EXTENSIONS).build()
    private static let RENDERER: HtmlRenderer = HtmlRenderer.builder().extensions(EXTENSIONS).build()

    protected override func render(source: String): String {
        return RENDERER.render(PARSER.parse(source))
    }
}

public class TablesTextContentTest <: RenderingTestCase {
    private static let EXTENSIONS: Array<Extension> = [TablesExtension.create()]
    private static let PARSER: Parser = Parser.builder().extensions(EXTENSIONS).build()
    private static let RENDERER: TextContentRenderer = TextContentRenderer.builder().extensions(EXTENSIONS).build()

    protected override func render(source: String): String {
        return RENDERER.render(PARSER.parse(source))
    }
}

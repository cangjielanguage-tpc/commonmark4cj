// DEPENDENCE: ../z_test.cj
// EXEC: cjc %import-path %L %l %f z_test.cj --test
// EXEC: ./main
// --filter=t11

import commonmark4cj.commonmark.*
import commonmark4cj.table.*

let EXTENSIONS: Array<Extension> = [TablesExtension.create()]
let md: Parser = Parser.builder().extensions(EXTENSIONS).build()

@Test
func t11(): Unit {
    let str = #"
以下为你提供包含不同类别食物的表格：
- |食物类别|具体食物|热量信息（参考）|
  | ---- | ---- |
  |主食类|米饭、面条、馒头、面包|3|
"#
    let node = md.parse(str)
    @Assert(node.getLastChild()() is BulletList)
    @Assert(node.getLastChild()().getLastChild()().getLastChild()() is Paragraph)
}

@Test
func t12(): Unit {
    let str = #"
以下为你提供包含不同类别食物的表格：

- |食物类别|具体食物|热量信息（参考）|
  | ---- | ---- |
  |主食类|米饭、面条、馒头、面包|3|
"#
    let node = md.parse(str)
    @Assert(node.getLastChild()() is BulletList)
    @Assert(node.getLastChild()().getLastChild()().getLastChild()() is Paragraph)
}

@Test
func t13(): Unit {
    let str = #"
以下为你提供包含不同类别食物的表格：

- |食物类别|具体食物|热量信息（参考）|
  | ---- | ---- | ---- |
  |主食类|米饭、面条、馒头、面包|3|
"#
    let node = md.parse(str)
    @Assert(node.getLastChild()() is BulletList)
    @Assert(node.getLastChild()().getLastChild()().getLastChild()() is TableBlock)
}

@Test
func t14(): Unit {
    let str = #"
以下为你提供包含不同类别食物的表格：
- |食物类别|具体食物|热量信息（参考）|
  | ---- | ---- | ---- |
  |主食类|米饭、面条、馒头、面包|3|
"#
    let node = md.parse(str)
    @Assert(node.getLastChild()() is BulletList)
    @Assert(node.getLastChild()().getLastChild()().getLastChild()() is TableBlock)
}

@Test
func t21(): Unit {
    let str = #"
以下为你提供包含不同类别食物的表格：
> |食物类别|具体食物|热量信息（参考）|
> | ---- | ---- |
> |主食类|米饭、面条、馒头、面包|3|
"#
    let node = md.parse(str)
    @Assert(node.getLastChild()() is BlockQuote)
    @Assert(node.getLastChild()().getLastChild()() is Paragraph)
}

@Test
func t22(): Unit {
    let str = #"
以下为你提供包含不同类别食物的表格：

> |食物类别|具体食物|热量信息（参考）|
> | ---- | ---- |
> |主食类|米饭、面条、馒头、面包|3|
"#
    let node = md.parse(str)
    @Assert(node.getLastChild()() is BlockQuote)
    @Assert(node.getLastChild()().getLastChild()() is Paragraph)
}

@Test
func t23(): Unit {
    let str = #"
以下为你提供包含不同类别食物的表格：

> |食物类别|具体食物|热量信息（参考）|
> | ---- | ---- | ---- |
> |主食类|米饭、面条、馒头、面包|3|
"#
    let node = md.parse(str)
    @Assert(node.getLastChild()() is BlockQuote)
    @Assert(node.getLastChild()().getLastChild()() is TableBlock)
}

@Test
func t24(): Unit {
    let str = #"
以下为你提供包含不同类别食物的表格：
> |食物类别|具体食物|热量信息（参考）|
> | ---- | ---- | ---- |
> |主食类|米饭、面条、馒头、面包|3|
"#
    let node = md.parse(str)
    @Assert(node.getLastChild()() is BlockQuote)
    @Assert(node.getLastChild()().getLastChild()() is TableBlock)
}

@Test
func t31(): Unit {
    let str = #"
以下为你提供包含不同类别食物的表格：
|食物类别|具体食物|热量信息（参考）|
| ---- | ---- |
|主食类|米饭、面条、馒头、面包|3|
"#
    let node = md.parse(str)
    @Assert(node.getLastChild()() is Paragraph)
    @Assert(refEq(node.getFirstChild()(),node.getLastChild()()))
}

@Test
func t32(): Unit {
    let str = #"
以下为你提供包含不同类别食物的表格：

|食物类别|具体食物|热量信息（参考）|
| ---- | ---- |
|主食类|米饭、面条、馒头、面包|3|
"#
    let node = md.parse(str)
    @Assert(node.getLastChild()() is Paragraph)
    @Assert(!refEq(node.getFirstChild()(),node.getLastChild()()))
}

@Test
func t33(): Unit {
    let str = #"
以下为你提供包含不同类别食物的表格：

|食物类别|具体食物|热量信息（参考）|
| ---- | ---- | ---- |
|主食类|米饭、面条、馒头、面包|3|
"#
    let node = md.parse(str)
    @Assert(node.getLastChild()() is TableBlock)
}

@Test
func t34(): Unit {
    let str = #"
以下为你提供包含不同类别食物的表格：
|食物类别|具体食物|热量信息（参考）|
| ---- | ---- | ---- |
|主食类|米饭、面条、馒头、面包|3|
"#
    let node = md.parse(str)
    @Assert(node.getLastChild()() is TableBlock)
}

@Test
func t35(): Unit {
    let str = #"|Abc | Def 
| --- | --- |
|主食类|米饭、面条、馒头、面包|"#
    let node = md.parse(str)
    @Assert(node.getLastChild()() is TableBlock)
}

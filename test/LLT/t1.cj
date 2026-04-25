// DEPENDENCE: z_test.cj
// EXEC: cjc %import-path %L %l %f z_test.cj --test
// EXEC: ./main --filter=*.t5

import commonmark4cj.commonmark.*
import commonmark4cj.table.*
import std.unittest.*
import std.unittest.testmacro.*
import std.regex.*

@Test
public func t1(): Unit {
    let str = """
**智能差旅：**出差太麻烦？用钉钉，申请、预订、报销，一站式搞定。"""
    var node = Parser.builder().build().parse(str)
    printNode(node)

    let ASCII_PUNCTUATION: String = "!\"#\\$%&'\\(\\)\\*\\+,\\-\\./:;<=>\\?@\\[\\\\\\]\\^_`\\{\\|\\}~"
    let PUNCTUATION: Regex = Regex("^[${ASCII_PUNCTUATION}]")
    let beforeIsPunctuation: Bool = PUNCTUATION.matcher("：").find().isSome()
    println(beforeIsPunctuation)
}

@Test
public func t2(): Unit {
    let str = """
&amp;
&"""
    var node = Parser.builder().build().parse(str)
    printNode(node)
    println(HtmlRenderer.builder().build().render(node))
}

@Test
public func t3(): Unit {
    let str = """
![](./media/emotion_184.png)方太集团签约专属钉钉，依托钉钉底座能力打造产业链协同平台

![](./media/emotion_143.png)[点击查看详情>>](https://ow.dingtalk.com/article/SWA00DRAYduQ6zTxiixxJ9NSbLG4sVSKiSuIoJK)
![](./media/emotion_143.png)[更多客户案例>>](https://page.dingtalk.com/wow/z/dingtalk/default/caselist)
![](https://alidocs.oss-accelerate.aliyuncs.com/res/jWgZOZ4jRGvrnLX8/img/0161e2e0-175e-4849-adc1-02f919a2b128.jpeg#102)"""
    var node = Parser.builder().build().parse(str)
    printNode(node)
    println(HtmlRenderer.builder().build().render(node))
}

@Test
public func t5(): Unit {
    let str = ##"## ![](./media/emotion_017.png)<font color="#C7451A">钉钉新功能黑板报</font>&#8203;**｜**&#8203;第三期（2023\.2\.16）
![](https://alidocs.oss-cn-zhangjiakou.aliyuncs.com/a/96330330620/5080580386/08c690f4-04cd-484a-926f-3e5b00cbb153?w=1200&h=511)
### &#8203;**一、今日产品新功能推荐**&#8203;
&#8203;ꔷ &#8203;智能差旅：&#8203;出差太麻烦？用钉钉，申请、预订、报销，一站式搞定。&#8203;
![](https://alidocs.oss-accelerate.aliyuncs.com/res/LvBPlNAzg52ROdG8/img/1dc9c762-e54e-4be2-8a15-346fa9ee4582.gif?w=666&h=375)
&#8203;
&#8203;ꔷ &#8203;钉钉会议：&#8203;会中突发情况不用慌，新增安全菜单，助你快速控场。​&#8203;
![](https://alidocs.oss-accelerate.aliyuncs.com/a/95920112692/2125320914/e59016aa-277f-4af8-9246-085da8e29367.gif?w=669&h=376)
&#8203;
&#8203;ꔷ &#8203;钉钉协同品功能：&#8203;「钉钉文档」：文档频繁切换太麻烦？新标签页打开，助力高效办公！&#8203;
![](https://alidocs.oss-accelerate.aliyuncs.com/a/95920112692/2125320914/c9e4f88a-7051-41cc-9c40-71d5427fdf5f.gif?w=667&h=375)
&#8203;
---
### &#8203;**二、今日新功能小视频推荐**&#8203;
&#8203;ꔷ [&#8203;**《钉钉会议新增取消全员看TA》🎬**&#8203;](https://cloud.video.taobao.com/play/u/null/p/1/e/6/t/1/394605986253.mp4?SBizCode=xiaoer)&#8203;
&#8203;ꔷ [&#8203;**《钉钉白板全新上线》🎬**&#8203;](https://cloud.video.taobao.com/play/u/null/p/1/e/6/t/1/397019548831.mp4?SBizCode=xiaoer)&#8203;
---
### &#8203;**三、今日客户案例推荐**&#8203; 
![](./media/emotion_184.png)&#8203;方太集团签约专属钉钉，依托钉钉底座能力打造产业链协同平台&#8203;&#8203;
国内知名厨电领军企业方太集团宣布与钉钉达成合作，未来将进一步依托钉钉开放的技术底座能力搭建自定义产业链协同平台，加速提升组织协同效率及业务数字化水平。&#8203;
![](./media/emotion_143.png)[&#8203;**点击查看详情\>\>**&#8203;](https://ow.dingtalk.com/article/SWA00DRAYduQ6zTxiixxJ9NSbLG4sVSKiSuIoJK)&#8203;
![](./media/emotion_143.png)[&#8203;**更多客户案例\>\>**&#8203;](https://page.dingtalk.com/wow/z/dingtalk/default/caselist)&#8203;
![](https://alidocs.oss-accelerate.aliyuncs.com/res/jWgZOZ4jRGvrnLX8/img/0161e2e0-175e-4849-adc1-02f919a2b128.jpeg#102)
---
 新功能投稿请联系：&#8203;弘阳、太奈&#8203;&#8203;
 对外渠道请联系：&#8203;圆悦、牛成&#8203;&#8203;
### ![](./media/emotion_111.png)[&#8203;**点击查看往期黑板报，进步全知道～**&#8203;](https://alidocs.dingtalk.com/i/nodes/jkB7yl4ZK3vV6nnOQ7peVPMX2O6oxqw0)
---
###### [点击查看详情](dingtalk://dingtalkclient/page/note?sharedNoteId=ABmOoeXXAZVZnawZ&amp;colorValue=) • 来自钉钉便签"##
    var node = Parser.builder().build().parse(str)
    printNode(node)
    println(HtmlRenderer.builder().build().render(node))
}

@Test
public func t4(): Unit {
    let str = ##"---
### qwe
asd  

---"##
/* 
国内知名厨电领军企业方太集团宣布与钉钉达成合作，未来将进一步依托钉钉开放的技术底座能力搭建自定义产业链协同平台，加速提升组织协同效率及业务数字化水平。&#8203;
![](./media/emotion_143.png)[&#8203;**点击查看详情\>\>**&#8203;](https://ow.dingtalk.com/article/SWA00DRAYduQ6zTxiixxJ9NSbLG4sVSKiSuIoJK)&#8203;
![](./media/emotion_143.png)[&#8203;**更多客户案例\>\>**&#8203;](https://page.dingtalk.com/wow/z/dingtalk/default/caselist)&#8203;
![](https://alidocs.oss-accelerate.aliyuncs.com/res/jWgZOZ4jRGvrnLX8/img/0161e2e0-175e-4849-adc1-02f919a2b128.jpeg#102)

 */
    var node = Parser.builder().build().parse(str)
    printNode(node)
    println(HtmlRenderer.builder().build().render(node))
    println(str)
}


@Test
public func t6(): Unit {
    let str = """
fsdfsdfg
![]()
***
| 测试 | Head |
| --- | --- |
| Data | Data |
| Data | Data |

---

| 测试 | Head |
| --- | --- |
| Data | Data |
| Data | Data |

fsdfsdfg
![]()

| 测试 | Head |
| --- | --- |
| Data | Data |
| Data | Data |"""
    var node = Parser.builder().extensions([TablesExtension.create()]).build().parse(str)
    printNode(node)
    println(HtmlRenderer.builder().build().render(node))
}
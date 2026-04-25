package commonmark

@Test
class Tester1{
    let node = Node()
    @TestCase
    func toStringTest():Unit{
        @Assert("adad", node.toString())
    }
}
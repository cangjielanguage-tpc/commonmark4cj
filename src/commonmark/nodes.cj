package commonmark4cj.commonmark

public class Nodes {
    @Frozen
    public static func between(first: Node, end: Node): Iterator<Node> {
        NodesIterator(first.getNext(), end)
    }
}

class NodesIterator <: Iterator<Node> {
    NodesIterator(var firstNode: ?Node, let endNode: Node) {}
    public func next(): ?Node {
        match (firstNode) {
            case Some(v) =>
                if (refEq(v, endNode)) {
                    firstNode = None
                    None
                } else {
                    firstNode = v.getNext()
                    v
                }
            case _ => None
        }
    }
}

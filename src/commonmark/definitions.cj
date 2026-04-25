package commonmark4cj.commonmark

/*
 * 此类用于管理BlockParser产出的链接定义
 * 场景: 一些便签需要引用其他处定义的链接
 * 优化: 使用简化的数据结构
 *      key: 链接类名+lable
 *      value: 链接对象
 * 限制: 所有的链接定义必须继承LinkReferenceDefinition
 */
public class Definitions {
    private let defs: HashMap<String, LinkReferenceDefinition> = HashMap()

    @Frozen
    public func addDefinition(ref: LinkReferenceDefinition): Unit {
        let k = ref.getNodeType() + ref.getLabel().getOrThrow()
        defs.addIfAbsent(k, ref)
    }

    @Frozen
    public func getDefinition<D>(typ: String, label: String): ?D {
        match (defs.get(typ + label)) {
            case Some(v: D) => v
            case _ => None
        }
    }
}

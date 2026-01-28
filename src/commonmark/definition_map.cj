package commonmark4cj.commonmark

/**
 * A map that can be used to store and look up reference definitions by a label. The labels are case-insensitive and
 * normalized, the same way as for {@link LinkReferenceDefinition} nodes.
 *
 * @param <D> the type of value
 */
public class DefinitionMap {
    private let typ: String
    // TreeMap for determinism and to preserve document order
    private let definitions = HashMap<String, LinkReferenceDefinition>()

    public DefinitionMap(typ: String) {
        this.typ = typ
    }

    public func getType(): String {
        return typ
    }

    public func addAll(that: DefinitionMap): Unit {
        for ((k, v) in that.definitions where !definitions.contains(k)) {
            // Note that keys are already normalized, so we can add them directly
            definitions.add(k, v)
        }
    }

    /**
     * Store a new definition unless one is already in the map. If there is no definition for that label yet, return null.
     * Otherwise, return the existing definition.
     * <p>
     * The label is normalized by the definition map before storing.
     */
    public func putIfAbsent(label: String, definition: LinkReferenceDefinition): ?LinkReferenceDefinition {
        let normalizedLabel = Escaping.normalizeLabelContent(label)

        // spec: When there are multiple matching link reference definitions, the first is used
        if (let Some(v) <- definitions.get(normalizedLabel) && !(v is Unit)) {
            return v
        } else {
            definitions.add(normalizedLabel, definition)
            return None
        }
    }

    /**
     * Look up a definition by label. The label is normalized by the definition map before lookup.
     *
     * @return the value or null
     */
    public func get(label: String): ?LinkReferenceDefinition {
        let normalizedLabel = Escaping.normalizeLabelContent(label)
        return definitions.get(normalizedLabel)
    }

    // public func keySet(): Collection<String> {
    //     return definitions.keys()
    // }

    // public func values(): Collection<LinkReferenceDefinition> {
    //     return definitions.values()
    // }
}

mutable struct blossomVnode{U}
    """ 
    True if this node is a tree root, implies that this node is outer and isn't matched.
    """
    is_tree_root :: Bool

    """
    True if this node is a pseudo node.
    """
    is_pseudo_node :: Bool

    """
    True if this node is an external node i.e. it isn't contracted in some blossom.
    """
    is_external :: Bool

    """
    Support variable to identify the nodes which have been "processed" in some sense by the algorithm.
    Is used in the shrink and expand operations.
    For example, during the shrink operation we traverse the odd circuit and apply dual changes. All nodes
    from this odd circuit are marked, i.e. blossomVnode.is_marked == true. When a node on this circuit is
    traversed, we set blossomVnode.is_processed to true. When a (+, +) inner edge is encountered, we can
    determine whether the opposite endpoint has been processed or not depending on the value of this variable.
    Without this variable inner (+, +) edges can be processed twice (which is wrong).
    """
    is_processed :: Bool

    """
    Support variable. In particular, it is used in shrink and expand operation to quickly determine whether a
    node belongs to the current blossom or not. Is similar to the is_processed.
    """
    is_marked :: Bool

    """
    Current label of this node. Is valid if this node is outer.
    """
    label

    """
    Current dual variable of this node. If the node belongs to a tree and is an external node, then this
    value may not be valid. The true dual variable is dual + tree.eps if this is a "+" node and
    dual - tree.eps if this is a "-" node.
    """
    dual :: Float64

end

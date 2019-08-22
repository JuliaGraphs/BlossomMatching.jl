"""
This struct stores auxilliary data needed to be stored with a graph node for the algorithm. This struct is also
used for storing auxilliary data blossomV_tree node. There is no separate struct storing auxilliary properties of 
blossomV_tree_node.

It represents a vertex of graph, and contains three major blocks of data needed for the algorithm.

Node's state information, i.e. {label}, {isTreeRoot}, etc.
This information is maintained dynamically and is changed by functions in PrimalUpdater.jl

Information needed to maintain alternating tree structure. It is designed to be able to quickly plant
subtrees, split and concatenate child lists, traverse the tree up and down.

Information needed to maintain a "pyramid" of contracted nodes. The common use-cases are to traverse
the nodes of a blossom, to move from some node up to the outer blossom (or penultimate blossom, if the outer
one is being expanded)

Each node has a dual variable. This is the only information that can be changed by the functions in DualUpdater.jl 
This variable is updated lazily due to performance reasons.

The edges incident to a node are stored in two linked lists. The first linked list is used for outgoing edges;
the other, for incoming edges. The notions of outgoing and incoming edges are symmetric in the context of this
algorithm since the initial graph is undirected.
The first element in the list of outgoing edges is {first[0]}, the first element in the list of incoming edges 
is {first[1]}.

A node is called a plus node if it belongs to the even layer of some alternating tree (root has layer 0).
Then its label is {PLUS}. A node is called a minus node if it belongs to the odd layer of
some alternating tree. Then its label is {MINUS}. A node is called an infinity or free
node if it doesn't belong to any alternating tree. A node is called outer it belongs to the surface graph, i.e.
it is not contracted.

A node is called a blossom or pseudonode if it emerged from contracting an odd
circuit. This implies that this node doesn't belong to the original graph. A node is called matched, if it
is matched to some other node. If a node is free, it means that it is matched. If a node is not a free node,
then it necessarily belongs to some tree. If a node isn't matched, it necessarily is a tree root.
"""


mutable struct graph_node
    """ 
    Set to true if this node is a tree root. A tree root isn't matched with any node and is always an outer node.
    """
    is_tree_root::Bool

    
    """
    Set to true if this node is a pseudo node. A pseudo node is equivalently called as blossom.
    (A cycle with odd number of edges)
    """
    is_blossom::Bool

    
    """
    Set to true if this node is an external node. An external node is not a part of contracted blossom.
    """
    is_outer::Bool

    
    """
    Support variable to identify the nodes which have been "processed" in some sense by the algorithm.
    Is used in the shrink and expand operations.
    For example, during the shrink operation we traverse the odd cycle and apply dual changes. All nodes
    from this odd cycle are marked, i.e. graph_node.is_marked == true. When a node on this cycle is
    traversed, we set graph_node.is_processed to true. When a (+, +) inner edge is encountered, we can
    determine whether the opposite endpoint has been processed or not depending on the value of this variable.
    Without this variable inner (+, +) edges can be processed twice (which is wrong).
    """
    is_processed::Bool

    
    """
    Support variable. In particular, it is used in shrink and expand operation to quickly determine whether a
    node belongs to the current blossom or not. 
    This variable is similar to the graph_node.is_processed.
    """
    is_marked::Bool

    
    """
    Current label of this node. Is valid if this node is an outer node i.e. it is not a part of a blossom.outer.
    The label of an outer node can be "+" , "-" or "inf".
    """
    @enum label PLUS MINUS INFINITY

    
    """
    Two-element array of pointers of the first elements in the linked lists of edges that are incident to this node.
    first[0] is the first outgoing edge, first[1] is the first incoming edge.
    """
    first = Vector{graph_edge}(undef,2)

    
    """
    Current dual variable of this node. If the node belongs to a tree and is an external node, then this
    value may not be valid. It is because we use implicit mentod to maintain dual variables and slack of the edges.
    We accumulate the eps of the tree instead of updating dual variable after every dual update.
    The true dual variable is dual + tree.eps if this is a "+" node and dual - tree.eps if this is a "-" node.
    """
    dual::Float64
    
    
    """
    Points to the edge which is incident to this node and is matched.
    """
    matched::graph_edge
    
    
    """
    This variable is used during fractional matching and is assigned only to the infinity nodes. It is used to 
    determine for a particular infinity node the edge with the minimum slack. When the dual change is bounded
    by the dual constraints on the (+,inf) edges, we choose the edge with the minimum slack , increase the 
    duals of the tree if needed and grow this edge.
    """
    best_edge::graph_edge
    
    
    """
    Points to the tree this node belongs to while growing the trees.
    """
    tree::blossomV_tree
    
    
    """
    Points to the edge which joins it to its parent in the tree this node belongs to.
    """
    parent_edge::graph_edge
    
    
    """
    First child in the linked list of children of this node.
    """
    first_tree_child::graph_node
    
    
    """
    Pointer to the next tree sibling in the doubly linked list of children of the node parent_edge.
    Is null if this node is the last child of the parent node.
    If this node is a tree root, references the next tree root in the doubly linked list of tree roots or
    is null if this is the last tree root.    
    """
    tree_sibling_next::graph_node
    
    
    """
    """
    tree_sibling_prev::graph_node
    
    
    """
    Points to the blossom this node is a part of. The blossom parent is always one layer higher than this node.
    """
    blossom_parent::graph_node
    
    
    """
    Points to a blossom that is higher than this node. This variable is needed to implement the path compression 
    technique. It is used to quickly find the penultimate grandparent of this node i.e. a grandparent whose 
    blossom_parent is an outer node.
    """
    blossom_grandparent::graphs_node 
    
    
    """
    Points to the next node in the blossom structure in the circularly single linked list of blossom nodes.
    It is used to traverse the blossom node in a cyclic order.
    """
    blossom_sibling::graphs_node 
    
end


# Things that should be implemented here :
# 1. Constructor.
# 2. Some helper functions to add, remove edges incident to a node and few other helper functions to quickly use grow, expand
#    and augment operation.
# 3. Iterator to traverse edges incident to a node. We are maintaining a doubly linked list with each node to store edges 
#    incident to it and hence we need to implement an iterator to traverse the list with ease.

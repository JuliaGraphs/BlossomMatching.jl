"""
This struct stores auxilliary data needed to be stored with a tree for the algorithm.
 
Represents an alternating tree of tight(slack=0) edges which is used to find an augmenting path of tight edges
in order to perform an augmentation and increase the cardinality of the matching. The nodes on odd layers
are necessarily connected to their children via matched edges. Thus, these nodes have always exactly one child.
The nodes on even layers can have arbitrarily many children.
 
The tree structure information is contained in {BlossomVNode}, this class only contains the reference
to the root of the tree. It also contains three heaps:

A heap of (+, inf) edges. These edges are also called infinity edges. If there exists a tight
infinity edge, then it can be grown. Thus, this heap is used to determine an infinity edge of
minimum slack.

A heap of (+, +) in-tree edges. These are edges between "+" nodes from the same tree. If a (+, +)
in-tree edges is tight, it can be used to perform the shrink operation and introduce a new blossom. Thus,
this heap is used to determine a (+, +) in-tree edge of minimum slack in a given tree.

A heap of "-" blossoms. If there exists a blossom with zero actual dual variable, it can be expanded.
Thus, this heap is used to determine a "-" blossom with minimum dual variable.

Each tree contains a variable which accumulates dual changes applied to it. The dual changes aren't spread until
a tree is destroyed by an augmentation. 
For every node in the tree its true dual variable is equal to {node.dual + node.tree.eps} if it is a "+" node; 
otherwise it equals {node.dual - node.tree.eps}. This applies only to the surface nodes that belong to some tree.
"""

mutable struct blossomV_tree
    """
    Two-element array of the first elements in the circular doubly linked lists of incident tree
    edges in each direction.
    """
    first = Vector{blossomV_tree_edge}(undef,2)   
    
    
    """
    This variable is used to quickly determine the edge between two trees during primal operations.
    Let T be a tree that is being processed in the main loop. For every tree 'T' that is adjacent
    to T this variable is set to the {@code blossomV_tree_edge} that connects both trees. This variable also
    helps to indicate whether a pair of trees is adjacent or not. 
    This variable is set to {null} when no primal operation can be applied to the tree T.
    """
    current_edge::blossomV_tree_edge
    
    
    """
    Direction of the tree edge connecting this tree and the currently processed tree.
    """
    current_direction::UInt8
    
    
    """
    Dual change that hasn't been spread among the nodes in this tree. This technique is called
    lazy delta spreading.
    """
    eps::Float64
    
    
    """
    Accumulated dual change. Is used during dual updates.
    """
    accumulated_eps::Float64
    
    
    """
    The root of the tree.
    """
    root::graph_node
    
    
    """
    Next tree in the connected component, is used during updating the duals via connected components.
    """
    next_tree::blossomV_tree

    
    """
    The heap of (+,+) edges of this tree which is used as priority queue.
    """
    plus_plus_edges = PriorityQueue{graph_edge,Float64}()
    
    
    """
    The heap of (+, inf) edges of this tree which is used as priority queue.
    """
    plus_infinity_edges = PriorityQueue{graph_edge,Float64}()
    
    
    """
    The heap of "-" blossoms of this tree which is used as priority queue.
    """
    minus_blossoms = PriorityQueue{graph_edge,Float64}()
    
end

#Things that should be implemented here :
#1. Constructor(Creates a tree with a specified root)
#2. Helper function to add a blossomV_tree_edge b/w 2 blossomV_trees, remove edges b/w 2 trees etc.

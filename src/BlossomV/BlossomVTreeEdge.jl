"""
This struct stores auxilliary data needed to be stored with a tree edge for the algorithm.

Is used to maintain an auxiliary graph whose nodes correspond to alternating trees in the Blossom V algorithm.
Let's denote the current tree T and some other tree T'. Every tree edge contains three heaps:

1. a heap of (+, +) cross-tree edges. This heap contains all edges between two "+" nodes where one node
belongs to tree T and another to T'. The (+, +) cross-tree edges are used to augment the matching.
2. a heap of (+, -) cross-tree edges. This heap contains all edges between "+" node in tree T and "-" nodes
in tree T'. 
3. a heap of (-, +) cross-tree edges. This heap contains all edges between "-" node in tree T and "+" nodes
in tree T'. 

From the tree edge perspective there is no difference between a heap of (+, -) and (-, +)
cross-tree edges. That's why we distinguish these heaps by the direction of the edge. Here the direction 
is considered with respect to the trees T and T' based upon the notation introduced above.

Every tree edge is directed from one tree to another and every tree edge belongs to the two doubly
linked lists of tree edges. The presence of a tree edge in these lists in maintained by the two-element
arrays {prev} and {next}. For one tree the edge is an outgoing tree edge; for the other,an incoming. 
In the first case it belongs to the {tree.first[0]} linked list; in the second, to the {tree.first[1]}
linked list.

Let {tree} be a tail of the edge, and {opposite_tree} a head of the edge. Then
{edge.head[0] == opposite_tree} and {edge.head[1] == tree}.
"""

mutable struct blossomV_tree_edge
    """
    Two-element array of trees this edge is incident to.
    """
    head = Vector{blossomV_tree_edge}(undef,2)
    
    
    """
    A two-element array of pointers to the previous elements in the circular doubly linked lists of tree edges.
    The lists are circular with one exception: the last_element.next[dir] == null. Each list belongs to
    one of the endpoints of this edge.
    """
    prev = Vector{blossomV_tree_edge}(undef,2)
    
    
    """
    A two-element array of pointers to the next elements in the circular doubly linked lists of tree edges.
    The lists are circular with one exception: the last_element_in_the_list.next[dir] == null. Each list belongs 
    to one of the endpoints of this edge.
    """
    next = Vector{blossomV_tree_edge}(undef,2)
    
    
    """
    A heap of (+, +) cross-tree edges.
    """
    plus_plus_edges = PriorityQueue{graph_edge,Float64}()
    
    
    """
    A heap of (-, +) cross-tree edges.
    """
    plus_minus_edges0 = PriorityQueue{graph_edge,Float64}()

    
    """
    A heap of (+, -) cross-tree edges.
    """
    plus_minus_edges1 = PriorityQueue{graph_edge,Float64}()

end


# Things left to implement here:
# 1. Constructor
# 2. Helper methods to add and remove edges from the doubly linked list and from the respective heaps.

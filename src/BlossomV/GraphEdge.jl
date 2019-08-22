"""
This struct stores auxilliary data needed to be stored with a graph edge for the algorithm.

Minimum weight perfect matching problem is solved for an undirected graph but an edge has a direction after intitialization
and henceforth it becomes an arc. Depending upon the direction, an edge is present in a circular double linked list of edges
(incident on a node). 
There is a next and prev pointer(for the circular doubly linked list) inside graph_edge struct.
The direction of an edge is not stored in an edge. The presence of an edge in the list of outgoing or incoming edge gives 
the direction of the edge. 

For example, let  e = {u, v} be an edge in the graph G = (V, E). Let's assume that after initialization
this edge has become directed from u to v, i.e. now e = (u, v). Then edge e belongs to the linked lists
u.first[0] and v.first[1].
In other words, e is an outgoing edge of u and an incoming edge of v. For convenience during computation,e.head[0] = v and 
e.head[1] = u. Therefore, while iterating over incident edges of a node {x} in the direction {dir}, we can easily 
access opposite node by {x.head[dir]}.

An edge is called an infinity edge if it connects a "+" node with an infinity node. An edge is called
free if it connects two infinity nodes. 
An edge is called matched if it belongs to the matching.
During the shrink or expand operations an edge is called an inner edge if it connects two nodes of
the blossom. 
It is called a boundary edge if it is incident to exactly one blossom node.
An edge is called tight if its slack is zero. 
Note: In this algorithm we use lazy delta spreading, so the graph_edge.slack isn't necessarily equal to the 
actual slack of an edge.
"""


mutable struct graph_edge
    """
    Pointer to a priority queue. 
    """
    handle = PriorityQueue{graph_edge,Float64}()
    
    """
    This variable stores the slack of the edge. If this edge is an outer edge (an edge that does not connect 2 nodes in 
    a blossom) which doesn't connect 2 infinity nodes, then we use implicit method to store the slack of the edge. We call it
    lazy delta spreading technique. In other cases, this variable stores the correct value of the slack.
    The true slack of the edge for the first type of edges above can be calculated as follows:
    For each of its two current endpoints {u, v} we subtract the endpoint.tree.eps if the endpoint is a "+" outer node 
    or add this value if it is a "-" outer node. After that we have valid slack for this edge.
    """
    slack::Float64
    
    
    """
    A two-element array of original endpoints of this edge. They are used to quickly determine original endpoints
    of an edge and compute the penultimate blossom. This is done while one of the current endpoints of this edge is
    being shrunk or expanded.
    These values stay unchanged throughout the course of the algorithm.   
    """
    head_original = Vector{graph_node}(undef,2)
    
    
    """
    A two-element array of current endpoints of this edge. These values change when previous endpoints are
    contracted into blossoms or are expanded. For node head[0] this is an incoming edge (direction 1) and for
    the node head[1] this is an outgoing edge (direction 0). 
    """
    head = Vector{graph_node}(undef,2)
    
    
    """
    A two-element array of pointers to the previous elements in the circular doubly linked lists of edges.
    Each list belongs to one of the current endpoints of this edge.
    """
    prev = Vector{graph_edge}(undef,2)
    
    
    """
    A two-element array of pointers to the next elements in the circular doubly linked lists of edges.
    Each list belongs to one of the current endpoints of this edge.
    """
    next = Vector{graph_edge}(undef,2)
    
end


# Things that should be implemented here :
# 1. Constructor.
# 2. Some helper functions to calculate true slack, reverse direction, find opposite endpoint etc.
# 3. Iterator to traverse edges in a blossom.

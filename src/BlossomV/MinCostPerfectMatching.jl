"""
This structure stores important statistics about the execution of the algorithm. 
Apart from the keeping track of time spent in doing each operation, it also measures the number of each 
type of shrink, expand and grow operation.
"""
mutable struct stats{T}
    """
    Number of shrink operations.
    """
    num_shrink_op = zero(T)
    
    
    """
    Number of expand operations.
    """
    num_expand_op = zero(T)
    
    
    """
    Number of grow operations.
    """
    num_grow_op = zero(T)
    
    
    """
    Number of augment operations.
    """
    num_augment_op = zero(T)
    
    
    """
    Time used for doing shrink operations.
    """
    time_shrink_op::Float64
    
    
    """
    Time used for doing expand operations.
    """
    time_expand_op::Float64
    
    
    """
    Time used for doing grow operations.
    """
    time_grow_op::Float64
    
    
    """
    Time used for doing augment operations.
    """
    time_augment_op::Float64
    
end



"""
This structure contains variables to decide which strategy we use for various parts of the algorithm. 
"""
mutable struct execution_options 
    """
    Set this variable to :
    - 0 for no initialization, i.e. we allocate N number of trees at the beginning.
    - 1 for greedy initialization strategy.
    - 2 for fractional initialization strategy. 
    """
    init_strategy::UInt8 
    
    
    """
    Set this variable to :
    - 0 for multiple tree fixed delta approach.
    - 1 for multiple tree variable delta approach.(using connected components strategy as described in BlossomV algorithm)
    """
    dual_update_strategy::Bool 
    
    
    """
    Set this variable to :
    - 0 to update the duals of the tree before tree growth.
    - 1 to update the duals of the tree after tree growth.
    """
    dual_update_sequence::Bool 
end



"""
Driver function for the BlossomV algorithm which controlls the execution of the algorithm.
Returns the min cost perfect matching.
"""
function min_cost_perfect_matching end
# see https://github.com/mauro3/SimpleTraits.jl/issues/47#issuecomment-327880153 for syntax

@traitfn function min_cost_perfect_matching(g::AG::(!IsDirected), wt_mx=weights(g), execution_options) where {T<:Integer, AG <:AbstractGraph{T}}   

     nvg = nv(g)
     neg = ne(g)
    
    
     """
     Perfect matching in a graph can only exist if we have even number of vertices in the graph.
     """
     if nvg%2 != 0 
         throw(ArgumentError("Given graph has odd number of vertices $nvg, no perfect matching exists for this graph"))
     end
        
    
     """
     This function does the following tasks :
     - Initialize the vector of struct for both edges and nodes which store the properties that we need to store with them.
     - Based on the init_strategy variable set under execution_options, initialize the matching and plant trees for 
       unmatched nodes.
     """
     initialize(g, wt_mx, execution_options)
    
     
     #Controller part of the function. To be implemented.
end

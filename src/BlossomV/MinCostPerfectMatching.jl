function min_cost_perfect_matching end
# see https://github.com/mauro3/SimpleTraits.jl/issues/47#issuecomment-327880153 for syntax

@traitfn function min_cost_perfect_matching(g::AG::(!IsDirected)) where {T<:Integer, AG <:AbstractGraph{T}}
     nvg = nv(g)

     if nvg % 2 != 0 
         throw(ArgumentError("Odd number of vertices $nvg, no perfect matching"))
     end
     
     Init()

     while(1)
         UpdtatePrimal() ## Involves growing alternating trees and other operations like shrink, augment etc. 
         UpdateDual() ## Makes no change to alternating trees but updates dual variables using multiple tree variable delta approach.
         CheckComplementarySlacknessCondition(). # break when this satisfies.
     end

     CheckCorrectnessOfSolution()  # Obtain certificate of optimality 
     return matching # if above function returns true.
end

## max_vertices = 1000. O(n^3) algorithm won't work in short amount(<=10sec) of time if n>10^3 

mutable struct aux_struct{T} 
    mate :: Vector{T}     #mate[i] stores the vertex which is matched to vertex i  
    p :: Vector{T}        #p[i] stores the ancestor of a vertex in the tree
    base :: Vector{T}     #base[i] stores the aux.base of the flower to which vertex i belongs. It equals i if vertex i doesn't belong to any flower.
    q :: Vector{T}        #array used in traversing the tree
    used :: Vector{T}     #boolean array to mark used vertex
    blossom :: Vector{T}  #boolean array to mark vertices in a blossom
end


"""
Function to calculate lowest common ancestor of 2 vertices in a tree.
The algorithm has O(N) time complexity. 
LCA algorithms with better time complexity e.g. O(log(N)) can be aux.used but not aux.used here as this is not of primary importance 
to the algorithm. PRs welcome for this.
"""

function lca(a, b, nvg, aux)
    for i in one(nvg):nvg
        aux.used[i] = 0
    end
    
    ##Rise from vertex a to root, marking all even vertices
    while true
        a = aux.base[a]
        aux.used[a] = one(nvg)
        if aux.mate[a] == -one(nvg) 
            break
        end
        a = aux.p[aux.mate[a]]
    end
      
    ##Rise from the vertex b until we find the labeled vertex
    while true
        b = aux.base[b]
        if aux.used[b] == one(nvg)
            return b
        end
        b = aux.p[aux.mate[b]]
    end
end
 
 
"""
This function on the way from the top to the aux.base of the flower, marks true for the vertices
in the array aux.blossom[] and stores the ancestors for the even nodes in the tree. 
The parameter children is the son for the vertex v itself(with the help of this parameter we close 
the loop in the ancestors).
"""
function mark_path(v, b, children, aux) 
    while aux.base[v] != b
        aux.blossom[aux.base[v]] = one(nvg)
        aux.blossom[aux.base[aux.mate[v]]] = one(nvg)
        aux.p[v] = children
        children = aux.mate[v]
        v = aux.p[aux.mate[v]]
    end
    return nothing 
end
   

"""
This function looks for augmenting path from the exposed vertex root 
and returns the last vertex of this path, or -one(nvg) if the augmenting path is not found.
"""
function find_path(root, nvg, aux)
    @inbounds for i in one(nvg):nvg
        aux.used[i] = 0
    end
    
    @inbounds for i in one(nvg):nvg
        aux.p[i] = -one(nvg) 
    end
        
    @inbounds for i in one(nvg):nvg
        aux.base[i] = i 
    end
    
    aux.used[root] = one(nvg)
            
    qh = one(nvg) 
    qt = one(nvg)  
            
    aux.q[qt] = root
    qt = qt + one(nvg)
    
    while qh<qt
        v = aux.q[qh]
        qh = qh + one(nvg) 
        for v_neighbor in neighbors(g, v)
            if (aux.base[v] == aux.base[v_neighbor]) || (aux.mate[v] == v_neighbor)
                continue
            end
            
            # The edge closes the cycle of odd length, i.e. a flower is found. 
            # An odd-length cycle is detected when the following condition is met.
            # In this case, we need to compress the flower.
            if (v_neighbor == root) || (aux.mate[v_neighbor] != -one(nvg)) && (aux.p[aux.mate[v_neighbor]] != -one(nvg))
                #######Code for compressing the flower######
                curbase = lca(v,v_neighbor,nvg, aux)
                for i in one(nvg):nvg
                    aux.blossom[i] = 0
                end
                
                mark_path(v, curbase, v_neighbor, aux)
                mark_path(v_neighbor, curbase, v, aux)
                        
                for i in one(nvg):nvg
                    if aux.blossom[aux.base[i]] == one(nvg) 
                        aux.base[i] = curbase
                        if  aux.used[i] == 0
                            aux.used[i] = one(nvg)
                            aux.q[qt] = i
                            qt = qt + one(nvg) 
                        end
                    end
                end
                ############################################
            
            # Otherwise, it is an “usual” edge, we act as in a normal wide search. 
            # The only subtlety - when checking that we have not visited this vertex yet, we must not look 
            # into the array aux.used, but instead into the array aux.p as it is filled for the odd visited vertices.
            # If we did not go to the top yet, and it turned out to be unsaturated, then we found an 
            # augmenting path ending at the top v_neighbor, return it.
                
            elseif aux.p[v_neighbor] == -one(nvg)
                aux.p[v_neighbor] = v
                if aux.mate[v_neighbor] == -one(nvg) 
                    return v_neighbor
                end
                v_neighbor = aux.mate[v_neighbor]
                aux.used[v_neighbor] = one(nvg)   
                aux.q[qt] = v_neighbor
                qt = qt + one(nvg)
            end
        end
    end
                                    
    return -one(nvg)
end
  

"""
    max_cardinality_matching(g)
Compute the maximum cardinality matching in an undirected (weighted/unweighted) graph 
`g` using Edmonds Blossom algorithm.
(https://en.wikipedia.org/wiki/Blossom_algorithm).
 
Returns a namedtuple(named 'solution') containing 2 vectors. 
solution.mate contains the matched vertex of a vertex(also called as mate of vertex). 
solution.matched_edges is a list of all matched edges represented by 2 end vertices. 
 
### Performance
Time Complexity : O(n^3)
There are a total of n iterations, each of which performs a wide pass for O(m), in addition,
there can be flower squeezing operations - which are O(n).  
Thus the general asymptotics of the algorithm will be O(n(m+n^2)) = O(n^3).

Complexity : O(n) {Excluding the memory required for storing graph}
n = Number of vertices
m = Number of edges

### Examples
```jldoctest

julia> g = SimpleGraph([0 1 0 ; 1 0 1; 0 1 0])
{3, 2} undirected simple Int64 graph

julia> max_cardinality_matching(g)
(mate = [2, 1, -1], matched_edges = Array{Int64,1}[[1, 2]])


julia> g=SimpleGraph(11)
{11, 0} undirected simple Int64 graph

julia> add_edge!(g,1,2);

julia> add_edge!(g,2,3);

julia> add_edge!(g,3,4);

julia> add_edge!(g,4,1);

julia> add_edge!(g,3,5);

julia> add_edge!(g,5,6);

julia> add_edge!(g,6,7);

julia> add_edge!(g,7,5);

julia> add_edge!(g,5,8);

julia> add_edge!(g,8,9);

julia> add_edge!(g,10,11);

julia> max_cardinality_matching(g)
(mate = [2, 1, 4, 3, 6, 5, -1, 9, 8, 11, 10], matched_edges = Array{Int64,1}[[1, 2], [3, 4], [5, 6], [8, 9], [10, 11]])

```
"""

function max_cardinality_matching end
# see https://github.com/mauro3/SimpleTraits.jl/issues/47#issuecomment-327880153 for syntax
@traitfn function max_cardinality_matching(g::AG::(!IsDirected)) where {T<:Integer, AG <:AbstractGraph{T}}
    
    nvg = nv(g)
    neg = ne(g)
    
    aux = aux_struct{T}(T[],T[],T[],T[],T[],T[])

    #Initializing vectors
    sizehint!(aux.mate, nvg)
    aux.mate = fill(-one(nvg), nvg)
                                
    sizehint!(aux.p, nvg)
    aux.p = fill(-one(nvg), nvg)
                                
    sizehint!(aux.base, nvg)
    @inbounds for i in one(nvg):nvg
        push!(aux.base, i) 
    end
                                
    sizehint!(aux.q, nvg)
    aux.q = fill(0, nvg)
                                
    sizehint!(aux.used, nvg)
    aux.used = fill(0, nvg)
                                
    sizehint!(aux.blossom, nvg)
    aux.blossom = fill(0, nvg)                                        
                                
    #Using a simple greedy algorithm to mark the preliminary matching to begin with the algorithm. This speeds up 
    #the matching algorithm by several times.
    #Better heuristic based algorithm can be used which start with near optimal matching thus reducing the number
    #of augmentating paths and thus speeding up the algorithm. PRs are welcome for this.
    @inbounds for v in one(nvg):nvg
        if aux.mate[v]==-one(nvg)
            @inbounds for v_neighbor in neighbors(g, v)
                if aux.mate[v_neighbor]==-one(nvg)
                    aux.mate[v_neighbor] = v
                    aux.mate[v] = v_neighbor
                    break
                end
            end
        end
    end
    
    #Iteratively going through all the vertices to find an unmarked vertex                                    
    @inbounds for u in one(nvg):nvg
        if aux.mate[u]==-one(nvg)                # If vertex u is not in matching.
            v = find_path(u, nvg, aux)       # Find augmenting path starting with u as one of end points.
            while v!=-one(nvg)                # Alternate along the path from i to last_v (whole while loop is for that).
                pv = aux.p[v]              # Increasing the number of matched edges by alternating the edges in 
                ppv = aux.mate[pv]        # augmenting path.
                aux.mate[v] = pv
                aux.mate[pv] = v
                v = ppv
            end
        end
    end
       
    matched_edges = Vector{Vector{T}}()       # Result vector containing end points of matched edges.

    @inbounds for u in one(nvg):nvg
        if u<aux.mate[u]
            temp = Vector{T}()
            push!(temp,u)
            push!(temp,aux.mate[u])
            push!(matched_edges,temp)       
        end
    end

    result = (mate = aux.mate, matched_edges = matched_edges)
    
    return result
end
                                    
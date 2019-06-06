const max_vertices = 1000 #O(n^3) algorithm won't work in short amount(<=10sec) of time if n>10^3 

##Definiton of the global vectors used in the algorithm

match = Vector{}()    #match[i] stores the vertex which is matched to vertex i  
p = Vector{}()        #p[i] stores the ancestor of a vertex in the tree
base = Vector{}()     #base[i] stores the base of the flower to which vertex i belongs. It equals i if vertex i doesn't belong to any flower.
q = Vector{}()        #array used in traversing the tree
used = Vector{}()     #boolean array to mark used vertex
blossom = Vector{}()  #boolean array to mark vertices in a blossom

struct Solution{T <: Integer} 
    match::Vector{T}
    matched_edges::Vector{Vector{T}}
end


"""
Function to calculate lowest common ancestor of 2 vertices in a tree.
The algorithm has O(N) time complexity. 
LCA algorithms with better time complexity e.g. O(log(N)) can be used but not used here as this is not of primary importance 
to the algorithm. PRs welcome for this.
"""
function lca(a, b, nvg)
    for i in 1:nvg
        used[i] = 0
    end
    
    ##Rise from vertex a to root, marking all even vertices
    while true
        a = base[a]
        used[a] = 1
        if match[a] == -1 
            break
        end
        a = p[match[a]]
    end
      
    ##Rise from the vertex b until we find the labeled vertex
    while true
        b = base[b]
        if used[b] == 1
            return b
        end
        b = p[match[b]]
    end
end
 
 
"""
This function on the way from the top to the base of the flower, marks true for the vertices
in the array blossom[] and stores the ancestors for the even nodes in the tree. 
The parameter children is the son for the vertex v itself(with the help of this parameter we close 
the loop in the ancestors).
"""
function mark_path(v, b, children) 
    while base[v] != b
        blossom[base[v]] = 1
        blossom[base[match[v]]] = 1
        p[v] = children
        children = match[v]
        v = p[match[v]]
    end
    return nothing 
end
   

"""
This function looks for augmenting path from the exposed vertex root 
and returns the last vertex of this path, or -1 if the augmenting path is not found.
"""
function find_path(root, nvg)
    @inbounds for i in 1:nvg
        used[i] = 0
    end
    
    @inbounds for i in 1:nvg
        p[i] = -1 
    end
        
    @inbounds for i in 1:nvg
        base[i] = i 
    end
    
    used[root] = 1
            
    qh = 1 
    qt = 1  
            
    q[qt] = root
    qt = qt + 1
    
    while qh<qt
        v = q[qh]
        qh = qh + 1 
        for v_neighbor in neighbors(g, v)
            if (base[v] == base[v_neighbor]) || (match[v] == v_neighbor)
                continue
            end
            
            # The edge closes the cycle of odd length, i.e. a flower is found. 
            # An odd-length cycle is detected when the following condition is met.
            # In this case, we need to compress the flower.
            if (v_neighbor == root) || (match[v_neighbor] != -1) && (p[match[v_neighbor]] != -1)
                #######Code for compressing the flower######
                curbase = lca(v,v_neighbor,nvg)
                for i in 1:nvg
                    blossom[i] = 0
                end
                
                mark_path(v, curbase, v_neighbor)
                mark_path(v_neighbor, curbase, v)
                        
                for i in 1:nvg
                    if blossom[base[i]] == 1 
                        base[i] = curbase
                        if  used[i] == 0
                            used[i] = 1
                            q[qt] = i
                            qt = qt + 1 
                        end
                    end
                end
                ############################################
            
            # Otherwise, it is an “usual” edge, we act as in a normal wide search. 
            # The only subtlety - when checking that we have not visited this vertex yet, we must not look 
            # into the array used, but instead into the array p as it is filled for the odd visited vertices.
            # If we did not go to the top yet, and it turned out to be unsaturated, then we found an 
            # augmenting path ending at the top v_neighbor, return it.
                
            elseif p[v_neighbor] == -1
                p[v_neighbor] = v
                if match[v_neighbor] == -1 
                    return v_neighbor
                end
                v_neighbor = match[v_neighbor]
                used[v_neighbor] = 1   
                q[qt] = v_neighbor
                qt = qt + 1
            end
        end
    end
                                    
    return -1
end
  

"""
    max_cardinality_matching(g)
Compute the maximum cardinality matching in an undirected (weighted/unweighted) graph 
`g` using Edmonds Blossom algorithm.
(https://en.wikipedia.org/wiki/Blossom_algorithm).

Returns a structure containg 2 vectors. One contains the matched vertex of a vertex and the other is 
a list of all matched edges presented by 2 end vertices. 

### Performance
Time Complexity : O(n^3)
There are a total of n iterations, each of which performs a wide pass for O(m), in addition,
there can be flower squeezing operations - which are O(n).  
Thus the general asymptotics of the algorithm will be O(n(m+n^2)) = O(n^3).

Complexity : O(m) {Excluding the memory required for storing graph}
n = Number of vertices
m = Number of edges

### Examples
```jldoctest

julia> g=SimpleGraph(3)
{3, 0} undirected simple Int64 graph

julia> g = SimpleGraph([0 1 0 ; 1 0 1; 0 1 0])
{3, 2} undirected simple Int64 graph

julia> max_cardinality_matching(g)
Solution{Int64}([2, 1, -1], Array{Int64,1}[[1, 2]])


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
Solution{Int64}([2, 1, 4, 3, 6, 5, -1, 9, 8, 11, 10], Array{Int64,1}[[1, 2], [3, 4], [5, 6], [8, 9], [10, 11]])

```
"""
function max_cardinality_matching end
# see https://github.com/mauro3/SimpleTraits.jl/issues/47#issuecomment-327880153 for syntax
@traitfn function max_cardinality_matching(g::AG::(!IsDirected)) where {T<:Integer, AG <: AbstractGraph{T}}
    
    nvg = nv(g)
    neg = ne(g)
    
    #Initializing global vectors
    sizehint!(match,nvg)
    global match = fill(-1, nvg)
                                
    sizehint!(p,nvg)
    global p = fill(-1, nvg)
                                
    sizehint!(base,nvg)
    @inbounds for i in 1:nvg
        push!(base,i) 
    end
                                
    sizehint!(q,nvg)
    global q = fill(0, nvg)
                                
    sizehint!(used,nvg)
    global used = fill(0, nvg)
                                
    sizehint!(blossom,nvg)
    global blossom = fill(0, nvg)                                        
                                
    #Using a simple greedy algorithm to mark the preliminary matching to begin with the algorithm. This speeds up 
    #the matching algortihm by several times.
    #Better heuristic based algorithm can be used which start with near optimal matching thus reducing the number
    #of augmentating paths and thus speeding up the algorithm. PRs are welcome for this.
    @inbounds for u in 1:nvg
        if match[u]==-1
            @inbounds for v_neighbor in neighbors(g, u)
                if match[v_neighbor]==-1
                    match[v_neighbor] = u
                    match[u] = v_neighbor
                    break
                end
            end
        end
    end
    
    #Iteratively going through all the vertices to find an unmarked vertex                                    
    @inbounds for u in 1:nvg
        if match[u]==-1                # If vertex u is not in matching.
            v = find_path(u,nvg)       # Find augmenting path starting with u as one of end points.
            while v!=-1                # Alternate along the path from i to last_v (whole while loop is for that).
                pv = p[v]              # Increasing the number of matched edges by alternating the edges in 
                ppv = match[pv]        # augmenting path.
                match[v] = pv
                match[pv] = v
                v = ppv
            end
        end
    end
       
    matched_edges = Vector{Vector{T}}()       # Result vector containing end points of matched edges.

    @inbounds for u in 1:nvg
        if u<match[u]
            temp = Vector{T}()
            push!(temp,u)
            push!(temp,match[u])
            push!(matched_edges,temp)       
        end
    end
    

    return Solution{T}(match,matched_edges)
end
                                    
@testset "EdmondsMaxCardinality" begin
    
    g = PathGraph(5)
    match = @inferred(max_cardinality_matching(g))
    @test match.mate == [2, 1, 4, 3, 0]
    @test match.matched_edges == [[1, 2], [3, 4]]

    g = CycleGraph(11)
    match = @inferred(max_cardinality_matching(g))
    @test match.mate == [2, 1, 4, 3, 6, 5, 8, 7, 10, 9, 0]
    @test match.matched_edges == [[1, 2], [3, 4], [5, 6], [7, 8], [9, 10]]

    g = CompleteGraph(11)
    match = @inferred(max_cardinality_matching(g))
    @test match.mate == [2, 1, 4, 3, 6, 5, 8, 7, 10, 9, 0]
    @test match.matched_edges == [1, 2], [3, 4], [5, 6], [7, 8], [9, 10]]

    g = SimpleGraph(11)
    add_edge!(g,1,2)
    add_edge!(g,2,3)
    add_edge!(g,3,4)
    add_edge!(g,4,1)   
    add_edge!(g,3,5)
    add_edge!(g,5,6)
    add_edge!(g,6,7)
    add_edge!(g,7,5)
    add_edge!(g,5,8)
    add_edge!(g,8,9)
    add_edge!(g,10,11)
    match = @inferred(max_cardinality_matching(g))
    @test match.mate == [2, 1, 4, 3, 6, 5, 0, 9, 8, 11, 10]
    @test match.matched_edges == [[1, 2], [3, 4], [5, 6], [8, 9], [10, 11]] 

    g = SimpleGraph(9)
    add_edge!(g,1,2)
    add_edge!(g,2,3)
    add_edge!(g,3,1)
    add_edge!(g,1,8)
    add_edge!(g,7,8)
    add_edge!(g,7,3)
    add_edge!(g,3,6)
    add_edge!(g,3,9)
    add_edge!(g,3,4)
    add_edge!(g,5,6)
    add_edge!(g,5,4)
    match = @inferred(max_cardinality_matching(g))
    @test match.mate == [2, 1, 4, 3, 6, 5, 8, 7, 0]
    @test match.matched_edges == [[1, 2], [3, 4], [5, 6], [7, 8]]

    g = SimpleGraph(12)
    add_edge!(g,1,2)
    add_edge!(g,1,3)
    add_edge!(g,3,2)
    add_edge!(g,5,2)
    add_edge!(g,6,2)
    add_edge!(g,4,2)
    add_edge!(g,6,7)
    add_edge!(g,9,7)
    add_edge!(g,8,7)
    add_edge!(g,8,11)
    add_edge!(g,9,10)
    add_edge!(g,9,8)
    add_edge!(g,10,11)
    add_edge!(g,10,12)
    match = @inferred(max_cardinality_matching(g))
    @test match.mate == [3, 4, 1, 2, 0, 7, 6, 9, 8, 11, 10, 0]
    @test match.matched_edges == [[1, 3], [2, 4], [6, 7], [8, 9], [10, 11]]

    g = SimpleGraph(12)
    add_edge!(g,1,2)
    add_edge!(g,1,3)
    add_edge!(g,3,2)
    add_edge!(g,5,2)
    add_edge!(g,6,2)
    add_edge!(g,4,2)
    add_edge!(g,9,7)
    add_edge!(g,8,7)
    add_edge!(g,8,11)
    add_edge!(g,9,10)
    add_edge!(g,9,8)
    add_edge!(g,10,11)
    add_edge!(g,10,12)
    match = @inferred(max_cardinality_matching(g))
    @test match.mate == [3, 4, 1, 2, 0, 0, 9, 11, 7, 12, 8, 10]
    @test match.matched_edges == [[1, 3], [2, 4], [7, 9], [8, 11], [10, 12]] 
    
end
using Test

include("../main.jl")

@testset "First test set" begin
    @test f(1) == 2
end


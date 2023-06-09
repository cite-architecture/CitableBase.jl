using Pkg
Pkg.activate("..")

using CitableBase 
using Test
using TestSetExtensions

#=
struct TestUrn <: Urn
    s::AbstractString
end
=#

@testset "All the tests" begin
    println(map(s -> replace(s, r".jl$" => ""), ARGS))
    @includetests map(s -> replace(s, r".jl$" => ""), ARGS)
end
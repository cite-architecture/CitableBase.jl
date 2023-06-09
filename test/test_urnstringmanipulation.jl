struct TestUrn <: Urn
    s::AbstractString
end

import Base: string
function string(u::TestUrn)
    u.s
end 


@testset "Test range patterns" begin
    @test CitableBase.str_isrange("x-y")
    @test CitableBase.str_isrange("xy") == false
    @test_throws ArgumentError CitableBase.str_isrange("-y")
    @test_throws ArgumentError CitableBase.str_isrange("x-y-z")

    u = TestUrn("rangey-value")
    @test isrange(u)
    @test isrange(TestUrn("singlevalue")) == false
    @test_throws ArgumentError isrange(TestUrn("-z"))
    @test_throws ArgumentError isrange(TestUrn("x-y-z"))
end
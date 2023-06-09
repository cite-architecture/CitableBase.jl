
@testset "Test range patterns" begin
    @test CitableBase.str_isrange("x-y")
    @test CitableBase.str_isrange("xy") == false
end
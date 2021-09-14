@testset "Test extending cex function for serialization" begin
    struct PretendCitable <: Citable
        col1
        col2
    end
    function cex(pc::PretendCitable, delim="|")
        join([pc.col1, pc.col2], delim)
    end
    pc = PretendCitable("x", "y")
    @test cex(pc) == "x|y"
    @test cex(pc, "#") == "x#y"
end
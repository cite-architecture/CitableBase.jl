@testset "Test extending Citable abstract type" begin
    struct MyUrn <: Urn
            urn::AbstractString
    end
    struct MyCite <: Citable
        urn
        label
    end
    u = MyUrn("urn:fake:id.subid")
    c = MyCite(u, "label")
    function urn(c::MyCite)
        c.urn
    end
    function label(c::MyCite)
        c.label
    end
    function cex(c::MyCite, delimiter = "|")
        join([c.urn.urn, c.label], delimiter)
    end
    @test urn(c) == u
    @test label(c) == "label"
    @test cex(c) == "urn:fake:id.subid|label"
    
end

@testset "Test incomplete implementation of Citable" begin
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
    @test_throws MethodError urn(pc)
    @test_throws MethodError label(pc)
end


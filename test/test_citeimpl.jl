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
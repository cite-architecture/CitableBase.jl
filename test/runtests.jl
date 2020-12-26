using CiteBase
using Test, URIs

@testset "URI compliance" begin
        urnString = "urn:cts:greekLit:tlg0012.tlg001.msA:1.1"
        u = CtsUrn(urnString)
        @test u.string == urnString
        @test isvalid(u.string)
end

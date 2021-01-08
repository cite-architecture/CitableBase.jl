using CitableBase
using Test

@testset "Extending URN abstract type" begin
        struct FakeUrn <: Urn
                urn::AbstractString
        end
        u = FakeUrn("urn:fake:id.subid")
        c = Citable(u, "label")
        
        @test u.urn == "urn:fake:id.subid"
        @test c.urn == u
        @test c.label == "label"
        @test components(u) == ["urn", "fake", "id.subid"]
        @test parts(components(u)[3]) == ["id", "subid"]
end

@testset "Generic URN validation" begin
        @test validurn("urn:mytype:val")
        @test validurn("urn:mytype:val:with:many:more:parts")
        @test validurn("urn:mytype:") == false
        @test validurn("urn::val") == false
        @test validurn("urnX:mytype:val") == false
end



@testset "Top-level components of URNs are separated by a colon" begin
        passageString = "urn:cts:greekLit:tlg0012.tlg001.msA:1.1"
        toplevel = components(passageString)
        @test size(toplevel,1) == 5
end

@testset "Parts of top-level components of URNs are separated by a period" begin
        group = "tlg0012.tlg001.msA"
        groupparts = parts(group)
        @test size(groupparts,1) == 3
end

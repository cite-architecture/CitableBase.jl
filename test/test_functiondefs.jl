@testset "Test extending URN abstract type" begin
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

@testset "Test fall-back definition of validurn" begin
    struct FakeUrn <: Urn
        urn::AbstractString
    end
    u = FakeUrn("urn:fake:id.subid")
    @test isnothing(dropversion(u))
    @test isnothing(addversion(u, "versionid"))
end



@testset "Test ovveride validurn" begin
    struct FakeUrn <: Urn
        urn::AbstractString
    end
    function dropversion(u::FakeUrn)
        "Success"
    end
    function addversion(u::FakeUrn, s)
        "Success adding $s"
    end
    u = FakeUrn("urn:fake:id.subid")
    @test dropversion(u) == "Success"
    @test addversion(u, "versionid") == "Success adding versionid"
end
@testset "Test extending URN abstract type" begin
    struct FakeUrn <: Urn
            urn::AbstractString
    end
    struct FakeCite <: Citable
        urn
        label
    end

    u = FakeUrn("urn:fake:id.subid")
    c = FakeCite(u, "label")
    
    @test u.urn == "urn:fake:id.subid"
    @test c.urn == u
    @test c.label == "label"
    @test components(u) == ["urn", "fake", "id.subid"]
    @test parts(components(u)[3]) == ["id", "subid"]
end

@testset "Test fall-back definition of validurn" begin
    u = FakeUrn("urn:fake:id.subid")
    @test isnothing(dropversion(u))
    @test isnothing(addversion(u, "versionid"))
end

@testset "Test ovveride validurn" begin
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
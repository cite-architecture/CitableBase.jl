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


@testset "Test incomplete implementation of URN" begin
    struct IncompleteUrn <: Urn
        urn::AbstractString
    end
   incompleteUrn =  IncompleteUrn("urn")
   @test_throws MethodError dropversion(incompleteUrn)
   @test_throws MethodError addversion(incompleteUrn, "v1")
end
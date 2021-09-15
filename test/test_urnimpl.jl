@testset "Test extending URN abstract type" begin
    struct FakeUrn <: Urn
            urn::AbstractString
    end
    fakeUrn = FakeUrn("urn:fake:id.subid")
    function urn(u::FakeUrn)
        u.urn
    end
     @test urn(fakeUrn) == "urn:fake:id.subid"
  end

@testset "Test dispatch of shared methods" begin
    struct UrnType2 <: Urn
        urn::AbstractString
    end
    urn2 = UrnType2("urn:type2:urnid")
    function urn(u::UrnType2)
        u.urn
    end
    @test urn(urn2) == "urn:type2:urnid"
end

@testset "Test incomplete implementation of URN" begin
    struct IncompleteUrn <: Urn
        urn::AbstractString
    end
   incompleteUrn =  IncompleteUrn("urn")
   @test_throws MethodError dropversion(incompleteUrn)
   @test_throws MethodError addversion(incompleteUrn, "v1")
end

@testset "Test application of dispatched functions" begin
    fakeUrn = FakeUrn("urn:fake:id.subid")
    components(fakeUrn)
end
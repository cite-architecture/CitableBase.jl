struct TestUrn <: Urn
    s::AbstractString
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

@testset "Test URN ranges" begin
    u = TestUrn("1-5")
    @test isrange(u)
end

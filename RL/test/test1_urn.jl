
@testset "Test Base overrides for Isbn10Urn" begin
    @test supertype(Isbn10Urn) == Urn

    distanthorizons = Isbn10Urn("urn:isbn10:022661283X")
    dupe = distanthorizons
    @test distanthorizons == dupe
    enumerations = Isbn10Urn("urn:isbn10:022656875X")
    @test distanthorizons != enumerations

    @test string(distanthorizons) == "urn:isbn10:022661283X"
end


@testset "Test UrnComparisonTrait for Isbn10Urn" begin
    distanthorizons = Isbn10Urn("urn:isbn10:022661283X")
    enumerations = Isbn10Urn("urn:isbn10:022656875X")
    wrong = Isbn10Urn("urn:isbn10:1108922036")
    qi = Isbn10Urn("urn:isbn10:3030234133")

    @test urncomparisontrait(typeof(distanthorizons)) == RL.IsbnComparable()
    @test urncomparable(distanthorizons)

    dupe = distanthorizons
    @test urnequals(distanthorizons, dupe)
    @test urnequals(distanthorizons, enumerations) == false

    @test urncontains(distanthorizons, enumerations)
    @test urncontains(distanthorizons, wrong) == false
    @test urncontains(distanthorizons, qi) == false

    @test urnsimilar(distanthorizons, wrong)
    @test urnsimilar(distanthorizons, enumerations)
    @test urnsimilar(distanthorizons, qi) == false

end
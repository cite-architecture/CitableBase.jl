@testset "Test Base overrides for CitableBook" begin
    distanthorizons = Isbn10Urn("urn:isbn10:022661283X")
    enumerations = Isbn10Urn("urn:isbn10:022656875X")
    wrong = Isbn10Urn("urn:isbn10:1108922036")
    qi = Isbn10Urn("urn:isbn10:3030234133")

    distantbook = CitableBook(distanthorizons, "Distant Horizons: Digital Evidence and Literary Change", "Ted Underwood")
    enumerationsbook = CitableBook(enumerations, "Enumerations: Data and Literary Study", "Andrew Piper")
    wrongbook = CitableBook(wrong, "Andrew Piper", "Can We Be Wrong? The Problem of Textual Evidence in a Time of Data")
    qibook = CitableBook(qi, "Quantitative Intertextuality: Analyzing the Markers of Information Reuse","Christopher W. Forstall and Walter J. Scheirer")

    dupe = distantbook
    @test distantbook == dupe
    @test distantbook != enumerationsbook

    @test string(enumerationsbook) == "Andrew Piper, *Enumerations: Data and Literary Study* (urn:isbn10:022656875X)"

end


@testset "Test CitableTrait for CitableBook" begin
end

@testset "Test UrnComparisonTrait for CitableBook" begin
end

@testset "Test CexTrait for CitableBook" begin
end
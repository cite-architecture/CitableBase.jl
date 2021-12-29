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
    distanthorizons = Isbn10Urn("urn:isbn10:022661283X")
    enumerations = Isbn10Urn("urn:isbn10:022656875X")
    wrong = Isbn10Urn("urn:isbn10:1108922036")
    qi = Isbn10Urn("urn:isbn10:3030234133")

    distantbook = CitableBook(distanthorizons, "Distant Horizons: Digital Evidence and Literary Change", "Ted Underwood")
    enumerationsbook = CitableBook(enumerations, "Enumerations: Data and Literary Study", "Andrew Piper")
    wrongbook = CitableBook(wrong, "Andrew Piper", "Can We Be Wrong? The Problem of Textual Evidence in a Time of Data")
    qibook = CitableBook(qi, "Quantitative Intertextuality: Analyzing the Markers of Information Reuse","Christopher W. Forstall and Walter J. Scheirer")

    @test citabletrait(typeof(distantbook)) == RL.CitableByIsbn10()
    @test citable(distantbook)

    @test urn(distantbook) == distanthorizons
    @test label(distantbook) == "Ted Underwood, *Distant Horizons: Digital Evidence and Literary Change* (urn:isbn10:022661283X)"
end

@testset "Test UrnComparisonTrait for CitableBook" begin
    distanthorizons = Isbn10Urn("urn:isbn10:022661283X")
    enumerations = Isbn10Urn("urn:isbn10:022656875X")
    wrong = Isbn10Urn("urn:isbn10:1108922036")
    qi = Isbn10Urn("urn:isbn10:3030234133")

    distantbook = CitableBook(distanthorizons, "Distant Horizons: Digital Evidence and Literary Change", "Ted Underwood")
    enumerationsbook = CitableBook(enumerations, "Enumerations: Data and Literary Study", "Andrew Piper")
    wrongbook = CitableBook(wrong, "Andrew Piper", "Can We Be Wrong? The Problem of Textual Evidence in a Time of Data")
    qibook = CitableBook(qi, "Quantitative Intertextuality: Analyzing the Markers of Information Reuse","Christopher W. Forstall and Walter J. Scheirer")

    @test urncomparisontrait(typeof(distantbook)) == RL.BookComparable()
    @test urncomparable(distantbook)

    dupebook = distantbook
    @test urnequals(distantbook, dupebook)
    @test urnequals(distantbook, enumerationsbook) == false

    @test urncontains(distantbook, enumerationsbook)
    @test urncontains(distantbook, wrongbook) == false
    @test urncontains(distantbook, qibook) == false

    @test urnsimilar(distantbook, wrongbook)
    @test urnsimilar(distantbook, enumerationsbook)
    @test urnsimilar(distantbook, qibook) == false
end

@testset "Test CexTrait for CitableBook" begin
    distanthorizons = Isbn10Urn("urn:isbn10:022661283X")
    enumerations = Isbn10Urn("urn:isbn10:022656875X")
    wrong = Isbn10Urn("urn:isbn10:1108922036")
    qi = Isbn10Urn("urn:isbn10:3030234133")

    distantbook = CitableBook(distanthorizons, "Distant Horizons: Digital Evidence and Literary Change", "Ted Underwood")
    enumerationsbook = CitableBook(enumerations, "Enumerations: Data and Literary Study", "Andrew Piper")
    wrongbook = CitableBook(wrong, "Andrew Piper", "Can We Be Wrong? The Problem of Textual Evidence in a Time of Data")
    qibook = CitableBook(qi, "Quantitative Intertextuality: Analyzing the Markers of Information Reuse","Christopher W. Forstall and Walter J. Scheirer")


    @test cextrait(typeof(distantbook)) == RL.BookCex()
    @test cexserializable(distantbook)

    cexexpected = "urn:isbn10:022661283X|Distant Horizons: Digital Evidence and Literary Change|Ted Underwood"
    @test cex(distantbook) == cexexpected
    restored = fromcex(cex(distantbook), CitableBook)
    @test restored == distantbook

end
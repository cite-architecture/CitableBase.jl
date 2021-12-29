@testset "Test design and Base overrides for ReadingList" begin
    distanthorizons = Isbn10Urn("urn:isbn10:022661283X")
    enumerations = Isbn10Urn("urn:isbn10:022656875X")
    wrong = Isbn10Urn("urn:isbn10:1108922036")
    qi = Isbn10Urn("urn:isbn10:3030234133")

    distantbook = CitableBook(distanthorizons, "Distant Horizons: Digital Evidence and Literary Change", "Ted Underwood")
    enumerationsbook = CitableBook(enumerations, "Enumerations: Data and Literary Study", "Andrew Piper")
    wrongbook = CitableBook(wrong, "Andrew Piper", "Can We Be Wrong? The Problem of Textual Evidence in a Time of Data")
    qibook = CitableBook(qi, "Quantitative Intertextuality: Analyzing the Markers of Information Reuse","Christopher W. Forstall and Walter J. Scheirer")

    books = [distantbook, enumerationsbook, wrongbook, qibook]
    rl = ReadingList(books)

    @test string(rl) == "ReadingList with 4 items"
    @test rl.publications[4] == qibook
end

@testset "Test CitableCollectionTrait for ReadingList" begin
    distanthorizons = Isbn10Urn("urn:isbn10:022661283X")
    enumerations = Isbn10Urn("urn:isbn10:022656875X")
    wrong = Isbn10Urn("urn:isbn10:1108922036")
    qi = Isbn10Urn("urn:isbn10:3030234133")

    distantbook = CitableBook(distanthorizons, "Distant Horizons: Digital Evidence and Literary Change", "Ted Underwood")
    enumerationsbook = CitableBook(enumerations, "Enumerations: Data and Literary Study", "Andrew Piper")
    wrongbook = CitableBook(wrong, "Andrew Piper", "Can We Be Wrong? The Problem of Textual Evidence in a Time of Data")
    qibook = CitableBook(qi, "Quantitative Intertextuality: Analyzing the Markers of Information Reuse","Christopher W. Forstall and Walter J. Scheirer")

    books = [distantbook, enumerationsbook, wrongbook, qibook]
    rl = ReadingList(books)

    @test citablecollectiontrait(typeof(rl)) == RL.CitableReadingList()
    @test citablecollection(rl)
end

@testset "Test UrnComparisonTrait for ReadingList" begin
    distanthorizons = Isbn10Urn("urn:isbn10:022661283X")
    enumerations = Isbn10Urn("urn:isbn10:022656875X")
    wrong = Isbn10Urn("urn:isbn10:1108922036")
    qi = Isbn10Urn("urn:isbn10:3030234133")

    distantbook = CitableBook(distanthorizons, "Distant Horizons: Digital Evidence and Literary Change", "Ted Underwood")
    enumerationsbook = CitableBook(enumerations, "Enumerations: Data and Literary Study", "Andrew Piper")
    wrongbook = CitableBook(wrong, "Andrew Piper", "Can We Be Wrong? The Problem of Textual Evidence in a Time of Data")
    qibook = CitableBook(qi, "Quantitative Intertextuality: Analyzing the Markers of Information Reuse","Christopher W. Forstall and Walter J. Scheirer")

    books = [distantbook, enumerationsbook, wrongbook, qibook]
    rl = ReadingList(books)

    @test urncomparisontrait(typeof(rl)) == RL.ReadingListComparable()
    @test urncomparable(rl)

    @test urnequals(distanthorizons, rl) == [distantbook]
    @test urnsimilar(distanthorizons, rl) == [distantbook, enumerationsbook, wrongbook]
    @test urncontains(distanthorizons, rl) == [distantbook, enumerationsbook]
end

@testset "Test CexTrait for ReadingList" begin
    distanthorizons = Isbn10Urn("urn:isbn10:022661283X")
    enumerations = Isbn10Urn("urn:isbn10:022656875X")
    wrong = Isbn10Urn("urn:isbn10:1108922036")
    qi = Isbn10Urn("urn:isbn10:3030234133")

    distantbook = CitableBook(distanthorizons, "Distant Horizons: Digital Evidence and Literary Change", "Ted Underwood")
    enumerationsbook = CitableBook(enumerations, "Enumerations: Data and Literary Study", "Andrew Piper")
    wrongbook = CitableBook(wrong, "Can We Be Wrong? The Problem of Textual Evidence in a Time of Data", "Andrew Piper")
    qibook = CitableBook(qi, "Quantitative Intertextuality: Analyzing the Markers of Information Reuse","Christopher W. Forstall and Walter J. Scheirer")

    books = [distantbook, enumerationsbook, wrongbook, qibook]
    rl = ReadingList(books)

    @test cextrait(typeof(rl)) == RL.ReadingListCex()
    @test cexserializable(rl)

    expected = """#!citecollection
    urn:isbn10:022661283X|Distant Horizons: Digital Evidence and Literary Change|Ted Underwood
    urn:isbn10:022656875X|Enumerations: Data and Literary Study|Andrew Piper
    urn:isbn10:1108922036|Can We Be Wrong? The Problem of Textual Evidence in a Time of Data|Andrew Piper
    urn:isbn10:3030234133|Quantitative Intertextuality: Analyzing the Markers of Information Reuse|Christopher W. Forstall and Walter J. Scheirer
    """
    @test cex(rl) == expected
    restored = fromcex(cex(rl), ReadingList)
    @test string(rl) == string(restored)
end

@testset "Test Iterators for ReadingList" begin
    distanthorizons = Isbn10Urn("urn:isbn10:022661283X")
    enumerations = Isbn10Urn("urn:isbn10:022656875X")
    wrong = Isbn10Urn("urn:isbn10:1108922036")
    qi = Isbn10Urn("urn:isbn10:3030234133")

    distantbook = CitableBook(distanthorizons, "Distant Horizons: Digital Evidence and Literary Change", "Ted Underwood")
    enumerationsbook = CitableBook(enumerations, "Enumerations: Data and Literary Study", "Andrew Piper")
    wrongbook = CitableBook(wrong, "Andrew Piper", "Can We Be Wrong? The Problem of Textual Evidence in a Time of Data")
    qibook = CitableBook(qi, "Quantitative Intertextuality: Analyzing the Markers of Information Reuse","Christopher W. Forstall and Walter J. Scheirer")

    books = [distantbook, enumerationsbook, wrongbook, qibook]
    rl = ReadingList(books)

    @test length(rl) == 4
    @test eltype(rl) == RL.CitablePublication
    @test distantbook in rl
    @test collect(rl) == books
    for book in rl
        @test typeof(book) == CitableBook
    end
end
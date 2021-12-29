struct ReadingList
    publications::Vector{<: CitablePublication}
end
function show(io::IO, readingList::ReadingList)
    print(io, "ReadingList with ", length(readingList.publications), " items")
end

books = [distantbook, enumerationsbook, wrongbook, qibook]
rl = ReadingList(books)

struct CitableReadingList <: CitableCollectionTrait end

import CitableBase: citablecollectiontrait
function citablecollectiontrait(::Type{ReadingList})
    CitableReadingList()
end

struct ReadingListComparable <: UrnComparisonTrait end
function urncomparisontrait(::Type{ReadingList})
    ReadingListComparable()
end

function urnequals(urn::Isbn10Urn, reading::ReadingList, )
    filter(item -> urnequals(item.urn, urn), reading.publications)
end

function urncontains(urn::Isbn10Urn, reading::ReadingList)
    filter(item -> urncontains(item.urn, urn), reading.publications)
end

function urnsimilar(urn::Isbn10Urn, reading::ReadingList)
    filter(item -> urnsimilar(item.urn, urn), reading.publications)
end


struct ReadingListCex <: CexTrait end
function cextrait(::Type{ReadingList})
    ReadingListCex()
end


function cex(reading::ReadingList; delimiter = "|")
    header = "#!citecollection\n"
    strings = map(ref -> cex(ref, delimiter=delimiter), reading.publications)
    header * join(strings, "\n")
end

function fromcex(trait::ReadingListCex, cexsrc::AbstractString, T;
    delimiter = "|", configuration = nothing)

    lines = split(cexsrc, "\n")
    isbns = CitableBook[]
    inblock = false
    for ln in lines
        if ln == "#!citecollection"
            inblock = true
        elseif inblock
            bk = fromcex(ln, CitableBook)
            push!(isbns, bk)
        end
    end
    ReadingList(isbns)
end


import Base: iterate

function iterate(rlist::ReadingList)
    isempty(rlist.publications) ? nothing : (rlist.publications[1], 2)
end

function iterate(rlist::ReadingList, state)
    state > length(rlist.publications) ? nothing : (rlist.publications[state], state + 1)
end

import Base: length
function length(readingList::ReadingList)
    length(readingList.publications)
end
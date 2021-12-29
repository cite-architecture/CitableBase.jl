abstract type CitablePublication end
struct CitableBook <: CitablePublication
    urn::Isbn10Urn
    title::AbstractString
    authors::AbstractString
end

function show(io::IO, book::CitableBook)
    print(io, book.authors, ", *", book.title, "* (", book.urn, ")")
end

import Base.==
function ==(book1::CitableBook, book2::CitableBook)
    book1.urn == book2.urn && book1.title == book2.title && book1.authors == book2.authors
end

struct CitableByIsbn10 <: CitableTrait end
import CitableBase: citabletrait
function citabletrait(::Type{CitableBook})
    CitableByIsbn10()
end

import CitableBase: urn
function urn(book::CitableBook)
    book.urn
end

import CitableBase: label
function label(book::CitableBook)
    string(book)
end


struct BookComparable <: UrnComparisonTrait end
function urncomparisontrait(::Type{CitableBook})
    BookComparable()
end

function urnequals(bk1::CitableBook, bk2::CitableBook)
    bk1.urn == bk2.urn
end
function urncontains(bk1::CitableBook, bk2::CitableBook)
    urncontains(bk1.urn, bk2.urn)
end
function urnsimilar(bk1::CitableBook, bk2::CitableBook)
    urnsimilar(bk1.urn, bk2.urn)
end

struct BookCex <: CexTrait end
import CitableBase: cextrait
function cextrait(::Type{CitableBook})
    BookCex()
end

import CitableBase: cex
"Implement for CitableBook"
function cex(book::CitableBook; delimiter = "|")
    join([string(book.urn), book.title, book.authors], delimiter)
end

import CitableBase: fromcex
function fromcex(traitvalue::BookCex, cexsrc::AbstractString, T;
    delimiter = "|", configuration = nothing)
    fields = split(cexsrc, delimiter)
    urn = Isbn10Urn(fields[1])
    CitableBook(urn, fields[2], fields[3])
end









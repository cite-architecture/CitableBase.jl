```@setup collections
using CitableBase
struct Isbn10Urn <: Urn
    isbn::AbstractString
end
import Base: show
function show(io::IO, u::Isbn10Urn)
    print(io, u.isbn)
end
import CitableBase:  UrnComparisonTrait
struct IsbnComparable <: UrnComparisonTrait end
UrnComparisonTrait(::Type{Isbn10Urn}) = IsbnComparable()
import CitableBase: urnequals
function urnequals(u1::Isbn10Urn, u2::Isbn10Urn)
    u1 == u2
end
import CitableBase: urncontains
function urncontains(u1::Isbn10Urn, u2::Isbn10Urn)
    initial1 = components(u1.isbn)[3][1]
    initial2 = components(u2.isbn)[3][1]

    initial1 == initial2
end

function english(urn::Isbn10Urn)
    langarea = components(urn.isbn)[3][1]
    langarea == '0' || langarea == '1'
end

import CitableBase: urnsimilar
function urnsimilar(u1::Isbn10Urn, u2::Isbn10Urn)
    initial1 = components(u1.isbn)[3][1]
    initial2 = components(u2.isbn)[3][1]

    (english(u1) && english(u2)) ||  initial1 == initial2
end
distanthorizons = Isbn10Urn("urn:isbn:022661283X")
enumerations = Isbn10Urn("urn:isbn:022656875X")
wrong = Isbn10Urn("urn:isbn:1108922036")

abstract type CitablePublication end
struct CitableBook <: CitablePublication
    urn::Isbn10Urn
    title::AbstractString
    authors::AbstractString
end
distantbook = CitableBook(distanthorizons, "Distant Horizons: Digital Evidence and Literary Change", "Ted Underwood")
enumerationsbook = CitableBook(enumerations, "Enumerations: Data and Literary Study", "Andrew Piper")

import CitableBase: CitableTrait
struct CitableByIsbn10 <: CitableTrait end
CitableTrait(::Type{CitableBook}) = CitableByIsbn10()

import CitableBase: urn
function urn(book::CitableBook)
    book.urn
end

import CitableBase: label
function label(book::CitableBook)
    join([book.authors, "*" * book.title * "*"], ", ")
end

struct BookComparable <: UrnComparisonTrait end
UrnComparisonTrait(::Type{CitableBook}) = BookComparable()

function urnequals(bk1::CitableBook, bk2::CitableBook)
    bk1.urn == bk2.urn
end
function urncontains(bk1::CitableBook, bk2::CitableBook)
    urncontains(bk1.urn, bk2.urn)
end
function urnsimilar(bk1::CitableBook, bk2::CitableBook)
    urnsimilar(bk1.urn, bk2.urn)
end
wrongbook = CitableBook(wrong, "Andrew Piper", "Can We Be Wrong? The Problem of Textual Evidence in a Time of Data")

struct BookCex <: CexTrait end
CexTrait(::Type{CitableBook}) = BookCex()

import CitableBase: cex
function cex(book::CitableBook; delimiter = "|")
    join([string(book.urn), book.title, book.authors], delimiter)
end

import CitableBase: fromcex
function fromcex(cexstring::AbstractString, T; delimiter = "|", configuration = nothing)
    fields = split(cexstring, delimiter)
    urn = Isbn10Urn(fields[1])
    CitableBook(urn, fields[2], fields[3])
end
```




# Citable collections

!!! note "TBD"

    This page will 
    
    - √ define a `ReadingList` type 
    - √ implement the `CitableCollectionTrait`
    - implement `UrnComparisonTrait`, 
    - implement the `CexTrait`
    - implement `Iterators`.



## The task

## Defining the `ReadingList` type

```@example collections
struct ReadingList
    booklist::Vector{<: CitablePublication}
end
```

```@example collections
books = [distantbook, enumerationsbook, wrongbook,
    CitableBook(
        Isbn10Urn("3030234133"),"Quantitative Intertextuality
Analyzing the Markers of Information Reuse", "Christopher W. Forstall and Walter J. Scheirer"
    )
]
rl = ReadingList(books)
```


## Defining the `CitableCollectionTrait`

```@example collections
import CitableBase: CitableCollectionTrait
struct CitableReadingList <: CitableCollectionTrait end
CitableCollectionTrait(::Type{ReadingList}) = CitableReadingList()
```

```@example collections
citablecollection(rl)
```

## Defining the `UrnComparisonTrait`


```@example collections
struct ReadingListComparable <: UrnComparisonTrait end
UrnComparisonTrait(::Type{ReadingList}) = ReadingListComparable()
```

```@example collections
urncomparable(rl)
```



## Defining the `CexTrait`

## Defining the `Iterators`


---

> ---
> ---
>
> # QUARRY UNEDITED MATERIAL BELOW THIS
>

## Filtering a citable collection

Whether you use `Cite2Urn`s, `CtsUrn`s, or define your own URN type, as we did for ISBNs, filtering a collection of your content with URN logic is straightforward. All you need to do is define functions for `urnequals`, `urncontains` and `urnsimilar` that take a URN parameter to filter with (here, an `Isbn10Urn`), and a citable collection to filter (here, a `ReadingList`).  If no objects match, we'll return `nothing`; otherwise, we'll return a list of content matching your URN.


```
function urnequals(isbn::Isbn10Urn, rlist::ReadingList)
    matches = filter(i -> i == isbn, rlist.reff)
    isempty(matches) ? nothing : matches
end

function urncontains(isbn::Isbn10Urn, rlist::ReadingList)
    matches = filter(i -> urncontains(i, isbn), rlist.reff)
    isempty(matches) ? nothing : matches
end

function urnsimilar(isbn::Isbn10Urn, rlist::ReadingList)
    matches = filter(i -> urnsimilar(i, isbn), rlist.reff)
    isempty(matches) ? nothing : matches
end
```

```
urnequals(jane, rl)
```


```
group1 = Isbn10Urn("urn:isbn:1")
urncontains(group1, rl)
```

```
urnsimilar(group1, rl)
```



```
using CitableLibrary
using CitableBase

struct Isbn10Urn <: Urn
    isbn::AbstractString
end

distanthorizons = Isbn10Urn("urn:isbn:022661283X")
quantitativeintertextuality = Isbn10Urn("urn:isbn:3030234134")
enumerations = Isbn10Urn("urn:isbn:022656875X")
wrong = Isbn10Urn("urn:isbn:1108922036")
jane = Isbn10Urn("urn:isbn:0141395203") # Because all computational literary analysis is required to use Jane Austen as an example

struct ReadingList
    reff::Vector{Isbn10Urn}
end

import Base.==
function ==(rl1::ReadingList, rl2::ReadingList)
    rl1.reff == rl2.reff
end

rl = ReadingList([distanthorizons,enumerations, enumerations, wrong, jane])
```


# Serializing collections

In addition to making our citable collection comparable on URN logic and iterable, we must make it serializable to and from CEX format.   When we defined our `Isbn10Urn` type, it automatically inherited the `UrnComparable` trait because it was a subtype of `Urn`.  We saw this when we tested a collection with the `urncomparable` function.

```
urncomparable(jane)
```

In contrast, CEX-serializable content does not all fall within a single type hierarchy.  Instead, we will implement the `CexTrait` from `CitableBase`.  



## Defining our type as serializable

We first define our `ReadingList` type as serializable by importing the `CexTrait` type and assigning it a value of `CexSerializable()` for our type.  We can test whether this assignment is recognized  using the `cexserializable` function from `CitableBase`.

```
import CitableBase: CexTrait
CexTrait(::Type{ReadingList}) = CexSerializable()

cexserializable(rl)
```

When `cexserializable` is true, we know that `CitableBase` will dispatch functions to our type correctly.

## Implementing the required functions

Now we can implement the pair of inverse functions `cex` and `fromcex` from `CitableBase`.

To serialize our collection to CEX format, we'll compose a `citecollection` type of CEX block, and simply list each ISBN's string value, one per line.

```
import CitableBase: cex
function cex(reading::ReadingList; delimiter = "|")
    header = "#!citecollection\n"
    strings = map(ref -> ref.isbn, reading.reff)
    header * join(strings, "\n")
end
```

Let's see what our reading list looks in this format.

```
cexoutput = cex(rl)
println(cexoutput)
```

Now we'll write a function to instantiate a `ReadingList` from a string source.

!!! warning

    To keep this illustration brief and focused on the design of citable collections, we will naively begin reading data once we see a line containing the block header `citecollection`, and just read to the end of the file. This would fail on anything but the most trivial CEX source. For a real application, we would instead use the [`CiteEXchange` package](https://cite-architecture.github.io/CiteEXchange.jl/stable/) to work with CEX source data.  It includes functions to extract blocks and data lines by type or identifying URN, for example.

```
import CitableBase: fromcex
function fromcex(src::AbstractString, ReadingList; delimiter = "|")
    isbns = []
    lines = split(src, "\n")
    inblock = false
    for ln in lines
        if ln == "#!citecollection"
            inblock = true
        elseif inblock
            push!(isbns,Isbn10Urn(ln))
        end 
    end
    ReadingList(isbns)
end
```

The acid test: can we roundtrip the CEX output back to an equivalent `ReadingList`?

```
rl2 = fromcex(cexoutput, ReadingList)
rl == rl2
```





```
import Base: iterate

function iterate(rlist::ReadingList)
    (rlist.reff[1], 2)
end

function iterate(rlist::ReadingList, state)
    if state > length(rlist.reff)
        nothing
    else
        (rlist.reff[state], state + 1)
    end
end
```

```
for item in rl
    println(item)
end
```

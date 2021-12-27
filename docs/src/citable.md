```@setup book
using CitableBase
struct Isbn10Urn <: Urn
    isbn::AbstractString
end
import Base: show
function show(io::IO, u::Isbn10Urn)
    print(io, u.isbn)
end
import CitableBase: UrnComparisonTrait
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
```
# Citable entities


!!! note "TBD"

    This page will 
    
    - √ define a `CitableBook` type
    - √ implement the `CitableTrait`
    - √ implement the `UrnComparisonTrait`
    - √ implement `CexTrait`


## The task

We will define a type representing a book identified by ISBN-10 number.  Our type will follow the CITE architecture's model of a citable object, so that we can identify it by URN and label, apply URN logic to compare objects of our new type, and serialize citable books to plain-text format.


## Defining the `CitableBook`



```@example book
abstract type CitablePublication end
struct CitableBook <: CitablePublication
    urn::Isbn10Urn
    title::AbstractString
    authors::AbstractString
end
```



```@example book
distantbook = CitableBook(distanthorizons, "Distant Horizons: Digital Evidence and Literary Change", "Ted Underwood")
enumerationsbook = CitableBook(enumerations, "Enumerations: Data and Literary Study", "Andrew Piper")
```

## Defining the `CitableTrait`




```@example book
import CitableBase: CitableTrait
struct CitableByIsbn10 <: CitableTrait end
CitableTrait(::Type{CitableBook}) = CitableByIsbn10()
```

```@example book
citable(distantbook)
```

### Defining the required functions `urn` and `label`


```@example book
import CitableBase: urn
function urn(book::CitableBook)
    book.urn
end

import CitableBase: label
function label(book::CitableBook)
    join([book.authors, "*" * book.title * "*"], ", ")
end
```

```@example book
urn(distantbook)
```


```@example book
label(distantbook)
```

## Defining the `UrnComparisonTrait`

```@example book
struct BookComparable <: UrnComparisonTrait end
UrnComparisonTrait(::Type{CitableBook}) = BookComparable()
```

```@example book
urncomparable(distantbook)
```

### Defining the required functions `urnequals`, `urncontains` and `urnsimilar`

```@example book
function urnequals(bk1::CitableBook, bk2::CitableBook)
    bk1.urn == bk2.urn
end
function urncontains(bk1::CitableBook, bk2::CitableBook)
    urncontains(bk1.urn, bk2.urn)
end
function urnsimilar(bk1::CitableBook, bk2::CitableBook)
    urnsimilar(bk1.urn, bk2.urn)
end
```

```@example book
dupebook = distantbook
urnequals(distantbook, dupebook)
```

```@example book
urnequals(distantbook, enumerationsbook)
```



```@example book
urncontains(distantbook, enumerationsbook)
```

```@example book
urnsimilar(distantbook, enumerationsbook)
```


```@example book
wrongbook = CitableBook(wrong, "Andrew Piper", "Can We Be Wrong? The Problem of Textual Evidence in a Time of Data")
urnsimilar(distantbook, wrongbook)
```



## Defining the `CexTrait`


```@example book
struct BookCex <: CexTrait end
CexTrait(::Type{CitableBook}) = BookCex()
```

```@example book
cexserializable(distantbook)
```





### Defining the required functions `cex` and `fromcex`

```@example book
import CitableBase: cex
function cex(book::CitableBook; delimiter = "|")
    join([string(book.urn), book.title, book.authors], delimiter)
end
```

```@example book
cex(distantbook)
```


```@example book
import CitableBase: fromcex
#=
function fromcex(cexstring::AbstractString, T; delimiter = "|", configuration = nothing)
    fields = split(cexstring, delimiter)
    urn = Isbn10Urn(fields[1])
    CitableBook(urn, fields[2], fields[3])
end
=#

function fromcex(BookCex, cexstring::AbstractString, T; delimiter = "|", configuration = nothing)
    fields = split(cexstring, delimiter)
    urn = Isbn10Urn(fields[1])
    CitableBook(urn, fields[2], fields[3])
end
```



```@example book
cexoutput = cex(distantbook)
fromcex(cexoutput, CitableBook)
```
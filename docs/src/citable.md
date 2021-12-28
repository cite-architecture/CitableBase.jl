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
distanthorizons = Isbn10Urn("urn:isbn10:022661283X")
enumerations = Isbn10Urn("urn:isbn10:022656875X")
wrong = Isbn10Urn("urn:isbn10:1108922036")
```
# Citable entities


> # Summary
>
> **The task**: We will define a type representing a book identified by ISBN-10 number.  Our type will follow the CITE architecture's model of a citable object, so that we can identify it by URN and label, apply URN logic to compare objects of our new type, and serialize citable books to plain-text format.
>
> **The implementation**:
>
> - define a new type of citable object, the `CitableBook`
> - implement citation functions for it (the `CitableTrait`)
> - implement comparison using URN logic (the `UrnComparisonTrait`)
> - implement round-trip serialization (the `CexTrait`)




## Defining the `CitableBook`

We'll take advantage of Julia's type hierarchy to create an abstract `CitablePublication` type, and make `CitableBook` a subtype of it.  We won't create any further subtypes in this guide, but if we wanted to implement a type for some other form of citable publication, we could then share code applicable to any type of publication (that is, any subtype of `CitablePublication`).

We'll identify the book using the `Isbn10Urn` type we previously defined. Again, we'll keep the example simple, and just include strings for authors and a title.  You could elaborate this type however you choose.

```@example book
abstract type CitablePublication end
struct CitableBook <: CitablePublication
    urn::Isbn10Urn
    title::AbstractString
    authors::AbstractString
end
```

As we did with the `Isbn10Urn`, we'll override the `Base` package's `show` function for our new type.

```@example book
function show(io::IO, book::CitableBook)
    print(io, book.authors, ", *", book.title, "* (", book.urn, ")")
end
```

We can test this by creating a couple of examples of our new type.

```@example book
distantbook = CitableBook(distanthorizons, "Distant Horizons: Digital Evidence and Literary Change", "Ted Underwood")
enumerationsbook = CitableBook(enumerations, "Enumerations: Data and Literary Study", "Andrew Piper")
```

## Implementing the `CitableTrait`

The first trait we will implement is the `CitableTrait`.  We'll follow the same pattern we saw when we implemented the `UrnComparisonTrait` for the `Isbn10Urn` type. 

1. define a singleton type to use for the trait value
2. override the function identifying the trait value for our new type.  This time the function is named `citabletrait`, and we'll define it to return the concrete value `CitableByIsnb10()` for the type `CitableBook`.

```@example book
struct CitableByIsbn10 <: CitableTrait end

import CitableBase: citabletrait
function citabletrait(::Type{CitableBook})
    CitableByIsbn10()
end
```

```@example book
citabletrait(typeof(distantbook))
```

There is a `citable` function that tests whether individual objects belong to a type implementing the function. (This is parallel to the `urncomparable` function we saw before.) 

```@example book
citable(distantbook)
```

### Implementing the required functions `urn` and `label`
 
 Implementing `urn` and `label` is now trivial.  The `urn` function just returns the `urn` field of the book.  In Julia, `Base.show` underlies the `string` function, so since we have already implemented `show` for our book type, we can just return `string(book)` for the `label` function.
 

```@example book
import CitableBase: urn
function urn(book::CitableBook)
    book.urn
end

import CitableBase: label
function label(book::CitableBook)
    string(book)
end
```

```@example book
urn(distantbook)
```


```@example book
label(distantbook)
```

## Implementing the `UrnComparisonTrait`

We'll define the `UrnComparisonTrait` for our book type in exactly the same way we did for our URN type (and we've already imported `urncomparisontrait`).

```@example book
struct BookComparable <: UrnComparisonTrait end

function urncomparisontrait(::Type{CitableBook})
    BookComparable()
end
```

```@example book
urncomparisontrait(typeof(distantbook))
```

```@example book
urncomparable(distantbook)
```

### Defining the required functions `urnequals`, `urncontains` and `urnsimilar`

Implementing the URN comparison functions for a pair of `CitableBook`s is nothing more than applying the same URN comparison to the books' URNs.


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



## Implementing the `CexTrait`


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
"Implement for CitableBook"
function cex(book::CitableBook; delimiter = "|")
    join([string(book.urn), book.title, book.authors], delimiter)
end
```

```@example book
cex(distantbook)
```


```@example book
import CitableBase: fromcex
function fromcex(traittype, trait::BookCex, cexsrc::AbstractString, T; delimiter = "|", configuration = nothing)
    fields = split(cexsrc, delimiter)
    urn = Isbn10Urn(fields[1])
    CitableBook(urn, fields[2], fields[3])
end


```



```@example book
cexoutput = cex(distantbook)
restored = fromcex(cexoutput, CitableBook)
```



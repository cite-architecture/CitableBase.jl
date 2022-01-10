```@setup book
using CitableBase
struct Isbn10Urn <: Urn
    isbn::AbstractString
end

import Base: show
function show(io::IO, u::Isbn10Urn)
    print(io, u.isbn)
end

struct IsbnComparable <: UrnComparisonTrait end
import CitableBase: urncomparisontrait
function urncomparisontrait(::Type{Isbn10Urn})
    IsbnComparable()
end

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
qi = Isbn10Urn("urn:isbn10:3030234133")
wrong = Isbn10Urn("urn:isbn10:1108922036")
```


# Citable entities


> ## Summary
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
abstract type CitablePublication <: Citable end
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

We'll also override the `==` function so we can easily compare books for equality.

```@example book
import Base.==
function ==(book1::CitableBook, book2::CitableBook)
    book1.urn == book2.urn && book1.title == book2.title && book1.authors == book2.authors
end
```


We can test these by creating a couple of examples of our new type.

```@example book
distantbook = CitableBook(distanthorizons, "Distant Horizons: Digital Evidence and Literary Change", "Ted Underwood")
enumerationsbook = CitableBook(enumerations, "Enumerations: Data and Literary Study", "Andrew Piper")
```

```@example book
distantbook == enumerationsbook
```



## Implementing the `CitableTrait`

The first trait we will implement is the `CitableTrait`, which specifies that citable objects have an identifying URN and a human-readable label.  We'll follow the same general pattern we saw when we implemented the `UrnComparisonTrait` for the `Isbn10Urn` type, namely:

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

`CitableBase` includes the `citable` function to test whether individual objects belong to a type implementing the function. (This is parallel to the `urncomparable` function we saw before.) 

```@example book
citable(distantbook)
```

### Implementing the required functions `urntype`, `urn`, `label`
 
Implementing `urntype`, `urn` and `label` is now trivial.  The `urntype` function will report the type of URN we cite this object with. The `urn` function just returns the `urn` field of the book.  In Julia, `Base.show` underlies the `string` function, so since we have already implemented `show` for our book type, we can just return `string(book)` for the `label` function.
 

```@example book
import CitableBase: urntype
function urntype(book::CitableBook)
    Isbn10Urn
end

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
urntype(distantbook)
```

```@example book
urn(distantbook)
```


```@example book
label(distantbook)
```

## Implementing the `UrnComparisonTrait`

We've already seen the `UrnComparisonTrait`.  We'll now define it for our book type in exactly the same way we did for our URN type. (We don't even need to re-import its functions.)

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


Let's test these functions on `CitableBook`s the same way we tested them for URNs.

```@example book
dupebook = distantbook
urnequals(distantbook, dupebook)
```

```@example book
wrongbook = CitableBook(wrong, "Andrew Piper", "Can We Be Wrong? The Problem of Textual Evidence in a Time of Data")
urnequals(distantbook, wrongbook)
```

As before, our URNs define "similarity" as belonging to the same language area, so *Distant Horizons* and *Can We Be Wrong?* are similar.

```@example book
urnsimilar(distantbook, wrongbook)
```

But "containment" was defined as code for the same ISBN areas, so *Distant Horizons* does not "contain" *Can We Be Wrong?*.

```@example book
urncontains(distantbook, wrongbook)
```




## Implementing the `CexTrait`

Finally, we will implement the `CexTrait`.  It requires that we be able to round trip citable content to a plain-text representation in CEX format, and instantiate an equivalent object from the generated CEX. Once again we will:

1. define a singleton type to use for the trait value
2. override the function identifying the trait value for our new type. This time the function is named `cextrait`, and we'll define it to return the concrete value `CitableBook()` for the type `CitableBook`.


```@example book
struct BookCex <: CexTrait end
import CitableBase: cextrait
function cextrait(::Type{CitableBook})  
    BookCex()
end
```

```@example book
cextrait(typeof(distantbook))
```

`CitableBase` includes the `cexserializable` function to test individual objects.

```@example book
cexserializable(distantbook)
```



### Defining the required functions `cex` and `fromcex`

The `cex` function composes a delimited-text representation of an object on a single line, with fields separated by an optionally specified delimiting string.

```@example book
import CitableBase: cex
function cex(book::CitableBook; delimiter = "|")
    join([string(book.urn), book.title, book.authors], delimiter)
end
```

```@example book
cexoutput = cex(distantbook)
```

The inverse of `cex` is `fromcex`.  We need two essential pieces of information to convert a CEX string to an object:  the CEX source data, and the *type* of object to instantiate.  However, `CitableBase` dispatches this function on the *trait value* of the type want to instantiate.  Although we can find that value with the `cextrait` function, it needs to appear in the function signature for dispatch to work. We will therefore implement a function with three mandatory parameters: one for the trait value, and two more for the CEX data and Julia type to create.  (Two optional parameters allow you to define the delimiting string value, or create a dictionary with other configuration settings, but we won't need that for our implementation.)


```@example book
import CitableBase: fromcex
function fromcex(traitvalue::BookCex, cexsrc::AbstractString, T;      
    delimiter = "|", configuration = nothing)
    fields = split(cexsrc, delimiter)
    urn = Isbn10Urn(fields[1])
    CitableBook(urn, fields[2], fields[3])
end
```

!!! tip "Example of configuring `fromcex`"

    The `CitableLibrary` package implements `fromcex` for its `CiteLibrary` class. It uses the `configuration` parameter to map different kinds of content to Julia classes, and create a library that many include many different kinds of citable collections.  See its [documentation](https://cite-architecture.github.io/CitableLibrary.jl/stable/).

Note that because `CitableBase` can find our type's trait value on its own, it can delegate to the function we just wrote even when you invoke it only two parameters:  all a user needs to specify is the CEX data and Julia type.

```@example book
restored = fromcex(cexoutput, CitableBook)
```

The acid test: did we wind up with an equivalent book?

```@example book
distantbook == restored
```

## Recap: citable objects

This page  first defined the `CitableBook`.  Here's what an example looks like:

```@example book
dump(distantbook)
```

We implemented three traits which you can test for with boolean functions.

```@example book
citable(distantbook)
```

```@example book
urncomparable(distantbook)
```


```@example book
cexserializable(distantbook)
```

Those three traits allowed us to identify books by URN, compare books by URN, and round-trip books to and from plain-text representation.

Our initial goal was to manage a reading list of books citable by ISBN number.  We could do that directly with, say, a Vector of `CitableBook`s, but the next page shows how we could go a step futher by wrapping a Vector of `CitableBook`s in a type supporting the CITE architecture's definition of a collection with citable content.


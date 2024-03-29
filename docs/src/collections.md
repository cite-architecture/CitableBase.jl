```@setup collections
#page 1
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
wrong = Isbn10Urn("urn:isbn10:1108922036")

#page2
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
    delimiter = "|", configuration = nothing, strict = true)
    fields = split(cexsrc, delimiter)
    urn = Isbn10Urn(fields[1])
    CitableBook(urn, fields[2], fields[3])
end


qi = Isbn10Urn("urn:isbn10:3030234133")

distantbook = CitableBook(distanthorizons, "Distant Horizons: Digital Evidence and Literary Change", "Ted Underwood")
enumerationsbook = CitableBook(enumerations, "Enumerations: Data and Literary Study", "Andrew Piper")
wrongbook = CitableBook(wrong, "Can We Be Wrong? The Problem of Textual Evidence in a Time of Data", "Andrew Piper")
qibook = CitableBook(qi, "Quantitative Intertextuality: Analyzing the Markers of Information Reuse","Christopher W. Forstall and Walter J. Scheirer")


# root of repository in file system:
root = pwd() |> dirname |> dirname
```



# Citable collections

> ## Summary
>
> **The task**: We want to create a type for working with a *collection* of the citable books we developed on the previous page.  
> We should be able to filter the collection by appying URN logic to the identifiers for our books.  We should be able to write our collection to plain-text format and re-instantiate it from the plain-text representation.  And we should be able to apply any Julia functions for working with iterable content to our book list.
>
> **The implementation**:
> - define a new type for a collection of citable books, the `ReadingList` type
> - identify it as a citable collection (the `CitableCollectionTrait`)
> - implement filtering the collection using URN logic (the `UrnComparisonTrait`)
> - implement round-trip serialization (the `CexTrait`)
> - make the collection available to all Julia functions working with iterable content (`Iterators`)
>



## Defining the `ReadingList`

Our model for a reading list is simple: it's just a Vector of citable publications.  We'll annotate our vector as containing subtypes of the abstract `CitablePublication` we previously defined, even though in this example we'll only use our one concrete implementation, the `CitableBook`.  As with our other custom types, we'll override `Base.show`.


```@example collections
struct ReadingList
    publications::Vector{<: CitablePublication}
end
```

```@example collections
function show(io::IO, readingList::ReadingList)
    print(io, "ReadingList with ", length(readingList.publications), " items")
end
```

Let's see an example.

```@example collections
books = [distantbook, enumerationsbook, wrongbook, qibook]
rl = ReadingList(books)
```

The `publications` field is just a normal Julia Vector.


```@example collections
rl.publications[4]
```

What will make it different from other Vectors is that it will support a series of CITE traits


## Implementing the `CitableCollectionTrait`

We first want to identify our new type as fufilling the requirements of a citable collection with the `CitableCollectionTrait`. We'll repeat the pattern:

1. define a singleton type for the trait value.
2. override the function identifying the trait value for our new type.  Here the function is named `citablecollectiontrait`, and we'll define it to return the concrete value `CitableReadingList` for the tyupe `ReadingList`.


```@example collections
struct CitableReadingList <: CitableCollectionTrait end

import CitableBase: citablecollectiontrait
function citablecollectiontrait(::Type{ReadingList}) 
    CitableReadingList()
end
```

```@example collections
citablecollectiontrait(typeof(rl))
```
Use the `citablecollection` function to test if a specific object is a citable collection.

```@example collections
citablecollection(rl)
```

Like citable objects, citable collections should report the type of URN they use for citation.

```@example collections
import CitableBase: urntype
function urntype(readingList::ReadingList)
    Isbn10Urn
end
```


```@example collections
urntype(rl)
```

The promise we now need to fulfill is that our collection will implement three further traits for URN comparison, serialization and iteration.

## Implementing the `UrnComparisonTrait`

We have previously implemented the `UrnComparisonTrait` for an identifer type (the `Isbn10Urn`) and for a citable object type (the `CitableBook`).  In both of those cases, we compared two objects of the same type, and returned a boolean result of comparing them on URN logic.  

For our citable collection, we will implement the same suite of functions, but with a different signature and result type.  This time, our first parameter will be a URN which we will use to *filter* the collection given in the second parameter.  The result will be a (possibly empty) list of content in our citable collection -- in this example, a list of `CitableBook`s.

We mark our `ReadingList` type as urn-comparable exactly as we did for `Isbn10Urn`s and `CitableBook`s.

```@example collections
struct ReadingListComparable <: UrnComparisonTrait end
function urncomparisontrait(::Type{ReadingList}) 
    ReadingListComparable()
end
```

```@example collections
urncomparable(rl)
```


### Implementing the required functions `urnequals`, `urncontains` and `urnsimilar`

To implement the required functions, we'll just lean on the work we've already done: we'll use the boolean version of those functions to filter our collections.

```@example collections
function urnequals(urn::Isbn10Urn, reading::ReadingList, )
    filter(item -> urnequals(item.urn, urn), reading.publications)
end

function urncontains(urn::Isbn10Urn, reading::ReadingList)
    filter(item -> urncontains(item.urn, urn), reading.publications)
end

function urnsimilar(urn::Isbn10Urn, reading::ReadingList)
    filter(item -> urnsimilar(item.urn, urn), reading.publications)
end
```

If your collection does not allow duplicate identifiers, `urnequals` should return a list of 0 or 1 item.


```@example collections
urnequals(distanthorizons, rl)
```

Three of the books in our list are published in the English-language zone, and therefore will satisfy `urnsimilar` when compared to *Distant Horizons*.

```@example collections
urnsimilar(distanthorizons, rl)
```


But only two are published in the same ISBN area code as *Distant Horizons*:

```@example collections
urncontains(distanthorizons, rl)
```


## Implementing the `CexTrait`

As we did with citable objects, we want to ensure that we can round-trip an entire collection to and from delimited-text format.  We'll make our new `ReadingList` type implement `CexTrait` in the same way as `CitableBook`.


```@example collections
struct ReadingListCex <: CexTrait end
function cextrait(::Type{ReadingList})
    ReadingListCex()
end
```

```@example collections
cexserializable(rl)
```


### Implementing the required functions `cex` and `fromcex` 

We will serialize our collection with a header line identifying it as `citecollection` block, followed by one line for each book in our list.  We can format the books' data by mapping each book to an invocation the `cex` that we previously wrote for `CitableBook`s.

```@example collections
function cex(reading::ReadingList; delimiter = "|")
    header = "#!citecollection\n"
    strings = map(ref -> cex(ref, delimiter=delimiter), reading.publications)
    header * join(strings, "\n")
end
```


```@example collections
cexoutput = cex(rl)
println(cexoutput)
```

Recall from our experience implementing CEX serialization for `CitableBook`s that we will need to expose three mandatory parameters for `fromcex`: the trait value, the CEX data and the Julia type we want to instantiate.


```@example collections
function fromcex(trait::ReadingListCex, cexsrc::AbstractString, T; 
    delimiter = "|", configuration = nothing, strict = true)
    
    lines = split(cexsrc, "\n")
    datalines = filter(ln -> !isempty(ln), lines)
    isbns = CitableBook[]
    inblock = false
    for ln in datalines
        if ln == "#!citecollection"
            inblock = true
        elseif inblock
            bk = fromcex(ln, CitableBook)
            push!(isbns, bk)
        end
    end
    ReadingList(isbns)
end
```

!!! warning

    To keep this example brief and avoid introducing other packages, our implementation of `fromcex` naively assumes `cexsrc` will contain a single CEX block introduced by the `#!citecollection` heading.  This would break on real world CEX data sources: in a real application, we would instead use the `CiteEXchange` package to parse and extract appropriate blocks.  See the [documentation of `CiteEXchange`](https://cite-architecture.github.io/CiteEXchange.jl/stable/), or look at how a package like [`CitableCorpus`](https://cite-architecture.github.io/CitableCorpus.jl/stable/) uses `CiteEXchange` in its implementation of `fromcex` for different data type.


Once again, we can now invoke `fromcex` with just the parameters for the CEX data and desired Julia type to create, and `CitableBase` will find our implementation.

```@example collections
fromcex(cexoutput, ReadingList)
```

### Free bonus!

`CitableBase` optionally allows you to include a third parameter to the `fromcex` function naming the type of reader to apply to the first string parameter.  Valid values are `StringReader`, `FileReader` or `UrlReader`.  The previous example relied on the default value of `StringReader`.  The following examples use the file `RL/test/data/dataset.cex`  in this repository; its contents are the output of `cex(rl)` above.


```@example collections
fname = joinpath(root, "RL", "test", "data", "dataset.cex")
fileRL = fromcex(fname, ReadingList, FileReader)
```

```@example collections
url = "https://raw.githubusercontent.com/cite-architecture/CitableBase.jl/dev/RL/test/data/dataset.cex"
urlRL = fromcex(url, ReadingList, UrlReader)
```


## Implementing required and optional frnctions from `Base.Iterators`

The `Iterators` module in Julia `Base` was one of the first traits or interfaces in Julia.  It allows you to apply the same functions to many types of iterable collections.  We need to import the `Base.iterate` function, and implement two versions of it for our new type: one with a single parameter for the collection, and one with a second parameter maintaining some kind of state information.  Both of them have the same return type: either `nothing`, or a Tuple pairing one item in the collection with state information.

Since our reading list is keeping books in a Vector internally, we can use the state parameter to pass along an index into the Vector.  In the version of `iterate` with no parameters, we'll return the first item in the list, and set the "state" value to 2.  In the two-parameter version, we'll return the item indexed by the state count, and bump the count up one.


```@example collections
import Base: iterate

function iterate(rlist::ReadingList)
    isempty(rlist.publications) ? nothing : (rlist.publications[1], 2)
end

function iterate(rlist::ReadingList, state)
    state > length(rlist.publications) ? nothing : (rlist.publications[state], state + 1)
end
```


It is also useful (and trivial) to implement the optional methods for the length and base type of the collection.

```@example collections
import Base: length
function length(readingList::ReadingList)
    length(readingList.publications)
end


import Base: eltype
function eltype(readingList::ReadingList)
    CitablePublication
end
```

```@example collections
length(rl)
```

```@example collections
eltype(rl)
```

Now our `ReadingList` type is usable with all the richness of [the Julia interface for iterators](https://docs.julialang.org/en/v1/base/collections/#lib-collections-iteration).  Just a few examples:

- `for` loops 

```@example collections
for item in rl
    println(item)
end
```

- checking for presence of an item

```@example collections
distantbook in rl
```


- collect contents without having to know anything about the internal structure of the type

```@example collections
collect(rl)
```

## More free stuff!

The `slidingwindow` function does what its name suggests: it creates a Vector of Vectors by sliding a window along a collection.  
```@example collections
titles = map(bk -> bk.title, rl)
slidingwindow(titles)
```

It can also work directly on a citable collection.

```@example collections
slidingwindow(rl)
```


The `partitionvect` function partitions a Vector into a series of Vectors of a given size.  In contrast to `slidingwindow`, the elements in the new Vectors do not overlap.

`partitionvect` can work on any generic Vector.

```@example collections
v = collect(1:10)
partitionvect(v)
```

It also works on any citable collection.

```@example collections
partitionvect(rl)
```

## Recap: citable collections

On this page, we wrapped a citable collection type, te `ReadingList` around a Vector of `CitableBook`s.  We made the type identifiable as a citable collection.  We implemented filter of the collection on URN logic with the `UrnComparisonTrait`, and serialization with the `CexSerializableTrait`.  You can test these for these traits with boolean functions.


```@example collections
citablecollection(rl)
```



```@example collections
urncomparable(rl)
```


```@example collections
cexserializable(rl)
```

In addition, we made the `ReadingList` implement Julia's `Iterators` behavior.
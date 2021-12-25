# Citable collections

!!! note "TBD"

    This page will define a `ReadingList` type and implement the `CitableCollectionTrait`, `UrnComparisonTrait`, `CexTrait` and `Iterators`.






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

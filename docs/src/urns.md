# Identification with URNs

!!! note "TBD"

    This page will define an `Isbn10Urn` type and implement the `UrnComparisonTrait`.


The `Urn` abstract type models a Uniform Resource Name (URN). URNs have a string value with a specified syntax.  

> ADD LINKS TO URN SPECIFICATION AND INFO ON ISBN10

```@example urns
using CitableBase
struct Isbn10Urn <: Urn
    isbn::AbstractString
end

struct IsbnComparable <: UrnComparisonTrait end
import CitableBase: UrnComparisonTrait
UrnComparisonTrait(::Type{Isbn10Urn}) = IsbnComparable()

```

```@example urns
distanthorizons = Isbn10Urn("urn:isbn:022661283X")
urncomparable(typeof(distanthorizons))
```

```@example urns
import Base: show
function show(io::IO, u::Isbn10Urn)
    print(io, u.isbn)
end
```


quantitativeintertextuality = Isbn10Urn("urn:isbn:3030234134")
enumerations = Isbn10Urn("urn:isbn:022656875X")
wrong = Isbn10Urn("urn:isbn:1108922036")
jane = Isbn10Urn("urn:isbn:0141395203") # Because all computational literary analysis is required to use Jane Austen as an example
fake = FakeUrn("urn:fake:objectclass.objectid")
typeof(fake) |> supertype


Because it is a subtype of `Urn`, our new type is recognized as comparable on URN logic.

```
urncomparable(fake)

# output

true
```




# Filtering with URN logic


The [`CitableBase` package](https://cite-architecture.github.io/CitableBase.jl/stable/) identifies three kinds of URN comparison: *equality*, *containment* and *similarity*.  We want to be able to apply that logic to query our new `ReadingList` type.  If your citable collection includes objects cited by `Cite2Urn` or `CtsUrn`, this is as simple as filtering the collection using their `urnequals`, `urncontains` or `urnsimilar` functions.  Since we have defined a custom `Isbn10Urn` type, we'll need to implement those functions for our new URN type. We'll digress briefly with that implementation before turning to filtering our citable collection.


The `CitableBase` package provides a concrete implementation of `urnequals`, but we need to import and define functions for `urncontains` and `urnsimilar`


### Containment

For our ISBN type, we'll define "containment" as true when two ISBNS belong to the same initial-digit group (`0` - `4`).  We'll use the `components` functions from `CitableBase` to extract the third part of the URN string, and compare its first character.

```
import CitableBase: urncontains
function urncontains(u1::Isbn10Urn, u2::Isbn10Urn)
    initial1 = components(u1.isbn)[3][1]
    initial2 = components(u2.isbn)[3][1]

    initial1 == initial2
end
```

Both *Distant Horizons* and *Enumerations* are in ISBN group 0.

```
urncontains(distanthorizons, enumerations)
```

But *Can We Be Wrong?* is in ISBN group 1.

```
urncontains(distanthorizons, wrong)
```


### Similarity

We'll define "similarity" as belonging to the same language area.  In this definition, both `0` and `1` indicate English-language countries.


```
# True if ISBN starts with `0` or `1`
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
```

Both *Distant Horizons* and *Can We Be Wrong?* are published in English-language areas.

```
urnsimilar(distanthorizons, wrong)
```




## URN comparison

We need to implement three functions for our new URN type: `urnequals`, `urncontains` and `urnsimilar`.  



!!! note

    In addition to URN values, these three functions can be implemented for other types of objects.  See the following pages for an example of how they are applied to citable objects (subtypes of `Citable`);  for their use with collections of citable content, see the documentation for the [CitableLibary package](https://cite-architecture.github.io/CitableLibrary.jl/stable/).


   


The `==` function of Julia Base is overridden in `CitableBase` for all subtypes of `Urn`.  This in turn serves as an implementation of `urnequals` for subtypes of `Urn`.  



!!! warning

    Note that in order to compare two URNs for equality, you'll need to import or use `CitableBase` (as in the block above).

```
FakeUrn("urn:fake:demo1") == FakeUrn("urn:fake:demo1")

# output

true
```

To implement `urncontains` and `urnsimilar`, first import the method from `CitableBase`; then, implement the function with parameters for your new type.  

For this artificial example, we'll define one URN as "containing" another if they both belong to the URN type "urn:fake:".  We'll use a good generic definition for URN similarity: two URNs are similar if one contains the other or if both are equal.

```
import CitableBase: urncontains
function urncontains(u1::FakeUrn, u2::FakeUrn)
    startswith(u1.urn, "urn:fake:") && startswith(u2.urn, "urn:fake:")
end


import CitableBase: urnsimilar
function urnsimilar(u1::FakeUrn, u2::FakeUrn)
    urncontains(u1, u2) || urnequals(u1, u2)
end

urnsimilar(FakeUrn("urn:fake:demo1"),  FakeUrn("urn:fake:demo2"))

# output

true
```

```

urncontains(FakeUrn("urn:fake:demo1"),  FakeUrn("urn:fake:demo2"))

# output

true
```


## URN manipulation

Subtypes of `Urn` should also override the Base definition of `print`. This makes it possible to use the generic `components` and `parts` functions in `CitableBase`.

```
import Base: print
function print(io::IO, u::FakeUrn)
    print(io, u.urn)
end
print(fake)

# output

urn:fake:objectclass.objectid
```

Top-level syntactic units are separated by colons: `CitableBase` refers to these units as *components*.


```
components(fake)

# output

3-element Vector{SubString{String}}:
 "urn"
 "fake"
 "objectclass.objectid"
```

At a second syntactic level, units are separated by periods.  `CitableBase` refers to these as *parts* of a component.

```
components(fake)[3] |> parts

# output

2-element Vector{SubString{String}}:
 "objectclass"
 "objectid"
```




Implementations of the `URN` interface should  dispatch the following two methods to type-specific functions:

- `dropversion(u::Urn)`
- `addversion(u::Urn, versionId)`




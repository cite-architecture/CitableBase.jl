# Identification with URNs

!!! note "TBD"

    This page will 
    
    - √ define a new type, `Isbn10Urn` type 
    - implement the `UrnComparisonTrait` for the new type


## The task

ISBN numbers uniquely identified published editions of a book.  We want to create a type representing a 10-digit ISBN number.  We'll make it a subtype of `Urn`, so that we can use it freely with other packages that recognize URNs.

## Defining the `Isbn10Urn` type

> ADD LINKS TO URN SPECIFICATION


The `Urn` abstract type models a Uniform Resource Name (URN). We'll follow  the requirements of the URN standard to create a URN type for ISBN-10 numbers.  Its URN strings will have three colon-delimited components, beginning with the required prefix `urn`, then a URN type we'll call `isbn10`, followed by a 10-digit ISBN number.  For example, the URN for *Distant Horizons* by Ted Underwood will be `urn:isbn:022661283X`.

```@example urns
using CitableBase
struct Isbn10Urn <: Urn
    isbn::AbstractString
end
```



!!! warning "Note on the ISBN-10 format"

    Parsing the full [ISBN-10 format](https://en.wikipedia.org/wiki/International_Standard_Book_Number) is extremely complicated: ISBN-10 numbers have four components, each of which is variable in length! In this user's guide example, we'll restrict ourselves to ISBNs for books published in English-, French- or German-speaking countries, indicated by an initial digit of `0` or `1` (English), `2` (French) or `3` (German).  In a real program, we would enforce this in the constructor, but to keep this example brief and focused on the `CitableBase` class, we blindly accept any string value for the `isbn` field of our type.


Our new type is a subtype of `Urn`.
```@example urns
supertype(Isbn10Urn)
```

As often in Julia, we'll override the default `show` method for our type.  (Note that in Julia this requires *importing* the specific method, not just using the package.)


```@example urns
import Base: show
function show(io::IO, u::Isbn10Urn)
    print(io, u.isbn)
end
```

Now when we create objects of our new type, the display in our REPL (or other contexts) will be easily recognizable as an `Isbn10Urn`.

```@example urns
distanthorizons = Isbn10Urn("urn:isbn:022661283X")
```




## Defining the `UrnComparisonTrait`


Subtypes of `Urn` are required to implement the `UrnComparisonTrait`, and its three functions. `CitableBase` uses the "Holy trait trick" to recognize types implementing the `UrnComparisonTrait`.  We need to import the `UrnComparisonTrait`, and define a function that assigns it a  value for instances of our new type.  For that value, we'll define a subtype of `UrnComparisonTrait`.

> ADD LINK TO explanation of the HTT



```@example urns
import CitableBase: UrnComparisonTrait
struct IsbnComparable <: UrnComparisonTrait end
UrnComparisonTrait(::Type{Isbn10Urn}) = IsbnComparable()
```

You can use the `urncomparable` function to test whether the trait is recognized for an instance of your new type.

```@example urns
urncomparable(typeof(distanthorizons))
```





## Implementing the logic of URN comparison

To fulfill the contract of the `UrnComparisonTrait`, we must implement three boolean functions for three kinds of URN comparison: `urnequals` (for *equality*), `urncontains` (for *containment*) and and `urnsimilar` (for *similarity*).  


### Equality



The `==` function of Julia Base is overridden in `CitableBase` for all subtypes of `Urn`.  This makes it trivial to implement `urnequals` once we use `CitableBase` and import `urnequals`.


```@example urns
import CitableBase: urnequals
function urnequals(u1::Isbn10Urn, u2::Isbn10Urn)
    u1 == u2
end
```

```@example urns
dupe = distanthorizons
urnequals(distanthorizons, dupe)
```

```@example urns
enumerations = Isbn10Urn("urn:isbn:022656875X")
urnequals(distanthorizons, enumerations)
```



!!! tip "Why do we need urnequals?"

    Because collections will also do this!






> ## QUARRY THIS STUFF
>
> Unedited below here.



quantitativeintertextuality = Isbn10Urn("urn:isbn:3030234134")

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




!!! warning

   

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




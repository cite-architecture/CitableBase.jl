# Identification with URNs

> ## Summary 
>   
> This page
>
> - defines a new URN type representing an ISBN-10 number
> - implements the `UrnComparisonTrait` for the new type


## The task

ISBN numbers uniquely identify published editions of a book.  We want to create a type representing a 10-digit ISBN number.  We'll make it a subtype of `Urn`, so that we can use it freely with other packages that recognize URNs.

## Defining the `Isbn10Urn` type

The `Urn` abstract type models a Uniform Resource Name (URN). We'll follow  the requirements of the URN standard to create a URN type for ISBN-10 numbers.  Its URN strings will have three colon-delimited components, beginning with the required prefix `urn`, then a URN type we'll call `isbn10`, followed by a 10-digit ISBN number.  For example, the URN for *Distant Horizons* by Ted Underwood will be `urn:isbn10:022661283X`.

```@example urns
using CitableBase
struct Isbn10Urn <: Urn
    isbn::AbstractString
end
```



!!! warning "Note on the ISBN-10 format"

    There is in fact a URN namespace for ISBN numbers identifeid by the `isbn` namespace identifier. (See this [blogpost about citing publications with URNs](https://www.benmeadowcroft.com/webdev/articles/urns-and-citations/).)  This guide invents an `isbn10` URN type solely to illustrate how you could create your own URN type using the `CitableBase` package.

    Parsing the full [ISBN-10 format](https://en.wikipedia.org/wiki/International_Standard_Book_Number) is extremely complicated: ISBN-10 numbers have four components, each of which is variable in length! In this user's guide example, we'll restrict ourselves to ISBNs for books published in English-, French- or German-speaking countries, indicated by an initial digit of `0` or `1` (English), `2` (French) or `3` (German).  In a real program, we would enforce this in the constructor, but to keep our example brief and focused on the `CitableBase` class, we blindly accept any string value for the `isbn` field of our type.


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
distanthorizons = Isbn10Urn("urn:isbn10:022661283X")
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
enumerations = Isbn10Urn("urn:isbn10:022656875X")
urnequals(distanthorizons, enumerations)
```



!!! tip "Why do we need 'urnequals' when we already have '==' ?"

    Our implementation of the `UrnComparisonTrait`'s functions use two parameters of the same type, compare the two URNs, and produce a boolean result.  In the following section, we will implement the same trio of functions, but with one URN parameter and one parameter giving a citable collection.  In those implementations, we can filter the collection by comparing the URN to the URNs of individual items in the collection.  We can reserve `==` for comparing the contents of two collections, and use `urnequals` to filter a collection's content.





### Containment

For our ISBN type, we'll define "containment" as true when two ISBNS belong to the same initial-digit group (`0` - `4`).  We'll use the `components` functions from `CitableBase` to extract the third part of each URN string, and compare their first characters.

```@example urns
import CitableBase: urncontains
function urncontains(u1::Isbn10Urn, u2::Isbn10Urn)
    initial1 = components(u1.isbn)[3][1]
    initial2 = components(u2.isbn)[3][1]

    initial1 == initial2
end
```

Both *Distant Horizons* and *Enumerations* are in ISBN group 0.

```@example urns
urncontains(distanthorizons, enumerations)
```

But *Can We Be Wrong?* is in ISBN group 1.

```@example urns
wrong = Isbn10Urn("urn:isbn10:1108922036")
urncontains(distanthorizons, wrong)
```



### Similarity

We'll define "similarity" as belonging to the same language area.  In this definition, both `0` and `1` indicate English-language countries.


```@example urns
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

```@example urns
urnsimilar(distanthorizons, wrong)
```

But they are coded for different ISBN areas.

```@example urns
wrong = Isbn10Urn("urn:isbn10:1108922036")
urncontains(distanthorizons, wrong)
```












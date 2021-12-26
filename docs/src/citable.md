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
```
# Citable entities


!!! note "TBD"

    This page will 
    
    - define a `CitableBook` type
    - implement the `CitableTrait`
    - implement the `UrnComparisonTrait`
    - implement `CexTrait`


## The task

We will define a type representing a book identified by ISBN-10 number.  Our type will follow the CITE architecture's model of a citable object, so that we can identify it by URN and label, apply URN logic to the object, and serialize it to plain-text format.


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


### Defining the required functions `urn` and `label`

```@example book
function urnequals(bk1::CitableBook, bk2::CitableBook)
    bk1.urn == bk2.urn
end
```

```@example book
dupebook = distantbook
urnequals(distantbook, dupebook)
```

```@example book
urnequals(distantbook, enumerationsbook)
```

---

>
> ---
>
> QUARRY UNEDITED MATERIAL BELOW HERE



`CitableBase` defines three traits that all citable entities must implement:  

- the `CitableTrait`.  Citable objects are identified by URN, and have a human readable label.
- the `UrnComparisonTrait`.  Citable objects can be compared with other citable objects of the same type using URN logic.
- the `CexTrait`.  Citable objects can be round tripped to/from serialization to text strings in CEX format.


The next three pages walk through implementing these three traits for a custom type of citable object.


## Defining the citable type

We'll begin by defining a custom type of citable object, citable by its own custom type of URN.  Note that we make the types `MyOwnUrn` and `MyOwnCite` subtypes of the abstract `Urn` and `Citable` types, respectively.

```
using CitableBase

struct MyOwnUrn <: Urn
        urn::AbstractString
end
struct MyOwnCite <: Citable
    urn::MyOwnUrn
    label::AbstractString
end
u = MyOwnUrn("urn:fake:id.subid")
citablething = MyOwnCite(u, "Some citable resource")

# output

MyOwnCite(MyOwnUrn("urn:fake:id.subid"), "Some citable resource")
```


## Recognizing the three core traits of the CITE architecture

Because `MyOwnUrn` is a subtype of `Urn`, `MyOwnUrn` objects are assumed to implement the `UrnComparison` trait.

```
urncomparable(u)

# output

true
```

Because `MyOwnCite` is a subtype of `Citable`, objects of that type are now recognizable as citable objects implementing all three core traits

```
citable(citablething)

# output

true
```



```
urncomparable(citablething)

# output

true
```


```
cexserializable(citablething)

# output

true
```
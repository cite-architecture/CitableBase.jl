# Citable entities


!!! note "TBD"

    This page will define a `CitableBook` type and implement the `CitableTrait`, `UrnComparisonTrait`, and `CexTrait`.


For this example, we'll define a custom type of citable collection that we'll use throughout this documentation.  The type will manage a list of books, identified by their ISBN numbers.  We'll invent our own URN type for ISBN numbers, and define a `ReadingList` type as just a list of these ISBN values.  For our URN type, we'll follow the URN syntax requirements for a URN type named `isbn`.

  


!!! warning

    In a real program, we would enforce this limitation with appropriate validation of the constructor, but to keep this example brief and focused on the requirements of citable collections, we'll pass through strings to the constructor unchecked.

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
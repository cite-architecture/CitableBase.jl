# Citable resources: an example implementation


The `CitableBase` modules includes a `CitableTrait` using the Holy trait trick to define three categories of citable trait, `CitableByCtsUrn`, `CitableByCite2Urn` and `NotCitable`.  For those values of the `CitableTrait`, it despatches four functions: `urn`, `label`, `cex` and `fromcex`.  

This page illustrates how to define a new trait value, and use it with a particular type of citable content that even has its own unique type of URN.


## Defining the citable type

We'll begin by defining our own concrete implementations of the `Urn` type and the `Citable` type.

```jldoctest citable
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


## Define the type as a `CitableTrait`

Next we'll use the Holy trait trick to make our new type work with the citable trait.  We create our new value for the citable trait as a concrete type of the `CitableTrait` abstract type, and identify our new citable type as having this trait value.

```jldoctest citable
import CitableBase: CitableTrait
struct MyUniquelyCitable <: CitableTrait end
CitableTrait(::Type{MyOwnCite}) = MyUniquelyCitable()

# output

CitableTrait
```

## Implementing the required functions

To implement the four functions of the `CitableTrait` interface, all we have to do is define parameters of the proper type.

### Identification

All citable resources are identified by a `Urn`, which can be found with the `urn` function.

```jldoctest citable
import CitableBase: urn
function urn(c::MyOwnCite)
    c.urn
end
urn(citablething)

# output

MyOwnUrn("urn:fake:id.subid")
```

All citable resources must have a human-readable label.

```jldoctest citable
import CitableBase: label
function label(c::MyOwnCite)
    c.label
end
label(citablething)

# output

"Some citable resource"
```


### Serialization

It must be possible to serialize a citable resource following to CiteEXchange format with the `cex` function.

```jldoctest citable
import CitableBase: cex
function cex(c::MyOwnCite, delimiter = "|")
    join([c.urn.urn, c.label], delimiter)
end
cex(citablething)

# output

"urn:fake:id.subid|Some citable resource"
```

In the other direction, we can read CEX to instantiate a citable object.
```jldoctest citable
import CitableBase: fromcex
function fromcex(s::AbstractString, MyOwnCite, delimiter = "|")
    parts = split(s, delimiter)
    urn = MyOwnUrn(parts[1])
    label = parts[2]
    MyOwnCite(urn, label)
end

fromcex("urn:fake:id.subid|Some citable resource", MyOwnCite)

# output

MyOwnCite(MyOwnUrn("urn:fake:id.subid"), "Some citable resource")
```
# Serialization to and from CEX format

The `CexTrait` requires that content be serializable from strings in CEX format, and round-tripped from CEX source to instantiate the original object.

To begin with, we'll create a URN type, `MyOwnUrn`, and a `MyOwnCite` type with a `MyOwnUrn` field used for unique identification of objects. We define the `CexTrait` of the new type to be `CexSerializable()`.

```jldoctest citable
using CitableBase

struct MyOwnUrn <: Urn
        urn::AbstractString
end
struct MyOwnCite <: Citable
    urn::MyOwnUrn
    label::AbstractString
end

import CitableBase: CexTrait
CexTrait(::Type{MyOwnCite}) = CexSerializable() 

# output

CexTrait
```

Now we can import and define the `cex` and `fromcex` functions.


```jldoctest citable
import CitableBase: cex
function cex(c::MyOwnCite, delimiter = "|")
    join([c.urn.urn, c.label], delimiter)
end

u = MyOwnUrn("urn:fake:id.subid")
citablething = MyOwnCite(u, "Some citable resource")
cex(citablething)

# output

"urn:fake:id.subid|Some citable resource"
```

In the other direction, we define `fromcex` to instantiate a citable object from CEX source.

```jldoctest citable
import CitableBase: fromcex
function fromcex(s::AbstractString, MyOwnCite; delimiter = "|")
    parts = split(s, delimiter)
    urn = MyOwnUrn(parts[1])
    label = parts[2]
    MyOwnCite(urn, label)
end

fromcex("urn:fake:id.subid|Some citable resource", MyOwnCite)

# output

MyOwnCite(MyOwnUrn("urn:fake:id.subid"), "Some citable resource")
```

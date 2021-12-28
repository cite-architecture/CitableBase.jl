# Serialization to and from CEX format

The `CexTrait` requires that content be serializable from strings in CEX format, and round-tripped from CEX source to instantiate the original object.

We define the `CexTrait` for the new type we created in the previous pages to be `CexSerializable()`.

```@setup citable
using CitableBase

struct MyOwnUrn <: Urn
        urn::AbstractString
end
struct MyOwnCite <: Citable
    urn::MyOwnUrn
    label::AbstractString
end
```



```@example citable
import CitableBase: CexTrait
CexTrait(::Type{MyOwnCite}) = CexSerializable() 
```

Now we can import and define the `cex` and `fromcex` functions.


```@example citable
import CitableBase: cex
function cex(c::MyOwnCite; delimiter = "|")
    join([c.urn.urn, c.label], delimiter)
end

u = MyOwnUrn("urn:fake:id.subid")
citablething = MyOwnCite(u, "Some citable resource")
cex(citablething)
```

In the other direction, we define `fromcex` to instantiate a citable object from CEX source.




```@example citable
import CitableBase: fromcex

function fromcex(s::AbstractString, MyOwnCite; delimiter = "|")
    parts = split(s, delimiter)
    urn = MyOwnUrn(parts[1])
    label = parts[2]
    MyOwnCite(urn, label)
end
```


```@example citable
s = "urn:fake:id.subid|Some citable resource"
fromcex(s, MyOwnCite)

```

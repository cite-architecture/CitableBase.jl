# Citable resources: an example implementation

Citable resources extend the `Citable` abstract type and  implement three functions: `urn`, `label` and `cex`.   



```jldoctest citable
using CitableBase
struct FakeUrn <: Urn
    urn::AbstractString
end
ref = FakeUrn("urn:fake:objectclass.objectid")

struct FakeCite <: Citable
    urn::FakeUrn
    label
end
citable = FakeCite(ref, "Some citable resource")
typeof(citable) |> supertype

# output

Citable
```

All citable resources are identified by a `Urn`, which can be found with the `urn` function.


```jldoctest citable
function urn(c::FakeCite)
    c.urn
end

urn(citable)

# output

FakeUrn("urn:fake:objectclass.objectid")
```

All citable resources must have a human-readable label.

```jldoctest citable
function label(c::FakeCite)
    c.label
end
label(citable)

# output

"Some citable resource"
```


It must be possible to serialize a citable resource following to CiteEXchange format with the `cex` function.

```jldoctest citable
function cex(c::FakeCite, delimiter = "#")
    join([c.urn.urn, c.label], delimiter)
end
cex(citable)

# output

"urn:fake:objectclass.objectid#Some citable resource"
```
# Citable resources

Citable resources extend the `Citable` abstract type and  implement three functions: `urn`, `label` and `cex`.   



```jldoctest citable
using CitableBase
struct FakeUrn <: Urn
    urn::AbstractString
end
struct FakeCite <: Citable
    urn::FakeUrn
    label
end
function urn(c::FakeCite)
    c.urn
end
ref = FakeUrn("urn:fake:objectclass.objectid")
citable = FakeCite(ref, "Some citable resource")
urn(citable)

# output

FakeUrn("urn:fake:objectclass.objectid")
```


```jldoctest citable
function label(c::FakeCite)
    c.label
end
label(citable)

# output

"Some citable resource"
```

```jldoctest citable
function cex(c::FakeCite, delimiter = "#")
    join([c.urn.urn, c.label], delimiter)
end
cex(citable)

# output

"urn:fake:objectclass.objectid#Some citable resource"
```
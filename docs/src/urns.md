# URNs: an example implementation

The `Urn` abstract type models a Uniform Resource Name (URN). URNs have a string value with a specified syntax.  Top-level syntactic units are separated by colons: `CitableBase` refers to these units as *components*.

Here's a minimal example subtyping the `Urn` abstraction.

```jldoctest urns
using CitableBase
struct FakeUrn <: Urn
    urn::AbstractString
end
fake = FakeUrn("urn:fake:objectclass.objectid")
components(fake)

# output

3-element Vector{SubString{String}}:
 "urn"
 "fake"
 "objectclass.objectid"
```

At a second syntactic level, units are separated by periods.  `CitableBase` refers to these as *parts* of a component.

```jldoctest urns
components(fake)[3] |> parts

# output

2-element Vector{SubString{String}}:
 "objectclass"
 "objectid"
```



All implementations of the `URN` interface should override `Base.show`, and dispatch the following three methods to type-specific functions:

- `validurn`
- `dropversion`
- `addversion`


## Real implementations

In practice, there are two URN classes that implement the `URN` abstract type:  

1. the CTS URN (implemented in the [CitableText](https://cite-architecture.github.io/CitableText.jl/stable/) module)
2. the CITE2 URN (implemented in the [CitableObject](https://cite-architecture.github.io/CitableObject.jl/stable/) module).


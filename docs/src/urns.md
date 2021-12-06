# URNs: an example implementation

The `Urn` abstract type models a Uniform Resource Name (URN). URNs have a string value with a specified syntax.   Here's a minimal example subtyping the `Urn` abstraction.

```jldoctest urns
using CitableBase
struct FakeUrn <: Urn
    urn::AbstractString
end
fake = FakeUrn("urn:fake:objectclass.objectid")
typeof(fake) |> supertype

# output

Urn
```

!!! note

    The `==` function is overridden in `CitableBase` for all `Urn` types.  In order to compare two URNs for equality, you'll need to import or use `CitableBase` (as in the block above).

```jldoctest urns
FakeUrn("urn:fake:demo1") == FakeUrn("urn:fake:demo1")

# output

true
```



Subtypes of `Urn` should override the Base definition of `print`. This makes it possible to use the generic `components` and `parts` functions in `CitableBase`.

```jldoctest urns
import Base: print
function print(io::IO, u::FakeUrn)
    print(io, u.urn)
end
print(fake)

# output

urn:fake:objectclass.objectid
```

Top-level syntactic units are separated by colons: `CitableBase` refers to these units as *components*.


```jldoctest urns
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

## URN manipulation

Implementations of the `URN` interface should  dispatch the following two methods to type-specific functions:

- `dropversion(u::Urn)`
- `addversion(u::Urn, versionId)`




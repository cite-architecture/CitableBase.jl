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

Subtypes of `Urn` should override the Base definition of `print`.

```jldoctest urns
import Base: print
function print(io::IO, u::FakeUrn)
    print(io, u.urn)
end
print(fake)

# output

urn:fake:objectclass.objectid
```

This makes it possible to use the generic `components` and `parts` functions in `CitableBase`.

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

- `dropversion`
- `addversion`



## URN comparison

Implementations of the `URN` interface should  dispatch the `contains(urn1::Urn, urn2::Urn)` to a type-specific method.

We illustrate with a simple-minded function that defines containment as any time the first part if the third component is shared.

```jldoctest urns
function contains(u1::FakeUrn, u2::FakeUrn)
    components1 = components(u1)
    components2 = components(u2)

    parts1 = parts(components1[3])
    parts2 = parts(components2[3])
    parts1[1] == parts2[1]
end
urn1 = FakeUrn("urn:fake:group")
urn2 = FakeUrn("urn:fake:group.id2")
contains(urn1, urn2)

# output

true
```

The generic `urnmatch`
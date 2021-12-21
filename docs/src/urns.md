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

Because it is a subtype of `Urn`, our new type is recognized as comparable on URN logic.

```jldoctest urns
urncomparable(fake)

# output

true
```





## URN comparison

We need to implement three functions for our new URN type: `urnequals`, `urncontains` and `urnsimilar`.  



!!! note

    In addition to URN values, these three functions can be implemented for other types of objects.  See the following pages for an example of how they are applied to citable objects (subtypes of `Citable`);  for their use with collections of citable content, see the documentation for the [CitableLibary package](https://cite-architecture.github.io/CitableLibrary.jl/stable/).


   


The `==` function of Julia Base is overridden in `CitableBase` for all subtypes of `Urn`.  This in turn serves as an implementation of `urnequals` for subtypes of `Urn`.  



!!! warning

    Note that in order to compare two URNs for equality, you'll need to import or use `CitableBase` (as in the block above).

```jldoctest urns
FakeUrn("urn:fake:demo1") == FakeUrn("urn:fake:demo1")

# output

true
```

To implement `urncontains` and `urnsimilar`, first import the method from `CitableBase`; then, implement the function with parameters for your new type.  

For this artificial example, we'll define one URN as "containing" another if they both belong to the URN type "urn:fake:".  We'll use a good generic definition for URN similarity: two URNs are similar if one contains the other or if both are equal.

```jldoctest urns
import CitableBase: urncontains
function urncontains(u1::FakeUrn, u2::FakeUrn)
    startswith(u1.urn, "urn:fake:") && startswith(u2.urn, "urn:fake:")
end


import CitableBase: urnsimilar
function urnsimilar(u1::FakeUrn, u2::FakeUrn)
    urncontains(u1, u2) || urnequals(u1, u2)
end

urnsimilar(FakeUrn("urn:fake:demo1"),  FakeUrn("urn:fake:demo2"))

# output

true
```

```jldoctest urns

urncontains(FakeUrn("urn:fake:demo1"),  FakeUrn("urn:fake:demo2"))

# output

true
```


## URN manipulation

Subtypes of `Urn` should also override the Base definition of `print`. This makes it possible to use the generic `components` and `parts` functions in `CitableBase`.

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




Implementations of the `URN` interface should  dispatch the following two methods to type-specific functions:

- `dropversion(u::Urn)`
- `addversion(u::Urn, versionId)`




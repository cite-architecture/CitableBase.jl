# Comparison using URN logic

You can compare citable objects of the same type using URN logic. 

In this example, we'll create a type that is *not* a subtype of `Citable`.  We import the `UrnComparisonTrait` trait, define the new type, and then define its trait value to be `UrnComparable()`.


## Comparing individual objects


```
using CitableBase
import CitableBase: UrnComparisonTrait
struct UrnThing
    urn::AbstractString
end
UrnComparisonTrait(::Type{UrnThing})  = UrnComparable()

# output

UrnComparisonTrait
```

The `UrnComparisonTrait` requires us to implement three functions, `urnequals`, `urncontains` and `urnsimilar`.  For this example, we'll just say that any pair of `UrnThing`s starting with the `fake` class contain each other and are similar.

```
import CitableBase: urnequals
function urnequals(u1::UrnThing, u2::UrnThing)
   u1.urn == u2.urn
end

import CitableBase: urncontains
function urncontains(u1::UrnThing, u2::UrnThing)
    startswith(u1.urn, "urn:fake:") && startswith(u2.urn, "urn:fake:")
end


import CitableBase: urnsimilar
function urnsimilar(u1::UrnThing, u2::UrnThing)
    urncontains(u1, u2)
end

# output

urnsimilar (generic function with 2 methods)
```

Let's try it out.


```
thing1 = UrnThing("urn:fake:id.subid")
thing2 = UrnThing("urn:fake:id2")
thing3 = UrnThing("urn:notevenfake:id")
urnsimilar(thing1, thing2)

# output

true
```

```
urnsimilar(thing1, thing3)

# output

false
```

```
urncontains(thing1, thing2)

# output

true
```

```
urnequals(thing1,thing2)

# output

false
```


## Making lists of citable objects URN comparable

We're not limited to implementing the `UrnComparable` trait for individual  objects.  The next example defines a type with a collection of citable objects.  We can make it URN comparable in exactly the same way.

Because it is *not* a subtype of `Citable`, we again explicitly define its trait value as `UrnComparable()`.

```
struct UrnThingList
    arr::Vector{UrnThing}
end
UrnComparisonTrait(::Type{UrnThingList})  = UrnComparable()
 
# output

UrnComparisonTrait
```

We can verify that objets of our new type are now recognized as `urncomparable`.

```
ulist = UrnThingList([thing1, thing2, thing3])
urncomparable(ulist)

# output

true
```

Now we'll our required functions not to return a boolean value, but to filter the collection for matching content
using URN logic. The functions will return a (possibly empty) list of `UrnThing`s.



!!! note

    This is the same semantics as in the [CitableLibary package](https://cite-architecture.github.io/CitableLibrary.jl/stable/) where  the `UrnComparisonTrait` is used to filter citable collections.
 
```
function urnequals(urnlist::UrnThingList, uthing::UrnThing)
    filter(u -> urnequals(uthing, u), urnlist.arr)
end


function urncontains(urnlist::UrnThingList, uthing::UrnThing)
    filter(u -> urncontains(uthing, u), urnlist.arr)
end

function urnsimilar(urnlist::UrnThingList, uthing::UrnThing)
    urncontains(urnlist, uthing)
end

# output

urnsimilar (generic function with 3 methods)
```


```

urnsimilar(ulist, thing1)

# output

2-element Vector{UrnThing}:
 UrnThing("urn:fake:id.subid")
 UrnThing("urn:fake:id2")
```

```
urnequals(ulist, thing1)

# output

1-element Vector{UrnThing}:
 UrnThing("urn:fake:id.subid")
```
# Comparison using URN logic

You can compare citable objects of the same using URN logic.  The `UrnComparisonTrait` requires you 


Import the trait, define your type, and declare its trait value to be `UrnComparable()`.


## Comparing individual objects


Subtypes of `Urn` are automatically categorized as `UrnComparable()`, but you can define the trait for any type.


```jldoctest citable
using CitableBase: UrnComparable
import CitableBase: UrnComparisonTrait
struct UrnThing
    urn::AbstractString
end
UrnComparisonTrait(::Type{UrnThing})  = UrnComparable()

# output

UrnComparisonTrait
```

To fulfill the trait's contract, we need to implement three functions, `urnequals`, `urncontains` and `urnsimilar`.  For this example, we'll just say that any pair of `UrnThing`s starting with the `fake` class contain each other and are similar.

```jldoctest citable
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


```jldoctest citable
thing1 = UrnThing("urn:fake:id.subid")
thing2 = UrnThing("urn:fake:id2")
thing3 = UrnThing("urn:notevenfake:id")
urnsimilar(thing1, thing2)

# output

true
```

```jldoctest citable
urnsimilar(thing1, thing3)

# output

false
```

```jldoctest citable
urncontains(thing1, thing2)

# output

true
```

```jldoctest citable
urnequals(thing1,thing2)

# output

false
```
## Filtering lists of citable objects 

We'll define a type with a collection of citable objects, and make it `UrnComparable` in exactly the same way.

```jldoctest citable
struct UrnThingList
    arr::Vector{UrnThing}
end
UrnComparisonTrait(x::UrnThingList)  = UrnComparable()
 
# output

UrnComparisonTrait
```

Now we'll use URN logic to filter the collection for matching content.  In this implementation, the function returns a (possibly empty) list of `UrnThing`s.
 
```jldoctest citable
function urncontains(urnlist::UrnThingList, uthing::UrnThing)
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


```jldoctest citable
ulist = UrnThingList([thing1, thing2, thing3])
urnsimilar(ulist, thing1)

# output

2-element Vector{UrnThing}:
 UrnThing("urn:fake:id.subid")
 UrnThing("urn:fake:id2")
```

```jldoctest citable
urnequals(ulist, thing1)

# output

1-element Vector{UrnThing}:
 UrnThing("urn:fake:id.subid")
 ```
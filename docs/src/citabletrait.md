
## Implement `CitableTrait`

The `CitableTrait` requires defining two functions, `urn` and `label`. As always, we first import the required method from `CitableBase`, then implement a function with a parameter of our new type.

### Identification

Citable resources are identified by a `Urn`, which can be found with the `urn` function.

```@setup citable
using CitableBase

struct MyOwnUrn <: Urn
        urn::AbstractString
end
struct MyOwnCite <: Citable
    urn::MyOwnUrn
    label::AbstractString
end
u = MyOwnUrn("urn:fake:id.subid")
citablething = MyOwnCite(u, "Some citable resource")

```

```@example citable
import CitableBase: urn
function urn(c::MyOwnCite)
    c.urn
end
urn(citablething)

# output

MyOwnUrn("urn:fake:id.subid")
```

Citable resources have a human-readable label.

```@example citable
import CitableBase: label
function label(c::MyOwnCite)
    c.label
end
label(citablething)

# output

"Some citable resource"
```



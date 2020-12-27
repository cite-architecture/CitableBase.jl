module CitableBase

using Documenter, DocStringExtensions

export Urn, Citable, string, components, parts

abstract type Urn end


function string(u::Urn)
    u.string()
end

"""
$(SIGNATURES)
Splits a string on colons (seprator for top-level components of URNs).

# Examples
```julia-repl
julia> CiteBase.components("urn:cts:greekLit:tlg0012.tlg001.msA:1.1")
```
"""
function components(uString::String)
    split(uString, ":")
end



"""
$(SIGNATURES)
Splits a string on periods (seprator for parts within components of URNs).

# Examples
```julia-repl
julia> CiteBase.parts("tlg0012.tlg001.msA")
```
"""
function parts(componentString::String)
    split(componentString,".")
end

struct Citable
    urn::Urn
    label::String
end

end # module

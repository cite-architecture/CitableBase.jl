
"Unique identifiers expressible in the syntax of the IETF's URN specification."
abstract type Urn end 

"""
$(SIGNATURES)
Splits a string on colons (separator for top-level components of URNs).

# Examples
```julia-repl
julia> components("urn:cts:greekLit:tlg0012.tlg001.msA:1.1")
```
"""
function components(uString::AbstractString)
    split(uString, ":")
end

"""
$(SIGNATURES)
Splits a URN's string representation into top-level components.
"""
function components(u::Urn)
    split(u.urn, ":")
end


"""
$(SIGNATURES)
Splits a string on periods (seprator for parts within components of URNs).

# Examples
```julia-repl
julia> parts("tlg0012.tlg001.msA")
```
"""
function parts(componentString::AbstractString)
    split(componentString,".")
end


"""Catch-all function for `dropversion` method.
$(SIGNATURES)
"""
function dropversion  end


"""Catch-all function for `addversion` method.
$(SIGNATURES)
"""
function addversion end

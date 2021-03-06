
# They SHOULD
# 1. override the validurn function to provide more specific validation

"""
$(SIGNATURES)
True if s is valid for this type of URN.

This checks only the minimal generic syntax for a URN, and should
be overriden to check more specific requirements of types extending URN.        

# Examples
```julia-repl
julia> validurn("urn:isbn:1788998367")
```
"""
function validurn(s)
    toplevel = components(s)
    if size(toplevel,1) < 3
        false
    elseif toplevel[1] != "urn"
        false
    elseif toplevel[2] == ""
        false
    elseif toplevel[3] == ""
        false
    else 
        true
    end
end

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

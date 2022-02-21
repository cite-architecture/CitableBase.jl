"Unique identifiers expressible in the syntax of the IETF's URN specification."
abstract type Urn end 

"""Override Base.== for all `Urn` types.

$(SIGNATURES)
"""
function ==(u1::T, u2::T) where {T <: Urn}
    string(u1) == string(u2)
end


"""For subtypes of `Urn`, implement `urnequals` concretely.

$(SIGNATURES)
"""
function urnequals(u1::T, u2::T) where {T <: Urn}
    u1 == u2
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
function components(u::U) where {U <: Urn}
    split(string(u), ":")
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


"""True for URN types that support versioning.
$(SIGNATURES)
"""
function supportsversion(u::Type{<:Urn})
    false
end


"""Urn subtypes should implement `dropversion(urn::U)::U`.

$(SIGNATURES)
"""
function dropversion(u::Type{<:Urn})  
    if !(supportsversion(u))
        @warn("URNs of type $(typeof(u)) do not support versions.")
        u
    else
        throw(DomainError(u, 
        "`dropversion` not implemented for type $(typeof(u))"))
    end
end


"""Urn subtypes should implement `addversion(urn::U, versionid)::U`.  

$(SIGNATURES)
"""
function addversion(u::Type{<:Urn}, versioninfo::AbstractString)  
    if !(supportsversion(u))
        @warn("URNs of type $(typeof(u)) do not support versions.")
        u
    else
        throw(DomainError(u, 
        "`addversion` not implemented for type $(typeof(u))"))
    end
end

"""Urn subtypes should implement `addversion(urn::U, versionid)::U`.  

$(SIGNATURES)
"""
function versionid(u::Type{<:Urn})  
    if !(supportsversion(u))
        @warn("URNs of type $(typeof(u)) do not support versions.")
        u
    else
        throw(DomainError(u, 
        "`addversion` not implemented for type $(typeof(u))"))
    end
end




"""True for URN types that support subreferences.
$(SIGNATURES)
"""
function supportssubref(u::Type{<:Urn})
    false
end



"""True for URN types that support subreferences.
$(SIGNATURES)
"""
function hassubref(u::Type{<:Urn})
    if !(supportssubref)
        @warn("URNs of type $(typeof(u)) do not support subreferences.")
        false
    else
        throw(DomainError(u, 
        "`hassubref` not implemented for type $(typeof(u))"))
    end
end

"""Urn subtypes should implement `dropversion(urn::U)::U`.

$(SIGNATURES)
"""
function subref(u::Type{<:Urn})  
    if !(supportssubref)
        @warn("URNs of type $(typeof(u)) do not support subreferences.")
        u
    else
        throw(DomainError(u, 
        "`subref` not implemented for type $(typeof(u))"))
    end
end


"""Urn subtypes should implement `dropversion(urn::U)::U`.

$(SIGNATURES)
"""
function dropsubref(u::Type{<:Urn})  
    if !(supportssubref)
        @warn("URNs of type $(typeof(u)) do not support subreferences.")
        u
    else
        throw(DomainError(u, 
        "`dropsubref` not implemented for type $(typeof(u))"))
    end
end




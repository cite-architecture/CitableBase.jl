"A citable unit of any kind is identified by a URN and has a human-readable label."
abstract type Citable end

"""Abstraction of values for a citable trait."""
abstract type CitableTrait end 

"""Value for the CitableTrait for everything not citable."""
struct NotCitable <: CitableTrait end 

"""Define default value of CitableTrait as NotCitable."""
function citabletrait(::Type) 
    NotCitable() 
end

"""True if `x` is a citable object."""
function citable(x)
    citabletrait(typeof(x)) != NotCitable()
end

#=
Define delegation for the 2 functions of the CitableTrait:
1. urn
2. label
=#

"""Delegate `urn` to specific functions based on 
type's citable trait value.

$(SIGNATURES)
"""
function urn(x::T) where {T} 
    urn(CitableTrait(T), x)
end

"""Delegate `label` to specific functions based on 
type's citable trait value.

$(SIGNATURES)
"""
function label(x::T) where {T} 
    label(CitableTrait(T), x)
end

# Catch attempts to use these functions on NotCitable:

"""It is an error to invoke the `urn` function on material that is not citable.

$(SIGNATURES)
"""
function urn(::NotCitable, x)
    throw(DomainError(x, string( typeof(x), " does not implement the urn function.")))
end

"""It is an error to invoke the `label` function on material that is not citable.

$(SIGNATURES)
"""
function label(::NotCitable, x)
    throw(DomainError(x, string(typeof(x), " does not implement the label function.")))
end

"Abstraction of values for URN manipulation."
abstract type UrnComparisonTrait end

"""Value of the UrnComparisonTrait for evertything that can NOT be compared using URN logic."""
struct NotUrnComparable <: UrnComparisonTrait end

"""Default value of `UrnComparisonTrait` is `NotUrnComparable`."""
function urncomparisontrait(::Type)
    NotUrnComparable() 
end

# Delegate functions based on trait value.
"""URN-comparable objects must implement `urncontains`.
$(SIGNATURES)
"""
function urncontains(x::T, y) where {T <: Urn} 
    urncontains(urncomparisontrait(T), x, y)
end

"""URN-comparable objects must implement `urnsimilar`.
$(SIGNATURES)
"""
function urnsimilar(x::T, y) where {T <: Urn} 
    urnsimilar(urncomparisontrait(T), x, y)
end

"""URN-comparable objects must implement `urnequals`.
$(SIGNATURES)
"""
function urnequals(x::T, y) where {T <: Urn} 
    urnequals(urncomparisontrait(T), x, y)
end


"""True if type `T` implements the `UrnComparisonTrait`.
$SIGNATURES
"""
function urncomparable(u::T) where {T}
    urncomparisontrait(T) != NotUrnComparable()
end

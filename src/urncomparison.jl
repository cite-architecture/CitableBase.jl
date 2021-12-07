
"Abstraction of values for URN manipulation."
abstract type UrnComparisonTrait end

"""Value of the UrnComparisonTrait for evertything that can be compared using URN logic."""
struct UrnComparable <: UrnComparisonTrait end

"""Value of the UrnComparisonTrait for evertything that can NOT be compared using URN logic."""
struct NotUrnComparable <: UrnComparisonTrait end


"""Define default value of UrnComparisonTrait as NotUrnComparable."""
UrnComparisonTrait(::Type) = NotUrnComparable() 

"""All subtypes of `Urn` are URN comparable."""
UrnComparisonTrait(x::T)  where {T <: Urn} = UrnComparable() 

# Delegate functions based on trait value.
"""URN-comparable objects must implement `urncontains`.
$(SIGNATURES)
"""
function urncontains(x::T) where {T} 
    urncontains(UrnComparisonTrait(T), x)
end

"""URN-comparable objects must implement `urnsimilar`.
$(SIGNATURES)
"""
function urnsimilar(x::T) where {T} 
    urnsimilar(UrnComparisonTrait(T), x)
end


"""URN-comparable objects must implement `urnequals`.
$(SIGNATURES)
"""
function urnequals(x::T) where {T} 
    urnequals(UrnComparisonTrait(T), x)
end
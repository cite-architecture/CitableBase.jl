"Abstraction of values for URN manipulation."
abstract type UrnComparisonTrait end

"""Value of the UrnComparisonTrait for evertything that can be compared using URN logic."""
struct UrnComparable <: UrnComparisonTrait end

"""Value of the UrnComparisonTrait for evertything that can NOT be compared using URN logic."""
struct NotUrnComparable <: UrnComparisonTrait end


"""Default value of `UrnComparisonTrait` is `NotUrnComparable`."""
UrnComparisonTrait(::Type) = NotUrnComparable() 

"""All subtypes of `Urn` are URN comparable."""
UrnComparisonTrait(::Type{<:Urn}) = UrnComparable() 

"""All subtypes of `Citable` are URN comparable."""
UrnComparisonTrait(::Type{<:Citable}) = UrnComparable() 


# Delegate functions based on trait value.
"""URN-comparable objects must implement `urncontains`.
$(SIGNATURES)
"""
function urncontains(x::T, y::T) where {T} 
    urncontains(UrnComparisonTrait(T), x, y)
end

"""URN-comparable objects must implement `urnsimilar`.
$(SIGNATURES)
"""
function urnsimilar(x::T, y::T) where {T} 
    urnsimilar(UrnComparisonTrait(T), x, y)
end


"""URN-comparable objects must implement `urnequals`.
$(SIGNATURES)
"""
function urnequals(x::T, y::T) where {T} 
    urnequals(UrnComparisonTrait(T), x, y)
end


"""True if `T` implements the `UrnComparisonTrait`.
$SIGNATURES
"""
function urncomparable(u::T) where {T}
    UrnComparisonTrait(T) != NotUrnComparable()
end

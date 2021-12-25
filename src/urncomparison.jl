"Abstraction of values for URN manipulation."
abstract type UrnComparisonTrait end

"""Value of the UrnComparisonTrait for evertything that can NOT be compared using URN logic."""
struct NotUrnComparable <: UrnComparisonTrait end

"""Default value of `UrnComparisonTrait` is `NotUrnComparable`."""
UrnComparisonTrait(::Type) = NotUrnComparable() 

# Delegate functions based on trait value.
"""URN-comparable objects must implement `urncontains`.
$(SIGNATURES)
"""
function urncontains(x::T, y) where {T} 
    urncontains(UrnComparisonTrait(T), x, y)
end

"""URN-comparable objects must implement `urnsimilar`.
$(SIGNATURES)
"""
function urnsimilar(x::T, y) where {T} 
    urnsimilar(UrnComparisonTrait(T), x, y)
end


"""URN-comparable objects must implement `urnequals`.
$(SIGNATURES)
"""
function urnequals(x::T, y) where {T} 
    urnequals(UrnComparisonTrait(T), x, y)
end


"""True if `T` implements the `UrnComparisonTrait`.
$SIGNATURES
"""
function urncomparable(u::T) where {T}
    UrnComparisonTrait(T) != NotUrnComparable()
end

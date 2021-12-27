"Trait for objects serializable in CEX format."
abstract type CexTrait end

"""Value for the CexTrait for serializable content."""
struct CexSerializable <: CexTrait end

"""Value for the CexTrait for content not serializable to CEX format."""
struct NotCexSerializable <: CexTrait end

"""The default value of `CitableTrait` is `NotCexSerializable`."""
CexTrait(::Type) = NotCexSerializable() 

"""Subtypes of `Citable` are `CexSerializable`."""
CexTrait(::Type{<:Citable}) = CexSerializable() 


function cexserializable(x::T) where {T}
    CexTrait(T) != NotCexSerializable()
end

#=
Define delegation for the 2 functions of the CexTrait:

- cex
- fromcex
=#

"""Delegate `cex` to specific functions based on 
type's citable trait value.

$(SIGNATURES)
"""
function cex(x::T; delimiter = "|") where {T} 
    cex(CexTrait(T), x; delimiter = delimiter)
end

"""Delegate `fromcex` to specific functions based on 
type's citable trait value.

$(SIGNATURES)
"""
function fromcex(s::AbstractString, T::Type{<: DataType}; 
    delimiter = "|", configuration = nothing) 
    fromcex(CexTrait(T), s, T; delimiter = delimiter)
end


# Catch attempts to use these functions on NotCexSerializable:

"""It is an error to invoke the `cex` function on material that is not CEX serializable.

$(SIGNATURES)
"""
function cex(::NotCexSerializable, x; delimiter)
    throw(DomainError(x, string(typeof(x), " is not a CexSerializable type.")))
end

"""It is an error to invoke the `fromcex` function on material that is not CEX serializable.

$(SIGNATURES)
"""
function fromcex(::NotCexSerializable, cex, T::Type{<: DataType}; delimiter, configuration) 
    throw(DomainError(T, "$(T) is not a CexSerializable type."))
end

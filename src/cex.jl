"Trait for objects serializable in CEX format."
abstract type CexTrait end


"""Value for the CexTrait for serializable content."""
struct CexSerializable <: CexTrait end

"""Value for the CexTrait for content not serializable to CEX format."""
struct NotCexSerializable <: CexTrait end

"""Define default value of CitableTrait as NotCexSerializable."""
CexTrait(::Type) = NotCexSerializable() 


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
function fromcex(s::AbstractString, T; delimiter = "|")
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
function fromcex(::NotCexSerializable, cex, T; delimiter)
    throw(DomainError(T, "$(T) is not a CexSerializable type."))
end


# Impose `cex` function on all content citable by Cite2Urn or CtsUrn

"""Citable content should implement `cex`.

$(SIGNATURES)
"""
function cex(::CitableByCite2Urn, obj; delimiter)  
    throw(DomainError(obj, string("Please implement the cex function for type ", typeof(obj))))
end


"""Citable text content should implement `cex`.

$(SIGNATURES)
"""
function cex(::CitableByCtsUrn, txt; delimiter)
    throw(DomainError(txt, string("Please implement the cex function for type ", typeof(txt))))
end

# Impose `fromcex` function on all content citable by Cite2Urn or CtsUrn

"""Citable content should implement `fromcex`.

$(SIGNATURES)
"""
function fromcex(::CitableByCite2Urn, obj; delimiter)  
    throw(DomainError(obj, string("Please implement the cex function for type ", typeof(obj))))
end


"""Citable text content should implement `fromcex`.

$(SIGNATURES)
"""
function fromcex(::CitableByCtsUrn, txt; delimiter)
    throw(DomainError(txt, string("Please implement the cex function for type ", typeof(txt))))
end

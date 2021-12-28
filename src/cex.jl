"Trait for objects serializable in CEX format."
abstract type CexTrait end

"""Value for the CexTrait for serializable content."""
struct CexSerializable <: CexTrait end

"""Value for the CexTrait for content not serializable to CEX format."""
struct NotCexSerializable <: CexTrait end

"""The default value of `CexTrait` is `NotCexSerializable`.

$(SIGNATURES)
"""
function cextrait(::Type) 
    NotCexSerializable() 
end    

"""Subtypes of `Citable` are `CexSerializable`.

$(SIGNATURES)
"""
function cextrait(::Type{<:Citable})  
    CexSerializable() 
end

"""True if type `T` is serializable to CEX format
$(SIGNATURES)
"""
function cexserializable(x::T) where {T}
    #@warn("x/T/trait", x, T, cextrait(T))
    cextrait(T) != NotCexSerializable()
end

#=
Define delegation for the 2 functions of the CexTrait:
- cex
- fromcex
=#

"""Delegate `cex` to specific functions based on 
type's `cextrait` value.

$(SIGNATURES)
"""
function cex(x::T; delimiter = "|") where {T} 
    cex(cextrait(T), x; delimiter = delimiter)
end


"""Instantiate an object of type `T` from CEX-formatted data `cexsrc` by dispatching based on `cextrait` of `T`.

$(SIGNATURES)
"""    
function fromcex(cexsrc::AbstractString, T; 
    delimiter = "|", configuration = nothing)
    fromcex(cextrait(T), cexsrc, T, 
    delimiter = delimiter, configuration = configuration)
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
function fromcex(::NotCexSerializable, cex, T::Type{<: Any}; delimiter , configuration) 
    throw(DomainError(T, "$(T) is not a CexSerializable type."))
end

"""It is an error invoke `fromcex` function with an
unimplemented trait value.

$(SIGNATURES)
"""
function fromcex(traitvalue::TraitType, cexsrc::AbstractString, T;
    delimiter, configuration) where {TraitType <: CexTrait}
    throw(DomainError(traitvalue, "`fromcex` is not implemented for trait $(traitvalue) on type $(T)."))  
end

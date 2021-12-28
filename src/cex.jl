"Trait for objects serializable in CEX format."
abstract type CexTrait end

"""Value for the CexTrait for serializable content."""
struct CexSerializable <: CexTrait end

"""Value for the CexTrait for content not serializable to CEX format."""
struct NotCexSerializable <: CexTrait end

"""The default value of `CexTrait` is `NotCexSerializable`."""
function cextrait(::Type) 
    NotCexSerializable() 
end    

"""Subtypes of `Citable` are `CexSerializable`."""
function cextrait(::Type{<:Citable})  
    CexSerializable() 
end


function cexserializable(x::T) where {T}
    @warn("x/T/trait", x, T, cextrait(T))
    cextrait(T) != NotCexSerializable()
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
    cex(cextrait(T), x; delimiter = delimiter)
end


"""Instantiate an object of type `T` from CEX-formatted data `cexsrc` by dispatching based on `CexTrait` of `T`.

$(SIGNATURES)
"""    
function fromcex(cexsrc::AbstractString, T; 
    delimiter = "|", configuration = nothing)
    fromcex(cextrait(T), cexsrc, T, 
    delimiter = delimiter, configuration = configuration)
    #traitobj = cextrait(T)
    #traittype = typeof(traitobj)
    #@warn("Dispatching with trait/traittype", traitobj, traittype)
    #fromcex( traittype, traitobj, cexsrc, T, delimiter = delimiter, configuration = configuration)
end



# 3-param version
"""Instantiate an object of type `T` from CEX-formatted data `cexsrc` by dispatching on the value and type of `traitvalue`.  `traitvalue` should be an object subtyped from `CexTrait`, and should be accesible as `CexTrait(T)`.

$(SIGNATURES)
"""
function fromcex(traitvalue::TraitType, cexsrc::AbstractString, T;
    delimiter, configuration) where {TraitType <: CexTrait}


    @warn("traitvalue/TraitType/T/cexstr", traitvalue, TraitType, T, cexsrc)
    @warn("Dispatch on trait/type", TraitType, typeof(TraitType))
    #fromcex(TraitType, traitvalue, cexsrc, T, delimiter = delimiter, configuration = configuration)
    throw(DomainError(traitvalue, "`fromcex` is not implemented for trait $(traitvalue) on type $(T)."))  
end

#=
#"Sig with 4 params for trait type/trait instance/string/target type"
"""Instantiate an object of type `T` from CEX-formatted data `cexsrc` by dispatching on the value and type of an object subtyped from `CexTrait`.
$(SIGNATURES)

"""
function fromcex(traittype, traitinstance::C, str::AbstractString, T;
    delimiter , configuration) where {C <: CexTrait}
    @warn("Yay traittype, traitinstance/C/T/str", traittype, traitinstance, C, T, str)
    typeOfClass = C <: CexTrait
    typeOfInstance = traittype <: CexTrait
    @warn("Type of trait class/trait instance <: CexTrait", typeOfClass,  typeOfInstance)
    throw(DomainError(C, "`fromcex` is not implemented for trait $(C) on type $(T)."))  
end

=#




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
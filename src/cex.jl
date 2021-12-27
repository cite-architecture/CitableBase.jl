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
    @warn("Delegate from cex to ", T)
    fromcex(CexTrait(T), s, T; delimiter = delimiter)
end


# Catch attempts to use these functions on NotCexSerializable:

"""It is an error to invoke the `cex` function on material that is not CEX serializable.

$(SIGNATURES)
"""
function cex(::NotCexSerializable, x; delimiter)
    throw(DomainError(x, string(typeof(x), " is not a CexSerializable type.")))
end



#=
"""It is an error to invoke the `fromcex` function on material that is not CEX serializable.

$(SIGNATURES)
"""
function fromcexORIG(::NotCexSerializable, cex, T::Type{<: Any}; delimiter, configuration) 
    throw(DomainError(T, "$(T) is not a CexSerializable type."))
end



"""Handle functions dispatched by `CexTrait`.
$(SIGNATURES)
"""
function fromcexORIG(C::Type{<: CexTrait}, s::AbstractString, T::Type{<: DataType}; 
    delimiter = "|", configuration = nothing)  
    throw(DomainError(C, "No implementation of fromcex for trait $(C)."))
end
=#

"""It is an error to invoke the `fromcex` function on material that is not CEX serializable.

$(SIGNATURES)
"""
function fromcex(::NotCexSerializable, cex, T::Type{<: Any}; delimiter , configuration) 
    throw(DomainError(T, "$(T) is not a CexSerializable type."))
end

"""Instantiate an object of type `T` from CEX-formatted data `cexsrc` by dispatching based on `CexTrait` of `T`.

$(SIGNATURES)
"""    
function fromcex(cexsrc::AbstractString, T; delimiter = "|", configuration = nothing)
    fromcex(CexTrait(T), cexsrc, T, delimiter = delimiter, configuration = configuration)
end


"""Instantiate an object of type `T` from CEX-formatted data `cexsrc` by dispatching on the value and type of `traitvalue`.  `traitvalue` should be an object subtyped from `CexTrait`, and should be accesible as `CexTrait(T)`.

$(SIGNATURES)
"""
function fromcex(traitvalue::TraitType, cexsrc::AbstractString, T;
    delimiter, configuration) where {TraitType <: CexTrait}


    @warn("traitvalue/TraitType/T/cexstr", traitvalue, TraitType, T, cexsrc)
    @warn("Dispatch on C of type", TraitType, typeof(TraitType))
    fromcex(TraitType, traitvalue, cexsrc, T, delimiter = delimiter, configuration = configuration)
end

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



#=
"Sig with 4 params for trait type/trait instance/string/target type"
function fromcex(c2, x::C, str::AbstractString, T) where {C <: CexTrait}
    @warn("Yay c2, x/C/T/str", c2, x, C, T, str)

    
    nothing
end
=#
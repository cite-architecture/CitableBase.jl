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



function fromcex(::NotCexSerializable, cex, T::Type{<: Any}; delimiter, configuration) 
    throw(DomainError(T, "$(T) is not a CexSerializable type."))
end

"Sig with 2 params for string/target type"
function fromcex(str::AbstractString, T)
    fromcex(CexTrait(T), str, T)
end


"Sig with 3 params for trait instance/string/target type"
function fromcex(x::C, str::AbstractString, T) where {C <: CexTrait}
    @warn("x/C/T/str", x, C, T, str)
    @warn("Dispatch on C of type", C, typeof(C))
    fromcex(C, x, str, T)
end



"Sig with 4 params for trait type/trait instance/string/target type"
function fromcex(c2, x::C, str::AbstractString, T) where {C <: CexTrait}
    @warn("Yay c2, x/C/T/str", c2, x, C, T, str)
    typeOfC = C <: CexTrait
    typeOfc2 = c2 <: CexTrait
    @warn("Type of C/c2/D", typeOfC,  typeOfc2)
    nothing
end



#=
"Sig with 4 params for trait type/trait instance/string/target type"
function fromcex(c2, x::C, str::AbstractString, T) where {C <: CexTrait}
    @warn("Yay c2, x/C/T/str", c2, x, C, T, str)

    
    nothing
end
=#
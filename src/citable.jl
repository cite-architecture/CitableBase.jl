"A citable unit of any kind is identified by a URN and has a human-readable label."
abstract type Citable end

"""Abstraction of values for a citable trait."""
abstract type CitableTrait end 

"""Value for the CitableTrait for citable text content."""
struct CitableByCtsUrn <: CitableTrait end

"""Value for the CitableTrait for discrete objects."""
struct CitableByCite2Urn <: CitableTrait end 

"""Value for the CitableTrait for everything not citable."""
struct NotCitable <: CitableTrait end 

"""Define default value of CitableTrait as NotCitable."""
CitableTrait(::Type) = NotCitable() 


#=
Define delegation for the 4 functions of the CitableTrait:

1. urn
2. label
3. cex
4. fromcex
=#

"""Delegate `urn` to specific functions based on 
type's citable trait value.

$(SIGNATURES)
"""
function urn(x::T) where {T} 
    urn(CitableTrait(T), x)
end

"""Delegate `label` to specific functions based on 
type's citable trait value.

$(SIGNATURES)
"""
function label(x::T) where {T} 
    label(CitableTrait(T), x)
end

"""Delegate `cex` to specific functions based on 
type's citable trait value.

$(SIGNATURES)
"""
function cex(x::T; delimiter = "|") where {T} 
    cex(CitableTrait(T), x; delimiter)
end

"""Delegate `fromcex` to specific functions based on 
type's citable trait value.

$(SIGNATURES)
"""
function fromcex(s::AbstractString, T; delimiter = "|")
    "Type $(T) does not implement the fromcex function."
end

# Catch attempts to use these functions on NotCitable:
"""It is an error to invoke the `urn` function on material that is not citable.

$(SIGNATURES)
"""
function urn(::NotCitable, x)
    throw(DomainError(x, string( typeof(x), " does not implement the urn function.")))
end

"""It is an error to invoke the `label` function on material that is not citable.

$(SIGNATURES)
"""
function label(::NotCitable, x)
    throw(DomainError(x, string(typeof(x), " does not implement the label function.")))
end

"""It is an error to invoke the `cex` function on material that is not citable.

$(SIGNATURES)
"""
function cex(::NotCitable, x; delimiter)
    throw(DomainError(x, string(typeof(x), " does not implement the cex function.")))
end




# Impose required function on all citable texts:
"""Citable text content should implement `urn`.

$(SIGNATURES)
"""
function urn(::CitableByCtsUrn, txt)
    throw(DomainError(txt, string("Please implement the urn function for type ", typeof(txt))))
end

"""Citable text content should implement `label`.

$(SIGNATURES)
"""
function label(::CitableByCtsUrn, txt)
    throw(DomainError(txt, string("Please implement the label function for type ", typeof(txt))))
end

"""Citable text content should implement `cex`.

$(SIGNATURES)
"""
function cex(::CitableByCtsUrn, txt; delimiter)
    throw(DomainError(txt, string("Please implement the cex function for type ", typeof(txt))))
end


# Impose required function on all citable objects:
"""Citable content should implement cex.

$(SIGNATURES)
"""
function urn(::CitableByCite2Urn, obj)  
    throw(DomainError(obj, string("Please implement the urn function for type ", typeof(obj))))
end

"""Citable content should implement `label`.

$(SIGNATURES)
"""
function label(::CitableByCite2Urn, obj)  
    throw(DomainError(obj, string("Please implement the label function for type ", typeof(obj))))
end

"""Citable content should implement `cex`.

$(SIGNATURES)
"""
function cex(::CitableByCite2Urn, obj; delimiter)  
    throw(DomainError(obj, string("Please implement the cex function for type ", typeof(obj))))
end

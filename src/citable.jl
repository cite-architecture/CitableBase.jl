"A citable unit of any kind is identified by a URN and has a human-readable label."
abstract type Citable end

"""The citable trait."""
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
Define delegation for the 3 functions of the CitableTrait:

1. urn
2. label
3. cex
=#

"""Delegate to specific functions based on 
type's citable trait value.

$(SIGNATURES)
"""
function urn(x::T) where {T} 
    urn(CitableTrait(T), x)
end

"""Delegate to specific functions based on 
type's citable trait value.

$(SIGNATURES)
"""
function label(x::T) where {T} 
    label(CitableTrait(T), x)
end

"""Delegate to specific functions based on 
type's citable trait value.

$(SIGNATURES)
"""
function cex(x::T, delim = "|") where {T} 
    cex(CitableTrait(T), x, delim)
end



# Catch attempts to use these functions on NotCitable:
"""It is an error to invoke the `urn` function on material that is not citable.

$(SIGNATURES)
"""
function urn(::NotCitable, x)
    throw(DomainError(x, string("Objects of type ", typeof(x), " are not citable.")))
end

"""It is an error to invoke the `cex` function on material that is not citable.

$(SIGNATURES)
"""
function label(::NotCitable, x)
    throw(DomainError(x, string("Objects of type ", typeof(x), " are not citable.")))
end

"""It is an error to invoke the `cex` function on material that is not citable.

$(SIGNATURES)
"""
function cex(::NotCitable, x, delim)
    throw(DomainError(x, string("Objects of type ", typeof(x), " are not citable.")))
end



# Impose required function on all citable texts:
"""Citable text content should implement cex.

$(SIGNATURES)
"""
function urn(::CitableByCtsUrn, txt)
    throw(DomainError(txt, string("Please implement the urn function for type ", typeof(txt))))
end

"""Citable text content should implement cex.

$(SIGNATURES)
"""
function label(::CitableByCtsUrn, txt)
    throw(DomainError(txt, string("Please implement the label function for type ", typeof(txt))))
end

"""Citable text content should implement cex.

$(SIGNATURES)
"""
function cex(::CitableByCtsUrn, txt, delim)
    throw(DomainError(txt, string("Please implement the cex function for type ", typeof(txt))))
end




# Impose required function on all citable objects:
"""Citable content should implement cex.

$(SIGNATURES)
"""
function urn(::CitableByCite2Urn, obj)  
    throw(DomainError(txt, string("Please implement the urn function for type ", typeof(obj))))
end

"""Citable content should implement cex.

$(SIGNATURES)
"""
function label(::CitableByCite2Urn, obj)  
    throw(DomainError(txt, string("Please implement the label function for type ", typeof(obj))))
end

"""Citable content should implement cex.

$(SIGNATURES)
"""
function cex(::CitableByCite2Urn, obj, delim)  
    throw(DomainError(txt, string("Please implement the cex function for type ", typeof(obj))))
end

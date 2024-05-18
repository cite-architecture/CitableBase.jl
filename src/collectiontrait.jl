"""Abstraction of values for a citable library collection trait."""
abstract type CitableCollectionTrait end

"""Value for the CitableCollectionTrait for evertything that is not a citable library collection."""
struct NotCitableCollection <: CitableCollectionTrait end

"""Define default value of CitableCollectionTrait as NotCitableCollection."""
function citablecollectiontrait(::Type) 
    NotCitableCollection() 
end


"""True if `x` has the value `CitableCollection` for the `CitableCollectionTrait`.

$(SIGNATURES)
"""
function citablecollection(x::T) where {T} 
    citablecollectiontrait(T) != NotCitableCollection()
end

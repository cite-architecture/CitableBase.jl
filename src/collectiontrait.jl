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

"""Delegate function, catching types that do not implement `CitableCollectionTrait`.
$(SIGNATURES)
"""
function slidingwindow(coll::T, windowsize::Int64 = 2; pad = false) where {T} 
    if citablecollection(coll)
        slidingwindow(citablecollectiontrait(T), coll, windowsize; pad = pad)

    else
        throw(ArgumentError("Function `slidingwindow` not implemented for type $(T)"))
    end
end

"""Create a vector of objects by sliding a window over a citable collection.
$(SIGNATURES)
"""
function slidingwindow(trait::T, coll, windowsize::Int64 = 2; pad = false) where {T <: CitableCollectionTrait}
    slidingwindow(collect(coll), windowsize, pad = pad)
end

function slidingwindow(v::T,windowsize::Int64 = 2; pad = false)  where {T <: AbstractVector}
    span = windowsize - 1
    if pad
        a = similar(v, Union{Nothing, eltype(v)}, length(v) + 2 * (span) )
        for i in 1:length(v)
            a[span + i] = v[i]
        end
        view.(Ref(a), UnitRange.(1:length(a) - span, windowsize:length(a)))
    else
        view.(Ref(v), UnitRange.(1:length(v) - span, windowsize:length(v)))
    end
end


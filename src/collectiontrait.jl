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

"""Disipatch function, catching types that do not implement `CitableCollectionTrait`.
$(SIGNATURES)
"""
function slidingwindow(coll::T; n::Int64 = 2, pad = false) where {T} 
    if citablecollection(coll)
        slidingwindow(citablecollectiontrait(T), coll, n = n, pad = pad)

    else
        throw(ArgumentError("Function `slidingwindow` not implemented for type $(T)"))
    end
end

"""Create a vector of objects by sliding a window over a citable collection.
$(SIGNATURES)
"""
function slidingwindow(trait::T, coll; n::Int64 = 2, pad = false) where {T <: CitableCollectionTrait}
    slidingwindow(collect(coll), n = n, pad = pad)
end


"""Create a Vector of Vectors of type `T` by sliding a window 
of size `n` over `v`.

$(SIGNATURES)
"""
function slidingwindow(v::T; n::Int64 = 2, pad = false)  where {T <: AbstractVector}
    span = n - 1
    if pad
        a = similar(v, Union{Nothing, eltype(v)}, length(v) + 2 * (span) )
        for i in 1:length(v)
            a[span + i] = v[i]
        end
        view.(Ref(a), UnitRange.(1:length(a) - span, n:length(a)))
    else
        view.(Ref(v), UnitRange.(1:length(v) - span, n:length(v)))
    end
end

"""Segment `v` into a series of Vectors of size `n`.
$(SIGNATURES)
It dividng `v` into units of size `n` does not produce partitions of 
equal size (i.e., if `mod(v, n)` is not equal to 0), trailing elements 
are omitted.
"""
function partitionbalanced(v::T, n::Int64) where {T <: AbstractVector}
    # Make math easier to read without all those parentheses:
    vlen = length(v)
    startindexes = range(start = 1, step = n, stop = vlen) |> collect
    endindexes = range(start = n, step = n, stop = vlen) |> collect    
    
    indexlen = mod(vlen, n) == 0 ? length(startindexes) : length(startindexes) - 1
    rnglist =  UnitRange.(startindexes[1:indexlen], endindexes)
    view.(Ref(v), rnglist)
end

"""Segment `v` into a series of Vectors of size `n`.
$(SIGNATURES)
The final vector is padded with `nothing` elements if its size is not
equal to `n`.
"""
function partitionvect(v::T; n::Int64 = 2) where {T <: AbstractVector}
     remainderlen = mod(length(v), n)
    if remainderlen == 0
        partitionbalanced(v,n)
    else
        totallen = length(v) + remainderlen
        balanced =  Union{Nothing, eltype(v)}[nothing for _ in 1:totallen]
        for i in 1:length(v)
            balanced[i] = v[i]
        end
        partitionbalanced(balanced, n)
    end
end







###function partitionvect(v::T; n::Int64 = 2) where {T <: AbstractVector}

"""Delegate `partitionvect` function, catching types that do not implement `CitableCollectionTrait`.
$(SIGNATURES)
"""
function partitionvect(coll::T; n::Int64 = 2) where {T} 
    if citablecollection(coll)
        partitionvect(citablecollectiontrait(T), coll; n = n)

    else
        throw(ArgumentError("Function `partitionvect` not implemented for type $(T)"))
    end
end

"""Create a vector of objects by sliding a window over a citable collection.
$(SIGNATURES)
"""
function partitionvect(trait::T, coll; n::Int64 = 2) where {T <: CitableCollectionTrait}
    partitionvect(collect(coll), n = n)
end

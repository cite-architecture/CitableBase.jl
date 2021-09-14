
"Unique identifiers expressible in the syntax of the IETF's URN specification."
abstract type Urn end 
# Classes extending the URN abstractions MUST
# have a member of type AbstractString named "urn":



"A citable unit of any kind is identified by a URN and has a human-readable label."
abstract type Citable end

"""Citable content should always be serializable.
"""
function cex(data::T, delim="|") where {T <: Citable}
    @warn("No cex function defined for ", typeof(data))
end

function objectid(data::T) where {T <: Citable}
    @warn("No cex function defined for ", typeof(data))
    nothing
end
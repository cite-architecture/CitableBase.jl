"""Catch-all function for `dropversion` method.
$(SIGNATURES)
"""
function dropversion(u::T) where {T <: Urn}
    msg = string("dropversion not implemented for ", typeof(u))
    @warn(msg)
    nothing
end

"""Catch-all function for `addversion` method.
$(SIGNATURES)
"""
function addversion(u::T, s::AbstractString) where {T <: Urn}
    msg = string("addversion not implemented for ", typeof(u))
    @warn(msg)
    nothing
end
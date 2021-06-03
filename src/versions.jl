"""Catch-all function for `dropversion` method.
$(SIGNATURES)
"""
function dropversion(u::Urn)
    msg = string("dropversion not implemented for ", typeof(u))
    @warn(msg)
    nothing
end

"""Catch-all function for `addversion` method.
$(SIGNATURES)
"""
function addversion(u::Urn, s::AbstractString)
    msg = string("addversion not implemented for ", typeof(u))
    @warn(msg)
    nothing
end
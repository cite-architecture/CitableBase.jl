
function dropversion(u::Urn)
    msg = string("dropversion not implemented for ", typeof(u))
    @warn(msg)
    nothing
end
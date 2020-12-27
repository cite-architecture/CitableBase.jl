module CiteBase

export Urn, Citable, string, components, parts

abstract type Urn end

function string(u::Urn)
    u.string()
end

function components(uString::String)
    split(uString, ":")
end

function parts(componentString::String)
    split(componentString,".")
end

struct Citable
    urn::Urn
    label::String
end

end # module

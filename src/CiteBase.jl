module CiteBase

export Urn, CtsUrn, Cite2Urn, Citable

abstract type Urn end


struct CtsUrn <: Urn
    string::String
end

struct Cite2Urn <: Urn
    string::String
end

function string(u::Urn)
    u.string()
end

struct Citable
    urn::Urn
    label::String
end

end # module

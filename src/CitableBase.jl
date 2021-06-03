module CitableBase
import Base.show

using Documenter, DocStringExtensions

export Urn, Citable
export components, parts, validurn

export dropversion, addversion


include("core.jl")
include("urns.jl")
include("versions.jl")

end # module

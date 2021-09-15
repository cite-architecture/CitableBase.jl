module CitableBase

using Documenter, DocStringExtensions

# Urn and its required functions:
export Urn 
export components, parts, validurn
export dropversion, addversion

# Citable and its required functions
export Citable 
export urn, label, cex

include("urns.jl")
include("citable.jl")

end # module

module CitableBase

using Documenter, DocStringExtensions

# Urn and its required functions:
export Urn
export dropversion, addversion
export urnsimilar, urncontains
# Concrete implementations:
export components, parts

# Citable and its required functions
export Citable 
export urn, label, cex

include("urns.jl")
include("citable.jl")

end # module

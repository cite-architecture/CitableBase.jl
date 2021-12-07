module CitableBase

import Base:  ==

using Documenter, DocStringExtensions

# Urn and its required functions:
export Urn
export dropversion, addversion
export urnsimilar, urncontains
# Concrete implementations:
export components, parts

# Citable and its required functions
export Citable, CitableTrait
export CitableByCtsUrn, CitableByCite2Urn, NotCitable
export urn, label, citableobject
export CexTrait, cex, fromcex 
export ==

include("urns.jl")
include("urncomparison.jl")
include("citable.jl")
include("cex.jl")


end # module

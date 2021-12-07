module CitableBase

using Documenter, DocStringExtensions
import Base:  ==

# Urn and its required functions:
export Urn
export dropversion, addversion
export ==
# Concrete implementations:
export components, parts

# The three key traits of citable content, 
# together with their required functions:
export Citable, CitableTrait
export CitableByCtsUrn, CitableByCite2Urn, NotCitable
export urn, label, citableobject
export CexTrait, CexSerializable, NotCexSerializable
export cex, fromcex 
export UrnComparisonTrait, UrnComparable, NotUrnComparable
export urnsimilar, urncontains

include("urns.jl")
include("urncomparison.jl")
include("citable.jl")
include("cex.jl")


end # module

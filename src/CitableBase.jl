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
export CitableByCtsUrn, CitableByCite2Urn, NotCitable, citable
export urn, label

export CexTrait, CexSerializable, NotCexSerializable, cexserializable
export cex, fromcex 

export UrnComparisonTrait, UrnComparable, NotUrnComparable, urncomparable
export urnsimilar, urncontains, urnequals


include("citable.jl")
include("urns.jl")
include("urncomparison.jl")
include("cex.jl")


end # module

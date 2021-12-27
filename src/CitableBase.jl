module CitableBase

using Documenter, DocStringExtensions
import Base:  ==

# Urn and its required functions:
export Urn
export UrnComparisonTrait, NotUrnComparable, urncomparable
export urnsimilar, urncontains, urnequals
export dropversion, addversion
export ==
# Concrete implementations:
export components, parts

# The three key traits of citable content, 
# together with their required functions:
export Citable, CitableTrait
export NotCitable, citable
export urn, label

export CexTrait, NotCexSerializable, cexserializable
export cex, fromcex 

export CitableCollectionTrait, NotCitableCollection, citablecollection

include("citable.jl")
include("urns.jl")
include("urncomparison.jl")
include("cex.jl")
include("collectiontrait.jl")


end # module

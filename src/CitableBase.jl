module CitableBase

using Documenter, DocStringExtensions
import Base:  ==

# Urn and its functions
export Urn
export dropversion, addversion
export ==
# Concrete implementations:
export components, parts


# The three key traits of citable content, 
# together with their required functions:
export UrnComparisonTrait, NotUrnComparable
export urncomparisontrait,  urncomparable
export urnsimilar, urncontains, urnequals

export Citable, CitableTrait
export NotCitable, citable
export urn, label

export CexTrait, NotCexSerializable, cexserializable
export cex, fromcex 

# The citable collection trait
export CitableCollectionTrait, NotCitableCollection, citablecollection


include("citable.jl")
include("urns.jl")
include("urncomparison.jl")
include("cex.jl")
include("collectiontrait.jl")


end # module

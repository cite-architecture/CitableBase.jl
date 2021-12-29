# ReadingList demo from #Code from https://cite-architecture.github.io/CitableBase.jl/stable
module RL

#Code from https://cite-architecture.github.io/CitableBase.jl/stable/urns/
include("page1_urn.jl")

#Code from  https://cite-architecture.github.io/CitableBase.jl/stable/citable/
include("page2_citable.jl")

#Code from https://cite-architecture.github.io/CitableBase.jl/stable/collections/
include("page3_collection.jl")

export Isbn10Urn
export CitableBook
export ReadingList

end # module

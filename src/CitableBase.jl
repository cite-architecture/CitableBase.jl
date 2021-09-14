module CitableBase
#import Base.show

using Documenter, DocStringExtensions

export Urn 
# Urn required functions:
export components, parts, validurn
export dropversion, addversion

export Citable 
# Citable required functions
export urn, label, cex


include("core.jl")
include("urns.jl")
include("versions.jl")

end # module

# Use this from root directory of repository, e.g.,
#
#   julia --project=docs/ docs/make.jl
#
# Serve docs from repository root:
#
#   julia -e 'using LiveServer; serve(dir="docs/build")'julia -e 'using LiveServer; serve(dir="docs/build")' 
#
using Pkg
Pkg.activate(".")
Pkg.instantiate()


using Documenter, DocStringExtensions, CitableBase

makedocs(
    sitename = "CitableBase.jl",
    pages = [
        "Home" => "index.md",
        "URNs" => "urns.md",
        "URN comparison" => "urncomparison.md",
        "Citable resources" => "citable.md",
        "Implementations" => "implementations.md",
        "API documentation" => "apis.md"
    ]
    )

deploydocs(
    repo = "github.com/cite-architecture/CitableBase.jl.git",
) 

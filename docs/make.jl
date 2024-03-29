# Use this from root directory of repository, e.g.,
#
#   julia --project=docs/ docs/make.jl
#
# Serve docs from repository root:
#
#   julia -e 'using LiveServer; serve(dir="docs/build")'
#
using Pkg
Pkg.activate(".")
Pkg.instantiate()


using Documenter, DocStringExtensions, CitableBase

makedocs(
    sitename = "CitableBase.jl",
    pages = [
        "Home" => "index.md",
        "Identifiers" => "urns.md",
        "Citable objects" => "citable.md",
        "Citable collections" => "collections.md",
        "Julia collections" => "collections2.md",
        "API documentation" => "apis.md"
    ]
    )

deploydocs(
    repo = "github.com/cite-architecture/CitableBase.jl.git",
) 

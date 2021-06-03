# Use this from root directory of repository, e.g.,
# julia --project=docs/ docs/make.jl

using Pkg
Pkg.activate(".")
Pkg.instantiate()


using Documenter, DocStringExtensions, CitableBase

makedocs(
    sitename = "CitableBase.jl",
    pages = [
        "Home" => "index.md"
    ]
    )

deploydocs(
    repo = "github.com/cite-architecture/CitableBase.jl.git",
) 

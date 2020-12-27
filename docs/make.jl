using Pkg
pkg"activate .."
push!(LOAD_PATH,"../src/")
using Documenter, CitableBase
makedocs(sitename = "CitableBase Documentation")

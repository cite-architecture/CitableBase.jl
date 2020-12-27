using Pkg
pkg"activate .."
push!(LOAD_PATH,"../src/")
using Documenter, CiteBase
makedocs(sitename = "CiteBase Documentation")

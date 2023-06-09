using CitableBase
using Test, Documenter
import CitableBase: CitableTrait
import CitableBase: UrnComparisonTrait
import CitableBase: CexTrait



include("test_urnimpl.jl")
include("test_urnstringmanipulation.jl")
include("test_urnmanipulation.jl")
include("test_urncomparison.jl")
include("test_citable.jl")
include("test_cex.jl")

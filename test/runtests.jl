using CitableBase
using Test, Documenter
import CitableBase: CitableTrait

include("test_urnimpl.jl")
include("test_urnmanipulation.jl")
#include("test_citeimpl.jl")
#include("test_trait.jl")

# This doesn't seem to execute any tests.
# Misconfigured MetaData ?
#doctest(CitableBase; manual=false)
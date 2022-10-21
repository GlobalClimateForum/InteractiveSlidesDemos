using Revise
import Pkg
__revise_mode__ = :eval
includet("src/" * Pkg.project().name * ".jl")
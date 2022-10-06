using Revise
__revise_mode__ = :eval
includet("src/" * Pkg.project().name * ".jl")
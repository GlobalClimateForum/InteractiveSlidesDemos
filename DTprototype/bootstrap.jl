(pwd() != @__DIR__) && cd(@__DIR__) # allow starting app from bin/ dir

using DTprototype
push!(Base.modules_warned_for, Base.PkgId(DTprototype))
DTprototype.main()

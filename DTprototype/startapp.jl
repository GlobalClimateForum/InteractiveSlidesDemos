#execute the following: push!(LOAD_PATH, "public/(name of presentation folder)"); include("startapp.jl")
using Genie
loadapp()
up(8000, open_browser = true)
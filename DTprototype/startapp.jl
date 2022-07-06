#execute the following (modify path accordingly): push!(LOAD_PATH, "public/templates/template1"); include("startapp.jl")
using Genie
loadapp()
up(8000, open_browser = true)
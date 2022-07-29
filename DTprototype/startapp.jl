#execute the following (modify path accordingly): push!(LOAD_PATH, "public/templates/template1"); include("startapp.jl")
using Genie
Genie.loadapp()
Genie.up(8000, open_browser = true)
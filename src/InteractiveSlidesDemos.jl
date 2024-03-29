using Revise, DataStructures
import DataFrames.DataFrame

using InteractiveSlides

@presentation! struct PresentationModel <: ReactiveModel
    @addfields(10, ::Int, 0)
    @addfields(10, ::Bool, false)
    @addfields(10, ::String, "")
    @addfields(10, ::Vector, [])
    @addfields(2, ::PlotLayout, PlotLayout())
    @addfields(2, ::PlotConfig, PlotConfig())
    @addfields(2, ::DataTable, DataTable())
    @addfields(2, ::DataTablePagination, DataTablePagination())
    @addfields(5, ::Vector{PlotData}, [PlotData()])
    files::R{Vector{Dict{Symbol, Any}}} = [filedict(dirname(@__DIR__))] #used by draggable_tree() (referred to by :files in introduction.jl). Note: Needs to be assigned here, otherwise component will disappear upon dragging
end

includet("elements.jl") #mostly additional code for a custom component used on slide number 6 
includet("introduction.jl")
includet("main.jl")
includet("content.jl") #this file defines gen_content() which is passed to serve_presentation() below 

serve_presentation(PresentationModel, gen_content; num_teams_default = 2, max_num_teams = 4, isdev = true)

Genie.up(8080, "0.0.0.0", open_browser = true) #with 0.0.0.0, you can access the presentation from any device in your local network (using the IP of the device you are hosting with)
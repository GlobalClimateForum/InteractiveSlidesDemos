using DataStructures, CSV
import DataFrames.DataFrame

using InteractiveSlides, StipplePlotly

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
    files::R{Vector{Dict{Symbol, Any}}} = []
end

# add_js("draggable_tree", basedir = @__DIR__) #because draggable_tree.js adds a custom Vue component, it must be loaded in this way. 

includet("./draggable_tree.jl") #simply some additional code for a custom component used on slide number 6 
includet("./content.jl")

serve_presentation(PresentationModel, gen_content; num_teams_default = 2)

Genie.up(8080, "0.0.0.0", open_browser = true) #with 0.0.0.0, you can access the presentation from any device in your local network (using the IP of the device you are hosting with)
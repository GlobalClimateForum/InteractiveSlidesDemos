using InteractiveSlides, StipplePlotly

const folder = splitpath(@__DIR__)[end]
num_monitors() = 2 #as a function so it can be changed without having to restart Julia session

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
end

const settings = Dict{Symbol, Any}(
    :folder => folder, 
    :num_monitors => num_monitors(),
    :use_Stipple_theme => false)

includet("./content.jl")

serve_presentation(PresentationModel, gen_content, settings)

Genie.up(8000, open_browser = true)
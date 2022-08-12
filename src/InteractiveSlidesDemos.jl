using DataStructures, CSV
import DataFrames.DataFrame

using InteractiveSlides, StipplePlotly

num_teams_foo() = 2 #as function so it can be changed during julia session
const settings = Dict{Symbol, Any}(
    :num_teams => num_teams_foo(),
    :use_Stipple_theme => false)

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

includet("./short_slideshow.jl") #changing file requires restart of julia session

serve_presentation(PresentationModel, gen_content, settings)

Genie.up(8080, open_browser = true)
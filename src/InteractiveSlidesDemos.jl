using DataStructures, CSV
import DataFrames.DataFrame

using InteractiveSlides, StipplePlotly

num_teams = 2 #requires passing reset=1 as URL argument upon change

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
    :num_teams => num_teams,
    :use_Stipple_theme => false)

includet("./longer_slideshow.jl")

serve_presentation(PresentationModel, gen_content, settings)

Genie.up(8080, open_browser = true)
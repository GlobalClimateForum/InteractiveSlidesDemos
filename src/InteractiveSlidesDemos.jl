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
end

add_js("vue_custom", basedir = @__DIR__)

includet("./short_slideshow.jl") #trying out longer_slideshow.jl can be done by either (e.g.)
# (1) changing above line correspondingly and then (re-)starting the Julia session or
# (2) including "longer_slideshow.jl" in the REPL (e.g. via includet), and then resetting the presentation by supplying "reset=1" as a URL argument (this works only if you have already executed this script).
# Note: It is not (yet?) possible to serve several slideshows at the same time

serve_presentation(PresentationModel, gen_content; num_teams_default = 2)

Genie.up(8080, "0.0.0.0", open_browser = true) #with 0.0.0.0, you can access the presentation from any device in your local network (using the IP of the device you are hosting with)
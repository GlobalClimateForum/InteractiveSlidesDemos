using InteractivePresentations, StipplePlotly

const folder = joinpath(splitpath(@__DIR__)[end-1:end])
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

const settings = Dict{Symbol, Any}(:folder => folder, :num_monitors => num_monitors()) #further possibility: :use_stipple_theme

function create_auxUI(m_id::Int) #header, footer, menu. This is not returned by create_slideshow because it needs to be generated for each monitor every request (as is)
    [quasar(:header, quasar(:toolbar, navcontrols(m_id)))
    quasar(:footer, [quasar(:separator), quasar(:toolbar, 
        [space(), slide_id(m_id)])],
        iftitleslide(m_id))
    menu(m_id, (id, title) -> string(id) * ": " * title)]
end

includet("./content.jl")

Genie.route("/") do
    serve_slideshow(PresentationModel, create_slideshow, create_auxUI, settings, params())
end

Genie.route("/:monitor_id::Int/") do
    serve_slideshow(PresentationModel, create_slideshow, create_auxUI, settings, params())
end

Genie.up(8000, open_browser = true)
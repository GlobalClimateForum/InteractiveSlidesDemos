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

const settings = Dict{Symbol, Any}(
    :folder => folder, 
    :num_monitors => num_monitors(),
    :use_Stipple_theme => false)

function gen_auxUI(m_id::Int) #This is not returned by create_slideshow because it needs to be generated for each monitor every request (as is)
    [quasar(:header, quasar(:toolbar, navcontrols(m_id)))
    quasar(:footer, [quasar(:separator), quasar(:toolbar, 
        [space(), slide_id(m_id)])],
        iftitleslide(m_id))
    menu_slides(m_id, (id, title) -> string(id) * ": " * title)]
end

includet("./content.jl")

serve_presentation(PresentationModel, gen_content, gen_auxUI, settings)

Genie.up(8000, open_browser = true)
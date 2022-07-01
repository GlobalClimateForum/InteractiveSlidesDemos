module SlideUI
using Reexport
@reexport using Stipple, StipplePlotly, StippleUI
import Random

#SLIDE UI
#region
export slide, render_slides, standard_menu, standard_header, standard_footer

slides = Vector[]
function slide(args...)
    push!(slides, AbstractString[args...])
end

function render_slides(slides_to_render::Vector{Vector}, monitor_id::Int)
    titles = String[]
    bodies = ParsedHTMLString[]
        for (id,sld) in enumerate(slides_to_render)
            push!(titles, strip(match(r">.*<", String(sld[1])).match[2:end-1]))
            push!(bodies, 
            Genie.Renderer.Html.div(class = "slide text-center flex-center q-gutter-sm q-col-gutter-sm", 
            sld, @iif("$id == current_id$monitor_id")))
        end
    return (titles, bodies)
end

function reset_slideUI()
    empty!(slides)
end

function standard_menu(slide_titles::Vector{String})
    drawer(side="left", v__model="drawer", [
            list([
                item(item_section(string(id) * ": " * title), :clickable, @click("current_id = $(id)")) 
                for 
                (id, title) in enumerate(slide_titles)
                ])
            ])
end

function standard_header(num_slides::Int, m_id::Int)
    quasar(:header, quasar(:toolbar, [
        btn("",icon="menu", @click("drawer = ! drawer"))
        btn("",icon="chevron_left", @click("current_id$m_id > 1 ? current_id$m_id-- : null"))
        btn("",icon="navigate_next", @click("current_id$m_id < $num_slides ? current_id$m_id++ : null"))
        ])
    )
end

function standard_footer(m_id::Int, folder::AbstractString)
    quasar(:footer, quasar(:toolbar, [space(),
            icon("img:$folder/img/GCFlogo.png", size = "md"),
            quasar(:toolbar__title, "GCF"), span("", @text(Symbol("current_id$m_id")))])
    )
end
#endregion

#PresentationModels
#region
export get_pmodel, PresentationModel

register_mixin(@__MODULE__)

@reactive! mutable struct PresentationModel <: ReactiveModel
    int1::R{Int} = 0
    current_id1::R{Int8} = 1
    current_id2::R{Int8} = 1
    current_id3::R{Int8} = 1
    current_id4::R{Int8} = 1
    drawer::R{Bool} = false
    vector1::R{Vector} = []
    vector2::R{Vector} = []
    plotdata1::R{Vector{PlotData}} = [PlotData()]
    plotdata2::R{Vector{PlotData}} = [PlotData()]
    layout::R{PlotLayout} = PlotLayout()
    config::R{PlotConfig} = PlotConfig()

    show_bar::R{Bool} = false
end

pmodels = PresentationModel[]

function get_pmodel()
    if isempty(pmodels)
        pmodel = Stipple.init(PresentationModel)
        on(pmodel.isready) do ready
            ready || return
            push!(pmodel)        
        end
        push!(pmodels, pmodel)
    end
    pmodels[1]
end
#endregion

#ModelManager
#region
export new_field!, on_bool!, on_vector!, reset_counter, reset_manager
#this module should generate handlers and somehow populate fields for each pmodel (depending on slides), or expose functions/macros toward such ends

counters = Dict{Symbol, Int8}(:Bool => 1, :Int => 1, :Vector => 1, :PlotData => 1, :PlotLayout => 1, :PlotConfig => 1)

handlers = Observables.ObserverFunction[]

function new_field!(pmodel::PresentationModel, type::Symbol; value = Nothing, dummy = 0::Int)
    rng = Random.MersenneTwister(dummy)
    name = lowercase(string(type, counters[type]))
    if name[1:4] == "bool"
        name = "int" * name[5:end]
    end
    name_sym = Symbol(name)
    if type == :PlotData
        if dummy > 0
          
            pd(name) = PlotData(
                x = 1:12,
                y = rand(rng, 12).*2,
                name = name,
                plot = "scatter",
            )
            
            value = [pd(name) for name in ["Dummy Team A", "Dummy Team B"]]
        end
    elseif type == :Bool
        if dummy > 0
            value = rand(rng, [0 1])
        end
    end
    getfield(pmodel, name_sym).o.val = value
    counters[type] += 1
    return name_sym
end

function reset_manager()
    for key in keys(counters)
        counters[key] = 1
    end
    off.(handlers)
end

function on_bool!(pmodel::PresentationModel)
    handler = on(pmodel.int1) do val
        println(string("show bar = ", pmodel.int1[]))
        if val == 1
            setproperty!.(pmodel.plotdata1[], :plot, "bar")
            setproperty!.(pmodel.plotdata2[], :plot, "bar")
        else
            setproperty!.(pmodel.plotdata1[], :plot, "scatter")
            setproperty!.(pmodel.plotdata2[], :plot, "scatter")
        end
        notify(pmodel.plotdata1)
        notify(pmodel.plotdata2)   
    end
    push!(handlers, handler)
    notify(pmodel.int1)
end

function on_vector!(pmodel::PresentationModel)
    handler = on(pmodel.vector1) do choice
        for i = 1:2
            y = pmodel.plotdata1[i].y
            x = 1:12
            if choice == ["Increase"]
                y += x./12
            elseif choice == ["Decrease"]
                y -= x./12
            elseif choice == ["Sine"]
                y += sin.(x.*pi./6)
            end
            pmodel.plotdata2[i].y = y
        end
        notify(pmodel.plotdata2)
    end
    push!(handlers, handler)
    notify(pmodel.vector1)
end
#endregion

end
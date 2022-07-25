module SlideUI
using Reexport
@reexport using Stipple, StipplePlotly, StippleUI
import Random
export monitor_ids

const m_max = 4 #max number of monitors. Note: This setting does not really (yet) affect anything except error messages (the max number of monitors depends on the model fields which are hardcoded).

function monitor_ids()
    [1, 2, 3, 4] end

#PresentationModels
#region
export get_or_create_pmodel, PresentationModel, reset_counters
register_mixin(@__MODULE__)

@reactive! mutable struct PresentationModel <: ReactiveModel
    counters::Dict{Symbol, Int8} = Dict(:Bool => 1, :String => 1, :Int => 1, :Vector => 1, :PlotData => 1, 
    :PlotLayout => 1, :PlotConfig => 1, :DataTable => 1, :DataTablePagination => 1)
    num_slides::R{Int8} = 0
    current_id0::R{Int8} = 1
    current_id1::R{Int8} = 1
    current_id2::R{Int8} = 1
    current_id3::R{Int8} = 1
    current_id4::R{Int8} = 1
    drawer0::R{Bool} = false
    drawer1::R{Bool} = false
    drawer2::R{Bool} = false
    drawer3::R{Bool} = false
    drawer4::R{Bool} = false
    int1::R{Int} = 0
    int2::R{Int} = 0
    int3::R{Int} = 0
    int4::R{Int} = 0
    int5::R{Int} = 0
    int6::R{Int} = 0
    int7::R{Int} = 0
    int8::R{Int} = 0
    int9::R{Int} = 0
    int10::R{Int} = 0
    bool1::R{Bool} = false
    bool2::R{Bool} = false
    bool3::R{Bool} = false
    bool4::R{Bool} = false
    bool5::R{Bool} = false
    bool6::R{Bool} = false
    bool7::R{Bool} = false
    bool8::R{Bool} = false
    bool9::R{Bool} = false
    bool10::R{Bool} = false
    string1::R{String} = ""
    string2::R{String} = ""
    string3::R{String} = ""
    string4::R{String} = ""
    string5::R{String} = ""
    string6::R{String} = ""
    string7::R{String} = ""
    string8::R{String} = ""
    string9::R{String} = ""
    string10::R{String} = ""
    vector1::R{Vector} = []
    vector2::R{Vector} = []
    vector3::R{Vector} = []
    vector4::R{Vector} = []
    vector5::R{Vector} = []
    vector6::R{Vector} = []
    vector7::R{Vector} = []
    vector8::R{Vector} = []
    vector9::R{Vector} = []
    vector10::R{Vector} = []
    plotdata1::R{Vector{PlotData}} = [PlotData()]
    plotdata2::R{Vector{PlotData}} = [PlotData()]
    plotdata3::R{Vector{PlotData}} = [PlotData()]
    plotdata4::R{Vector{PlotData}} = [PlotData()]
    plotdata5::R{Vector{PlotData}} = [PlotData()]
    plotlayout1::R{PlotLayout} = PlotLayout()
    plotlayout2::R{PlotLayout} = PlotLayout()
    plotlayout3::R{PlotLayout} = PlotLayout()
    plotlayout4::R{PlotLayout} = PlotLayout()
    plotlayout5::R{PlotLayout} = PlotLayout()
    plotconfig1::R{PlotConfig} = PlotConfig()
    plotconfig2::R{PlotConfig} = PlotConfig()
    plotconfig3::R{PlotConfig} = PlotConfig()
    plotconfig4::R{PlotConfig} = PlotConfig()
    plotconfig5::R{PlotConfig} = PlotConfig()
    datatable1::R{DataTable} = DataTable()
    datatable2::R{DataTable} = DataTable()
    datatable3::R{DataTable} = DataTable()
    datatable4::R{DataTable} = DataTable()
    datatable5::R{DataTable} = DataTable()
    datatablepagination1::R{DataTablePagination} = DataTablePagination()
    datatablepagination2::R{DataTablePagination} = DataTablePagination()
    datatablepagination3::R{DataTablePagination} = DataTablePagination()
    datatablepagination4::R{DataTablePagination} = DataTablePagination()
    datatablepagination5::R{DataTablePagination} = DataTablePagination()
end

pmodels = PresentationModel[]

function reset_counters(pmodel::PresentationModel)
    for key in keys(pmodel.counters)
        pmodel.counters[key] = 1
    end
end

function get_or_create_pmodel(; force_create = false::Bool)
    force_create && empty!(pmodels)
    if isempty(pmodels) || force_create
        pmodel = create_pmodel()
        push!(pmodels, pmodel)
    end
    pmodels[1]
end

function create_pmodel()
    println("Time to initialize model:")
    @time pmodel = Stipple.init(PresentationModel)
    on(pmodel.isready) do ready
        ready || return
        push!(pmodel)        
    end

    return pmodel
end
#endregion

#ModelManager
#region
export new_field!, new_multi_field!, new_handler
#this module should generate handlers and somehow populate fields for each pmodel (depending on slides), or expose functions/macros toward such ends

mutable struct ManagedField
    str::String
    sym::Symbol
    ref::Reactive
end

function new_field!(pmodel::PresentationModel, type::Symbol; value = Nothing, dummy = 0::Int)
    rng = Random.MersenneTwister(dummy)
    name = lowercase(string(type, pmodel.counters[type]))
    name_sym = Symbol(name)
    if type == :PlotData
        if dummy > 0
          
            pd(name) = PlotData(
                x = 1:12,
                y = (1:12)/5,
                name = name,
                plot = "scatter",
            )
            value = [pd(string("Dummy Team ", m_id)) for m_id in monitor_ids()]
        end
    end
    if value != Nothing
        getfield(pmodel, name_sym).o.val = value
    end
    pmodel.counters[type] += 1
    return ManagedField(name, name_sym, getfield(pmodel, name_sym))::ManagedField
end

function new_multi_field!(pmodel::PresentationModel, type::Symbol; value = Nothing, dummy = 0::Int)
    [new_field!(pmodel, type; value, dummy) for i in monitor_ids()]
end

function Base.getindex(field::Vector{ManagedField}, sym::Symbol)
    return Symbol(field[1].sym, "<f_id")
end

handlers = Observables.ObserverFunction[]

function new_handler(fun::Function, field::Reactive)
    handler = on(field, weak = true) do val
        fun(val)
    end
    notify(field)
    push!(handlers, handler)
end

function new_handler(fun::Function, field::ManagedField)
    new_handler(fun, field.ref)
end

function rep!(e, old, new)
    for (i,a) in enumerate(e.args)
        if a==old
            e.args[i] = new
        elseif a isa Expr
            rep!(a, old, new)
        end
    end
    e
end

#endregion

#SLIDE UI
#region
export serve_slideshow, slide, titleslide, iftitleslide, slide_id, navcontrols

mutable struct Slide
    title::String
    HTMLattr::Dict
    body::Vector{ParsedHTMLString}
end

function slide(HTMLelem...; prepend_class = ""::String, title = ""::String, HTMLattr...)
    HTMLattr = Dict(HTMLattr)
    if isempty(HTMLattr)
        HTMLattr = Dict{Symbol, Any}() 
    end #"text-center flex-center q-gutter-sm q-col-gutter-sm slide"
    HTMLattr[:class] = prepend_class * " " * get(HTMLattr, :class, "slide")
    for m_id in monitor_ids()
        body = [replace(x,  
                                                "m_id" => "$m_id", 
                                    r"[0-9+](<f_id)" => y -> string(parse(Int8,y[1])+m_id-1))
                                    for x in HTMLelem]
        if isempty(title) 
            try
                title = strip(match(r"(?<=\<h[1-2]\>).+(?=<)", String(body[1])).match)
            catch
                title = "Untitled"; println("Warning: Untitled slide")
            end
        end
        push!(slides[m_id], Slide(title, HTMLattr, body))
    end
end

slides = Vector{Vector{Slide}}([[],[],[],[]]) #create slideshow for each monitor

function titleslide(args...; prepend_class = "text-center flex-center"::String, title = ""::String, HTMLattr...)
    HTMLattr = Dict(HTMLattr)
    if isempty(HTMLattr)
        HTMLattr = Dict{Symbol, Any}() 
    end
    HTMLattr[:class] = "titleslide"
    if !isempty(prepend_class)
        slide(args...; prepend_class, title, HTMLattr...)
    else
        slide(args...; title, HTMLattr...)
    end
end

function render_slides(m_slides::Vector{Slide}, monitor_id::Int)
    rendered_bodies = ParsedHTMLString[]
        for (id,sld) in enumerate(m_slides)
            push!(rendered_bodies, quasar(:page,
            sld.body, @iif("$id == current_id$monitor_id"); sld.HTMLattr...))
        end
    return rendered_bodies
end

function navcontrols(m_id::Int)
    [btn("",icon="menu", @click("drawer$m_id = ! drawer$m_id"))
    btn("",icon="chevron_left", @click("current_id$m_id > 1 ? current_id$m_id-- : null"))
    btn("",icon="navigate_next", @click("current_id$m_id < num_slides ? current_id$m_id++ : null"))]
end

function iftitleslide(m_id::Int)
    titleslide_ids = findall(contains.([slide.HTMLattr[:class] for slide in slides[m_id]], "titleslide"))
    @iif("!$titleslide_ids.includes(current_id$m_id)")
end

function slide_id(m_id::Int) span("", @text(Symbol("current_id$m_id")), class = "slide_id") end

function menu(m_id::Int, item_fun; side = "left")
drawer(v__model = "drawer$m_id", [
    list([
        item(item_section(item_fun(id, title)), :clickable, @click("current_id$m_id = $(id); drawer$m_id = ! drawer$m_id")) 
        for 
        (id, title) in enumerate(getproperty.(slides[m_id], :title))
        ])
    ]; side)
end

function ui(pmodel::PresentationModel, create_slideshow::Function, create_auxUI::Function, request_params::Dict{Symbol, Any}, folder::String)
    m_id = get(request_params, :monitor_id, 1)::Int
    !(0 < m_id <= m_max) && return "1 is the minimum monitor number, $m_max the maximum."
    !(m_id in monitor_ids()) && return "Monitor $m_id not active."
    if isempty(slides[1]) || get(request_params, :reset, "0") != "0" || get(request_params, :hardreset, "0") != "0"
        push!(Stipple.Layout.THEMES, () -> [link(href = "$folder/theme.css", rel = "stylesheet"), ""])
        foreach(x -> empty!(x),slides)
        Genie.Router.delete!(Symbol("get_stipple.jl_master_assets_css_stipplecore.css")) 
        create_slideshow(pmodel)
    end
    pmodel.num_slides = length(slides[m_id])
    page(pmodel,
    [
        StippleUI.Layouts.layout(view="hHh lpR lFf", [
            create_auxUI(m_id)
            quasar(:page__container, 
                render_slides(slides[m_id], m_id)
            )
        ])
    ])
end

function serve_slideshow(request_params::Dict{Symbol, Any}, create_slideshow::Function, create_auxUI::Function, folder::String)
    hardreset = get(request_params, :hardreset, "0") != "0"
    if hardreset
        pmodel = get_or_create_pmodel(force_create = true)
    else
        pmodel = get_or_create_pmodel()
    end
    println("Time to build UI:")
    if hardreset || get(request_params, :reset, "0") != "0"
        reset_counters(pmodel)
        off.(SlideUI.handlers)
        empty!(SlideUI.handlers)
        pop!(Stipple.Layout.THEMES)
    end
    @time ui(pmodel, create_slideshow, create_auxUI, request_params, folder) |> html 
end
#endregion
end
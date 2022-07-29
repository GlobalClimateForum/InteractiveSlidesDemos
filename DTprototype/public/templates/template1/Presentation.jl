module Presentation
using Reexport, StipplePlotly, Revise
include("../../../src/SlideUI.jl")
@reexport using .SlideUI
Revise.track(SlideUI)
export PresentationModel, create_slideshow, create_auxUI, settings

const folder = joinpath(splitpath(@__DIR__)[end-1:end])
num_monitors() = 2 #as a function so it can be changed without having to restart Julia session

@presentation! struct PresentationModel <: ReactiveModel
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

const settings = Dict{Symbol, Any}(:folder => folder, :num_monitors => num_monitors()) #further possibility: :use_stipple_theme

function create_auxUI(m_id::Int) #header, footer, menu. This is not returned by create_slideshow because it needs to be generated for each monitor every request (as is)
    [quasar(:header, quasar(:toolbar, navcontrols(m_id)))
    quasar(:footer, [quasar(:separator), quasar(:toolbar, 
        [space(), slide_id(m_id)])],
        iftitleslide(m_id))
    menu(m_id, (id, title) -> string(id) * ": " * title)]
end

function create_slideshow(pmodel::PresentationModel)
num_m = num_monitors() #TODO: make num_m parameter of function (and of create_auxUI)
pd(name) = PlotData(
    x = 1:12,
    y = (1:12)/5,
    name = name,
    plot = "scatter",
)

teamsdata = [pd(string("Dummy Team ", m_id)) for m_id in 1:num_m]

show_bar = new_field!(pmodel, :Bool, value = 1)
plot1data = new_field!(pmodel, :PlotData, value = teamsdata)
plot2data = new_field!(pmodel, :PlotData, value = deepcopy(teamsdata))
plotconfig = new_field!(pmodel, :PlotConfig)
plotlayout = new_field!(pmodel, :PlotLayout)
choice = new_multi_field!(pmodel, :Vector, num_m, value = ["Nothing"])
possible_choices = new_field!(pmodel, :Vector, value = ["Nothing", "Increase", "Decrease", "Sine"])

#Handlers
#region
new_handler(show_bar) do val
    println(string("show bar = ", show_bar.ref[]))
    if val == 1
        setproperty!.(plot1data.ref[], :plot, "bar")
        setproperty!.(plot2data.ref[], :plot, "bar")
    else
        setproperty!.(plot1data.ref[], :plot, "scatter")
        setproperty!.(plot2data.ref[], :plot, "scatter")
    end
    notify(plot1data.ref)
    notify(plot2data.ref)   
end

for m_id in 1:num_m
    new_handler(choice[m_id]) do choice
        y = plot1data.ref[m_id].y
        x = 1:12
        if choice == ["Increase"]
            y += x./12
        elseif choice == ["Decrease"]
            y -= x./12
        elseif choice == ["Sine"]
            y += sin.(x.*pi./6)
        end
        plot2data.ref[m_id].y = y
        notify(plot2data.ref)
    end
end

#endregion

titleslide(num_m,
"""<h1>Hello team m_id</h1>""", 
    p("The pandemic exposed an unspoken truth. 
    People were not less productive working from home; 
    in fact, many got more work done. What gives? 
    Well, subtract an hour of commute each way. 
    Subtract another hour spent walking to grab coffee, snacks, and lunch.
    Remove an hour here or there for all the collaboration that happened around the ping pong table or Xbox. 
    Take out the stand-ups, check-ins, and meetings spent on chit-chat and vague ideas which, ya know, could have been an email.")
)

slide(num_m,
    h1("Decision slide"),
    row(class = "flex-center", img(src = "$folder/img/samplepic.jpg")),
    row(class = "flex-center", cell(class = "col-2",
    select(choice[:m_id], options = possible_choices.sym); size = 2
    )),
)

slide(num_m,
    h1("Plot slide"),
row(class = "q-col-gutter-sm", [
cell([
    plot(plot1data.sym, layout = plotlayout.sym, config = plotconfig.sym)]),
cell([
    plot(plot2data.sym, layout = plotlayout.sym, config = plotconfig.sym)])
]),
row(class = "flex-center",
    [radio("Scatter plot", show_bar.sym, val = 0),
    radio("Bar plot", show_bar.sym, val = 1),
    ]),
)

end
end
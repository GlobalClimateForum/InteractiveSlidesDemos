module PresentationModels
using Stipple, StipplePlotly, Mixers
export init_pmodel

pmodels = Dict{String, ReactiveModel}()

x = [
    "Jan2019",
    "Feb2019",
    "Mar2019",
    "Apr2019",
    "May2019",
    "Jun2019",
    "Jul2019",
    "Aug2019",
    "Sep2019",
    "Oct2019",
    "Nov2019",
    "Dec2019",
]

pd(name) = PlotData(
    x = x,
    y = rand(12).*2,
    name = name,
)

@reactive! mutable struct PresentationModel <: ReactiveModel
    bool1::R{Int} = 0
    current_id1::R{Int8} = 1
    current_id2::R{Int8} = 1
    current_id3::R{Int8} = 1
    current_id4::R{Int8} = 1
    drawer::R{Bool} = false
    changename::R{Vector} = ["Nothing"]
    changenames::R{Vector} = ["Nothing", "Increase", "Decrease", "Sine"]
    data::R{Vector{PlotData}} = [pd(name) for name in ["Team A", "Team B"]]
    data2::R{Vector{PlotData}} = deepcopy(data)
    layout::R{PlotLayout} = PlotLayout(
        plot_bgcolor = "#0000",
        paper_bgcolor = "#AAA",
        title = PlotLayoutTitle(text = "Random numbers", font = Font(24)),
    )
    config::R{PlotConfig} = PlotConfig()

    show_bar::R{Bool} = false
end


function init_pmodel(name)
    if !haskey(pmodels, name)
        pmodel = Stipple.init(PresentationModel)
        pmodels[name] = add_handlers!(pmodel)
    else
        pmodels[name]
    end
end

function change_data!(pmodel)
    for i = 1:2
        y = pmodel.data[i].y
        x = 1:12
        if pmodel.changename[1] == "Increase"
            y += x./12
        elseif pmodel.changename[1] == "Decrease"
            y -= x./12
        elseif pmodel.changename[1] == "Sine"
            y += sin.(x.*pi./6)
        end
        pmodel.data2[i].y = y
    end
    notify(pmodel.data2)
    return pmodel
end

function add_handlers!(pmodel)
    on(pmodel.isready) do ready
        ready || return
        push!(pmodel)        
    end
    on(pmodel.changename) do _
        change_data!(pmodel)     
    end
    pmodel
end

end
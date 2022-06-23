module Presentations
using Stipple, StipplePlotly, Mixers
export init_presentation

presentations = Dict{String, ReactiveModel}()

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

#replaces @reactive! (search for "mutable struct reactive!" in Stipple.jl)
@mix Stipple.@with_kw mutable struct presentation!
    Stipple.@reactors #This line is from the definition of reactive!
    current_id::R{Int8} = 1
    drawer::R{Bool} = false
end  

@presentation! mutable struct Presentation <: ReactiveModel
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


function init_presentation(name)
    if !haskey(presentations, name)
        presentation = Stipple.init(Presentation)
        presentations[name] = add_handlers!(presentation)
    else
        presentations[name]
    end
end

function switch_plots!(presentation)
    println(string("show bar = ", presentation.show_bar[]))
    if presentation.show_bar[]
        setproperty!.(presentation.data[], :plot, "bar")
        setproperty!.(presentation.data2[], :plot, "bar")
    else
        setproperty!.(presentation.data[], :plot, "scatter")
        setproperty!.(presentation.data2[], :plot, "scatter")
    end
    notify(presentation.data)
    notify(presentation.data2)
    return presentation
end

function change_data!(presentation)
    for i = 1:2
        y = presentation.data[i].y
        x = 1:12
        if presentation.changename[1] == "Increase"
            y += x./12
        elseif presentation.changename[1] == "Decrease"
            y -= x./12
        elseif presentation.changename[1] == "Sine"
            y += sin.(x.*pi./6)
        end
        presentation.data2[i].y = y
    end
    notify(presentation.data2)
    return presentation
end

function add_handlers!(presentation)
    on(presentation.isready) do ready
        ready || return
        push!(presentation)        
    end
    on(presentation.show_bar) do _
        switch_plots!(presentation)     
    end
    on(presentation.changename) do _
        change_data!(presentation)     
    end
    presentation
end

end
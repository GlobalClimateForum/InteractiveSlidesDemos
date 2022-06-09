module Presentations
using Stipple, StipplePlotly
export init_presentation

pd(name; plot_type = "scatter") = PlotData(
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
    ],
    y = Int[rand(1:100_000) for x = 1:12],
    plot = plot_type,
    name = name,
)

@reactive! mutable struct Presentation <: ReactiveModel
    data::R{Vector{PlotData}} = [pd("Random 1"), pd("Random 2")]
    layout::R{PlotLayout} = PlotLayout(
        plot_bgcolor = "#0000",
        paper_bgcolor = "#AAA",
        title = PlotLayoutTitle(text = "Random numbers", font = Font(24)),
    )
    config::R{PlotConfig} = PlotConfig()

    current_id::R{Int8} = 1
    drawer::R{Bool} = false
    show_bar::R{Bool} = false
    show_plot::R{Bool} = false
end


function init_presentation()
    presentation = Stipple.init(Presentation)
    return add_handlers!(presentation)
end

function switch_plots(presentation)
    println(string("show bar = ", presentation.show_bar[]))
    if presentation.show_bar[]
        setproperty!.(presentation.data[], :plot, "bar")
    else
        setproperty!.(presentation.data[], :plot, "scatter")
    end
    notify(presentation.data)
    return presentation
end

function add_handlers!(presentation)
    on(presentation.isready) do ready
        ready || return
        push!(presentation)        
    end
    on(presentation.show_bar) do _
        switch_plots(presentation)     
    end
    on(presentation.show_plot) do _
        "helloooooo"     
    end
    presentation
end

end
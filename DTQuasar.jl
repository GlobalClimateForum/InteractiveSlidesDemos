using Stipple, StippleUI, StipplePlotly

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


@reactive! mutable struct Example <: ReactiveModel
    data::R{Vector{PlotData}} = [pd("Random 1"), pd("Random 2")]
    layout::R{PlotLayout} = PlotLayout(
        plot_bgcolor = "#0000",
        paper_bgcolor = "#0000",
        title = PlotLayoutTitle(text = "Random numbers", font = Font(24)),
    )
    config::R{PlotConfig} = PlotConfig()

    drawer::R{Bool} = false
    show_bar::R{Bool} = false
    show_plot::R{Bool} = false
end

model = Stipple.init(Example)

function switch_plots(model)
    println("hello")
    if model.show_bar[]
        setproperty!.(model.data[], :plot, "bar")
    else
        setproperty!.(model.data[], :plot, "scatter")
    end
    notify(model.data)
    return model
end

function handlers(model)
    on(model.isready) do ready
        ready || return
        push!(model)        
    end
    on(model.show_bar) do _
        switch_plots(model)     
    end
    on(model.show_plot) do _
        "helloooooo"     
    end
    model
end

function ui(model)
    page(model, 
    [
        StippleUI.Layouts.layout([
            quasar(:header, quasar(:toolbar, [
                    btn("",icon="menu", @click("drawer = ! drawer"))
                    quasar(:toolbar__title, "Example App")])
            )
            drawer(side="left", v__model="drawer", [
                list([
                    item([
                        item_section(icon("bar_chart"), :avatar)
                        item_section("Bar")
                    ], :clickable, :v__ripple, @click("show_bar = true, drawer = false"))
                    item([
                        item_section(icon("scatter_plot"), :avatar)
                        item_section("Scatter")
                    ], :clickable, :v__ripple, @click("show_bar = false, drawer = false"))
                ])
            ])
            StippleUI.Layouts.page_container("",[
            row(
                [cell(class = "q-gutter-xs", [
                plot(:data, layout = :layout, config = :config)]), cell(class = "q-gutter-xs", [
                    plot(:data, layout = :layout, config = :config)])], @iif(:show_plot)
            )
            row(
                cell(class = "q-gutter-xs", 
                [radio("Scatter plot", :show_bar, val = 0),
                radio("Bar plot", :show_bar, val = "true"),
                btn("Show plot", color = "secondary", @click("show_plot = true"))]),@els(:show_plot)
            )]
            )
        ])
    ])
end

route("/") do
    model |> handlers |> ui |> html
end

route("/2") do
    model |> handlers |> ui |> html
end

up(8080, open_browser = true)
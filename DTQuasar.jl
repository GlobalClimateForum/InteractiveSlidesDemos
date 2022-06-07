using Stipple, StippleUI, StipplePlotly
include("Presentations.jl")
using .Presentations

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
    init_presentation() |> ui |> html
end

route("/2") do
    model |> handlers |> ui |> html
end

up(8080, open_browser = true)
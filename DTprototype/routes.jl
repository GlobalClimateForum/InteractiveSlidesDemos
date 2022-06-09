using Genie.Router
using Stipple, StippleUI, StipplePlotly
using Presentations

function ui(presentation)
  page(presentation, 
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
          StippleUI.Layouts.page_container("",
          include("slides.jl")
          )
      ])
  ])
end

route("/") do
  init_presentation() |> ui |> html
end
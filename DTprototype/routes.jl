using Genie.Router, Genie.Renderer
using Stipple, StippleUI, StipplePlotly, Slides
using Presentations

using DT

function menu(slide_titles::Vector{String})
drawer(side="left", v__model="drawer", [
        list([
            item(item_section(string(id) * ": " * title), :clickable, @click("current_id = $(id)")) 
            for 
            (id, title) in enumerate(slide_titles)
            ])
        ])
end

function ui(presentation)
  slide_titles, slide_bodies = create_slideshow() |> render_slides
  page(presentation, style = "font-size:40px", prepend = style(
    """
    h1 {
        font-size: 3em !important;
        line-height: 1em !important;
    }
    .slide > p, li {
        text-align: justify;
        max-width: 60%;
        margin: auto;
    }
    """
    ),
  [
      StippleUI.Layouts.layout([
          quasar(:header, quasar(:toolbar, [
                  btn("",icon="menu", @click("drawer = ! drawer"))
                  btn("",icon="chevron_left", @click("current_id > 1 ? current_id-- : null"))
                  btn("",icon="navigate_next", @click("current_id < $(length(slide_titles)) ? current_id++ : null"))
                  ])
          )
          quasar(:footer, quasar(:toolbar, [space(),
                  icon("img:$folder/img/GCFlogo.png", size = "md"),
                  quasar(:toolbar__title, "GCF"), span("", @text(:current_id))])
          )
          menu(slide_titles)
          StippleUI.Layouts.page_container("",
            slide_bodies
          )
      ])
  ])
end

route("/") do
    ui_out = init_presentation("1") |> ui |> html
end

route("/:name") do
    ui_out = init_presentation(params(:name)) |> ui |> html
end
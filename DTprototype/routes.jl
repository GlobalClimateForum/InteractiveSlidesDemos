using Genie.Router, Genie.Renderer
using Stipple, StippleUI, StipplePlotly
using Presentations

pname = "presentation1"
slides = Vector[]


function slide(args...)
    push!(slides, AbstractString[args...])
end

function render_slides(slides::Vector{Vector})
titles = String[]
bodies = ParsedHTMLString[]
    for (id,sld) in enumerate(slides)
        push!(titles, strip(match(r">.*<", String(sld[1])).match[2:end-1]))
        push!(bodies, Html.div(class = "slide text-center flex-center q-gutter-sm q-col-gutter-sm", sld, @iif(:($id == current_id))))
    end
    return (titles, bodies)
end

function menu(slide_titles::Vector{String})
drawer(side="left", v__model="drawer", [
        list([
            item(item_section(string(id) * ": " * title), :clickable, @click("current_id = $(id)")) 
            for 
            (id, title) in enumerate(slide_titles)
            ])
        ])
end


slides = include("public/$pname/slides.jl")
slide_titles, slide_bodies = render_slides(slides)



function ui(presentation)
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
                  icon("img:$pname/img/GCFlogo.png", size = "md"),
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
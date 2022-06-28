using Genie.Router, Genie.Renderer
using Stipple, StippleUI, StipplePlotly
using PresentationModels, SlideUI
import ModelManager

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

function ui(pmodel, m_id)
    try
        slide_titles, slide_bodies = render_slides(create_slideshow(pmodel), m_id)
        page(pmodel, style = "font-size:40px", prepend = style(
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
                        btn("",icon="chevron_left", @click("current_id$m_id > 1 ? current_id$m_id-- : null"))
                        btn("",icon="navigate_next", @click("current_id$m_id < $(length(slide_titles)) ? current_id$m_id++ : null"))
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
    finally
        ModelManager.reset_manager()
        SlideUI.reset_slideUI()
    end
end

route("/") do
    ui_out = ui(init_pmodel("default"), 1) |> html
end

route("/:monitor_id::Int/") do
    ui_out = ui(init_pmodel("default"), params(:monitor_id)) |> html
end

route("/:name::String/:monitor_id::Int/") do
    ui_out = ui(init_pmodel(params(:name)), params(:monitor_id)) |> html
end
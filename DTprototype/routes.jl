println("Time to import Presentation:")
@time using Presentation

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
    reset_manager()
    SlideUI.reset_slideUI()
    slide_titles, slide_bodies = SlideUI.render_slides(create_slideshow(pmodel), m_id)
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
                    quasar(:toolbar__title, "GCF"), span("", @text(Symbol("current_id$m_id")))])
            )
            menu(slide_titles)
            StippleUI.Layouts.page_container("",
                slide_bodies
            )
        ])
    ])
end

route("/") do
    println("Time to get model:")
    @time pmodel = get_pmodel()
    println("Time to build UI:")
    @time ui_out = ui(pmodel, 1) |> html
end

Genie.Router.route("/:monitor_id::Int/") do
    ui_out = ui(get_pmodel(), params(:monitor_id)) |> html
end
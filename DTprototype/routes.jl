println("Time to import Presentation:")
@time using Presentation

function ui(pmodel::PresentationModel, m_id::Int)
    reset_manager(pmodel)
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
            standard_menu(slide_titles)
            standard_header(length(slide_titles), m_id)
            standard_footer(m_id, folder)
            StippleUI.Layouts.page_container("",
                slide_bodies
            )
        ])
    ])
end

route("/") do
    if get(params(), :recreate, "0") == "0"
        pmodel = get_or_create_pmodel()
    else
        pmodel = create_or_recreate_pmodel()
    end
    println("Time to build UI:")
    @time ui_out = ui(pmodel, m_id) |> html
end

Genie.Router.route("/:monitor_id::Int/") do
    ui_out = ui(get_pmodel(), params(:monitor_id)) |> html
end
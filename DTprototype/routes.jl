println("Time to import Presentation:")
@time using Presentation

UI = ParsedHTMLString("")

function ui(pmodel::PresentationModel, request_params::Dict{Symbol, Any})
    m_id = get(request_params, :monitor_id, 1)::Int
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
    pmodel = get_or_create_pmodel(params())
    println("Time to build UI:")
    @time ui_out = ui(pmodel, params()) |> html
end

route("/:monitor_id::Int/") do
    pmodel = get_or_create_pmodel(params())
    ui_out = ui(get_pmodel(), params()) |> html
end
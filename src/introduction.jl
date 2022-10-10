function introduction(pmodel::PresentationModel, params::Dict, slides::Vector{Slide})

@titleslide(
    h1("InteractiveSlides.jl"), 
    """<br><p>Hello team $(params[:team_id]) !</p>
    <p>Use arrow keys to navigate, and "m" to expand/collapse the menu.</p>""", 
)

#As you can see above, you can directly write html strings (which may be useful for using code generated by GenieBuilder e.g.)
#However, InteractiveSlides.jl does not parse strings (as opposed to GenieBuilder), and it thus often may be preferable/necessary to use the functions supplied by Genie, Stipple and StippleUI (see code below).

@slide(
    h1("You can use web technologies to create your slide"), 
    row(class = "items-center justify-around",
    [cell(size=1), 
     cell(p("For example, this slide is responsive. The picture only shows for wide screens (try resizing the window)")),
     autocell(img(src = "img/samplepic.jpg", style = "max-width: 45vmax", class = "gt-sm"))]
    )
)

@simpleslide(h1("This slide has vertically centered content"), 
    simplelist(
        "Try",
        "resizing", simplelist("the", "window")), 
    img(src = "img/samplepic.jpg", style = "max-height: 60vh"),
title = "Vertically centered content"
)

@simpleslide(h1("This presentation also features a timer"),
    simplelist(
        "You can see the timer in the header (top right)",
        "You can control it with hotkeys",
        simplelist( """"d" starts a countdown of the timer""", 
                    """"u" counts up""",
                    """"p" pauses the timer""")), 
title = "Timer"
)

@simpleslide(h1("What is 'behind' this presentation?"), 
    img(src = "img/scheme.png", style = "max-height: 60vh"),
)

pmodel.files[] = [filedict(dirname(@__DIR__))] #used by draggable_tree() below (referred to by :files)
@slide(h1("Let's look at the project folder"), 
    row([
    draggabletree(:files; style = "font-size:0.75rem"),
    pre(code(
        """#startapp.jl
        using Revise
        __revise_mode__ = :eval
        includet("src/" * Pkg.project().name * ".jl")
        
        #this executes InteractiveSlidesDemos.jl
        #which in turn includes content.jl"""
    , class = "language-julia hljs"), @appear_on(2, true)),

    ], class = "justify-evenly"),
class = "scroll-always", num_states = 2
)

# pre(code(
#     """#InteractiveSlidesDemos.jl
#     using InteractiveSlides

#     @presentation! struct PresentationModel <: ReactiveModel
#         files::R{Vector{Dict{Symbol, Any}}} = []
#     end

#     add_js("vue_custom", basedir = @__DIR__)

#     includet("./custom_funs.jl")
#     includet("./content.jl")

#     serve_presentation(PresentationModel, gen_content; num_teams_default = 2)

#     Genie.up(8080, "0.0.0.0", open_browser = true)"""
# , class = "language-julia hljs"), show_from_to(3, 3)),

@slide(h1("This is what you might typically be doing:"), 
    spacer("1vw"),
    row([
    cell([
        h2("Step 1: Save picture"),
        img(src = "img/fromPowerpoint.jpg", style = "width: 90%"),
        ], class = "text-center", size = 6),
    cell([
        h2("Step 2: Add code to content.jl"),
        pre(code(
            """@simpleslide(
                    h1("What is 'behind' 
                    this presentation?"), 
                    img(src = "img/scheme.jpg", 
                        style = "max-height: 60vh")
                )"""
        , class = "language-julia hljs", style = "width: 90%; margin:auto")),
        ], size = 6),
    ]),
title = "Creating slides is easy"
)

return slides
end
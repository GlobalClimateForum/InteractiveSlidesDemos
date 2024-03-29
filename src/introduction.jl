function introduction(pmodel::PresentationModel, params::Dict, slides::Vector{Slide})

@titleslide(
    h1("InteractiveSlides.jl"), 
    """<br><p>Hello team $(params[:team_id]) !</p>
    <p>Use arrow keys to navigate, and "m" to expand/collapse the menu.</p>""", 
)

#As you can see above, you can directly write html strings (which may be useful for using code generated by GenieBuilder e.g., 
#though it should be noted that InteractiveSlides.jl does not make use of Genie HTML parsing, and as such not all such-generated code will be directly usable)
#It thus often may be preferable/necessary to use the functions supplied by Genie, Stipple and StippleUI (see code below).

@simpleslide(h1("InteractiveSlides.jl is powered by the <a href=https://genieframework.com>Genie framework</a>"), 
    p("\"Genie Framework includes all you need to quickly build production-ready web applications with Julia. 
    Develop Julia backends, create beautiful web UIs, build data applications and dashboards, integrate with 
    databases and set up high-performance web services and APIs.\"", style = "max-width:70%"),
title = "The Genie framework"
)

@slide(
    h1("You can thus use modern web technologies for creating your slideshow"), 
    row(class = "items-center justify-around",
    [cell(size=1), 
     cell(p("For example, this slide is responsive. E.g., the picture here only shows on wide screens (try resizing the window). 
     <a href=https://v1.quasar.dev/style/visibility>This behavior</a> and other UI stuff is enabled by 
     Quasar (which is shipped with the Genie framework).")),
     img(src = "img/samplepic.jpg", style = "max-width: 45vmax", class = "gt-sm")]
    ),
title = "Quasar"
)

@simpleslide(h1("This slide has vertically centered content"), 
    simplelist(
        "Plus caption",
        "Plus rounded borders",
        "Plus tooltip"), 
        q__img([Html.div("<a href=https://v1.quasar.dev/vue-components/img>Caption</a>", class = "absolute-bottom text-center text-subtitle2"), 
        q__icon(tooltip("Click link in caption for more info on Quasar and images."), name = "info",  
             class = "absolute all-pointer-events", size = "1.5rem", style = "top: 8px; left: 8px")],
        src = "img/samplepic.jpg", style = "height: 60vh; width:40vw", class = "rounded-borders"),
title = "More Quasar stuff"
)

@slide(h1("There's more"),
    spacer("2vw"),
    simplelist(
        "Quasar and Stipple employ <a href=https://v2.vuejs.org/>Vue.js</a> - which you can also use.",
        "You can also run plain Javascript.",
        "CSS is included too: By simply editing the <a href=css/theme.css>theme.css</a> file, you can quickly change the style of this presentation.",
        "And HTML! Woohoo!", style = "max-width:80%; margin:auto"), 
title = "Vue, Javascript, CSS"
)

@simpleslide(h1("InteractiveSlides.jl makes creating presentations a breeze"),
    simplelist(
        "Plus, it provides gimmicks such as a timer!",
        "In this presentation, you can see the timer in the header (top right)",
        "You can control it with hotkeys",
        simplelist( """"d" starts a countdown of the timer""", 
                    """"u" counts up""",
                    """"p" pauses the timer""")), 
title = "Timer"
)

@simpleslide(h1("How does it all work?"), 
    img(src = "img/scheme.png", style = "height: 90%"),
)

@slide(h1("Let's look at the project folder of this presentation (click on the folder!)"), 
    row([

    draggabletree(:files, rowkey = "key", group = "test"; style = "font-size:0.75rem"),

    Html.div([
    pre(code_startapp),
    @linktoslide("Click here if you saw enough code (skip to next slide)", "+= 1", style = "font-size:0.65rem")
    ],@show_from_to(2, 2, true, false)),

    pre(code_InteractiveSlidesDemos, @show_from_to(3, 3)),

    pre(code_content, @appear_on(4)),

    ], class = "justify-around"),
class = "scroll-always", num_states = 4
)

@simpleslide(h1("This is what you might typically be doing:"), 
    two_columns(

    [h2("Step 1: Save picture"),
    img(src = "img/fromPowerpoint.jpg", style = "width: 90%")],

    [h2("Step 2: Add code to project files"),
        pre(code(
            """@simpleslide(
                    h1("What is 'behind' 
                    this presentation?"), 
                    img(src = "img/scheme.jpg", 
                        style = "max-height: 60vh")
                )""", 
            class = "language-julia hljs", style = "width: 100%; margin:auto"))],
    ),
title = "Creating slides is easy"
)

@slide(h1("This means you can use Git and GitHub!"), 
    spacer("1vw"),
    row([
        autocell(img(src = "img/commits.jpg", style = "max-height: 70vh")),
        autocell(a("GitHub repository of this presentation", href = "https://github.com/GlobalClimateForum/InteractiveSlidesDemos"))
    ], class = "items-center justify-evenly"),
title = "Git and GitHub!",
)

return slides
end
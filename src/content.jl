function gen_content(pmodel::PresentationModel, params::Dict)

slides = Slide[]
slides = introduction(pmodel, params, slides)
slides = main(pmodel, params, slides)

# HEADER AND FOOTER
# needs to be at the end because the variable "slides" gets updated by each use of @slide
timertext = """timer > 60 ? Math.round(timer/60) + " min" : timer"""
auxUI = [quasar(:header, toolbar([@navcontrols()..., space(), span("", @text(timertext), @hide_on_titleslide)])),

        quasar(:footer, [separator(), toolbar( 
        [img(src = "img/logo.png", style = "max-height:1rem"), space(), 
        span("InteractiveSlides.jl in action"), space(), @slide_id])], @hide_on_titleslide),

        menu_slides(slides, params, (id, title) -> string(id) * ": " * title)]

return slides, auxUI

end
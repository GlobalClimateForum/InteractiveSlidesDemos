println("Time to import Presentation:")
import Revise
# Revise.track("src/Presentation.jl")
@time include("public/templates/template1/Presentation.jl")
using .Presentation
Revise.track(Presentation)

Genie.route("/") do
    serve_slideshow(PresentationModel, create_slideshow, create_auxUI, settings, params())
end

Genie.route("/:monitor_id::Int/") do
    serve_slideshow(PresentationModel, create_slideshow, create_auxUI, settings, params())
end
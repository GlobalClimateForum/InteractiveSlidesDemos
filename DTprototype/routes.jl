println("Time to import Presentation:")
@time using Presentation

route("/") do
    serve_slideshow(PresentationModel, create_slideshow, create_auxUI, settings, params())
end

route("/:monitor_id::Int/") do
    serve_slideshow(PresentationModel, create_slideshow, create_auxUI, settings, params())
end
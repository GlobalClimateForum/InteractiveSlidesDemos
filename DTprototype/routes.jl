println("Time to import Presentation:")
@time using Presentation

route("/") do
    serve_slideshow(params(), create_slideshow, folder)
end

route("/:monitor_id::Int/") do
    serve_slideshow(params(), create_slideshow, folder)
end
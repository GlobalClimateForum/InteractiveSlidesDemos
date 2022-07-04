println("Time to import Presentation:")
@time using Presentation

route("/") do
    respond(params())
end

route("/:monitor_id::Int/") do
    respond(params())
end

function respond(request_params)
    pmodel = get_or_create_pmodel(request_params)
    println("Time to build UI:")
    if get(request_params, :refresh, "0") != "0"
        reset_counters(pmodel)
        off.(SlideUI.handlers)
        empty!(SlideUI.handlers)
    end
    @time ui(pmodel, create_slideshow, request_params, folder) |> html
end
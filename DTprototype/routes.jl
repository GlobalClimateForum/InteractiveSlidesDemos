println("Time to import Presentation:")
@time using Presentation

route("/") do
    respond(params())
end

route("/:monitor_id::Int/") do
    respond(params())
end

function respond(request_params)
    hardreset = get(request_params, :hardreset, "0") != "0"
    if hardreset
        pmodel = get_or_create_pmodel(force_create = true)
    else
        pmodel = get_or_create_pmodel()
    end
    println("Time to build UI:")
    if hardreset || get(request_params, :reset, "0") != "0"
        reset_counters(pmodel)
        off.(SlideUI.handlers)
        empty!(SlideUI.handlers)
    end
    @time ui(pmodel, create_slideshow, request_params, folder) |> html
end
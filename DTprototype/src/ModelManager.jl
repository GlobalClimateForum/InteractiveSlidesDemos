module ModelManager
println("Time to import Stipple and StipplePlotly in ModelManager:")
@time using Stipple, StipplePlotly
import Random
export new_field!, on_bool!, on_vector!, reset_counter
#this module should generate handlers and somehow populate fields for each pmodel (depending on slides), or expose functions/macros toward such ends

counters = Dict{Symbol, Int8}(:Bool => 1, :Int => 1, :Vector => 1, :PlotData => 1, :PlotLayout => 1, :PlotConfig => 1)

handlers = Observables.ObserverFunction[]

# PlotLayout(
#         plot_bgcolor = "#0000",
#         paper_bgcolor = "#AAA",
#         title = PlotLayoutTitle(text = "Dummy numbers", font = Font(24)),
#     )


function new_field!(pmodel, type::Symbol; value = Nothing, dummy = 0::Int)
    rng = Random.MersenneTwister(dummy)
    name = lowercase(string(type, counters[type]))
    if name[1:4] == "bool"
        name = "int" * name[5:end]
    end
    name_sym = Symbol(name)
    if type == :PlotData
        if dummy > 0
          
            pd(name) = PlotData(
                x = 1:12,
                y = rand(rng, 12).*2,
                name = name,
                plot = "scatter",
            )
            
            value = [pd(name) for name in ["Dummy Team A", "Dummy Team B"]]
        end
    elseif type == :Bool
        if dummy > 0
            value = rand(rng, [0 1])
        end
    end
    getfield(pmodel, name_sym).o.val = value
    counters[type] += 1
    return name_sym
end

function reset_manager()
    for key in keys(counters)
        counters[key] = 1
    end
    off.(handlers)
end

function on_bool!(pmodel)
    handler = on(pmodel.int1) do val
        println(string("show bar = ", pmodel.int1[]))
        if val == 1
            setproperty!.(pmodel.plotdata1[], :plot, "bar")
            setproperty!.(pmodel.plotdata2[], :plot, "bar")
        else
            setproperty!.(pmodel.plotdata1[], :plot, "scatter")
            setproperty!.(pmodel.plotdata2[], :plot, "scatter")
        end
        notify(pmodel.plotdata1)
        notify(pmodel.plotdata2)   
    end
    push!(handlers, handler)
    notify(pmodel.int1)
end

function on_vector!(pmodel)
    handler = on(pmodel.vector1) do choice
        for i = 1:2
            y = pmodel.plotdata1[i].y
            x = 1:12
            if choice == ["Increase"]
                y += x./12
            elseif choice == ["Decrease"]
                y -= x./12
            elseif choice == ["Sine"]
                y += sin.(x.*pi./6)
            end
            pmodel.plotdata2[i].y = y
        end
        notify(pmodel.plotdata2)
    end
    push!(handlers, handler)
    notify(pmodel.vector1)
end

end
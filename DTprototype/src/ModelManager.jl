module ModelManager
using Stipple
import Random
export new_field!, on_bool!, reset_counter
#this module should generate handlers and somehow populate fields for each pmodel (depending on slides), or expose functions/macros toward such ends

counters = Dict{Symbol, Int8}(:Bool => 1, :Int => 1, :Vector => 1, :PlotData => 1, :PlotLayout => 1, :PlotConfig => 1)

handlers = Observables.ObserverFunction[]


function new_field!(pmodel, type::Symbol; value, dummy = 0::Int)
    rng = Random.MersenneTwister(dummy)
    name = lowercase(string(type, counters[type]))
    name_sym = Symbol(name)
    # if type == :PlotData
    #     fieldname = string(type, counters[type])
    #     if dummy > 0
          
    #         pd(name) = PlotData(
    #             x = 1:12,
    #             y = rand(rng, 12).*2,
    #             name = name,
    #         )
            
    #         pmodel.data = [pd(name) for name in ["Dummy Team A", "Dummy Team B"]]
    #     end
    #     return Symbol(fieldname)
    if type == :Bool
        if dummy > 0
            value = rand(rng, [0 1])
        end
        # setproperty!(getfield(pmodel, fieldname), , value)
        # pmodel.bool1[] = true
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
    handler = on(pmodel.bool1) do val
        println(string("show bar = ", pmodel.bool1[]))
        if val == 1
            setproperty!.(pmodel.data[], :plot, "bar")
            setproperty!.(pmodel.data2[], :plot, "bar")
        else
            setproperty!.(pmodel.data[], :plot, "scatter")
            setproperty!.(pmodel.data2[], :plot, "scatter")
        end
        notify(pmodel.data)
        notify(pmodel.data2)   
    end
    notify(pmodel.bool1)
    push!(handlers, handler)
end

end
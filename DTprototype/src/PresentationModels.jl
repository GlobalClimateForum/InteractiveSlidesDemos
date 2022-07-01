module PresentationModels
println("Time to import Stipple and StipplePlotly in PresentationModels:")
@time using Stipple, StipplePlotly
import Stipple.table
export get_pmodel

pmodels = ReactiveModel[]

register_mixin(@__MODULE__)

@reactive! mutable struct PresentationModel <: ReactiveModel
    int1::R{Int} = 0
    current_id1::R{Int8} = 1
    current_id2::R{Int8} = 1
    current_id3::R{Int8} = 1
    current_id4::R{Int8} = 1
    drawer::R{Bool} = false
    vector1::R{Vector} = []
    vector2::R{Vector} = []
    plotdata1::R{Vector{PlotData}} = [PlotData()]
    plotdata2::R{Vector{PlotData}} = [PlotData()]
    layout::R{PlotLayout} = PlotLayout()
    config::R{PlotConfig} = PlotConfig()

    show_bar::R{Bool} = false
end


function get_pmodel()
    if isempty(pmodels)
        pmodel = Stipple.init(PresentationModel) |> add_handlers!
        push!(pmodels, pmodel)
    end
    pmodels[1]
end

function add_handlers!(pmodel)
    on(pmodel.isready) do ready
        ready || return
        push!(pmodel)        
    end
    pmodel
end

end
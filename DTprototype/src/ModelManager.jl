module ModelManager
#this module should generate handlers and somehow populate fields for each pmodel (depending on slides), or expose functions/macros toward such ends

fieldcounters = Dict{Symbol, Int8}(:Bool => 1, :Int => 1, :Vector => 1, :PlotData => 1, :PlotLayout => 1, :PlotConfig => 1)

function newfield(; type = :Bool::Symbol, dummy = 0::Int)
    rng = MersenneTwister(dummy)
    if type == :PlotData
        if dummy > 0
          
            pd(name) = PlotData(
                x = 1:12,
                y = rand(rng, 12).*2,
                name = name,
            )
            
            data = [pd(name) for name in ["Dummy Team A", "Dummy Team B"]]
        end
        return :data
    end
end

end
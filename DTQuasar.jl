using Genie.Router
using Stipple, StippleUI, StipplePlotly

@reactive! mutable struct Presentation <: ReactiveModel
    current_id::R{Int8} = 1
end

function init_presentation()
    presentation = Stipple.init(Presentation)
    on(presentation.isready) do ready
        ready || return
        push!(presentation)        
    end
    presentation
end

function ui(presentation)
    page(presentation, "", @on("keyup.right", "current_id++"),
    [
        cell(
            [
                h2("slide 1"), 
                input("", @on("keyup.right", "current_id++"))
            ], @iif(:(current_id == 1))),
        h3("slide 2", @iif(:(current_id == 2))),
        h3("slide 3", @iif(:(current_id == 3))),
    ]
    )
end

route("/") do
  init_presentation() |> ui |> html
end

up(8080, open_browser = true)
module SlideUI
println("Time to import Stipple in SlideUI:")
@time import Stipple.ParsedHTMLString, Stipple.@iif, Genie.Renderer
export slide, render_slides

slides = Vector[]
function slide(args...)
    push!(slides, AbstractString[args...])
end

function render_slides(slides_to_render::Vector{Vector}, monitor_id)
    titles = String[]
    bodies = ParsedHTMLString[]
        for (id,sld) in enumerate(slides_to_render)
            push!(titles, strip(match(r">.*<", String(sld[1])).match[2:end-1]))
            push!(bodies, 
            Renderer.Html.div(class = "slide text-center flex-center q-gutter-sm q-col-gutter-sm", 
            sld, @iif("$id == current_id$monitor_id")))
        end
    return (titles, bodies)
end

function reset_slideUI()
    empty!(slides)
end

end
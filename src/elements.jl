row_c(args...; kwargs...) = row(class = "flex-center text-center", args...; kwargs...) # just a convenience function

# below example code for a draggable tree component is taken from https://github.com/GenieFramework/StippleDemos/tree/master/AdvancedExamples/DraggableTree
function filedict(startfile)
    dict(; kwargs...) = Dict{Symbol, Any}(kwargs...)
    if isdir(startfile)
        files = readdir(startfile, join = true)
        index = isdir.(files)
        files = vcat(files[index], files[.! index])
        dict(
            label = basename(startfile),
            key = startfile,
            icon = "folder",
            children = filedict.(files)
        )
    else
        dict(
            label = basename(startfile),
            key = startfile,
            icon = "insert_drive_file"
        )
    end
end

draggabletree(fieldname::Symbol; data::Union{Symbol, String} = fieldname, rowkey = "key", kwargs...) = quasar(:draggable__tree; fieldname, data, row__key = rowkey, kwargs...)

class = "language-julia hljs"

code_InteractiveSlidesDemos = code(
    """#InteractiveSlidesDemos.jl
    using InteractiveSlides, StipplePlotly, #3 more

    @presentation! struct PresentationModel <: ReactiveModel
        files::R{Vector{Dict{Symbol, Any}}} = []
        #code for some more fields (omitted here)
    end

    includet("elements.jl")
    includet("introduction.jl")
    includet("main.jl")
    includet("content.jl")

    serve_presentation(PresentationModel, gen_content; 
                       num_teams_default = 2)

    Genie.up(8080, "0.0.0.0", open_browser = true)"""
, class)

code_content = code(
    """#content.jl
    function gen_content(pmodel::PresentationModel, params::Dict)

        slides = Slide[]
        slides = introduction(pmodel, params, slides)
        slides = main(pmodel, params, slides)
        
        auxUI = #code defining header, footer, and drawer
        
        return slides, auxUI
        
    end
    """
, class)

code_startapp = code(
    """#startapp.jl
    using Revise
    __revise_mode__ = :eval
    includet("src/" * Pkg.project().name * ".jl")
    
    #this executes InteractiveSlidesDemos.jl
    #which in turn includes content.jl"""
, class)
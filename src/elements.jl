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
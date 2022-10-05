#custom funs can also defined within gen_content (which may be more convenient, for small functions in particular)
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
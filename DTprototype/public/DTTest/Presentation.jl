module Presentation
using Stipple, StipplePlotly, StippleUI
using SlideUI, ModelManager
export create_slideshow, folder

const folder = splitpath(@__DIR__)[end]

function create_slideshow(pmodel)
show_bar = new_field!(pmodel, :Bool, value = 1, dummy = 0)
on_bool!(pmodel)
# layout1 = :layout
# config1 = :config

# function add_handler(var1::Symbol, var2::Symbol; on = [vars], notify = [vars]) #perhaps only kwargs
#     if var1
#         var1 * var2
# # "this function or macro takes these symbols and creates the respective handler"
# end

slide(
"""<h1>Title slide</h1>""", 
    p("The pandemic exposed an unspoken truth. 
    People were not less productive working from home; 
    in fact, many got more work done. What gives? 
    Well, subtract an hour of commute each way. 
    Subtract another hour spent walking to grab coffee, snacks, and lunch.
    Remove an hour here or there for all the collaboration that happened around the ping pong table or Xbox. 
    Take out the stand-ups, check-ins, and meetings spent on chit-chat and vague ideas which, ya know, could have been an email.")
)

slide(
    h1("Decision slide"),
    row(class = "flex-center", img(src="$folder/img/samplepic.jpg")),
    row(class = "flex-center", cell(class = "col-2",
    select(:changename, options= :changenames); size = 2
    )),
)

slide(
    h2("Plot slide"),
row(class = "q-col-gutter-sm", [
cell([
    plot(:data, layout = :layout, config = :config)]),
cell([
    plot(:data2, layout = :layout, config = :config)])
]),
row(class = "flex-center",
    [radio("Scatter plot", show_bar, val = 0),
    radio("Bar plot", show_bar, val = 1),
    ]),
)

end
end
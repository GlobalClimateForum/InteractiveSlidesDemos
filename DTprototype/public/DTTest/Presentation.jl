module Presentation
using Reexport
@reexport using SlideUI
export create_slideshow, folder

const folder = splitpath(@__DIR__)[end]

function create_slideshow(pmodel)
show_bar = new_field!(pmodel, :Bool, value = 1, dummy = 0)
team1data = new_field!(pmodel, :PlotData, dummy = 1)
team2data = new_field!(pmodel, :PlotData, dummy = 1)
plotconfig = new_field!(pmodel, :PlotConfig)
plotlayout = new_field!(pmodel, :PlotLayout)
choice = new_field!(pmodel, :Vector, value = ["Nothing"])
possible_choices = new_field!(pmodel, :Vector, value = ["Nothing", "Increase", "Decrease", "Sine"])

handler = on(show_bar.ref) do val
    println(string("show bar = ", show_bar.ref[]))
    if val == 1
        setproperty!.(team1data.ref[], :plot, "bar")
        setproperty!.(team2data.ref[], :plot, "bar")
    else
        setproperty!.(team1data.ref[], :plot, "scatter")
        setproperty!.(team2data.ref[], :plot, "scatter")
    end
    notify(team1data.ref)
    notify(team2data.ref)   
end
push!(pmodel.handlers, handler)
notify(show_bar.ref)

handler = on(choice.ref) do choice
    for i = 1:2
        y = team1data.ref[i].y
        x = 1:12
        if choice == ["Increase"]
            y += x./12
        elseif choice == ["Decrease"]
            y -= x./12
        elseif choice == ["Sine"]
            y += sin.(x.*pi./6)
        end
        team2data.ref[i].y = y
    end
    notify(team2data.ref)
end
push!(pmodel.handlers, handler)
notify(choice.ref)

# @new_handler!(possible_choices)
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
    row(class = "flex-center", img(src = "$folder/img/samplepic.jpg")),
    row(class = "flex-center", cell(class = "col-2",
    select(choice.sym, options = possible_choices.sym); size = 2
    )),
)

slide(
    h2("Plot slide"),
row(class = "q-col-gutter-sm", [
cell([
    plot(team1data.sym, layout = plotlayout.sym, config = plotconfig.sym)]),
cell([
    plot(team2data.sym, layout = plotlayout.sym, config = plotconfig.sym)])
]),
row(class = "flex-center",
    [radio("Scatter plot", show_bar.sym, val = 0),
    radio("Bar plot", show_bar.sym, val = 1),
    ]),
)

end
end
function gen_content(pmodel::PresentationModel)
num_m = num_monitors() #TODO: make num_m parameter of function (and of create_auxUI)

pd(name) = PlotData(
    x = 1:12,
    y = (1:12)/5,
    name = name,
    plot = "scatter",
)

teamsdata = [pd(string("Dummy Team ", m_id)) for m_id in 1:num_m]

show_bar = new_field!(pmodel, "Bool", value = 1)
plot1data = new_field!(pmodel, "VectorPlotData", value = teamsdata)
plot2data = new_field!(pmodel, "VectorPlotData", value = deepcopy(teamsdata))
plotconfig = new_field!(pmodel, "PlotConfig")
plotlayout = new_field!(pmodel, "PlotLayout")
choice = new_multi_field!(pmodel, "Vector", num_m, value = ["Nothing"])
possible_choices = new_field!(pmodel, "Vector", value = ["Nothing", "Increase", "Decrease", "Sine"])

#Handlers
#region
new_handler(show_bar) do val
    println(string("show bar = ", show_bar.ref[]))
    if val == 1
        setproperty!.(plot1data.ref[], :plot, "bar")
        setproperty!.(plot2data.ref[], :plot, "bar")
    else
        setproperty!.(plot1data.ref[], :plot, "scatter")
        setproperty!.(plot2data.ref[], :plot, "scatter")
    end
    notify(plot1data.ref)
    notify(plot2data.ref)   
end

for m_id in 1:num_m
    new_handler(choice[m_id]) do choice
        y = plot1data.ref[m_id].y
        x = 1:12
        if choice == ["Increase"]
            y += x./12
        elseif choice == ["Decrease"]
            y -= x./12
        elseif choice == ["Sine"]
            y += sin.(x.*pi./6)
        end
        plot2data.ref[m_id].y = y
        notify(plot2data.ref)
    end
end

#endregion

titleslide(num_m,
"""<h1>Hello team m_id</h1>""", 
    p("The pandemic exposed an unspoken truth. 
    People were not less productive working from home; 
    in fact, many got more work done. What gives? 
    Well, subtract an hour of commute each way. 
    Subtract another hour spent walking to grab coffee, snacks, and lunch.
    Remove an hour here or there for all the collaboration that happened around the ping pong table or Xbox. 
    Take out the stand-ups, check-ins, and meetings spent on chit-chat and vague ideas which, ya know, could have been an email.")
)

slide(num_m,
    h1("Decision slide"),
    row(class = "flex-center", img(src = "$folder/img/samplepic.jpg")),
    row(class = "flex-center", cell(class = "col-2",
    select(choice[:m_id], options = possible_choices.sym); size = 2
    )),
)

slide(num_m,
    h1("Plot slide"),
row(class = "q-col-gutter-sm", [
cell([
    plot(plot1data.sym, layout = plotlayout.sym, config = plotconfig.sym)]),
cell([
    plot(plot2data.sym, layout = plotlayout.sym, config = plotconfig.sym)])
]),
row(class = "flex-center",
    [radio("Scatter plot", show_bar.sym, val = 0),
    radio("Bar plot", show_bar.sym, val = 1),
    ]),
)

end
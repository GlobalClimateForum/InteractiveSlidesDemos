function gen_content(team_id::Int, pmodel::PresentationModel, init::Bool)
slides = Slide[]
####### custom code goes below ######

pd(name) = PlotData(
    x = 1:12,
    y = (1:12)/5,
    name = name,
    plot = "scatter",
)

teamsdata = [pd(string("Dummy Team ", t_id)) for t_id in 1:num_teams]

show_bar = @new_field!("Bool", init_val = 1)
plot1data = @new_field!("VectorPlotData", init_val = teamsdata)
plot2data = @new_field!("VectorPlotData", init_val = deepcopy(teamsdata))
plotconfig = @new_field!("PlotConfig")
plotlayout = @new_field!("PlotLayout")
choice = @new_multi_field!("Vector", init_val = ["Nothing"])
possible_choices = @new_field!("Vector", init_val = ["Nothing", "Increase", "Decrease", "Sine"])

if init #Handlers
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

for t_id in 1:num_teams
    new_handler(choice[t_id]) do choice
        y = plot1data.ref[t_id].y
        x = 1:12
        if choice == ["Increase"]
            y += x./12
        elseif choice == ["Decrease"]
            y -= x./12
        elseif choice == ["Sine"]
            y += sin.(x.*pi./6)
        end
        plot2data.ref[t_id].y = y
        notify(plot2data.ref)
    end
end
end

@titleslide(
"""<h1>Hello team $team_id</h1> 
   <p>You can directly write html strings, though generally it is recommended 
   to use the functions supplied by Genie, Stipple and StippleUI (see code for the other slides).</p>""", 
)

@slide(
    h1("Decision time"),
    row(class = "flex-center", img(src = "$folder/img/samplepic.jpg")),
    row(class = "flex-center", cell(class = "col-2",
    select(choice[team_id].sym, options = possible_choices.sym); size = 2
    )),
)

@slide(
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

auxUI = [quasar(:header, quasar(:toolbar, navcontrols(team_id))),
        quasar(:footer, [quasar(:separator), quasar(:toolbar, 
        [space(), slide_id(team_id)])], iftitleslide(slides, team_id)),
        menu_slides(slides, team_id, (id, title) -> string(id) * ": " * title)]

return slides, auxUI
end
function gen_content(pmodel::PresentationModel, params::Dict)
slides = Slide[]
num_teams = pmodel.num_teams[]
team_id = params[:team_id]::Int
####### custom code goes below ######

pd(name) = PlotData(
    x = 1:12,
    y = ones(12),
    name = name,
    plot = "bar",
)

teamsdata = [pd(string("Dummy Team ", t_id)) for t_id in 1:num_teams]

plotdata = @use_field!("VectorPlotData", init_val = deepcopy(teamsdata))
plotconfig = @use_field!("PlotConfig")
plotlayout = @use_field!("PlotLayout", init_val = PlotLayout(font = Font("Helvetica, sans-serif", 40, "rgb(31, 31, 31)"), 
    legend = PlotLayoutLegend(orientation = "h", xanchor = "center", y= 1.3, x= 0.5))) #better on small screens
choice = @use_fields!("Vector", init_val = ["No change"])
possible_choices = @use_field!("Vector", init_val = ["No change", "Increase", "Decrease", "Sine"])

if params[:init]
pmodel.timer[] = 100
for t_id in 1:num_teams #Handlers
    new_handler(choice[t_id]) do choice
        y = teamsdata[t_id].y
        x = 1:12
        if choice == ["Increase"]
            y = x./12
        elseif choice == ["Decrease"]
            y = 1 .- (x./12)
        elseif choice == ["Sine"]
            y = sin.(x.*pi./6)
        end
        plotdata.ref[t_id].y = y
        notify(plotdata.ref)
    end
end
end

@titleslide(
"""<h1>Hello team $team_id</h1> 
   <p>This is a short example. For more examples for what you can do, include "longer_slideshow.jl" in InteractiveSlides.jl.</p>""", 
) 
#As you can see above, you can directly write html strings (which may be useful for using code generated by GenieBuilder e.g.)
#However, InteractiveSlides does not parse strings (as opposed to GenieBuilder), and it thus often may be preferable/necessary to use the functions supplied by Genie, Stipple and StippleUI (see code below).

@slide(
    h1("Decision time"),
    row(class = "flex-center", img(src = "img/choice.png")),
    row(class = "flex-center", cell(class = "col-2",
    select(choice[team_id].sym, options = possible_choices.sym); size = 2)),
    h2("Good choice!", @appear_on(2)),
    num_states = 2
)

@slide(
    h1("Results"),
    row(class = "flex-center", p("Each team's bar plot depends on the choice the team made in the previous slide.")),
    plot(plotdata.sym, layout = plotlayout.sym, config = plotconfig.sym),
    params[:is_controller] ? row(p("Here's some info which can only be seen by the controller (speaker). 
                                    This view can be accessed e.g. by passing ?ctrl=1 as an URL parameter"), style = "color:red") : "",
)

timertext = """timer > 60 ? Math.round(timer/60) + ":" + (timer%60 > 9 ? timer%60 : "0" + timer%60) : timer"""

auxUI = [quasar(:header, quasar(:toolbar, [navcontrols(params)..., space(), span("", @text(timertext))])),
        quasar(:footer, [quasar(:separator), quasar(:toolbar, 
        [space(), slide_id(params)])], iftitleslide(slides, params)),
        menu_slides(slides, params, (id, title) -> string(id) * ": " * title)]

return slides, auxUI
end
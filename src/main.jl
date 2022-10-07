function main(pmodel::PresentationModel, params::Dict, slides::Vector{Slide})
num_teams = pmodel.num_teams[]::Int

#Fields and handlers for interactive slides (which come later, see below)
#region
feedback = @use_field!("String", init_val = "")
team_ids = collect(1:num_teams)

event1_choices = @use_fields!("String", init_val = "moderate")
event2_choices = @use_fields!("Bool", init_val = false)
investment_choices = @use_fields!("Vector", init_val = [])
available_invest_choices = ["Investment A", "Investment B", "Investment C"]
available_invest_choices_field = @use_field!("Vector", init_val = available_invest_choices)
row_names = OrderedDict(:Choices => append!(["Event 1", "Event 2"], available_invest_choices))
df = DataFrame(;merge(row_names,OrderedDict((Symbol("Team $t_id")=>["", "", "", "", ""] for t_id = team_ids)...))...)
choices_table = @use_field!("DataTable", init_val = DataTable(df))

data = Dict{String, Vector{Float64}}("little" => [17.85, 13.76], "moderate" => [24.8, 20.59], "high" => [33.02, 28.67])
plotdata = @use_field!("VectorPlotData", 
                    init_val = [PlotData(x = team_ids, y = zeros(num_teams), plot = "bar", text = ["", "", "", ""], textposition = "outside")])
plotconfig = @use_field!("PlotConfig")
plotlayout = @use_field!("PlotLayout", init_val = PlotLayout(
    height = 600,
    font = Font("Helvetica, sans-serif", 40, "rgb(31, 31, 31)"),
    yaxis = [PlotLayoutAxis(tickprefix = "+", xy = "y", range = [0.0, 38.0], nticks = 4)],
    xaxis = [PlotLayoutAxis(tickvals = team_ids, tickangle = 0, automargin = true;
            ticktext = ["Team $t_id" for t_id in team_ids])],
))

function handler_helper(t_id)
    yval = data[event1_choices[t_id].ref[]][Int(event2_choices[t_id].ref[])+1]
    plotdata.ref[1].y[t_id] = yval
    plotdata.ref[1].text[t_id] = "+" * string(round(Int, yval))
    xticktext = num_teams > 2 ? "Team $t_id<br>$(choices_table.ref.data[!, t_id+1][1])<br>$(choices_table.ref.data[!, t_id+1][2])" : "Team $t_id"
    plotlayout.ref.xaxis[1].ticktext[t_id] = xticktext
    plotlayout.ref.yaxis[1].range[2] = max(plotdata.ref[1].y...) + 5 #https://github.com/plotly/plotly.js/issues/2001
    notify(choices_table.ref)
    notify(plotdata.ref)
    notify(plotlayout.ref)
end

if params[:init] #Handlers
for t_id in team_ids
    new_handler(@getslidefield(t_id)) do id
        if id == pmodel.num_slides[]
            try mkdir("out") catch end
            time = Dates.format(Dates.now(), "yy-mm-dd at HH:MM")
            open("out/feedback $time.html", "w") do io
                write(io, feedback.ref[])
            end
            CSV.write("out/choices $time.csv", choices_table.ref[].data)
        end
    end
    new_handler(event1_choices[t_id]) do choice
        choices_table.ref.data[!, t_id+1][1] = choice
        handler_helper(t_id)
    end
    new_handler(event2_choices[t_id]) do choice
        choices_table.ref.data[!, t_id+1][2] = choice ? "yes" : "no"
        handler_helper(t_id)
    end
    new_handler(investment_choices[t_id]) do choices
        if length(choices) == 2
            choices_bool = contains.(available_invest_choices, choices[1]) .|| contains.(available_invest_choices, choices[2])
            choices_table.ref.data[!, t_id+1][3:5] = [choice ? "✓" : "" for choice in choices_bool]
        end
        notify(choices_table.ref)
    end
end
end
#endregion


#Slides
#region
@titleslide(
    h1("So what about interactivity?"),
)

team_id = params[:team_id]::Int
@slide(
    h1("Choose wisely!"), 
    spacer("2vw"),
    row_c([span("Event 1: "), radio("little", event1_choices[team_id].sym, val = "little"),
    radio("moderate", event1_choices[team_id].sym, val = "moderate"),
    radio("high", event1_choices[team_id].sym, val = "high")]),
    row_c(
    [span("Event 2:"), toggle("Yes?", event2_choices[team_id].sym),
    ]),
    spacer("2vw"),
    row_c(p("Investments (pick 2):")), 
    row_c(cell(select(investment_choices[team_id].sym, options = available_invest_choices_field.sym, 
    multiple = true, maxvalues = 2, inputclass = "flex-center", label = "Pick 2"), size = 8))
)

@slide(
    h1("Overview of choices of teams"), 
    spacer("2vw"),
    row_c(
        cell(table(choices_table.sym, hide__bottom = true); size = 10 - (4 - num_teams)))
)

content = [cell(plot(plotdata.sym, layout = plotlayout.sym, config = plotconfig.sym); size = 11 - 2 * (4 - num_teams)), 
            cell(p("(Some more info)"), size = 2)]

team_description(t_id) = p(["Team $t_id:<br>", span("", @text("$(event1_choices[t_id].str)")), "<br>", span("", @text("$(event2_choices[t_id].str)"))],
                            style = "font-size:0.8rem")

if num_teams < 3
    pushfirst!(content, cell([team_description(1), team_description(2)], size = 2))
end

@slide(
    h1("Events - Outcomes"), 
    spacer("2vw"),
    row(class = "text-center",
        h2("Data (units: potatoes)", style = "margin-bottom:-100px; z-index:1")),
    row_c(content),
    params[:is_controller] ? row(p("Here's some info which can only be seen by the controller (speaker). 
    This view can be accessed e.g. by passing ?ctrl=1 as an URL parameter"), style = "color:red") : "",
)

@slide(
    h2("Feedback"),
    spacer("1vw"),
    editor(feedback.sym, minheight="50vh", style = "width:90%; margin:auto"),
)

@slide(
    h2("""Thaanks (your input has been saved in folder "out")!""", class = "absolute-center"), 
title = "Thanks"
)
#endregion

return slides
end
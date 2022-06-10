[
cell(class = "q-gutter-sm",
    [radio("Scatter plot", :show_bar, val = 0),
    radio("Bar plot", :show_bar, val = "true"),
    btn("Show plot", color = "secondary", @click("current_id++"))]),
[
cell([
    plot(:data, layout = :layout, config = :config)]), 
cell([
    plot(:data, layout = :layout, config = :config)])]
]
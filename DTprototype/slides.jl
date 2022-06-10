[
    h1("Title slide"),
[
    h1("Plot slide"),
row(class = "q-col-gutter-sm", [
cell([
    plot(:data, layout = :layout, config = :config)]), 
cell([
    plot(:data, layout = :layout, config = :config)])
]),
row(class = "q-gutter-sm",
    [radio("Scatter plot", :show_bar, val = 0),
    radio("Bar plot", :show_bar, val = "true"),
    ]),
]
]
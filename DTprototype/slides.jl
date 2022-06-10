[
    h1("Title slide"),
[
    h1("Decision slide"),
    row(class = "flex-center",
    select(:changename, options= :changenames, label="Add this to the data")
    ),
],
[
    h1("Plot slide"),
row(class = "q-col-gutter-sm", [
cell([
    plot(:data, layout = :layout, config = :config)]), 
cell([
    plot(:data2, layout = :layout, config = :config)])
]),
row(class = "flex-center",
    [radio("Scatter plot", :show_bar, val = 0),
    radio("Bar plot", :show_bar, val = "true"),
    ]),
]
]
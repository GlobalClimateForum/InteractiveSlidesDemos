[
row(
    [cell(class = "q-gutter-xs", [
    plot(:data, layout = :layout, config = :config)]), cell(class = "q-gutter-xs", [
        plot(:data, layout = :layout, config = :config)])], @iif(:show_plot)
)
row(
    cell(class = "q-gutter-xs", 
    [radio("Scatter plot", :show_bar, val = 0),
    radio("Bar plot", :show_bar, val = "true"),
    btn("Show plot", color = "secondary", @click("show_plot = true"))]),@els(:show_plot)
)]
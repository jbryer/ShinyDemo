library(shiny)
library(ShinyDemo)

data("mtcars")
data("faithful")

data_frames <- list(mtcars = mtcars,
					faithful = faithful)

# When running server and UI code that exists in a package, the function environment will not
# be a child of this environment so will not see the variables defined here.
ui <- ShinyDemo::df_viewer_ui
environment(ui) <- environment()
server <- ShinyDemo::df_viewer_server
environment(server) <- environment()

shinyApp(ui = ui, server = server)

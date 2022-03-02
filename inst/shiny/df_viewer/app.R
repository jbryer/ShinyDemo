library(shiny)
library(ShinyDemo)

shinyApp(ui = ShinyDemo::df_viewer_ui, 
         server = ShinyDemo::df_viewer_server)

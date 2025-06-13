#' Shiny UI for data frame viewer application
#' 
#' @rdname dfviewer
#' @export
#' @importFrom DT DTOutput
df_viewer_ui <- shiny::fluidPage(
	shiny::titlePanel("Data Frame Viewer"),
	shiny::uiOutput('df_select'),
	shiny::tabsetPanel(
		shiny::tabPanel(
			'Structure',
			shiny::verbatimTextOutput('df_structure')
		),
		shiny::tabPanel(
			'Table',
			DT::DTOutput('df_table')
		)
	)
)

#' Shiny Server for Data Frame Viewer
#'
#' This is a simple Shiny application to demonstrate the [runAppWithParams()] function. This will
#' display the structure and contents of any data frames listed in the `data_frames` list object.
#' 
#' @param input input object from Shiny.
#' @param output output object from Shiny.
#' @param session session object from Shiny.
#' @rdname dfviewer
#' @importFrom DT renderDT
#' @export
#' @examples
#' if (interactive()) { # Only run this example in interactive R sessions
#' data(mtcars)
#' data(faithful)
#' runAppWithParams(ui = ShinyDemo::df_viewer_ui,
#'                  server = ShinyDemo::df_viewer_server,
#'                  data_frames = list(mtcars = mtcars, faithful = faithful),
#'                  port = 2112)
#' }
df_viewer_server <- function(input, output, session) {
	get_data_frames <- reactive({
		get_shiny_parameter(param = 'data_frames', type_check = is.list)
	})
	
	get_data <- shiny::reactive({
		shiny::req(input$dataframe)
		data_frames <- get_data_frames()
		df <- NULL
		if(input$dataframe %in% names(data_frames)) {
			df <- data_frames[[input$dataframe]]
		}
		return(df)
	})
	
	output$df_select <- shiny::renderUI({
		data_frames <- get_data_frames()
		shiny::selectInput('dataframe', 'Select Data Frame', choices = names(data_frames))
	})
	
	output$df_structure <- shiny::renderPrint({
		df <- get_data()
		str(df)
	})
	
	output$df_table <- DT::renderDT({
		df <- get_data()
		return(df)
	})
}


#' Shiny UI for Data Frame Viewer
#' 
#' @export
df_viewer_ui <- function() {
	fluidPage(
		titlePanel("Data Frame Viewer"),
		uiOutput('df_select'),
		tabsetPanel(
			tabPanel(
				'Structure',
				verbatimTextOutput('df_structure')
			),
			tabPanel(
				'Table',
				dataTableOutput('df_table')
			),
			tabPanel(
				'Vignette',
				htmlOutput('vignette')
			)
		)
	)
}

#' Shiny Server for Data Frame Viewer
#' 
#' @param input input object from Shiny.
#' @param output output object from Shiny.
#' @param session session object from Shiny.
#' @export
df_viewer_server <- function(input, output, session) {
	get_data <- reactive({
		req(input$dataframe)
		df <- NULL
		if(exists(input$dataframe)) {
			df <- get(input$dataframe)
		}
		return(df)
	})
	
	output$df_select <- renderUI({
		ls_out <- ls_all()
		dfs <- character()
		for(i in ls_out) {
			if(is.data.frame(get(i))) {
				dfs <- c(dfs, i)
			}
		}
		if(length(dfs) > 0) {
			selectInput('dataframe', 'Select Data Frame', choices = dfs)
		} else {
			p('No data.frames found!')
		}
	})
	
	output$df_structure <- renderPrint({
		df <- get_data()
		str(df)
	})
	
	output$df_table <- renderDataTable({
		df <- get_data()
		return(df)
	})
	
	output$vignette <- renderVignette(topic = 'ShinyDemo', 
									  package = 'ShinyDemo', 
									  quiet = FALSE)
	
}

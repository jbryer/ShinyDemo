server <- function(input, output) {
	output$global_environment <- renderPrint({
		ls_all()
	})
	
	output$param_value <- renderText({
		if(exists('param')) {
			return(get('param'))
		} else {
			return('param variable value not available.')
		}
	})
}

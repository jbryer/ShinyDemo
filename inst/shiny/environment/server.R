function(input, output) {
	output$global_environment <- renderPrint(as.list(.GlobalEnv))
}

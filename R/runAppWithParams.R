#' This is a wrapper to shiny::runApp to include parameters.
#'
#' This function will run a Shiny app but will pass arbitrary parameters
#' (`NAME = VALUE`) through the `...` parameter to the application. This
#' is done by modifying the Shiny UI and server function environments.
#' 
#' @rdname runAppWithParams
#' @param ui the Shiny ui object.
#' @param server the Shiny server object.
#' @param ... [shiny::runApp()] parameters, [shiny::shinyApp()] parameters,
#'        or parameters to pass to the Shiny app.
#' @export
#' @examples
#' if (interactive()) { # Only run this example in interactive R sessions
#' library(ShinyDemo)
#' data(mtcars)
#' data(faithful)
#' runAppWithParams(ui = ShinyDemo::df_viewer_ui,
#'                  server = ShinyDemo::df_viewer_server,
#'                  data_frames = list(mtcars = mtcars, faithful = faithful),
#'                  port = 2112)
#' }
runAppWithParams <- function(ui, server, ...) {
	if(missing(ui) | missing(server)) {
		stop("Must set ui and server parameters.")
	}
	
	params <- list(...)
	shinyApp_args <- list()
	runApp_args <- list()
	
	if(length(params) > 0) {
		runApp_params <- names(formals(shiny::runApp))
		shinyApp_params <- names(formals(shiny::shinyApp))
		
		runApp_args <- params[names(params) %in% runApp_params]
		shinyApp_args <- params[names(params) %in% shinyApp_params]
		app_args <- params[!names(params) %in% c(runApp_params, shinyApp_params)]
		
		# Assign ... arguments to the sever and ui environments
		app_env <- new.env()
		for(i in names(app_args)) {
			assign(i, app_args[[i]], app_env)
		}
		
		environment(ui) <- as.environment(app_env)
		environment(server) <- as.environment(app_env)
	}
	
	shinyApp_args$ui <- ui
	shinyApp_args$server <- server
	runApp_args$appDir <- do.call(shiny::shinyApp, shinyApp_args)
	do.call(shiny::runApp, runApp_args)
}

#' Utility function to retrieve a parameter.
#' 
#' This function will traverse up the environment tree looking for the given parameter. Optionally,
#' if `type_check` is set to an `is.` type function (e.g. `is.numeric`, `is.list`, etc.) it will
#' check the object type. If the object is not found or the type doesn't match it will throw an
#' error.
#' 
#' @param param the parameter name.
#' @param type_check an `is.` function (e.g. `is.numeric`) to test the parameter type.
#' @rdname runAppWithParams
#' @export
get_shiny_parameter <- function(param, type_check) {
	env <- parent.frame()
	obj_exists <- exists(param, envir = env)
	while(!obj_exists & !identical(env, globalenv())) {
		env <- parent.env(env)
		obj_exists <- exists(param, envir = env)
	}
	if(exists(param, envir = env)) {
		obj <- get(param, envir = env)
		if(!missing(type_check)) {
			if(!type_check(obj)) {
				stop(paste0(param, ' parameter is not the expected type.'))
			}
		}
		return(obj)
	} else {
		stop(paste0(param, ' parameter not found. Please pass to runAppWithParams or set in global.R'))
	}
}

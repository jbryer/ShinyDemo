#' This is a wrapper to shiny::runApp to include parameters.
#' 
#' This function will run a Shiny app but will pass arbitrary parameters
#' (NAME = VALUE) through the \code{...} parameter to the application. This
#' is done by modifying the global environment. This function will attempt
#' to clean up any objects placed into the global environment on exit. If
#' objects exist prior to calling this function (i.e. \code{exists(OBJECT)}
#' returns TRUE) then the value will be reset to it's state prior to calling
#' \code{run_shiny_app}. There are instances where objects will be in the
#' calling environment although they were were not prior to calling 
#' \code{run_shiny_app}. Objects in the base environment will return TRUE
#' from \code{exists}. For example, \code{exists('mtcars')} will always
#' return TRUE even if the dataset has not been loaded yet using 
#' \code{data(mtcars)}. As a result, if you call 
#' \code{run_shin_app(mtcars = mtcars)} \code{mtcars} will now be in the calling
#' environment. To avoid this, don't use parameter names that exist in the
#' global environment (e.g. \code{run_shiny_app(my_mtcars = mtcars)}).
#' 
#' @param appDir the directory of the application to run.
#' @param ui the Shiny ui object.
#' @param server the Shiny server object.
#' @param ... [shiny::runApp()] parameters, [shiny::shinyApp()] parameters,
#'        or parameters to pass to the Shiny app.
#' @export
run_shiny_app <- function(appDir, ui, server, ...) {
	params <- list(...)
	shinyApp_args <- list()
	runApp_args <- list()
	if(length(params) > 0) {
		reset_params <- list()
		
		runApp_params <- names(formals(shiny::runApp))
		shinyApp_params <- names(formals(shiny::shinyApp))
		
		runApp_args <- params[names(params) %in% runApp_params]
		shinyApp_args <- params[names(params) %in% shinyApp_params]
		app_args <- params[!names(params) %in% c(runApp_params, shinyApp_params)]
		
		for(i in names(app_args)) {
			if(exists(i, envir = parent.env(environment()))) {
				reset_params[[i]] <- get(i)
			}
			.GlobalEnv[[i]] <- app_args[[i]]
		}
		
		if(length(app_args) > 0) {
			on.exit({
				rm(list = names(app_args), envir = .GlobalEnv)
				for(i in names(reset_params)) {
					.GlobalEnv[[i]] <- reset_params[[i]]
				}
			})
		}
	}
	
	if(!missing(appDir)) {
		runApp_args$appDir <- appDir
		do.call(runApp, runApp_args)
	} else if(!missing(ui) & !missing(server)) {
		shinyApp_args$ui <- ui
		shinyApp_args$server <- server
		runApp_args$appDir <- do.call(shiny::shinyApp, shinyApp_args)
		do.call(shiny::runApp, runApp_args)
	} else {
		stop('Must specify appDir or ui and server.')
	}
}


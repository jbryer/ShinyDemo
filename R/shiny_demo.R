#' This is a wrapper to shiny::runApp to include parameters.
#' 
#' @param appDir the directory of the application to run.
#' @param ... [shiny::runApp] parameters or parameters to pass to the Shiny app.
#' @export
run_shiny_app <- function(appDir, ...) {
	params <- list(...)
	shiny_params <- list()
	if(length(params) > 0) {
		reset_params <- list()
		runApp_params <- names(formals(shiny::runApp))
		shiny_params <- params[names(params) %in% runApp_params]
		app_params <- params[!names(params) %in% runApp_params]
		for(i in names(app_params)) {
			if(exists(i, envir = parent.env(environment()))) {
				reset_params[[i]] <- get(i)
			}
			.GlobalEnv[[i]] <- app_params[[i]]
		}

		if(length(app_params) > 0) {
			on.exit({
				rm(list = names(app_params), envir = .GlobalEnv)
				for(i in names(reset_params)) {
					.GlobalEnv[[i]] <- reset_params[[i]]
				}
			})
		}
	}
	shiny_params$appDir <- appDir
	do.call(runApp, shiny_params)
}

#' Run a Shiny App from a Package
#' 
#' \code{shiny_demo} is a user-friendly interface to running Shiny applications 
#' from R packages. For package developers, simply put Shiny apps in the
#' \code{inst/shiny} directory in your package. This function will find any
#' apps located there in the installed package.
#' 
#' @param topic the topic/app which should be run.
#' @param package the package which contains the app to run. If \code{NULL} the 
#'   first app with the given topic name will be run.
#' @param lib.loc a character vector of directory names of R libraries, or NULL.
#'   The default value of NULL corresponds to all libraries currently known. If
#'   the default is used, the loaded packages are searched before the libraries.
#' @param verbose a logical. If TRUE, additional diagnostics are printed.
#' @param includeAllInstalled a logical. If TRUE and topic not specified, all
#'   Shiny apps from all installed packages will be listed.
#' @param ... parameters passed to [shiny::runApp] or to the Shiny app itself.
#' @author Jason Bryer (jason@bryer.org)
#' @export
shiny_demo <- function(topic, 
					   package = NULL, 
					   lib.loc = NULL, 
					   verbose = getOption("verbose"),
					   includeAllInstalled = FALSE, 
					   ...) {
	paths <- find.package(package, lib.loc, verbose = verbose)
	if(includeAllInstalled & missing(topic)) {
		installed <- installed.packages()[,'Package']
		paths <- find.package(installed, lib.loc, verbose = verbose)
	}
	
	pkgs <- basename(paths)
	
	# List available shiny demos
	shiny.apps <- data.frame()
	shiny.paths <- file.path(paths, "shiny")
	for(i in seq_along(shiny.paths)) {
		apps <- list.dirs(shiny.paths[i], recursive=FALSE, full.names=FALSE)
		if(length(apps) > 0) {
			shiny.apps <- rbind(shiny.apps, data.frame(
				package = rep(pkgs[i], length(apps)),
				app = apps,
				stringsAsFactors=FALSE
			))
		}
	}
	
	if(missing(topic)) {
		if(nrow(shiny.apps) > 0) {
			#message(shiny.apps, row.names=FALSE)
			return(shiny.apps)
		} else {
			warning('No Shiny apps found in loaded packages.')
			invisible()
		}
	} else { #Run the shiny app
		if(is.null(package)) { # find the package containing the topic
			pos <- which(shiny.apps$app == topic)
			if(length(pos) == 0) {
				stop(paste0(topic, ' app not found in a loaded package.'))
			} else if(length(pos) > 1) {
				warning(paste0(topic, ' named app found in more than one package. ',
							   'Running app from ', pkgs[pos[1]], ' package.'))
			}
			package <- shiny.apps[pos[1],]$package
		}
		message(paste0('Running ', topic, ' app from the ', package, ' package'))
		app.path <- file.path(path.package(package), 'shiny', topic)
		tryCatch({
			# shiny::runApp(app.path)
			run_shiny_app(appDir = app.path, ...)
		}, finally=print("App finished"))
		invisible()
	}
}

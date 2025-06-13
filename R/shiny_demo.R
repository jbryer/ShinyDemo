#' Find and run Shiny applications from R package
#' 
#' `shiny_demo()` is a user-friendly interface to finding and running Shiny applications 
#' from R packages. For package developers, simply put Shiny apps in thec`inst/` directory in 
#' your package. This function will find any apps located there from loaded package.
#' 
#' @rdname shiny_demo
#' @param topic the topic/app which should be run.
#' @param package the package which contains the app to run. If `NULL` the 
#'   first app with the given topic name will be run.
#' @param lib.loc a character vector of directory names of R libraries, or NULL.
#'   The default value of NULL corresponds to all libraries currently known. If
#'   the default is used, the loaded packages are searched before the libraries.
#' @param verbose a logical. If TRUE, additional diagnostics are printed.
#' @param include.installed search installed packages for Shiny applications. If `FALSE` only
#'   loaded packages will be searched.
#' @param ... parameters passed to [shiny::runApp()].
#' @return if `topic` is not specified this will return a data frame listing all the Shiny
#'   applications found.
#' @export
#' @importFrom utils str vignette
#' @importFrom shiny runApp
#' @examples
#' if(interactive()) {
#' library(ShinyDemo)
#' shiny_demo() # this should at least return the Shiny apps in this package
#' shiny_demo(topic = 'df_viewer', package = 'ShinyDemo')
#' }
shiny_demo <- function(topic, 
					   package, 
					   lib.loc = .libPaths(), 
					   verbose = getOption("verbose"),
					   include.installed = FALSE,
					   ...) {
	paths <- NULL
	if(include.installed) {
		paths <- c()
		for(i in lib.loc) {
			paths <- c(paths, list.dirs(i, recursive = FALSE))
		}
	} else {
		loaded <- search()
		loaded <- loaded[grep('^package:', loaded)]
		loaded <- sapply(strsplit(loaded, ':'), FUN = function(x) { x[2] })
		paths <- find.package(loaded)
	}
	pkgs <- basename(paths)
	
	shiny.apps <- data.frame()
	for(i in paths) {
		pkg <- basename(i)
		dirs <- list.dirs(i)
		for(j in dirs) {
			# j <- dirs[241]
			if(any(c('app.r', 'server.r', 'ui.r') %in% tolower(list.files(j)))) {
				shiny.apps <- rbind(
					shiny.apps,
					data.frame(
						package = pkg,
						app = basename(j),
						app_dir = j,
						stringsAsFactors = FALSE
					)
				)
			}
		}
	}
	
	if(missing(topic)) {
		if(nrow(shiny.apps) > 0) {
			class(shiny.apps) <- c('shinyapplist', 'data.frame')
			return(shiny.apps)
		} else {
			message('No Shiny apps found in loaded packages.')
			invisible()
		}
	} else { # Run the shiny app
		if(missing(package)) { # find the package containing the topic
			pos <- which(shiny.apps$app == topic)
			if(length(pos) == 0) {
				stop(paste0(topic, ' app not found in a ',
							ifelse(include.installed, 'installed', 'loaded'), ' package.'))
			} 
			package <- shiny.apps[pos[1],]$package
		}
		pos <- which(shiny.apps$app == topic & shiny.apps$package == package)
		if(length(pos) > 1) {
			warning(paste0(topic, ' named app found in more than one package. ',
						   'Running app from ', package, ' package.'))
		} else if(length(pos) == 0) {
			stop(paste0(topic, ' app not found in a ',
						ifelse(include.installed, 'installed', 'loaded'), ' package.'))
		}
		message(paste0('Running ', topic, ' app from the ', package, ' package'))
		app.path <- shiny.apps[pos[1],]$app_dir
		tryCatch({
			shiny::runApp(appDir = app.path, ...)
		}, finally = print("App finished"))
		invisible()
	}
}

#' Print the Shiny app name and package.
#' @param x results from [shiny_demo()].
#' @param ... other parameters passed to `print()`.
#' @rdname shiny_demo
#' @method print shinyapplist
print.shinyapplist <- function(x, ...) {
	print(as.data.frame(x[,1:2]), ...)
}

#' Render a vignette from source to include in a Shiny app.
#' 
#' This will render a vignette (currently Rmd only) to be included within
#' a Shiny app.
#'
#' @param topic	a character string giving the name of the vignette to include.
#' @param package a character vector with the names of packages to search 
#'        through, or NULL in which ‘all’ packages (as defined by argument all) 
#'        are searched
#' @param ... other parameters passed to [ShinyDemo::renderRmd()].
#' @export
renderVignette <- function(topic, package, ...) {
	if(missing(topic)) {
		stop('topic is required.')
	}
	
	v <- as.data.frame(vignette()$results)
	if(missing(package)) {
		v <- v[v$Item == topic,]
		if(nrow(v) > 1) {
			warning(paste0('More than one vignette found for ', topic, 
						   ', using the ', v[1,]$Package, ' version.'))
		}
	} else {
		v <- v[v$Item == topic & v$Package == package,]
	}
	
	if(nrow(v) == 0) {
		stop(paste0(topic, ' vignette not found.'))
	}
	
	v <- v[1,]
	package <- v[1,]$Package

	path <- find.package(package = package)
	file <- paste0(path, '/doc/', topic, '.Rmd')
	if(!file.exists(file)) {
		stop('Vignette not found')
	}

	return(renderRmd(file, ...))
}

#' Include a vignette within a Shiny app.
#' 
#' This will read in a vignette (currently HTML only) to be included within
#' a Shiny app.
#'
#' @param topic	a character string giving the name of the vignette to include.
#' @param package a character vector with the names of packages to search 
#'        through, or NULL in which all packages (as defined by argument all) 
#'        are searched
#' @export
#' @importFrom tools file_ext
#' @importFrom shiny HTML
includeVignette <- function(topic, package) {
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
	file <- paste0(path, '/doc/', topic, '.html')
	if(!file.exists(file)) {
		file <- paste0(path, '/doc/', topic, '.pdf')
		if(file.exists(file)) { # Look for a PDF
			# TODO: Would be nice to allow PDF vignettes to be embedded
			stop('PDF vignettes not supported.')
			# stop(paste0('Could not find ', topic))
		} else {
			stop('Vignette not found')
		}
	} 
	
	html <- ''
	
	if(tools::file_ext(file) == 'html') {
		html <- readLines(file)
		html <- paste0(html, collapse = '\n')
	} else if(tools::file_ext(file) == 'pdf') {
		# Eventually, maybe?!
	}
	
	tmp <- strsplit(html, "(.*<\\s*body[^>]*>)")[[1]][2]
	tmp <- strsplit(tmp, "(<\\s*/\\s*body\\s*\\>)")[[1]][1]
	
	return(shiny::HTML(html))
}

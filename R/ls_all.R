#' List All Objects
#' 
#' This function returns a character vector of all objects available. Unlike
#' [ls()] this function will loop through all environments from the current
#' environment to \code{.GlobalEnv}. This will also verify that the object
#' is indeed available from the current environment using the [exists()]
#' function call.
#' 
#' @return a character vector with the name of all objects available.
#' @export
ls_all <- function() {
	objs <- character()
	i <- 1
	repeat {
		local_objs <- ls(parent.frame(i))
		# Confirm the object is available from the current environment
		for(j in local_objs) {
			if(exists(j)) {
				objs <- c(objs, j)
			}
		}
		if(identical(parent.frame(i), .GlobalEnv)) {
			break
		} else {
			i <- i + 1
		}
	}
	return(objs)
}

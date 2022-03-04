library(devtools)
library(usethis)

# This function will cleanup the DESCRIPTION file to be tidy
usethis::use_tidy_description()

document()
install(build_vignettes = TRUE)

build()

# Run the tests
test()
# If test() detected new snapshots or changes to existing snapshots, run this to review them.
testthat::snapshot_review()

# Build and check a package 
check()


# Create a website using pkgdown
library(pkgdown)
usethis::use_pkgdown()
pkgdown::build_site()

################################################################################
# Use the package
library(ShinyDemo)

ls('package:ShinyDemo')

shiny_demo()
shiny_demo('gambler')
shiny_demo('environment', 
		   port = 2112,
		   param = 'Hello ShinyDemo!')
shiny_demo('df_viewer')
shiny_demo('df_viewer',
		   mtcars = mtcars,
		   faithful = faithful)
run_shiny_app(ui = ShinyDemo::df_viewer_ui,
			 server = ShinyDemo::df_viewer_server)
run_shiny_app(ui = ShinyDemo::df_viewer_ui,
			 server = ShinyDemo::df_viewer_server,
			 mtcars = mtcars)


################################################################################
# Setup stuff
# Add package dependencies
usethis::use_package('shiny', type = 'Imports')

# Create a test
usethis::use_test('loess-test')

# Create a vignette. This will add VignetteBuilder: knitr to the DESCRIPTION file
usethis::use_vignette("ShinyDemo")


################################################################################
# Hex logo
library(hexSticker)
library(tidyverse)

p <- 'man/figures/ShinyDemo_source.png'

hexSticker::sticker(p,
					filename = 'man/figures/ShinyDemo.png',
					p_size = 18,
					package = 'ShinyDemo',
					url = "jbryer.github.io/ShinyDemo/",
					u_size = 5,
					s_width = .5, s_height = .5,
					s_x = 1, s_y = 0.79,
					p_x = 1, p_y = 1.49,
					p_color = "#FFFFFF",
					h_fill = '#9BC9FF',
					h_color = '#1E81CE',
					white_around_sticker = FALSE)


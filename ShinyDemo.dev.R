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
		   my_mtcar = mtcars,
		   my_faithful = faithful)
run_shiny_app(ui = ShinyDemo::df_viewer_ui,
			 server = ShinyDemo::df_viewer_server)
run_shiny_app(ui = ShinyDemo::df_viewer_ui,
			 server = ShinyDemo::df_viewer_server,
			 my_mtcars = mtcars)


################################################################################
# Setup stuff
# Add package dependencies
usethis::use_package('shiny', type = 'Imports')

# Create a test
usethis::use_test('loess-test')

# Create a README file
usethis::use_readme_md()

# Create a NEWS.md file.
usethis::use_news_md()

# Setup the package to use testthat
usethis::use_testthat()

# Create a vignette. This will add VignetteBuilder: knitr to the DESCRIPTION file
usethis::use_vignette("ShinyDemo")

# Using git to track changes
usethis::use_git()

# Publish to Github
usethis::use_github()

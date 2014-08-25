setwd('~/Dropbox/Projects/ShinyDemo')

require(devtools)

document()
check_doc()
install()
build()
check()

require(ShinyDemo)
require(StatToolkit) # This package contains some Shiny apps
shiny_demo()
shiny_demo('gambler')
shiny_demo('lottery')

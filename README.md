
<!-- README.md is generated from README.Rmd. Please edit that file -->

## <img src="man/figures/ShinyDemo.png" align="right" width="200" /> ShinyDemo - Package for Running Shiny Apps Like Package Demos

<!-- badges: start -->

[![](https://www.r-pkg.org/badges/version/ShinyDemo?color=orange)](https://cran.r-project.org/package=ShinyDemo)
[![](https://img.shields.io/badge/devel%20version-0.9.1-blue.svg)](https://github.com/jbryer/ShinyDemo)
[![R build
status](https://github.com/jbryer/ShinyDemo/workflows/R-CMD-check/badge.svg)](https://github.com/jbryer/ShinyDemo/actions)
<!-- badges: end -->

#### Author: Jason Bryer (<jason@bryer.org>)

#### Website: <http://jbryer.github.io/ShinyDemo/>

This package is designed to run Shiny apps included in packages in the
inst/shiny/ directory. In addition to providing a standardized way of
running apps within packages, it extends the typical process of running
Shiny apps by allowing function parameters to be passed to the
application. Utility functions for the developer are provided to safely
check for parameter values and to retrieve defaults if the application
is run outside of the package.

#### Installation

The latest version of the `ShinyDemo` package can be installed using the
\`remotes\`\` package.

``` r
remotes::install_github('jbryer/ShinyDemo')
```

For package developers, simply include your Shiny apps in the
`inst/shiny` directory within your R package. The
`ShinyDemo::shiny_demo()` function will automatically find those apps.

``` r
library('ShinyDemo')
data("mtcars"); data("faithful")
runAppWithParams(ui = ShinyDemo::df_viewer_ui,
                 server = ShinyDemo::df_viewer_server,
                 data_frames = list(mtcars = mtcars, faithful = faithful),
                 port = 2112)
```

#### Development

``` r
# Generate the package documentation
usethis::use_tidy_description()
devtools::document()
# Install the package
devtools::install()
# Run CRAN check
devtools::check(cran = TRUE)
```

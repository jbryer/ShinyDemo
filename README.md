## ShinyDemo - Package for Running Shiny Apps Like Package Demos

<img src="man/figures/ShinyDemo.png" align="right" width="120" />

#### Authors: Jason Bryer ([jason@bryer.org](mailto:jason@bryer.org))   
#### Website: http://jbryer.github.io/ShinyDemo/

This package is designed to run Shiny apps included in packages in the inst/shiny/ directory. In addition to providing a standardized way of running apps within packages, it extends the typical process of running Shiny apps by allowing function parameters to be passed to the application. Utility functions for the developer are provided to safely check for parameter values and to retrieve defaults if the application is run outside of the package.

#### Installation

The latest version of the `ShinyDemo` package can be installed using the `devtools` package.

```
devtools::install_github('jbryer/ShinyDemo')
```

For package developers, simply include your Shiny apps in the `inst/shiny` directory within your R package. The `ShinyDemo::shiny_demo()` function will automatically find those apps.

```
library('ShinyDemo')
shiny_demo()
shiny_demo('df_viewer',
           mtcars = mtcars,
           faithful = faithful)
```


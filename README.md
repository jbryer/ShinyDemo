## ShinyDemo - Package for Running Shiny Apps Like Package Demos

<img src="man/figures/ShinyDemo.png" align="right" width="120" />

#### Authors: Jason Bryer ([jason@bryer.org](mailto:jason@bryer.org))

#### Installation

The latest version of the `ShinyDemo` package can be installed using the `devtools` package.

```
devtools::install_github('jbryer/ShinyDemo')
```

For package developers, simply include your Shiny apps in the `inst/shiny` directory within your R package. The `ShinyDemo::shiny_demo()` function will automatically find those apps.

```
library('ShinyDemo')
shiny_demo()
shiny_demo('gambler')
```


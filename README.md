
<!-- README.md is generated from README.Rmd. Please edit that file -->

# connector.sharepoint <a href="https://novonordisk-opensource.github.io/connector.sharepoint"><img src="man/figures/logo.png" align="right" height="138" alt="connector.sharepoint website" /></a>

<!-- badges: start -->

[![R-CMD-check](https://github.com/novonordisk-OpenSource/connector.sharepoint/actions/workflows/check_and_co.yaml/badge.svg)](https://github.com/novonordisk-OpenSource/connector.sharepoint/actions/workflows/check_and_co.yaml)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/connector.sharepoint)](https://CRAN.R-project.org/package=connector.sharepoint)
<!-- badges: end -->

The connector.sharepoint package provides a convenient interface for
accessing and interacting with Microsoft SharePoint sites directly from
R. This vignette will guide you through the process of connecting to a
SharePoint site, retrieving data, and performing various operations
using this package.

This package is meant to be used with
[connector](%22https://github.com/novonordisk-OpenSource/connector%22)
package, which provides a common interface for interacting with various
data sources. The connector.sharepoint package extends the connector
package to support Microsoft SharePoint sites.

## Installation

You can install the connector.sharepoint package using the following
command:

``` r
# Install from CRAN
install.packages("connector.sharepoint")

# Alternatively, you can install the development version from GitHub:
devtools::install_github("novonordisk-OpenSource/connector.sharepoint")
```

## Usage

Package is meant to be used alongside connector package, but it can be
used independently as well. Here is an example of how to connect to a
SharePoint site and retrieve data:

``` r
library(connector.sharepoint)

# Connect to SharePoint
con <- ConnectorSharepoint(site_url = "sharepoint_url")
```

When connecting to SharePoint, you need to provide the URL of the
SharePoint site. By default, token is retrieved from the
[AzureAuth](%22https://github.com/Azure/AzureAuth%22) package using
`get_token()` function, or it can be provided by the user, and it is
used to authenticate the user to the SharePoint site.

Example of how to use the connector object:

``` r
# List content
con |>
  list_content_cnt()

# Write a file
con |>
  write_cnt(iris, "iris.rds")

# Read a file
con |>
  read_cnt("iris.rds") |>
  head()

# Remove a file
con |>
  remove_cnt("file_name.csv")
```

## Usage with connector package

Here is an example how it can be used with connector package and
configuration YAML file (for more information take a look at the
connector package):

``` r
# Connect using configuration file
yaml <- yaml::read_yaml(system.file("config", "example_yaml.yaml", package = "connector.sharepoint"), eval.expr = TRUE)

connector <- connector::connect(yaml)

# List content
connector$test |>
  list_content_cnt()

# Get SharePoint connection object
connector$test |>
  get_conn()

# Write a file
connector$test |>
  write_cnt(iris, "Test/iris.csv")

# Read a file
connector$test |>
  read_cnt("Test/iris.csv")
```

## Contributing

We welcome contributions to the connector.sharepoint package. If you
have any suggestions or find any issues, please open an issue or submit
a pull request on GitHub.

## License

This package is licensed under the Apache License.


<!-- README.md is generated from README.Rmd. Please edit that file -->

# connector.sharepoint <a href="https://nn-opensource.github.io/connector.sharepoint"><img src="man/figures/logo.png" align="right" height="138" alt="connector.sharepoint website" /></a>

<!-- badges: start -->

[![R-CMD-check](https://github.com/NN-OpenSource/connector.sharepoint/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/NN-OpenSource/connector.sharepoint/actions/workflows/R-CMD-check.yaml)
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
[connector](%22https://github.com/NN-OpenSource/connector%22) package,
which provides a common interface for interacting with various data
sources. The connector.sharepoint package extends the connector package
to support Microsoft SharePoint sites.

## Installation

You can install the connector.sharepoint package using the following
command:

``` r
# Install from CRAN
install.packages("connector.sharepoint")

# Alternatively, you can install the development version from GitHub:
devtools::install_github("NovoNordisk-OpenSource/connector.sharepoint")
```

## Usage

<<<<<<< HEAD
Package is meant to be used alongside connector package, but it can be
used independently as well. Here is an example of how to connect to a
SharePoint site and retrieve data:

``` r
library(connector.sharepoint)

# Connect to SharePoint
con <- connector_sharepoint(site_url = "sharepoint_url")
=======
From the yaml file and with the connector package:

``` r
# Connect
yaml <- yaml::read_yaml(system.file("config", "example_yaml.yaml", package = "connector.sharepoint"), eval.expr=TRUE)

connector <- connector::connect(yaml)
#> ℹ Using generic backend connection for con: test
#> ✖ No SHAREPOINT_AZURE_HASH env found, trying to find a .active_hash file
#> ℹ Active hash file found, using it to get the hash.
#> Access token has expired or is no longer valid; refreshing

connector$test$list_content_cnt()
#>    name size isdir                                 id
#> 1  Test 3716  TRUE 01I7W5MXW5FNKFSSCDCFHY6VDTIXYOTQ2M
#> 2 test2    0  TRUE 01I7W5MXTR2VLMIO2CJ5FK3BSIW3IF4YPP
connector$test$get_conn()
#> <Document library 'Documents'>
#>   directory id: b!6QoHXTqvDEeYRghQ-UXpoXVuMqn50sZJn7epArNtqIUJDREOivAlTKJXanJ6ONkN 
#>   web link: https://novonordisk.sharepoint.com/sites/sharepoint_connector_testing/Shared%20Documents 
#>   description:  
#> ---
#>   Methods:
#>     copy_item, create_folder, create_share_link, delete,
#>     delete_item, do_operation, download_file, download_folder,
#>     get_item, get_item_properties, get_list_pager, list_files,
#>     list_items, list_shared_files, list_shared_items,
#>     load_dataframe, load_rdata, load_rds, move_item, open_item,
#>     save_dataframe, save_rdata, save_rds, set_item_properties,
#>     sync_fields, update, upload_file, upload_folder
connector$test$write_cnt(iris, "Test/iris.csv")
#> [1] TRUE
connector$test$read_cnt("Test/iris.csv")
#> Rows: 150 Columns: 5
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: ","
#> chr (1): Species
#> dbl (4): Sepal.Length, Sepal.Width, Petal.Length, Petal.Width
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
#> # A tibble: 150 × 5
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#>           <dbl>       <dbl>        <dbl>       <dbl> <chr>  
#>  1          5.1         3.5          1.4         0.2 setosa 
#>  2          4.9         3            1.4         0.2 setosa 
#>  3          4.7         3.2          1.3         0.2 setosa 
#>  4          4.6         3.1          1.5         0.2 setosa 
#>  5          5           3.6          1.4         0.2 setosa 
#>  6          5.4         3.9          1.7         0.4 setosa 
#>  7          4.6         3.4          1.4         0.3 setosa 
#>  8          5           3.4          1.5         0.2 setosa 
#>  9          4.4         2.9          1.4         0.2 setosa 
#> 10          4.9         3.1          1.5         0.1 setosa 
#> # ℹ 140 more rows
>>>>>>> origin/main
```

When connecting to SharePoint, you need to provide the URL of the
SharePoint site. By default, token is retrieved from the
[AzureAuth](%22https://github.com/Azure/AzureAuth%22) package using
`get_token()` function, or it can be provided by the user, and it is
used to authenticate the user to the SharePoint site.

Example of how to use the connector object:

``` r
# List content
con$cnt_list_content()

# Write a file
con$cnt_write(iris, "iris.rds")

# Read a file
con$cnt_read("iris.rds") |> 
  head()

# Remove a file
con$cnt_remove("file_name.csv")
```

## Contributing

We welcome contributions to the connector.sharepoint package. If you
have any suggestions or find any issues, please open an issue or submit
a pull request on GitHub.

## License

This package is licensed under the MIT License.

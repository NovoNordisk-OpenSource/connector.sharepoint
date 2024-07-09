
<!-- README.md is generated from README.Rmd. Please edit that file -->

# connector.sharepoint

<!-- badges: start -->

[![R-CMD-check](https://github.com/NN-OpenSource/connector.sharepoint/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/NN-OpenSource/connector.sharepoint/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of connector.sharepoint is to provide a way to interact with
Sharepoint, adding the ability to list, read, write, download, upload,
create directories and remove files.

## Installation

From our GitHub repository:

``` r
# install.packages("remotes")
remotes::install_github("NN-OpenSource/connector.sharepoint")
```

## Example

From the yaml file and witt the connector package:

``` r
# Connect
yaml <- connector::read_yaml_config(system.file("config", "example_yaml.yaml", package = "connector.sharepoint"))

connector <- connector::connect_from_yaml(yaml)
#> ℹ Using generic backend connection for con: myteam
#> Access token has expired or is no longer valid; refreshing

connector$myteam$list_content()
#>       name  size isdir                                 id
#> 1     Test 22280  TRUE 01H53SEMJQ3OG6ZMVEYJEJUXJPMDVUXBIO
#> 2 test.txt     5 FALSE 01H53SEMJT2O2SHKH7TFFZBEOOICYHIULR
#> 3 text.txt     5 FALSE 01H53SEMMRRBS3XUFNVNCKSKQDAVDT7S6G
connector$myteam$get_conn()
#> <Document library 'Documents'>
#>   directory id: b!4XSDULnNSEaPtuvwNAynpgqSUZUCDotCpwEoBpedVQngFq3uivaKQYe8kJ2vZkpI 
#>   web link: https://myorg.sharepoint.com/sites/Document-Storage/Shared%20Documents 
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
connector$myteam$read("Test/iris.csv")
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
```

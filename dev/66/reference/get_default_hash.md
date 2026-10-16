# Get the default hash

Two solutions are possible:

1.  The user has set the environment variable SHAREPOINT_AZURE_HASH

2.  The user has set the file .active_hash in the AzureR directory

## Usage

``` r
get_default_hash()
```

## Value

A character string with the token hash, or `NULL` if not found

## Examples

``` r
if (FALSE) { # \dontrun{
hash <- get_default_hash()
} # }
```

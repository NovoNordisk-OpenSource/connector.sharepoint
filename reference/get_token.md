# Retrieve a token from the AzureAuth package

Retrieve a token from the AzureAuth package

## Usage

``` r
get_token(hash = get_default_hash())
```

## Arguments

- hash:

  The hash of the token to use. By default, use this function to
  retrieve it
  [get_default_hash](https://novonordisk-opensource.github.io/connector.sharepoint/reference/get_default_hash.md).
  If not found, use the first token found. \#nolint

## Value

A token

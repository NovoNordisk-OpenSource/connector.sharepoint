# Download a directory

Addition list content methods for databricks connectors implemented for
[`connector::download_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/download_directory_cnt.html):

## Usage

``` r
download_directory_cnt(connector_object, src, dest = basename(src), ...)

# S3 method for class 'ConnectorSharepoint'
download_directory_cnt(
  connector_object,
  src,
  dest = basename(src),
  ...,
  recursive = TRUE
)
```

## Arguments

- connector_object:

  [Connector](https://novonordisk-opensource.github.io/connector/reference/Connector.html)
  The connector object to use.

- src:

  The name of the directory to download from SharePoint

- dest:

  The local directory path to save the downloaded content

- ...:

  additional paramaeters passed on to `download_folder()` method of
  [`ms_drive`](https://rdrr.io/pkg/Microsoft365R/man/ms_drive.html)
  class.

- recursive:

  If `recursive` is `TRUE`, all subfolders will also be transferred
  recursively. Default: `FALSE`

## Value

[ConnectorSharepoint](https://novonordisk-opensource.github.io/connector.sharepoint/reference/ConnectorSharepoint.md)
object

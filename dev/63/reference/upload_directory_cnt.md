# Upload a directory

Addition list content methods for sharepoint connectors implemented for
[`connector::upload_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/upload_directory_cnt.html):

## Usage

``` r
upload_directory_cnt(
  connector_object,
  src,
  dest,
  overwrite = zephyr::get_option("overwrite", "connector"),
  open = FALSE,
  ...
)

# S3 method for class 'ConnectorSharepoint'
upload_directory_cnt(
  connector_object,
  src,
  dest = basename(src),
  overwrite = zephyr::get_option("overwrite", "connector.sharepoint"),
  open = FALSE,
  ...,
  recursive = TRUE
)
```

## Arguments

- connector_object:

  [Connector](https://novonordisk-opensource.github.io/connector/reference/Connector.html)
  The connector object to use.

- src:

  The local directory path to upload

- dest:

  The destination directory name/path in SharePoint

- overwrite:

  Overwrite existing content if it exists in the connector? See
  [connector-options](https://novonordisk-opensource.github.io/connector/reference/connector-options.html)
  for details. Default can be set globally with
  `options(connector.overwrite = TRUE/FALSE)` or environment variable
  `R_CONNECTOR_OVERWRITE`.. Default: `FALSE`.

- open:

  [logical](https://rdrr.io/r/base/logical.html) Open the directory as a
  new connector object.

- ...:

  additional paramaeters passed on to `upload_folder()` method of
  [`ms_drive`](https://rdrr.io/pkg/Microsoft365R/man/ms_drive.html)
  class.

- recursive:

  If `recursive` is `TRUE`, all subfolders will also be transferred
  recursively. Default: `FALSE`

## Value

[ConnectorSharepoint](https://novonordisk-opensource.github.io/connector.sharepoint/reference/ConnectorSharepoint.md)
object

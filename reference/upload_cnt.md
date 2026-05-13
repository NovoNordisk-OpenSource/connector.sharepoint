# Upload content to the connector

Addition list content methods for databricks connectors implemented for
[`connector::upload_cnt()`](https://novonordisk-opensource.github.io/connector/reference/upload_cnt.html):

- [ConnectorSharepoint](https://novonordisk-opensource.github.io/connector.sharepoint/reference/ConnectorSharepoint.md):
  Reuses the
  [`connector::upload_cnt()`](https://novonordisk-opensource.github.io/connector/reference/upload_cnt.html)
  method for
  [`ConnectorSharepoint()`](https://novonordisk-opensource.github.io/connector.sharepoint/reference/ConnectorSharepoint.md)

## Usage

``` r
upload_cnt(
  connector_object,
  src,
  dest = basename(src),
  overwrite = zephyr::get_option("overwrite", "connector"),
  ...
)

# S3 method for class 'ConnectorSharepoint'
upload_cnt(
  connector_object,
  src,
  dest = basename(src),
  overwrite = zephyr::get_option("overwrite", "connector.sharepoint"),
  ...,
  recursive = FALSE
)
```

## Arguments

- connector_object:

  [Connector](https://novonordisk-opensource.github.io/connector/reference/Connector.html)
  The connector object to use.

- src:

  The local file path to upload

- dest:

  The destination name/path in SharePoint

- overwrite:

  Overwrite existing content if it exists in the connector? See
  [connector-options](https://novonordisk-opensource.github.io/connector/reference/connector-options.html)
  for details. Default can be set globally with
  `options(connector.overwrite = TRUE/FALSE)` or environment variable
  `R_CONNECTOR_OVERWRITE`.. Default: `FALSE`.

- ...:

  [ConnectorSharepoint](https://novonordisk-opensource.github.io/connector.sharepoint/reference/ConnectorSharepoint.md):
  Additional parameters to pass to the `upload_file()` or
  `upload_folder()` method of
  [`ms_drive`](https://rdrr.io/pkg/Microsoft365R/man/ms_drive.html)
  class.

- recursive:

  If `recursive` is TRUE, all subfolders will also be transferred
  recursively. Default: `FALSE`

## Value

[ConnectorSharepoint](https://novonordisk-opensource.github.io/connector.sharepoint/reference/ConnectorSharepoint.md)
object

# Download content from the connector

Addition list content methods for sharepoint connectors implemented for
[`connector::download_cnt()`](https://novonordisk-opensource.github.io/connector/reference/download_cnt.html):

- [ConnectorSharepoint](https://novonordisk-opensource.github.io/connector.sharepoint/reference/ConnectorSharepoint.md):
  Reuses the
  [`connector::download_cnt()`](https://novonordisk-opensource.github.io/connector/reference/download_cnt.html)
  method for
  [`ConnectorSharepoint()`](https://novonordisk-opensource.github.io/connector.sharepoint/reference/ConnectorSharepoint.md)

## Usage

``` r
download_cnt(connector_object, src, dest = basename(src), ...)

# S3 method for class 'ConnectorSharepoint'
download_cnt(connector_object, src, dest = basename(src), ...)
```

## Arguments

- connector_object:

  [Connector](https://novonordisk-opensource.github.io/connector/reference/Connector.html)
  The connector object to use.

- src:

  The name of the file to download from SharePoint

- dest:

  The local path to save the downloaded file

- ...:

  [ConnectorSharepoint](https://novonordisk-opensource.github.io/connector.sharepoint/reference/ConnectorSharepoint.md):
  Additional parameters to pass to the `download()` method of
  [`ms_drive`](https://rdrr.io/pkg/Microsoft365R/man/ms_drive.html)
  class.

## Value

[ConnectorSharepoint](https://novonordisk-opensource.github.io/connector.sharepoint/reference/ConnectorSharepoint.md)
object

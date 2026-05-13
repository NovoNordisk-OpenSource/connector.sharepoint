# List available content from the connector

Addition list content methods for databricks connectors implemented for
[`connector::list_content_cnt()`](https://novonordisk-opensource.github.io/connector/reference/list_content_cnt.html):

- [ConnectorSharepoint](https://novonordisk-opensource.github.io/connector.sharepoint/reference/ConnectorSharepoint.md):
  Reuses the
  [`connector::list_content_cnt()`](https://novonordisk-opensource.github.io/connector/reference/list_content_cnt.html)
  method for
  [`ConnectorSharepoint()`](https://novonordisk-opensource.github.io/connector.sharepoint/reference/ConnectorSharepoint.md)

## Usage

``` r
list_content_cnt(connector_object, ...)

# S3 method for class 'ConnectorSharepoint'
list_content_cnt(connector_object, ...)
```

## Arguments

- connector_object:

  [Connector](https://novonordisk-opensource.github.io/connector/reference/Connector.html)
  The connector object to use.

- ...:

  [ConnectorSharepoint](https://novonordisk-opensource.github.io/connector.sharepoint/reference/ConnectorSharepoint.md):
  Additional parameters to pass to the `list_items()` method of
  [`ms_drive`](https://rdrr.io/pkg/Microsoft365R/man/ms_drive.html)
  class.

## Value

A [character](https://rdrr.io/r/base/character.html) vector of content
names

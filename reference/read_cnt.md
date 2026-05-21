# Read content from the connector

Addition read methods for sharepoint connectors implemented for
[`connector::read_cnt()`](https://novonordisk-opensource.github.io/connector/reference/read_cnt.html):

- [ConnectorSharepoint](https://novonordisk-opensource.github.io/connector.sharepoint/reference/ConnectorSharepoint.md):
  Reuses the
  [`connector::read_cnt()`](https://novonordisk-opensource.github.io/connector/reference/read_cnt.html)
  method for
  [`ConnectorSharepoint()`](https://novonordisk-opensource.github.io/connector.sharepoint/reference/ConnectorSharepoint.md)

## Usage

``` r
read_cnt(connector_object, name, ...)

# S3 method for class 'ConnectorSharepoint'
read_cnt(connector_object, name, ...)
```

## Arguments

- connector_object:

  [Connector](https://novonordisk-opensource.github.io/connector/reference/Connector.html)
  The connector object to use.

- name:

  The name of the file to read

- ...:

  [ConnectorSharepoint](https://novonordisk-opensource.github.io/connector.sharepoint/reference/ConnectorSharepoint.md):
  Additional parameters to pass to the `get_item()` method of
  [`ms_drive`](https://rdrr.io/pkg/Microsoft365R/man/ms_drive.html)
  class

## Value

R object with the content. For rectangular data a
[data.frame](https://rdrr.io/r/base/data.frame.html).

# Remove a directory

Addition list content methods for sharepoint connectors implemented for
[`connector::remove_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/remove_directory_cnt.html):

- [ConnectorSharepoint](https://novonordisk-opensource.github.io/connector.sharepoint/reference/ConnectorSharepoint.md):
  Reuses the
  [`connector::remove_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/remove_directory_cnt.html)
  method for
  [`ConnectorSharepoint()`](https://novonordisk-opensource.github.io/connector.sharepoint/reference/ConnectorSharepoint.md)

## Usage

``` r
remove_directory_cnt(connector_object, name, ...)

# S3 method for class 'ConnectorSharepoint'
remove_directory_cnt(connector_object, name, ...)
```

## Arguments

- connector_object:

  [Connector](https://novonordisk-opensource.github.io/connector/reference/Connector.html)
  The connector object to use.

- name:

  [character](https://rdrr.io/r/base/character.html) The name of the
  directory to remove

- ...:

  [ConnectorSharepoint](https://novonordisk-opensource.github.io/connector.sharepoint/reference/ConnectorSharepoint.md):
  Additional parameters to pass to `delete()` method of
  [`ms_drive`](https://rdrr.io/pkg/Microsoft365R/man/ms_drive.html)
  class.

## Value

[ConnectorSharepoint](https://novonordisk-opensource.github.io/connector.sharepoint/reference/ConnectorSharepoint.md)
object

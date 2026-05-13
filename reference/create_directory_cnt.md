# Create a directory

Addition list content methods for databricks connectors implemented for
[`connector::create_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/create_directory_cnt.html):

- [ConnectorSharepoint](https://novonordisk-opensource.github.io/connector.sharepoint/reference/ConnectorSharepoint.md):
  Reuses the
  [`connector::create_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/create_directory_cnt.html)
  method for
  [`ConnectorSharepoint()`](https://novonordisk-opensource.github.io/connector.sharepoint/reference/ConnectorSharepoint.md)

## Usage

``` r
create_directory_cnt(connector_object, name, open = TRUE, ...)

# S3 method for class 'ConnectorSharepoint'
create_directory_cnt(connector_object, name, open = TRUE, ...)
```

## Arguments

- connector_object:

  [Connector](https://novonordisk-opensource.github.io/connector/reference/Connector.html)
  The connector object to use.

- name:

  [character](https://rdrr.io/r/base/character.html) The name of the
  directory to create

- open:

  create a new connector object

- ...:

  [ConnectorSharepoint](https://novonordisk-opensource.github.io/connector.sharepoint/reference/ConnectorSharepoint.md):
  Additional parameters to pass to `create_folder()` method of
  [`ms_drive`](https://rdrr.io/pkg/Microsoft365R/man/ms_drive.html)
  class.

## Value

[ConnectorSharepoint](https://novonordisk-opensource.github.io/connector.sharepoint/reference/ConnectorSharepoint.md)
object or
[ConnectorSharepoint](https://novonordisk-opensource.github.io/connector.sharepoint/reference/ConnectorSharepoint.md)
object of a newly built directory

# Use dplyr verbs to interact with the remote database table

Addition tbl methods for databricks connectors implemented for
[`connector::tbl_cnt()`](https://novonordisk-opensource.github.io/connector/reference/tbl_cnt.html):

- [ConnectorSharepoint](https://novonordisk-opensource.github.io/connector.sharepoint/reference/ConnectorSharepoint.md):
  Uses
  [`read_cnt()`](https://novonordisk-opensource.github.io/connector.sharepoint/reference/read_cnt.md)
  to allow redundancy.

## Usage

``` r
tbl_cnt(connector_object, name, ...)

# S3 method for class 'ConnectorSharepoint'
tbl_cnt(connector_object, name, ...)
```

## Arguments

- connector_object:

  [Connector](https://novonordisk-opensource.github.io/connector/reference/Connector.html)
  The connector object to use.

- name:

  [character](https://rdrr.io/r/base/character.html) Name of the content
  to read, write, or remove. Typically the table name.

- ...:

  Additional arguments passed to the method for the individual
  connector.

## Value

A [dplyr::tbl](https://dplyr.tidyverse.org/reference/tbl.html) object.

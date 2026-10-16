# Connector Object for Sharepoint class, built on top of [connector::Connector](https://novonordisk-opensource.github.io/connector/reference/Connector.html) class

This object is used to interact with Sharepoint, adding the ability to
list, read, write, download, upload, create directories and remove
files.

## Details

About the token, you can retrieve it by following the guideline in your
enterprise.

## Super classes

[`connector::Connector`](https://novonordisk-opensource.github.io/connector/reference/Connector.html)
-\>
[`connector::ConnectorFS`](https://novonordisk-opensource.github.io/connector/reference/ConnectorFS.html)
-\> `ConnectorSharepoint`

## Active bindings

- `folder`:

  [character](https://rdrr.io/r/base/character.html) The path of the
  folder to interact with

- `token`:

  [character](https://rdrr.io/r/base/character.html) The Azure token

- `site_url`:

  [character](https://rdrr.io/r/base/character.html) The URL of the
  Sharepoint site

- `path`:

  [character](https://rdrr.io/r/base/character.html) The whole URL path
  of the Sharepoint resource

## Methods

### Public methods

- [`ConnectorSharepoint$new()`](#method-ConnectorSharepoint-new)

- [`ConnectorSharepoint$get_conn()`](#method-ConnectorSharepoint-get_conn)

Inherited methods

- [`connector::Connector$list_content_cnt()`](https://novonordisk-opensource.github.io/connector/reference/Connector.html#method-list_content_cnt)
- [`connector::Connector$print()`](https://novonordisk-opensource.github.io/connector/reference/Connector.html#method-print)
- [`connector::Connector$read_cnt()`](https://novonordisk-opensource.github.io/connector/reference/Connector.html#method-read_cnt)
- [`connector::Connector$remove_cnt()`](https://novonordisk-opensource.github.io/connector/reference/Connector.html#method-remove_cnt)
- [`connector::Connector$write_cnt()`](https://novonordisk-opensource.github.io/connector/reference/Connector.html#method-write_cnt)
- [`connector::ConnectorFS$create_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/ConnectorFS.html#method-create_directory_cnt)
- [`connector::ConnectorFS$download_cnt()`](https://novonordisk-opensource.github.io/connector/reference/ConnectorFS.html#method-download_cnt)
- [`connector::ConnectorFS$download_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/ConnectorFS.html#method-download_directory_cnt)
- [`connector::ConnectorFS$remove_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/ConnectorFS.html#method-remove_directory_cnt)
- [`connector::ConnectorFS$tbl_cnt()`](https://novonordisk-opensource.github.io/connector/reference/ConnectorFS.html#method-tbl_cnt)
- [`connector::ConnectorFS$upload_cnt()`](https://novonordisk-opensource.github.io/connector/reference/ConnectorFS.html#method-upload_cnt)
- [`connector::ConnectorFS$upload_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/ConnectorFS.html#method-upload_directory_cnt)

------------------------------------------------------------------------

### Method `new()`

Initializes the ConnectorSharepoint class

#### Usage

    ConnectorSharepoint$new(
      site_url,
      token = get_token(),
      folder = "",
      extra_class = NULL,
      ...
    )

#### Arguments

- `site_url`:

  [character](https://rdrr.io/r/base/character.html) The URL of the
  Sharepoint site

- `token`:

  [character](https://rdrr.io/r/base/character.html) The Azure token. By
  default, it will be retrieve by
  [get_token](https://novonordisk-opensource.github.io/connector.sharepoint/reference/get_token.md)

- `folder`:

  [character](https://rdrr.io/r/base/character.html) The path of the
  folder to interact with, if you don't want to interact with the root
  folder "Documents"

- `extra_class`:

  [character](https://rdrr.io/r/base/character.html) Extra class added
  to the object.

- `...`:

  Additional parameters to pass to the
  [`get_sharepoint_site`](https://rdrr.io/pkg/Microsoft365R/man/client.html)
  function

#### Returns

A ConnectorSharepoint object

------------------------------------------------------------------------

### Method `get_conn()`

Get the connection

#### Usage

    ConnectorSharepoint$get_conn()

#### Returns

The connection

## Examples

``` r
if (FALSE) { # \dontrun{
  # Connect to Sharepoint
  cs <- ConnectorSharepoint$new(
    site_url = Sys.getenv("SHAREPOINT_SITE_URL")
  )

  cs

  # List content
  cs$list_content_cnt()

  # Write to the connector
  cs$write_cnt(iris, "iris.rds")

  # Check it is there
  cs$list_content_cnt()

  # Read the result back
  cs$read_cnt("iris.rds") |>
    head()

  # Remove a file or directory
  cs$remove_cnt("iris.rds")

  # Check it is there
  cs$list_content_cnt()
} # }
```

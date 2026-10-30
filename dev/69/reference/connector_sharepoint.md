# Create sharepoint connector object

Create a new sharepoint connector object. See
[ConnectorSharepoint](https://novonordisk-opensource.github.io/connector.sharepoint/reference/ConnectorSharepoint.md)
for details.

## Usage

``` r
connector_sharepoint(
  site_url,
  token = get_token(),
  folder = "",
  extra_class = NULL,
  ...
)
```

## Arguments

- site_url:

  [character](https://rdrr.io/r/base/character.html) The URL of the
  Sharepoint site

- token:

  [AzureAuth::AzureToken](https://rdrr.io/pkg/AzureAuth/man/AzureToken.html)
  The Azure token. By default, it will be retrieved by
  [get_token](https://novonordisk-opensource.github.io/connector.sharepoint/reference/get_token.md)

- folder:

  [character](https://rdrr.io/r/base/character.html) The path of the
  folder to interact with, if you don't want to interact with the root
  folder.

- extra_class:

  [character](https://rdrr.io/r/base/character.html) Extra class added
  to the object.

- ...:

  Additional parameters to pass to the
  [ConnectorSharepoint](https://novonordisk-opensource.github.io/connector.sharepoint/reference/ConnectorSharepoint.md)
  object

## Value

A new
[ConnectorSharepoint](https://novonordisk-opensource.github.io/connector.sharepoint/reference/ConnectorSharepoint.md)
object

## Details

The `extra_class` parameter allows you to create a subclass of the
[ConnectorSharepoint](https://novonordisk-opensource.github.io/connector.sharepoint/reference/ConnectorSharepoint.md)
object. This can be useful if you want to create a custom connection
object for easier dispatch of new s3 methods, while still inheriting the
methods from the
[ConnectorSharepoint](https://novonordisk-opensource.github.io/connector.sharepoint/reference/ConnectorSharepoint.md)
object.

Authentication is handled through Azure tokens. See
[`get_token()`](https://novonordisk-opensource.github.io/connector.sharepoint/reference/get_token.md)
for details on token acquisition and management.

## Examples

``` r
if (FALSE) { # \dontrun{
  # Connect
  cs <- connector_sharepoint(Sys.getenv("SHAREPOINT_SITE_URL"))
  cs

  # Create subclass connection
  cs_subclass <- connector_sharepoint(Sys.getenv("SHAREPOINT_SITE_URL"),
    extra_class = "subclass"
  )

  cs_subclass
  class(cs_subclass)

} # }
```

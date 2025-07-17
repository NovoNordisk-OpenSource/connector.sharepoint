# connector.sharepoint dev

## Enhancement
* Replace `options` package with `zephyr` package for configuration management
* Update `ConnectorSharepoint` class to use `""` as a default value for folder.
Also, add private field called `.conn`.
* Update sharepoint methods so they use only `ms_drive()` class from `Microsoft365R` package.

# connector.sharepoint 0.0.5

## Breaking Changes
* Change connector class name from `Connector_sharepoint` to `ConnectorSharepoint`
* Update according to updated in `connector` version `0.0.8`, updated package dependency accordingly.
* Update generic methods to reflect new class name

## Enhancement
* Add issue and PR templates
* Add precommit
* Update pkgdown website with categories

# connector.sharepoint 0.0.4

* Added `upload_folder_cnt()` function to upload a folder to SharePoint

# connector.sharepoint 0.0.3

Initial release to internal package manager

# connector.sharepoint 0.0.1

* connector.sharepoint is ready to be used in beta version.

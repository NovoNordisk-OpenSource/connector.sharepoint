# connector.sharepoint dev

## Bug Fixes
* Fix README.md documentation to use correct factory function `connector_sharepoint()` instead of deprecated `ConnectorSharepoint()` constructor

## Enhancement
* Add logging support for SharePoint connector operations
  - Add `log_read_connector.ConnectorSharepoint()` method for logging read operations
  - Add `log_write_connector.ConnectorSharepoint()` method for logging write operations  
  - Add `log_remove_connector.ConnectorSharepoint()` method for logging delete operations
  - Logging functionality uses `whirl` package for structured logging
  - Log messages include file name and SharePoint site path information

## Breaking Changes

### Parameter Renaming for File Transfer Methods

The following methods have had their parameters renamed to provide consistent `src` (source) and `dest` (destination) naming:

* `upload_cnt()`: `file` → `src`, `name` → `dest`
* `download_cnt()`: `name` → `src`, `file` → `dest`
* `upload_directory_cnt()`: `dir` → `src`, `name` → `dest`
* `download_directory_cnt()`: `name` → `src`, `dir` → `dest`

#### Migration Examples

**Before:**
```r
# Upload file
cs$upload_cnt(file = "local_file.csv", name = "remote_file.csv")

# Download file
cs$download_cnt(name = "remote_file.csv", file = "local_file.csv")

# Upload directory
cs$upload_directory_cnt(dir = "local_folder", name = "remote_folder")

# Download directory
cs$download_directory_cnt(name = "remote_folder", dir = "local_folder")
```

**After:**
```r
# Upload file
cs$upload_cnt(src = "local_file.csv", dest = "remote_file.csv")

# Download file
cs$download_cnt(src = "remote_file.csv", dest = "local_file.csv")

# Upload directory
cs$upload_directory_cnt(src = "local_folder", dest = "remote_folder")

# Download directory
cs$download_directory_cnt(src = "remote_folder", dest = "local_folder")
```

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

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an R package called `connector.sharepoint` that provides a convenient interface for accessing and interacting with Microsoft SharePoint sites directly from R. It extends the connector package to support Microsoft SharePoint sites.

## Architecture

- **Main Class**: `ConnectorSharepoint` (R6 class) - Core connection object that inherits from connector package
- **Factory Function**: `connector_sharepoint()` - Creates new ConnectorSharepoint instances
- **Authentication**: Uses AzureAuth package via `get_token()` function for SharePoint authentication
- **Integration**: Designed to work with the main `connector` package but can be used independently

### Key Components

- `R/sharepoint.R` - Main connector class and factory function
- `R/sharepoint_methods.R` - SharePoint-specific methods (CRUD operations)
- `R/token.R` - Authentication token management
- `R/connector_imports.R` - Package imports and dependencies
- `R/connector-sharepoint-options.R` - Configuration options

## Development Commands

### Testing
```r
# Run all tests
devtools::test()

# Or use testthat directly
testthat::test_check("connector.sharepoint")
```

### Package Development
```r
# Build and check package
devtools::check()

# Load package for development
devtools::load_all()

# Generate documentation
devtools::document()

# Build package
devtools::build()
```

### Documentation
```r
# Build pkgdown site
pkgdown::build_site()
```

## CI/CD

The project uses GitHub Actions with NovoNordisk's reusable workflows:
- **check_current_version**: Version checking
- **pkgdown**: Documentation site generation
- **coverage**: Test coverage reporting
- **megalinter**: Code linting and formatting

## Key Dependencies

- `connector` (>= 0.1.1) - Base connector framework
- `Microsoft365R` - Microsoft 365 API interface
- `AzureAuth` - Azure authentication
- `R6` - Object-oriented programming
- `checkmate` - Parameter validation
- `zephyr` - Additional utilities

## Configuration

Example YAML configuration available at `inst/config/example_yaml.yaml` for use with the connector package framework.

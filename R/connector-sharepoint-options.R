#' @title Options for connector.sharepoint
#' @name connector-options-sharepoint
#' @description
#' Configuration options for the connector.sharepoint
#' `r zephyr::list_options(as = "markdown", .envir = "connector.sharepoint")`
NULL

#' @title Internal parameters for reuse in functions
#' @name connector-sharepoint-options-params
#' @eval zephyr::list_options(as = "params", .envir = "connector.sharepoint")
#' @details See [connector-options-sharepoint] for more information.
#' @keywords internal
NULL

zephyr::create_option(
  name = "overwrite",
  default = zephyr::get_option("overwrite", "connector"),
  desc = "Overwrite existing content if it exists in the connector?"
)

zephyr::create_option(
  name = "verbosity_level",
  default = zephyr::get_option("verbosity_level", "connector"),
  desc = "Verbosity level for functions in connector. See
  [zephyr::verbosity_level] for details."
)

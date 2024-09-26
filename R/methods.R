#' Methods for the sharepoint class
#'
#' @param connector_object The sharepoint object
#' @param name name of the file to remove
#' @param ... Additional parameters to pass to the delete method
#'
#' @rdname connector_methods
#' @export
remove_cnt.Connector_sharepoint <- function(connector_object, name, ...) {
  connector_object$get_conn()$get_item(name)$delete(...)
}

#' @description
#' * [Connector_sharepoint]: Reuses the [connector::list_content_cnt()]
#' method for [connector.sharepoint::Connector_sharepoint]
#'
#' @rdname connector_methods
#' @export
list_content_cnt.Connector_sharepoint <- function(connector_object, ...) {
  connector_object$get_conn()$list_items()
}

#' @description
#' * [read_cnt.Connector_sharepoint]: Reuses the [connector::read_cnt()]
#'  method for [connector.sharepoint::Connector_sharepoint].
#' @rdname connector_methods
#' @param name The name of the file to read
#' @param ... Additional parameters to pass to the read_microsoft_file function
#'
#' @export
read_cnt.Connector_sharepoint <- function(connector_object, name, ...) {
  connector_object$get_conn() |>
    read_microsoft_file(name, ...)
}

#' @rdname connector_methods
#' @param x The content to write
#' @param name The name of the file to write
#' @param ... Additional parameters to pass to the write_microsoft_file function
#' @export
write_cnt.Connector_sharepoint <- function(connector_object, x, name, ...) {
  connector_object$get_conn() |>
    write_microsoft_file(x, file = name, ...)
}

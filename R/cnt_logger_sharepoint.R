#' @rdname log_read_connector
#'
#' @description
#' * [ConnectorSharepoint]: Implementation of the `log_read_connector`
#' function for the ConnectorSharepoint class.
#'
#'
#' @export
log_read_connector.ConnectorSharepoint <- function(
  connector_object,
  name,
  ...
) {
  rlang::check_installed("whirl")
  msg <- paste0(name, " @ ", connector_object$path)
  whirl::log_read(msg)
}

#' @rdname log_write_connector
#'
#' @description
#' * [ConnectorSharepoint]: Implementation of the `log_write_connector`
#' function for the ConnectorSharepoint class.
#'
#'
#' @export
log_write_connector.ConnectorSharepoint <- function(
  connector_object,
  name,
  ...
) {
  rlang::check_installed("whirl")
  msg <- paste0(name, " @ ", connector_object$path)
  whirl::log_write(msg)
}

#' @rdname log_remove_connector
#'
#' @description
#' * [ConnectorSharepoint]: Implementation of the `log_remove_connector`
#' function for the ConnectorSharepoint class.
#'
#'
#' @export
log_remove_connector.ConnectorSharepoint <- function(
  connector_object,
  name,
  ...
) {
  rlang::check_installed("whirl")
  msg <- paste0(name, " @ ", connector_object$path)
  whirl::log_delete(msg)
}


#' Log connector message
#'
#' Generate connector object log message with all the information
#' about the object.
#' @noRd
#' @keywords internal
log_connector_message <- function(connector_object, name) {
  rlang::check_installed("whirl")
  msg <- paste0(
    name,
    " @ ",
    "path: ",
    connector_object$path,
    ", driveType: ",
    connector_object$get_conn()$properties$driveType,
    ", id: ",
    connector_object$get_conn()$properties$id,
    ", description:",
    connector_object$get_conn()$properties$description
  )
}

#' @description
#' * [ConnectorSharepoint]: Reuses the [connector::read_cnt()]
#'  method for [connector.sharepoint::ConnectorSharepoint()]
#'
#' @rdname read_cnt
#' @param name The name of the file to read
#' @param ... [ConnectorSharepoint]: Additional parameters to pass to the
#' `get_item()` method of \code{\link[Microsoft365R]{ms_drive}} class
#'
#' @export
read_cnt.ConnectorSharepoint <- function(connector_object, name, ...) {
  checkmate::assert_string(name)
  name <- paste(connector_object$folder, name, sep = "/")

  drive <- connector_object$get_conn()

  file <- drive$get_item(name)

  if (file$is_folder()) {
    cli::cli_abort(
      "The file provided is a folder, please use download_folder instead of
      read."
    )
  }

  find_ext <- tools::file_ext(name)

  temp_file <- tempfile(fileext = paste0(".", find_ext))

  file$download(dest = temp_file)

  x <- connector::read_file(temp_file, ...)

  unlink(temp_file)

  x
}

#' @description
#' * [ConnectorSharepoint]: Reuses the [connector::write_cnt()]
#'  method for [connector.sharepoint::ConnectorSharepoint()]
#'
#' @rdname write_cnt
#' @param ... [ConnectorSharepoint]: Additional parameters to pass to the
#' [connector::write_file()] function
#' @export
write_cnt.ConnectorSharepoint <- function(
  connector_object,
  x,
  name,
  overwrite = zephyr::get_option("overwrite", "connector.sharepoint"),
  ...
) {
  checkmate::assert_string(name)
  name <- paste(connector_object$folder, name, sep = "/")

  drive <- connector_object$get_conn()

  if (is.character(x)) {
    cli::cli_abort(
      "The object provided is a character, please provide a data frame or a
      R object. For files or folders, use the appropriate functions."
    )
  }

  find_ext <- tools::file_ext(name)

  temp_file <- tempfile(fileext = paste0(".", find_ext))

  connector::write_file(x, temp_file, ...)

  drive$upload_file(temp_file, name)

  unlink(temp_file)

  invisible(connector_object)
}

#' @description
#' * [ConnectorSharepoint]: Reuses the [connector::list_content_cnt()]
#'  method for [connector.sharepoint::ConnectorSharepoint()]
#'
#' @rdname list_content_cnt
#' @param ... [ConnectorSharepoint]: Additional parameters to pass to the
#' `list_items()` method of \code{\link[Microsoft365R]{ms_drive}} class.
#' @export
list_content_cnt.ConnectorSharepoint <- function(connector_object, ...) {
  list <- connector_object$get_conn()$list_items(
    path = connector_object$folder,
    ...
  )

  list$name
}

#' @description
#' * [ConnectorSharepoint]: Reuses the [connector::remove_cnt()]
#'  method for [connector.sharepoint::ConnectorSharepoint()]
#'
#' @rdname remove_cnt
#' @param ... [ConnectorSharepoint]: Additional parameters to pass to the
#' `delete()` method of \code{\link[Microsoft365R]{ms_drive}} class.
#'
#' @return [ConnectorSharepoint] object
#' @export
remove_cnt.ConnectorSharepoint <- function(connector_object, name, ...) {
  checkmate::assert_string(name)
  name <- paste(connector_object$folder, name, sep = "/")

  connector_object$get_conn()$get_item(name)$delete(...)

  invisible(connector_object)
}

#' @description
#' * [ConnectorSharepoint]: Reuses the [connector::download_cnt()]
#'  method for [connector.sharepoint::ConnectorSharepoint()]
#'
#' @rdname download_cnt
#' @param ... [ConnectorSharepoint]: Additional parameters to pass to the
#' `download()` method of \code{\link[Microsoft365R]{ms_drive}} class.
#'
#' @return [ConnectorSharepoint] object
#' @export
download_cnt.ConnectorSharepoint <- function(
  connector_object,
  name,
  file = basename(name),
  ...
) {
  checkmate::assert_string(name)
  checkmate::assert_string(file)
  name <- paste(connector_object$folder, name, sep = "/")

  connector_object$get_conn()$get_item(name)$download(file, ...)

  invisible(connector_object)
}

#' @description
#' * [ConnectorSharepoint]: Reuses the [connector::upload_cnt()]
#'  method for [connector.sharepoint::ConnectorSharepoint()]
#'
#' @rdname upload_cnt
#' @param recursive If `recursive` is TRUE, all subfolders will also be
#' transferred recursively. Default: `FALSE`
#' @param ... [ConnectorSharepoint]: Additional parameters to pass to
#' the `upload_file()` or `upload_folder()`
#' method of \code{\link[Microsoft365R]{ms_drive}} class.
#'
#' @return [ConnectorSharepoint] object
#' @export
upload_cnt.ConnectorSharepoint <- function(
  connector_object,
  file,
  name = basename(file),
  overwrite = zephyr::get_option("overwrite", "connector.sharepoint"),
  ...,
  recursive = FALSE
) {
  checkmate::assert_file_exists(file)
  checkmate::assert_string(name)
  name <- paste(connector_object$folder, name, sep = "/")

  drive <- connector_object$get_conn()

  drive$upload_file(src = file, dest = name)

  invisible(connector_object)
}

#' @description
#' * [ConnectorSharepoint]: Reuses the [connector::create_directory_cnt()]
#'  method for [connector.sharepoint::ConnectorSharepoint()]
#'
#' @rdname create_directory_cnt
#' @param ... [ConnectorSharepoint]: Additional parameters to pass to
#' `create_folder()` method of \code{\link[Microsoft365R]{ms_drive}} class.
#' @param open create a new connector object
#'
#' @return [ConnectorSharepoint] object or [ConnectorSharepoint] object of a
#' newly built directory
#' @export
create_directory_cnt.ConnectorSharepoint <- function(
  connector_object,
  name,
  open = TRUE,
  ...
) {
  checkmate::assert_string(name)
  checkmate::assert_logical(open)
  if (!(connector_object$folder == "")) {
    name <- paste(connector_object$folder, name, sep = "/")
  }

  new_directory <- connector_object$get_conn()$create_folder(name, ...)

  if (open) {
    connector_object <- connector_sharepoint(
      site_url = connector_object$site_url,
      path_of_folder = name
    )
  }

  invisible(connector_object)
}

#' @description
#' * [ConnectorSharepoint]: Reuses the [connector::remove_directory_cnt()]
#'  method for [connector.sharepoint::ConnectorSharepoint()]
#'
#' @rdname remove_directory_cnt
#' @param ... [ConnectorSharepoint]: Additional parameters to pass to
#' `delete()` method of \code{\link[Microsoft365R]{ms_drive}} class.
#' @return [ConnectorSharepoint] object
#' @export
remove_directory_cnt.ConnectorSharepoint <- function(
  connector_object,
  name,
  ...
) {
  checkmate::assert_string(name)
  name <- paste(connector_object$folder, name, sep = "/")

  connector_object$get_conn()$get_item(name)$delete(...)

  invisible(connector_object)
}

#' @description
#' * [ConnectorSharepoint]: Uses [read_cnt()] to allow redundancy.
#'
#' @rdname tbl_cnt
#' @export
tbl_cnt.ConnectorSharepoint <- function(connector_object, name, ...) {
  read_cnt(connector_object = connector_object, name = name, ...)
}

#' Upload a directory
#'
#' @rdname upload_directory_cnt
#' @param ... additional paramaeters passed on to `upload_folder()` method of
#' \code{\link[Microsoft365R]{ms_drive}} class.
#' @param recursive  If `recursive` is `TRUE`, all subfolders will also be
#' transferred recursively. Default: `FALSE`
#' @return [ConnectorSharepoint] object
#' @export
upload_directory_cnt.ConnectorSharepoint <- function(
  connector_object,
  dir,
  name = basename(dir),
  overwrite = zephyr::get_option("overwrite", "connector"),
  open = FALSE,
  ...,
  recursive = TRUE
) {
  checkmate::assert_directory_exists(dir)
  checkmate::assert_string(name)
  name <- paste(connector_object$folder, name, sep = "/")

  drive <- connector_object$get_conn()

  drive$upload_folder(dir, name, recursive = recursive, ...)

  # create a new connector object from the new path with persistent extra class
  if (open) {
    extra_class <- class(connector_object)
    extra_class <- utils::head(
      extra_class,
      which(extra_class == "ConnectorSharepoint") - 1
    )
    connector_object <- connector_sharepoint(
      site_url = connector_object$site_url,
      path_of_folder = paste0(connector_object$folder, "/", name)
    )
  }

  invisible(connector_object)
}

#' Download a directory
#'
#' @rdname download_directory_cnt
#' @param ... additional paramaeters passed on to `download_folder()` method of
#' \code{\link[Microsoft365R]{ms_drive}} class.
#' @param recursive  If `recursive` is `TRUE`, all subfolders will also be
#' transferred recursively. Default: `FALSE`
#' @return [ConnectorSharepoint] object
#' @export
download_directory_cnt.ConnectorSharepoint <- function(
  connector_object,
  name,
  dir = basename(name),
  ...,
  recursive = TRUE
) {
  checkmate::assert_string(dir)
  checkmate::assert_string(name)
  name <- paste(connector_object$folder, name, sep = "/")

  drive <- connector_object$get_conn()

  drive$download_folder(src = name, dest = dir, recursive = recursive, ...)

  invisible(connector_object)
}

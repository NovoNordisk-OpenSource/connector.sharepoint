#' @description
#' * [ConnectorSharepoint]: Reuses the [connector::read_cnt()]
#'  method for [connector.sharepoint::ConnectorSharepoint()]
#'
#' @rdname read_cnt
#' @param name The name of the file to read
#' @param ... [ConnectorSharepoint]: Additional parameters to pass to the `get_item()` method of
#'  [Microsoft365R::ms_drive()] class
#'
#' @export
read_cnt.ConnectorSharepoint <- function(connector_object, name, ...) {
  checkmate::assert_string(name)

  drive <- connector_object$get_conn()

  file <- drive$get_item(name)

  if (file$is_folder()) {
    cli::cli_abort(
      "The file provided is a folder, please use download_folder instead of read"
    )
  }

  find_ext <- tools::file_ext(name)

  temp_file <- tempfile(fileext = paste0(".", find_ext))

  file$download(dest = temp_file)

  # Read the downloaded file
  x <- connector::read_file(temp_file, ...)

  # delete the temporary file
  unlink(temp_file)

  return(x)
}

#' @description
#' * [ConnectorSharepoint]: Reuses the [connector::write_cnt()]
#'  method for [connector.sharepoint::ConnectorSharepoint()]
#'
#' @rdname write_cnt
#' @param ... [ConnectorSharepoint]: Additional parameters to pass to the [connector::write_file()] function
#' @export
write_cnt.ConnectorSharepoint <- function(connector_object, x, name, ...) {
  checkmate::assert_string(name)

  drive <- connector_object$get_conn()

  if (is.character(x)) {
    cli::cli_abort(
      "The object provided is a character, please provide a data frame or a R object.
      For files or folders, use the appropriate functions."
    )
  }

  # Find extension of file
  find_ext <- tools::file_ext(name)

  # Create temporary file as a placeholder
  temp_file <- tempfile(fileext = paste0(".", find_ext))

  # Write the file to a temporary file
  connector::write_file(x, temp_file, ...)

  # Upload the file to sharepoint
  upload_on_drive_or_folder(drive, temp_file, name)

  # delete the temporary file
  unlink(temp_file)

  return(
    invisible(connector_object)
  )
}

#' @description
#' * [ConnectorSharepoint]: Reuses the [connector::list_content_cnt()]
#'  method for [connector.sharepoint::ConnectorSharepoint()]
#'
#' @rdname list_content_cnt
#' @param ... [ConnectorSharepoint]: Additional parameters to pass to the `list_items()` method
#' of [Microsoft365R::ms_drive()] class.
#' @export
list_content_cnt.ConnectorSharepoint <- function(connector_object, ...) {
  connector_object$get_conn()$list_items(...)
}

#' @description
#' * [ConnectorSharepoint]: Reuses the [connector::remove_cnt()]
#'  method for [connector.sharepoint::ConnectorSharepoint()]
#'
#' @rdname remove_cnt
#' @param ... [ConnectorSharepoint]: Additional parameters to pass to the `delete()` method
#' of [Microsoft365R::ms_drive()] class.
#'
#' @return [ConnectorSharepoint] object
#' @export
remove_cnt.ConnectorSharepoint <- function(connector_object, name, ...) {
  checkmate::assert_string(name)

  connector_object$get_conn()$get_item(name)$delete(...)
  return(invisible(connector_object))
}

#' @description
#' * [ConnectorSharepoint]: Reuses the [connector::download_cnt()]
#'  method for [connector.sharepoint::ConnectorSharepoint()]
#'
#' @rdname download_cnt
#' @param ... [ConnectorSharepoint]: Additional parameters to pass to the `download()` method
#' of [Microsoft365R::ms_drive()] class.
#'
#' @return [ConnectorSharepoint] object
#' @export
download_cnt.ConnectorSharepoint <- function(
    connector_object,
    name,
    file = basename(name),
    ...) {
  checkmate::assert_string(name)
  checkmate::assert_string(file)

  connector_object$get_conn()$get_item(name)$download(file, ...)
  return(invisible(connector_object))
}

#' @description
#' * [ConnectorSharepoint]: Reuses the [connector::upload_cnt()]
#'  method for [connector.sharepoint::ConnectorSharepoint()]
#'
#' @rdname upload_cnt
#' @param recursive If `recursive` is TRUE, all subfolders will also be transferred recursively. Default: `FALSE`
#' @param ... [ConnectorSharepoint]: Additional parameters to pass to the `upload_file()` or `upload_folder()`
#' method of [Microsoft365R::ms_drive()] class.
#'
#' @return [ConnectorSharepoint] object
#' @export
upload_cnt.ConnectorSharepoint <- function(
    connector_object,
    file,
    name = basename(file),
    ...,
    recursive = FALSE) {
  checkmate::assert_file_exists(file)
  checkmate::assert_string(name)

  drive <- connector_object$get_conn()

  upload_on_drive_or_folder(ms_object = drive, src = file, dest = name)

  return(invisible(connector_object))
}

#' @description
#' * [ConnectorSharepoint]: Reuses the [connector::create_directory_cnt()]
#'  method for [connector.sharepoint::ConnectorSharepoint()]
#'
#' @rdname create_directory_cnt
#' @param ... [ConnectorSharepoint]: Additional parameters to pass to `create_folder()` method
#' of [Microsoft365R::ms_drive()] class.
#' @param open create a new connector object
#'
#' @return [ConnectorSharepoint] object or [ConnectorSharepoint] object of a newly built directory
#' @export
create_directory_cnt.ConnectorSharepoint <- function(
    connector_object,
    name,
    ...,
    open = TRUE) {
  checkmate::assert_string(name)
  checkmate::assert_logical(open)

  new_directory <- connector_object$get_conn()$create_folder(name, ...)

  if (open) {
    return(
      ConnectorSharepoint$new(
        site_url = connector_object$site_url,
        path_of_folder = new_directory$get_path()
      )
    )
  }
  return(invisible(connector_object))
}

#' @description
#' * [ConnectorSharepoint]: Reuses the [connector::remove_directory_cnt()]
#'  method for [connector.sharepoint::ConnectorSharepoint()]
#'
#' @rdname remove_directory_cnt
#' @param ... [ConnectorSharepoint]: Additional parameters to pass to
#' `delete()` method of [Microsoft365R::ms_drive()] class.
#' @return [ConnectorSharepoint] object
#' @export
remove_directory_cnt.ConnectorSharepoint <- function(
    connector_object,
    name,
    ...) {
  checkmate::assert_string(name)
  connector_object$get_conn()$get_item(name)$delete(...)
  return(invisible(connector_object))
}

#' @description
#' * [ConnectorSharepoint]: Uses [read_cnt()] to allow redundancy.
#'
#' @rdname tbl_cnt
#' @export
tbl_cnt.ConnectorDatabricksVolume <- function(connector_object, name, ...) {
  checkmate::assert_string(name)
  read_cnt(connector_object = connector_object, name = name, ...)
}

#' Util function to upload on drive or folder
#'
#' This function is used to upload a file on a drive or a folder
#'
#' @param ms_object A microsoft object, in our case embedded in a sharepoint object
#' @param src The source of the file to upload
#' @param dest The destination of the file
#' @param ... Additional parameters to pass to the `upload_file()` or `upload_folder()`
#' method of [Microsoft365R::ms_drive()] class.
#'
#' @return A file or folder uploaded
#' @keywords internal
#' @noRd
upload_on_drive_or_folder <- function(ms_object, src, dest, ...) {
  if (inherits(ms_object, "ms_drive")) {
    ms_object$upload_file(src, dest, ...)
  } else {
    ms_object$upload(src, dest, ...)
  }
  return(ms_object)
}

#' @title Upload folder to sharepoint
#'
#' @description
#' Upload folder to the Sharepoint drive or folder
#'
#' @param connector_object [ConnectorSharepoint] object
#' @param folder Local folder path
#' @param name Folder name to be used when uploaded
#' @param ... additional paramaeters passed on to `upload_folder()` method of [Microsoft365R::ms_drive()] class
#' or to `upload()` method of [Microsoft365R::ms_drive_item()] class.
#' @param recursive  If `recursive` is `TRUE`, all subfolders will also be transferred recursively. Default: `FALSE`
#' @return [ConnectorSharepoint] object
#'
#' @export
upload_directory_cnt <- function(
    connector_object,
    folder,
    name = basename(folder),
    ...,
    recursive = FALSE) {
  checkmate::assert_r6(x = connector_object, classes = "ConnectorSharepoint")
  checkmate::assert_directory_exists(folder)
  checkmate::assert_string(name)

  drive <- connector_object$get_conn()

  if (inherits(drive, "ms_drive")) {
    drive$upload_folder(folder, name, recursive = recursive, ...)
  } else {
    drive$upload(folder, name, recursive = recursive)
  }

  return(invisible(connector_object))
}

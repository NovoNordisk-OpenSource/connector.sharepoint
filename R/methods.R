#' @description
#' * [Connector_sharepoint]: Reuses the [connector::read_cnt()]
#'  method for [connector.sharepoint::Connector_sharepoint()]
#'
#' @rdname read_cnt
#' @param name The name of the file to read
#' @param ... [Connector_sharepoint]: Additional parameters to pass to the [get_item()] method of [Microsoft365R::ms_drive()] class
#'
#' @export
read_cnt.Connector_sharepoint <- function(connector_object, name, ...) {
  drive <- connector_object$get_conn()

  file <- drive$get_item(name)

  if (file$is_folder()) {
    cli::cli_abort("The file provided is a folder, please use download_folder instead of read")
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
#' * [Connector_sharepoint]: Reuses the [connector::write_cnt()]
#'  method for [connector.sharepoint::Connector_sharepoint()]
#' 
#' @rdname write_cnt
#' @param ... [Connector_sharepoint]: Additional parameters to pass to the [connector::write_file()] function
#' @export
write_cnt.Connector_sharepoint <- function(connector_object, x, name, ...) {
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
#' * [Connector_sharepoint]: Reuses the [connector::list_content_cnt()]
#'  method for [connector.sharepoint::Connector_sharepoint()]
#' 
#' @rdname list_content_cnt
#' @param ... [Connector_sharepoint]: Additional parameters to pass to the [list_items()] method of [Microsoft365R::ms_drive()] class.
#' @export
list_content_cnt.Connector_sharepoint <- function(connector_object, ...) {
  connector_object$get_conn()$list_items(...)
}

#' @description
#' * [Connector_sharepoint]: Reuses the [connector::remove_cnt()]
#'  method for [connector.sharepoint::Connector_sharepoint()]
#' 
#' @rdname remove_cnt
#' @param ... [Connector_sharepoint]: Additional parameters to pass to the [delete()] method of [Microsoft365R::ms_drive()] class.
#'
#' @return [Connector_sharepoint] object
#' @export
remove_cnt.Connector_sharepoint <- function(connector_object, name, ...) {
  connector_object$get_conn()$get_item(name)$delete(...)
  return(invisible(connector_object))
}


#' @description
#' * [Connector_sharepoint]: Reuses the [connector::download_cnt()]
#'  method for [connector.sharepoint::Connector_sharepoint()]
#' 
#' @rdname download_cnt
#' @param ... [Connector_sharepoint]: Additional parameters to pass to the [download()] method of [Microsoft365R::ms_drive()] class.
#'
#' @return [Connector_sharepoint] object
#' @export
download_cnt.Connector_sharepoint <- function(connector_object, name, dest, ...) {
  connector_object$get_conn()$get_item(name)$download(dest, ...)
  return(invisible(connector_object))
}

#' @description
#' * [Connector_sharepoint]: Reuses the [connector::upload_cnt()]
#'  method for [connector.sharepoint::Connector_sharepoint()]
#' 
#' @rdname upload_cnt
#' @param ... [Connector_sharepoint]: Additional parameters to pass to the [upload_file()] or [upload_folder()]
#' method of [Microsoft365R::ms_drive()] class.
#'
#' @return [Connector_sharepoint] object
#' @export
upload_cnt.Connector_sharepoint <- function(connector_object,
                                            src,
                                            dest,
                                            ...,
                                            recursive = FALSE) {
  driver <- connector_object$get_conn()

  if (dir.exists(src)) {
    if (inherits(driver, "ms_drive")) {
      driver$upload_folder(src, dest, ..., recursive = recursive)
    } else {
      driver$upload(src, dest, ..., recursive = recursive)
    }
  } else {
    upload_on_drive_or_folder(driver, src, dest)
  }

  return(invisible(connector_object))
}

#' @description
#' * [Connector_sharepoint]: Reuses the [connector::create_directory_cnt()]
#'  method for [connector.sharepoint::Connector_sharepoint()]
#' 
#' @rdname create_directory_cnt
#' @param ... [Connector_sharepoint]: Additional parameters to pass to the [brickster::db_volume_dir_create] method
#' @param open create a new connector object
#'
#' @return [Connector_sharepoint] object or [Connector_sharepoint] object of a newly built directory
#' @export
create_directory_cnt.Connector_sharepoint <- function(connector_object, name, ..., open = TRUE) {
  new_directory <- connector_object$get_conn()$create_folder(name, ...)

  if (open) {
    return(connector_sharepoint(
      site_url = connector_object$site_url,
      path_of_folder = new_directory$get_path()
    ))
  }
  return(invisible(connector_object))
}

#' @description
#' * [Connector_sharepoint]: Reuses the [connector::remove_directory_cnt()]
#'  method for [connector.sharepoint::Connector_sharepoint()]
#' 
#' @rdname remove_directory_cnt
#' @param ... [Connector_sharepoint]: Additional parameters to pass to
#' the [brickster::db_volume_dir_delete()] method
#' @return [Connector_sharepoint] object
#' @export
remove_directory_cnt.Connector_sharepoint <- function(connector_object, name, ...) {
  connector_object$get_conn()$get_item(name)$delete(...)
  return(invisible(connector_object))
}

#' @description
#' * [Connector_sharepoint]: Uses [read_cnt()] to allow redundancy.
#'
#' @rdname tbl_cnt
#' @export
tbl_cnt.ConnectorDatabricksVolume <- function(connector_object, name, ...) {
  read_cnt(connector_object = connector_object, name = name, ...)
}

#' Util function to upload on drive or folder
#'
#' This function is used to upload a file on a drive or a folder
#'
#' @param ms_object A microsoft object, in our case embedded in a sharepoint object
#' @param src The source of the file to upload
#' @param dest The destination of the file
#' @param ... Additional parameters to pass to the [upload_file()] or [upload_folder()]
#' method of [Microsoft365R::ms_drive()] class.
#'
#' @return A file or folder uploaded
#' @keywords internal
#' @noRd
upload_on_drive_or_folder <- function(ms_object, src, dest, ...) {
  if (inherits(ms_object, "ms_drive")) {
    return(ms_object$upload_file(src, dest, ...))
  } else {
    return(ms_object$upload(src, dest, ...))
  }
}

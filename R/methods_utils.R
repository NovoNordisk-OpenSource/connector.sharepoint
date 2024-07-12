#' Download content from sharepoint
#'
#' It use the download method from the sharepoint object
#'
#' @param connector_object The sharepoint object
#' @param name The name of the file to download
#' @param dest The destination of the file
#' @param ... Additional parameters to pass to the download method
#'
#' @return The sharepoint object link to the file downloaded
#' @export
#'
#' @examplesIf FALSE
#' # my_drive is a sharepoint object
#' my_drive %>%
#'   cnt_download_content("file.csv", "file.csv")
#'
#' # This function is used by the method download_content
#' my_drive$download_content("file.csv", "file.csv")
#'
cnt_download_content <- function(connector_object, name, dest, ...) {
  connector_object$get_conn()$get_item(name)$download(dest, ...)
}

#' Upload content to sharepoint
#'
#' @param connector_object The sharepoint object
#' @param src The source of the file to upload
#' @param dest The destination of the file
#' @param ... Additional parameters to pass to the upload method
#' @param recursive A boolean to upload recursively if folder
#'
#'
#' @return The sharepoint object link to the file uploaded
#' @export
#'
#' @examplesIf FALSE
#' # my_drive is a sharepoint object
#' my_drive %>%
#'  cnt_upload_content("file.csv", "file.csv")
#' # This function is used by the method upload_content
#' my_drive$upload_content("file.csv", "file.csv")
cnt_upload_content <- function(connector_object, src, dest, ..., recursive = FALSE) {
  drive <- connector_object$get_conn()

  if (dir.exists(src)) {
    if (inherits(drive, "ms_drive")) {
      drive$upload_folder(src, dest, ..., recursive = recursive)
    } else {
      drive$upload(src, dest, ..., recursive = recursive)
    }
  } else {
    upload_on_drive_or_folder(drive, src, dest)
  }
}

#' Create a directory
#'
#' @param connector_object The sharepoint object
#' @param name The name of the directory to create
#' @param ... Additional parameters to pass to the create_folder method
#'
#' @return The sharepoint object link to the directory created
#' @export
#'
#' @examplesIf FALSE
#' # my_drive is a sharepoint object
#' my_drive %>%
#'  cnt_create_directory("folder")
#' # This function is used by the method create_directory
#' my_drive$create_directory("folder")
cnt_create_directory <- function(connector_object, name, ...) {
  connector_object$get_conn()$create_folder(name, ...)
}



#' Read a file from sharepoint
#'
#' @param ms_object A microsoft object, in our case embedded in a sharepoint object
#' @param name The name of the file to read
#' @param ... Additional parameters to pass to the read_file method
#'
#' @return The content of the file in R
read_microsoft_file <- function(ms_object, name, ...) {
  file <- ms_object$get_item(name)

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

#' Util function to upload on drive or folder
#'
#' This function is used to upload a file on a drive or a folder
#'
#' @param ms_object A microsoft object, in our case embedded in a sharepoint object
#' @param src The source of the file to upload
#' @param dest The destination of the file
#'
#' @return A file or folder uploaded
upload_on_drive_or_folder <- function(ms_object, src, dest) {

  if (inherits(ms_object, "ms_drive")) {
    return(ms_object$upload_file(src, dest))
  } else {
    return(ms_object$upload(src, dest))
  }
}

#' Write a file to sharepoint
#'
#' @param ms_object A microsoft object, in our case embedded in a sharepoint object
#' @param x The content to write
#' @param file The name of the file to write
#' @param ... Additional parameters to pass to the write_file method
#'
#' @return The file path
write_microsoft_file <- function(ms_object, x, file, ...) {
  if (is.character(x)) {
    cli::cli_abort("The object provided is a character, please provide a data frame or a R object. For files or folders, use the appropriate functions")
  }

  # Find extension of file
  find_ext <- tools::file_ext(file)

  # Create temporary file as a placeholder
  temp_file <- tempfile(fileext = paste0(".", find_ext))

  # Write the file to a temporary file
  connector::write_file(x, temp_file, ...)

  # Upload the file to sahrepoint
  res <- upload_on_drive_or_folder(ms_object, temp_file, file)

  # delete the temporary file
  unlink(temp_file)

  # Return the file name
  return(TRUE)
}

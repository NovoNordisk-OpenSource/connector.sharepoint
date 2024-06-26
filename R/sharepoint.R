Connector_sharepoint <- R6::R6Class( # nolint
  "Connector_sharepoint",
  public = list(
    #' @description Initializes the connector_databricks_volumes class
    initialize = function(site_url,
                         token,
                         path_of_folder = NULL) {


      if(!AzureAuth::is_azure_token(token)){
        stop("The token provided is not a valid Azure token")
      }

      private$token <- token
      private$site_url <- site_url

      folder <- Microsoft365R::get_sharepoint_site(site_url = site_url, token = token)$get_drive()

      if(!is.null(path_of_folder)){
        folder <- folder$get_item(path_of_folder)
        if(!folder$is_folder()){
          stop("The path provided is not a folder")
        }
      }

     private$folder <- folder

    },
    list_content = function() {
      self %>%
        list_content()
    },
    read = function(name, ...) {
      self %>%
        read(name, ...)
    },
    write = function(x, file, ...) {
      self %>%
        write(x, file, ...)
    },
    download = function(name, ...) {
      self %>%
        download_content(name, ...)
    },
    upload = function(name, ...) {
      self %>%
        upload_content(name, ...)
    },
    get_conn = function() {
      private$folder
    },
    create_directory = function(name, ...) {
      self %>%
        create_directory(name, ...)
    },
    remove = function(name) {
      self %>%
        remove(name)
    }
  ),
  private = list(
    token = character(0),
    folder = NULL,
    site_url = character(0)
  ),
  cloneable = FALSE
)

download_content <- function(connector_object, name, dest, ...) {
  connector_object$get_conn()$get_item(name)$download(dest, ...)
}

upload_content <- function(connector_object, src, dest, ..., recursive = FALSE) {
  drive <- connector_object$get_conn()

  if(is.dir(src)){
    if(inherits(drive, "ms_drive")){
      drive$upload_folder(src, dest, ..., recursive = recursive)
    }else{
      drive$upload(src, dest, ..., recursive = recursive)
    }
  }else{
    upload_on_drive_or_folder(drive, src, dest)
  }

}

create_directory <- function(connector_object, name, ...) {
  connector_object$get_conn()$create_folder(name, ...)
}

remove.Connector_sharepoint <- function(connector_object, name) {
  connector_object$get_conn()$get_item(name)$delete()
}

list_content.Connector_sharepoint <- function(connector_object) {

  connector_object$get_conn()$list_items()
}

read.Connector_sharepoint <- function(connector_object, name, ...) {

  connector_object$get_conn() %>%
    read_microsoft_file(name, ...)
}

write.Connector_sharepoint <- function(connector_object, x, file, ...) {

  connector_object$get_conn() %>%
    write_microsoft_file(x, file, ...)
}

read_microsoft_file <- function(ms_object, name, ...) {

  file <- ms_object$get_item(name)

  if(file$is_folder()){
    stop("The file provided is a folder, please use download_folder instead of read")
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


upload_on_drive_or_folder <- function(ms_object, src, dest) {

  if(inherits(ms_object, "ms_drive")){
    return(ms_object$upload_file(src, dest))
  } else {
    return(ms_object$upload(src, dest))
  }
}

write_microsoft_file <- function(ms_object, x, file, ...) {

  if(is.character(x)){
    stop("The object provided is a character, please provide a data frame or a R object. For files or folders, use the appropriate functions")
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
  return(res$get_path())

}

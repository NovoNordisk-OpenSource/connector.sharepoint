#' Create sharepoint connector object
#'
#' @description Create a new sharepoint connector object. See [Connector_sharepoint] for details.
#'
#' @param site_url The URL of the Sharepoint site
#' @param token The Azure token. By default, it will be retrieve by [get_token]
#' @param path_of_folder The path of the folder to interact with, if you don't want to interact with the root folder "Documents"
#' @param ... Additional parameters to pass to the [Connector_sharepoint] object
#' @param extra_class [character] Extra class added to the object. See details.
#'
#' @return A new [Connector_sharepoint] object
#'
#' @details
#' The `extra_class` parameter allows you to create a subclass of the `Connector_sharepoint` object.
#' This can be useful if you want to create a custom connection object for easier dispatch of new s3 methods,
#' while still inheriting the methods from the `Connector_sharepoint` object.
#'
#' @examplesIf not_on_ci()
#'
#' # Connect
#'
#' my_drive <- connector_sharepoint(Sys.getenv("SHAREPOINT_SITE_URL", "https://sharepoint.com"))
#'
#' # List content
#' my_drive$list_content()
#' # Write a file
#' my_drive$write(iris, "iris.csv")
#' # Read a file
#' my_drive$read("iris.csv")
#' # Create a directory
#' my_drive$create_directory("new_directory")
#' # Remove a file or directory
#' my_drive$remove("iris.csv", confirm = FALSE)
#' my_drive$remove("new_directory")
#'
#' ### For a specific folder
#' test_folder <- connector_sharepoint(
#'   Sys.getenv("SHAREPOINT_SITE_URL", "https://sharepoint.com"),
#'   path_of_folder = "Test"
#' )
#' test_folder$list_content()
#' test_folder$write(iris, "iris.csv")
#' test_folder$read("iris.csv")
#'
#' @export
connector_sharepoint <- function(site_url,
                                 token = get_token(),
                                 ...,
                                 path_of_folder = NULL,
                                 extra_class = NULL) {
  checkmate::assert_character(extra_class, null.ok = TRUE)

  layer <- Connector_sharepoint$new(site_url = site_url, token = token, path_of_folder = path_of_folder, ...)
  if (!is.null(extra_class)) {
    # TODO: not sure about paste and so on
    # extra_class <- paste(class(layer), extra_class, sep = "_")
    class(layer) <- c(extra_class, class(layer))
  }
  return(layer)
}


#' @title Connector Object for Sharepoint
#' @description This object is used to interact with Sharepoint, adding the ability to list, read, write, download, upload, create directories and remove files.
#'
#' @importFrom R6 R6Class
#' @importFrom AzureAuth is_azure_token
#' @importFrom Microsoft365R get_sharepoint_site
#'
#' @details
#' About the token, you can retrieve it by following the guideline in your enterprise.
#'
#'
#' @export
#'
#' @name Connector_sharepoint_object
#'
#' @examplesIf not_on_ci()
#' # Connect to Sharepoint
#' my_drive <- Connector_sharepoint$new(
#'   site_url = Sys.getenv("SHAREPOINT_SITE_URL", "https://sharepoint.com")
#' )
#'
#' my_drive$list_content()
Connector_sharepoint <- R6::R6Class( # nolint
  "Connector_sharepoint",
  public = list(
    #' @description Initializes the Connector_sharepoint class
    #' @param site_url The URL of the Sharepoint site
    #' @param token The Azure token. By default, it will be retrieve by [get_token]
    #' @param path_of_folder The path of the folder to interact with, if you don't want to interact with the root folder "Documents"
    #' @param ... Additional parameters to pass to the [get_sharepoint_site] function
    #' @return A [Connector_sharepoint] object
    #'
    #'
    initialize = function(site_url,
                          token = get_token(),
                          path_of_folder = NULL,
                          ...) {
      # Check params
      if (!AzureAuth::is_azure_token(token)) {
        cli::cli_abort("The token provided is not a valid Azure token")
      }

      checkmate::assert_character(site_url)

      if (!grepl(pattern = "^http|^https", x = site_url)) {
        cli::cli_abort("site_url must be a valid URL")
      }


      ## set up the private variables
      zephyr::msg_debug("Setting up the private variables")
      private$token <- token
      private$site_url <- site_url

      # define the path of the folder
      zephyr::msg_debug("Define the path of the folder")
      folder <- Microsoft365R::get_sharepoint_site(site_url = site_url, token = token, ...)$get_drive()

      if (!is.null(path_of_folder)) {
        zephyr::msg_debug("Setting up subfolder path define by path_of_folder")
        folder <- folder$get_item(path_of_folder)
        if (!folder$is_folder()) {
          cli::cli_abort("The path provided is not a folder")
        }
      }

      private$folder <- folder
    },
    #' @description List the content of the folder
    #' @param ... Additional parameters to pass to the cnt_list_content method
    #' @return A data.frame with the content of the folder
    #'
    list_content = function(...) {
      self %>%
        cnt_list_content(...)
    },
    #' @description Read the content of a file
    #' @param name The name of the file to read
    #' @param ... Additional parameters to pass to the cnt_read method
    #' @return The content of the file
    read = function(name, ...) {
      self %>%
        cnt_read(name, ...)
    },
    #' @description Write a file
    #' @param x The content to write
    #' @param file The name of the file to write
    #' @param ... Additional parameters to pass to the cnt_write method
    #' @return The content of the file
    write = function(x, file, ...) {
      self %>%
        cnt_write(x, file, ...)
    },
    #' @description Download a file
    #' @param name The name of the file to download
    #' @param ... Additional parameters to pass to the cnt_download_content method
    #' @return The file downloaded
    download = function(name, ...) {
      self %>%
        cnt_download_content(name, ...)
    },
    #' @description Upload a file
    #' @param name The name of the file to upload
    #' @param ... Additional parameters to pass to the cnt_upload_content method
    #' @return The file uploaded
    upload = function(name, ...) {
      self %>%
        cnt_upload_content(name, ...)
    },
    #' @description Get the connection
    #' @return The connection
    get_conn = function() {
      private$folder
    },
    #' @description Create a directory
    #' @param name The name of the directory to create
    #' @param ... Additional parameters to pass to the cnt_create_directory method
    #' @return The directory created
    create_directory = function(name, ...) {
      self %>%
        cnt_create_directory(name, ...)
    },
    #' @description Remove a file or a directory
    #' @param name The name of the file or directory to remove
    #' @param ... Additional parameters to pass to the cnt_remove method
    remove = function(name, ...) {
      self %>%
        cnt_remove(name, ...)
    }
  ),
  private = list(
    token = character(0),
    folder = NULL,
    site_url = character(0)
  ),
  cloneable = FALSE
)

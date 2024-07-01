#' @title Connector Object for Sharepoint
#' @description This object is used to interact with Sharepoint, adding the ability to list, read, write, download, upload, create directories and remove files.
#'
#' @importFrom R6 R6Class
#' @importFrom AzureAuth is_azure_token
#' @importFrom Microsoft365R get_sharepoint_site
#'
#' @param site_url The URL of the Sharepoint site
#' @param token The Azure token
#' @param path_of_folder The path of the folder to interact with, if you don't want to interact with the root folder "Documents"
#'
#' @details
#' About the token, you can retrieve it by following the guideline in your entreprise.
#'
#'
#' @export
#'
#' @examplesIf FALSE
#' # To retrieve the token, follow the guideline in your entreprise
#' token <- readRDS("~/token_connect_only_sharepoint.rds")
#' drive <- Connector_sharepoint$new(
#'   site_url = "https://novonordisk.sharepoint.com/sites/Amace-Document-Storage/",
#'   token = token
#'  )
#' drive$list_content()
Connector_sharepoint <- R6::R6Class( # nolint
  "Connector_sharepoint",
  public = list(
    #' @description Initializes the Connector_sharepoint class
    #' @param site_url The URL of the Sharepoint site
    #' @param token The Azure token
    #' @param path_of_folder The path of the folder to interact with, if you don't want to interact with the root folder "Documents"
    #' @return A [Connector_sharepoint] object
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
    remove = function(name) {
      self %>%
        cnt_remove(name)
    }
  ),
  private = list(
    token = character(0),
    folder = NULL,
    site_url = character(0)
  ),
  cloneable = FALSE
)


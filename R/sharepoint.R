#' Create sharepoint connector object
#'
#' @description Create a new sharepoint connector object. See [Connector_sharepoint] for details.
#'
#' @param site_url The URL of the Sharepoint site
#' @param token The Azure token. By default, it will be retrieve by [get_token]
#' @param path_of_folder The path of the folder to interact with, if you don't want to interact with the root folder "Documents" #nolint
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
#' cs <- connector_sharepoint(Sys.getenv("SHAREPOINT_SITE_URL"))
#'
#' cs
#'
#' # Create subclass connection
#' cs_subclass <- connector_sharepoint(Sys.getenv("SHAREPOINT_SITE_URL"),
#'   extra_class = "subclass"
#' )
#'
#' cs_subclass
#' class(cs_subclass)
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
    class(layer) <- c(extra_class, class(layer))
  }
  return(layer)
}

#' @title Connector Object for Sharepoint class, built on top of [connector::connector] class
#' @description This object is used to interact with Sharepoint, adding the ability to list, read, write, download, upload, create directories and remove files. #nolint
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
#' cs <- Connector_sharepoint$new(
#'   site_url = Sys.getenv("SHAREPOINT_SITE_URL")
#' )
#'
#' cs
#'
#' # List content
#' cs$list_content_cnt()
#'
#' # Write to the connector
#' cs$write_cnt(iris, "iris.rds")
#'
#' # Check it is there
#' cs$list_content_cnt()
#'
#' # Read the result back
#' cs$read_cnt("iris.rds") |>
#'   head()
#'
#' # Remove a file or directory
#' cs$remove_cnt("iris.rds")
#'
#' # Check it is there
#' cs$list_content_cnt()
#'
#' @export
Connector_sharepoint <- R6::R6Class( # nolint
  classname = "Connector_sharepoint",
  inherit = connector::connector_fs,
  public = list(
    #' @description Initializes the Connector_sharepoint class
    #' @param site_url The URL of the Sharepoint site
    #' @param token The Azure token. By default, it will be retrieve by [get_token]
    #' @param path_of_folder The path of the folder to interact with, if you don't want to interact with the root folder "Documents" #nolint
    #' @param ... Additional parameters to pass to the [get_sharepoint_site] function
    #' @return A [Connector_sharepoint] object
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
      ## set up the private variables
      zephyr::msg_debug("Setting up the private variables")
      private$.token <- token
      private$.site_url <- site_url
      private$.folder <- folder
      private$.path <- paste0(site_url, path_of_folder, collapse = "/")
    },
    #' @description Get the connection
    #' @return The connection
    get_conn = function() {
      private$.folder
    }
  ),
  active = list(
    #' @field folder [character] The path of the folder to interact with
    folder = function() {
      private$.folder
    },
    #' @field token [character] The Azure token
    token = function() {
      private$.token
    },
    #' @field site_url [character] The URL of the Sharepoint site
    site_url = function() {
      private$.site_url
    },
    #' @field path [character] The whole URL path of the Sharepoint resource
    path = function() {
      private$.path
    }
  ),
  private = list(
    .token = character(0),
    .folder = NULL,
    .site_url = character(0),
    .path = character(0)
  ),
  cloneable = FALSE
)

#' Create sharepoint connector object
#'
#' @description Create a new sharepoint connector object. See [ConnectorSharepoint] for details.
#'
#' @param site_url The URL of the Sharepoint site
#' @param token The Azure token. By default, it will be retrieve by [get_token]
#' @param path_of_folder The path of the folder to interact with, if you don't want to
#' interact with the root folder "Documents" #nolint
#' @param ... Additional parameters to pass to the [ConnectorSharepoint] object
#' @param extra_class [character] Extra class added to the object.
#'
#' @return A new [ConnectorSharepoint] object
#'
#' @details
#' The `extra_class` parameter allows you to create a subclass of the `ConnectorSharepoint` object.
#' This can be useful if you want to create a custom connection object for
#' easier dispatch of new s3 methods,
#' while still inheriting the methods from the `ConnectorSharepoint` object.
#'
#' @examplesIf not_on_ci()
#' # Connect
#' cs <- connector_sharepoint(Sys.getenv("SHAREPOINT_SITE_URL"))
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
connector_sharepoint <- function(
    site_url,
    token = get_token(),
    path_of_folder = NULL,
    ...,
    extra_class = NULL) {
  ConnectorSharepoint$new(
    site_url = site_url,
    token = token,
    path_of_folder = path_of_folder,
    ...,
    extra_class = extra_class
  )
}

#' @title Connector Object for Sharepoint class, built on top of [connector::Connector] class
#' @description This object is used to interact with Sharepoint, adding the ability to
#' list, read, write, download, upload, create directories and remove files.
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
#' @name ConnectorSharepoint_object
#'
#' @examplesIf not_on_ci()
#' # Connect to Sharepoint
#' cs <- ConnectorSharepoint$new(
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
ConnectorSharepoint <- R6::R6Class(
  classname = "ConnectorSharepoint",
  inherit = connector::ConnectorFS,
  public = list(
    #' @description Initializes the ConnectorSharepoint class
    #' @param site_url The URL of the Sharepoint site
    #' @param token The Azure token. By default, it will be retrieve by [get_token]
    #' @param path_of_folder The path of the folder to interact with, if you don't
    #' want to interact with the root folder "Documents"
    #' @param ... Additional parameters to pass to the [get_sharepoint_site] function
    #' @param extra_class [character] Extra class added to the object.
    #' @return A [ConnectorSharepoint] object
    initialize = function(site_url,
                          token = get_token(),
                          path_of_folder = NULL,
                          ...,
                          extra_class = NULL) {
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
      folder <- Microsoft365R::get_sharepoint_site(
        site_url = site_url,
        token = token,
        ...
      )$get_drive()

      if (!is.null(path_of_folder)) {
        zephyr::msg_debug("Setting up subfolder path define by path_of_folder")
        folder <- folder$get_item(path_of_folder)
        if (!folder$is_folder()) {
          cli::cli_abort("The path provided is not a folder")
        }
      }

      checkmate::assert_character(extra_class, null.ok = TRUE)
      class(self) <- c(extra_class, class(self))

      ## set up the private variables
      private$.token <- token
      private$.site_url <- site_url
      private$.folder <- folder
      private$.path <- paste0(site_url, path_of_folder, collapse = "/")
    },
    #' @description Get the connection
    #' @return The connection
    get_conn = function() {
      private$.folder
    },
    #' @description Upload a folder
    #' @param folder Local folder path
    #' @param name Folder name to be used when uploaded
    #' @param ... additional paramaeters passed on to `upload_folder()` method
    #' of [Microsoft365R::ms_drive()] class or to `upload()` method of [Microsoft365R::ms_drive_item()] class.
    #' @param recursive  If `recursive` is `TRUE`, all subfolders will also
    #' be transferred recursively. Default: `FALSE`
    #' @return [ConnectorSharepoint] object
    upload_directory_cnt = function(folder,
                                    name = basename(folder),
                                    ...,
                                    recursive = FALSE) {
      upload_directory_cnt(self, folder, name, ..., recursive)
    }
  ),
  active = list(
    #' @field folder [character] The path of the folder to interact with
    folder = function(value) {
      if (missing(value)) {
        private$.folder
      } else {
        stop("Can't set `$folder` field", call. = FALSE)
      }
    },
    #' @field token [character] The Azure token
    token = function(value) {
      if (missing(value)) {
        private$.token
      } else {
        stop("Can't set `$token` field", call. = FALSE)
      }
    },
    #' @field site_url [character] The URL of the Sharepoint site
    site_url = function(value) {
      if (missing(value)) {
        private$.site_url
      } else {
        stop("Can't set `$site_url` field", call. = FALSE)
      }
    },
    #' @field path [character] The whole URL path of the Sharepoint resource
    path = function(value) {
      if (missing(value)) {
        private$.path
      } else {
        stop("Can't set `$path` field", call. = FALSE)
      }
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

#' Retrieve a token from the AzureAuth package
#'
#' @param hash The hash of the token to use. By default, use this function to retrieve it [get_default_hash]. If not found, use the first token found. #nolint
#'
#' @return A token
#' @export
#'
#' @importFrom AzureAuth list_azure_tokens
#' @importFrom checkmate assert_character
get_token <- function(hash = get_default_hash()) {
  checkmate::assert_character(hash, null.ok = TRUE)

  tokens <- AzureAuth::list_azure_tokens()

  if (length(tokens) == 0) {
    cli::cli_abort("Please create your token first, to do so, follow the guideline")
  }

  if (is.null(hash)) {
    cli::cli_alert_info("No hash provided or found, using the first token found")
    hash <- 1
  }

  token <- tokens[[hash]]

  return(token)
}


#' @noRd
get_tk_active_file <- function() {
  active_file <- file.path(AzureAuth::AzureR_dir(), ".active_hash")
  if (!file.exists(active_file)) {
    return(NULL)
  }
  return(active_file)
}

#' @noRd
edit_tk_active_file <- function() {
  active_file <- get_tk_active_file()
  # TODO not only for Rstudio..
  utils::file.edit(active_file)
}

#' @noRd
get_tk_hash_sharepoint <- function() {
  file_ <- get_tk_active_file()
  if (is.null(file_)) {
    cli::cli_alert_danger("No active hash file found.")
    return(NULL)
  }
  cli::cli_alert_info("Active hash file found, using it to get the hash.")

  hash <- readLines(file_) %>%
    grep(pattern = "^SHAREPOINT", value = TRUE)

  if (length(hash) == 0) {
    cli::cli_alert_danger("SHAREPOINT key not found in the active hash file.")
    return(NULL)
  }

  hash_f <- sub(pattern = '^SHAREPOINT="([a-zA-Z0-9]{6,})"', replacement = "\\1", hash)

  return(hash_f)
}

#' Get the default hash
#'
#' Two solutions are possible:
#' 1. The user has set the environment variable SHAREPOINT_AZURE_HASH
#' 2. The user has set the file .active_hash in the AzureR directory
#'
#' @importFrom cli cli_alert_danger
#' @export
get_default_hash <- function() {
  hash <- Sys.getenv("SHAREPOINT_AZURE_HASH")
  if (hash == "") {
    # try to find a .active_hash file
    cli::cli_alert_danger("No SHAREPOINT_AZURE_HASH env found, trying to find a .active_hash file")
    hash <- get_tk_hash_sharepoint()
  }

  return(hash)
}

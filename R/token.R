#' Retrive a token from the AzureAuth package
#'
#' @param hash The hash of the token to use, if not provided, the first one will be used
#'
#' @return A token
#' @export
#'
#' @importFrom AzureAuth list_azure_tokens
get_token <- function(hash = Sys.getenv("AZURE_HASH")) {
  tokens <- AzureAuth::list_azure_tokens()

  if (is.null(tokens)) {
    stop("Please create your token first, to do so, follow the guidline")
  }

  if (hash == "") {
    message("Please set up the environment variable AZURE_HASH with the hash of the token to use.
            Instead, We will use the first one.")
    hash <- names(tokens)[1]
  }

  token <- tokens[[hash]]

  if (is.null(token)) {
    stop("Token not found, please create your token first and/or
       set up the environment variable AZURE_HASH with the hash of the token")
  }

  return(token)
}

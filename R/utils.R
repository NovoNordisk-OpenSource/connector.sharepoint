#' Running on CI or not.
#'
#' @return logical
#' @export
#'
not_on_ci <- function() {
  !(
    isTRUE(
      as.logical(
        Sys.getenv("CI", "false")
      )
    )
  )
}

on_ci <-  isTRUE(
  as.logical(
    Sys.getenv("CI")
  )
)

## Setup

if(!on_ci){

  my_site <- Microsoft365R::list_sharepoint_sites(token = suppressMessages(get_token()))[[1]]$properties$webUrl

  cli::cli_alert_info("Using {my_site} for tests")

  ## stop now if no site found
  if (length(my_site) == 0) {
    cli::cli_abort("No site found")
  }

}

## Clean up
if(!on_ci){
withr::defer({
  cli::cli_alert_info("Cleaning up your site {my_site}")
  my_drive <- suppressMessages(connector_sharepoint(my_site))
  try(my_drive$remove("Test_453frg6g", confirm = FALSE), silent = TRUE)
}, teardown_env())
}

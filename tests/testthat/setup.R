on_ci <- isTRUE(
  as.logical(
    Sys.getenv("CI")
  )
)

## Setup

if (!on_ci) {
  my_site <- Sys.getenv("SHAREPOINT_SITE_URL")

  ## stop now if no site found
  if (length(my_site) == 0) {
    cli::cli_abort("No site found")
  }

  cli::cli_alert_info("Using {my_site} for tests")
}


withr::local_options(
  .new = list(
    connector.sharepoint.verbosity_level = "quiet",
    zephyr.verbosity_level = "quiet"
  ),
  .local_envir = teardown_env()
)

skip_on_ci()

my_site <- Sys.getenv("SHAREPOINT_SITE_URL")

## stop now if no site found
if (length(my_site) == 0) {
  cli::cli_abort("No site found")
}

cli::cli_alert_info("Using {my_site} for tests")

# just to have clean messages in tests
quiet_connect <- function(...) {
  suppressMessages(connector_sharepoint(...))
}

# Connect
test_drive <- quiet_connect(site_url = my_site)

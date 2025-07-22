withr::local_options(
  .new = list(
    connector.sharepoint.verbosity_level = "quiet",
    zephyr.verbosity_level = "quiet"
  ),
  .local_envir = teardown_env()
)

# just to have clean messages in tests
quiet_connect <- function(...) {
  suppressMessages(connector_sharepoint(...))
}

my_site <- Sys.getenv("SHAREPOINT_SITE_URL")

if (my_site == "") {
  cli::cli_alert_info("No site found, skipping tests.")
} else {
  cli::cli_alert_info("Using {my_site} for tests")
  setup_connector <- quiet_connect(site_url = my_site)
}

withr::local_options(
  .new = list(
    connector.sharepoint.verbosity_level = "quiet",
    zephyr.verbosity_level = "quiet"
  ),
  .local_envir = teardown_env()
)

testing_env_variables <- c(
  "SHAREPOINT_SITE_URL"
)

# Utility function for skipping tests if ENV variables are not set
skip_offline_test <- function() {
  skip_if(!all(testing_env_variables %in% names(Sys.getenv())), message = NULL)
}

# just to have clean messages in tests
quiet_connect <- function(...) {
  suppressMessages(connector_sharepoint(...))
}

if (!all(testing_env_variables %in% names(Sys.getenv()))) {
  cli::cli_alert_warning(
    "Not all testing parameters are set. Please set environment variable
      SHAREPOINT_SITE_URL in order to be able to test the whole package."
  )
} else {
  setup_site_url <- Sys.getenv("SHAREPOINT_SITE_URL")
  cli::cli_alert_info("Using {setup_site_url} for tests")
  setup_connector <- quiet_connect(site_url = setup_site_url)
}

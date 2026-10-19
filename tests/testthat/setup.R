withr::local_options(
  .new = list(
    connector.sharepoint.verbosity_level = "quiet",
    zephyr.verbosity_level = "quiet"
  ),
  .local_envir = teardown_env()
)

cli::cli_alert_info("SharePoint test backend: {sharepoint_backend()}")

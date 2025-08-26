skip_offline_test()
skip_if_not_installed("whirl")

sharepoint_connector <- connector.sharepoint::ConnectorSharepoint$new(
  site_url = setup_site_url,
  extra_class = "connector_logger"
)

test_that("log_read_connector for sharepoint sites logs correct message", {
  # Create mock for whirl::log_read
  log_mock <- mockery::mock()
  mockery::stub(
    log_read_connector.ConnectorSharepoint,
    "whirl::log_read",
    log_mock
  )

  # Test the function
  log_read_connector.ConnectorSharepoint(sharepoint_connector, "test.csv")

  # Verify log_read was called with correct message
  expected_msg <- glue::glue("test.csv @ {setup_site_url}/")
  mockery::expect_called(log_mock, 1)
  mockery::expect_args(log_mock, 1, expected_msg)
})

test_that("log_write_connector for sharepoint sites logs correct message", {
  # Create mock for whirl::log_write
  log_mock <- mockery::mock()
  mockery::stub(
    log_write_connector.ConnectorSharepoint,
    "whirl::log_write",
    log_mock
  )

  # Test the function
  log_write_connector.ConnectorSharepoint(
    sharepoint_connector,
    "test.csv"
  )

  # Verify log_write was called with correct message
  expected_msg <- glue::glue("test.csv @ {setup_site_url}/")
  mockery::expect_called(log_mock, 1)
  mockery::expect_args(log_mock, 1, expected_msg)
})

test_that("log_remove_connector for sharepoint sites logs correct message", {
  # Create mock for whirl::log_delete
  log_mock <- mockery::mock()
  mockery::stub(
    log_remove_connector.ConnectorSharepoint,
    "whirl::log_delete",
    log_mock
  )

  # Test the function
  log_remove_connector.ConnectorSharepoint(
    sharepoint_connector,
    "test.csv"
  )

  # Verify log_delete was called with correct message
  expected_msg <- glue::glue("test.csv @ {setup_site_url}/")
  mockery::expect_called(log_mock, 1)
  mockery::expect_args(log_mock, 1, expected_msg)
})

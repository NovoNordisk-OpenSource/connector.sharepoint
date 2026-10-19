skip_if_not_installed("whirl")

local_whirl_log <- function(env = parent.frame()) {
  log <- withr::local_tempfile(.local_envir = env)
  withr::local_envvar(WHIRL_LOG_MSG = log, .local_envir = env)
  log
}

# `time` changes on every run, so only `type` and `file` are compared
expect_whirl_logged <- function(log, type, file) {
  entries <- jsonlite::stream_in(base::file(log), verbose = FALSE)
  expect_equal(entries[c("type", "file")], data.frame(type = type, file = file))
}

test_that("log_read_connector logs a read of the file with drive details", {
  # Arrange
  con <- local_test_connector()
  log <- local_whirl_log()

  # Act
  log_read_connector(con, "test.csv")

  # Assert
  drive <- con$get_conn()$properties
  expected <- sprintf(
    "test.csv @ path: %s, driveType: %s, id: %s, description: %s",
    con$path,
    drive$driveType,
    drive$id,
    drive$description
  )
  expect_whirl_logged(log, type = "read", file = expected)
})

test_that("log_write_connector logs a write of the file with drive details", {
  # Arrange
  con <- local_test_connector()
  log <- local_whirl_log()

  # Act
  log_write_connector(con, "test.csv")

  # Assert
  drive <- con$get_conn()$properties
  expected <- sprintf(
    "test.csv @ path: %s, driveType: %s, id: %s, description: %s",
    con$path,
    drive$driveType,
    drive$id,
    drive$description
  )
  expect_whirl_logged(log, type = "write", file = expected)
})

test_that("log_remove_connector logs a delete of the file with drive details", {
  # Arrange
  con <- local_test_connector()
  log <- local_whirl_log()

  # Act
  log_remove_connector(con, "test.csv")

  # Assert
  drive <- con$get_conn()$properties
  expected <- sprintf(
    "test.csv @ path: %s, driveType: %s, id: %s, description: %s",
    con$path,
    drive$driveType,
    drive$id,
    drive$description
  )
  expect_whirl_logged(log, type = "delete", file = expected)
})

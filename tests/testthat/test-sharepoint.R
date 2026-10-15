test_that("ConnectorSharepoint creation fails with invalid parameters", {
  withr::local_options(list(connector.verbosity_level = "quiet"))

  expect_error(ConnectorSharepoint$new(site_url = 1))

  expect_error(ConnectorSharepoint$new(site_url = "not-a-url"))

  expect_error(ConnectorSharepoint$new(
    site_url = "https://valid-url.com",
    token = "invalid"
  ))

  expect_error(ConnectorSharepoint$new(
    site_url = "https://valid-url.com",
    folder = 1
  ))

  expect_error(ConnectorSharepoint$new(
    site_url = "https://valid-url.com",
    extra_class = 1
  ))
})

test_that("connector_sharepoint errors when site_url is not an http(s) URL", {
  # Act, Assert
  expect_error(quiet_connect("www.google.com"), "valid URL")
})

test_that("connector_sharepoint errors when token is not an Azure token", {
  # Act, Assert
  expect_error(
    quiet_connect(test_site_url(), token = "a weird token"),
    "not a valid Azure token"
  )
})

test_that("connector_sharepoint errors when folder points to a file", {
  # Arrange
  con <- local_test_connector()
  put_remote_csv(con, "iris.csv", iris)

  # Act, Assert
  expect_error(
    quiet_connect(test_site_url(), folder = drive_path(con, "iris.csv")),
    "not a folder"
  )
})

test_that("connector_sharepoint puts extra_class before ConnectorSharepoint", {
  # Act
  con <- local_test_connector(extra_class = "extra")

  # Assert
  expect_equal(class(con)[1:2], c("extra", "ConnectorSharepoint"))
})

test_that("connector exposes site_url, folder and token it was opened with", {
  # Arrange
  con <- local_test_connector()
  folder <- drive_path(con, "sub")
  put_remote_folder(con, "sub")

  # Act
  result <- quiet_connect(test_site_url(), token = con$token, folder = folder)

  # Assert
  expect_equal(result$site_url, test_site_url())
  expect_equal(result$folder, folder)
  expect_identical(result$token, con$token)
})

test_that("connector fields are read-only", {
  # Arrange
  con <- local_test_connector()

  # Act, Assert
  expect_error(con$folder <- "x", "Can't set `\\$folder`")
  expect_error(con$token <- "x", "Can't set `\\$token`")
  expect_error(con$site_url <- "x", "Can't set `\\$site_url`")
  expect_error(con$path <- "x", "Can't set `\\$path`")
})

describe("connector path", {
  it("should be site_url followed by a slash when no folder is given", {
    # Arrange
    token <- local_test_connector()$token

    # Act
    con <- quiet_connect(test_site_url(), token = token)

    # Assert
    expect_equal(con$path, paste0(test_site_url(), "/"))
  })

  it("should join site_url and folder with a slash", {
    testthat::skip(paste(
      "TODO: (bug) site_url '.../sites/team' with folder 'data' gives",
      "con$path '.../sites/teamdata/' instead of '.../sites/team/data'.",
      "Decide whether path ends with '/', then test it."
    ))
  })
})

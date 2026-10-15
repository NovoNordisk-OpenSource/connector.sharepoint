# Every SharePoint test runs against one backend, chosen with the
# SHAREPOINT_TEST_BACKEND environment variable:
#
# - "fake" (default): FakeMicrosoft365RDrive on a local temp dir. No network or
#   token.
# - "live": the real site at SHAREPOINT_SITE_URL, using the cached AzureAuth
#   token found by get_token().
#
# Tests only touch the backend through local_test_connector(), so the same
# test body runs unchanged on both.

sharepoint_backend <- function() {
  backend <- Sys.getenv("SHAREPOINT_TEST_BACKEND", "fake")
  match.arg(backend, c("fake", "live"))
}

test_site_url <- function() {
  Sys.getenv(
    "SHAREPOINT_SITE_URL",
    "https://example.sharepoint.com/sites/connector-test"
  )
}

# Stands in for an AzureToken where no tenant is involved. The R6 class name
# "AzureToken" satisfies AzureAuth::is_azure_token(); the fields cover what
# AzureGraph reads when it builds a request.
FakeToken <- R6::R6Class(
  "AzureToken",
  public = list(
    version = 2,
    tenant = "fake",
    scope = "https://graph.microsoft.com/.default",
    credentials = list(token_type = "Bearer", access_token = "fake-token"),
    validate = function() TRUE,
    refresh = function() invisible(self)
  )
)

# Points Microsoft365R and get_token() at a FakeMicrosoft365RDrive on a temp
# dir until `env` ends, and returns the token to connect with.
local_fake_sharepoint <- function(env = parent.frame()) {
  drive <- FakeMicrosoft365RDrive$new(withr::local_tempdir(.local_envir = env))
  testthat::local_mocked_bindings(
    get_sharepoint_site = function(...) list(get_drive = function() drive),
    .package = "Microsoft365R",
    .env = env
  )
  token <- FakeToken$new()
  # Connectors reopened by create_directory_cnt(open = TRUE) and
  # upload_directory_cnt(open = TRUE) call get_token() themselves
  testthat::local_mocked_bindings(get_token = function(...) token, .env = env)
  token
}

# A ConnectorSharepoint opened on an empty folder that is removed when the
# calling test ends. The random folder name keeps concurrent runs on a live
# backend apart.
local_test_connector <- function(
  ...,
  backend = sharepoint_backend(),
  env = parent.frame()
) {
  token <- switch(
    backend,
    fake = local_fake_sharepoint(env),
    live = get_token()
  )
  folder <- basename(tempfile("connector-sharepoint-test-"))

  drive <- quiet_connect(test_site_url(), token = token)$get_conn()
  withr::defer(
    drive$get_item(folder)$delete(confirm = FALSE, by_item = TRUE),
    envir = env
  )
  drive$create_folder(folder)

  quiet_connect(test_site_url(), token = token, folder = folder, ...)
}

# Seed remote state through the drive, so that
# - broken connector$write_cnt doesn't affect connector$read_cnt tests,
# - broken connector$read_cnt doesn't affect connector$write_cnt tests.

drive_path <- function(con, name) {
  paste(con$folder, name, sep = "/")
}

put_remote_csv <- function(con, name, x) {
  src <- withr::local_tempfile(fileext = ".csv")
  utils::write.csv(x, src, row.names = FALSE)
  con$get_conn()$upload_file(src, drive_path(con, name))
  invisible(name)
}

put_remote_folder <- function(con, name) {
  con$get_conn()$create_folder(drive_path(con, name))
  invisible(name)
}

get_remote_lines <- function(con, name) {
  dest <- withr::local_tempfile()
  con$get_conn()$get_item(drive_path(con, name))$download(dest)
  readLines(dest)
}

list_remote <- function(con, folder = ".") {
  path <- if (folder == ".") con$folder else drive_path(con, folder)
  con$get_conn()$list_items(path)$name
}

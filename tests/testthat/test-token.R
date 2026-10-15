# Token lookup only reads the local AzureR directory, so these tests run the
# same on every backend: the directory is a temp dir and the token cache is
# stubbed at the AzureAuth boundary.

local_token_cache <- function(tokens = list(), env = parent.frame()) {
  withr::local_envvar(
    R_AZURE_DATA_DIR = withr::local_tempdir(.local_envir = env),
    SHAREPOINT_AZURE_HASH = NA,
    .local_envir = env
  )
  testthat::local_mocked_bindings(
    list_azure_tokens = function(...) tokens,
    .package = "AzureAuth",
    .env = env
  )
}

write_active_hash <- function(lines) {
  writeLines(lines, file.path(AzureAuth::AzureR_dir(), ".active_hash"))
}

describe("get_token", {
  it("should error when no token is cached", {
    # Arrange
    local_token_cache(list())

    # Act, Assert
    expect_error(get_token(), "create your token first")
  })

  it("should return the token named by SHAREPOINT_AZURE_HASH", {
    # Arrange
    local_token_cache(list(aaaaaa = "first", bbbbbb = "second"))
    withr::local_envvar(SHAREPOINT_AZURE_HASH = "bbbbbb")

    # Act
    result <- get_token()

    # Assert
    expect_equal(result, "second")
  })

  it("should return the first cached token when no hash is configured", {
    # Arrange
    local_token_cache(list(aaaaaa = "first", bbbbbb = "second"))

    # Act
    result <- get_token()

    # Assert
    expect_equal(result, "first")
  })
})

describe("get_default_hash", {
  it("should prefer SHAREPOINT_AZURE_HASH over the .active_hash file", {
    # Arrange
    local_token_cache()
    write_active_hash('SHAREPOINT="fromfile"')
    withr::local_envvar(SHAREPOINT_AZURE_HASH = "fromenv")

    # Act
    result <- get_default_hash()

    # Assert
    expect_equal(result, "fromenv")
  })

  it("should read the SHAREPOINT hash from .active_hash if env var is unset", {
    # Arrange
    local_token_cache()
    write_active_hash(c('OTHER="zzzzzz"', 'SHAREPOINT="abc123"'))

    # Act
    result <- get_default_hash()

    # Assert
    expect_equal(result, "abc123")
  })

  it("should return NULL when .active_hash has no SHAREPOINT entry", {
    # Arrange
    local_token_cache()
    write_active_hash('OTHER="zzzzzz"')

    # Act
    result <- get_default_hash()

    # Assert
    expect_null(result)
  })

  it("should return NULL when there is no .active_hash file", {
    # Arrange
    local_token_cache()

    # Act
    result <- get_default_hash()

    # Assert
    expect_null(result)
  })

  it("should reject a SHAREPOINT hash shorter than 6 characters", {
    testthat::skip(paste(
      "TODO: the hash regex requires 6+ alphanumerics. A shorter",
      "value does not match, so the whole line 'SHAREPOINT=\"abc12\"' is",
      "returned as the hash. Should that error, return NULL, or be accepted?"
    ))
  })
})

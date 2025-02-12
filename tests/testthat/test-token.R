test_that("Test set up of Token", {
  skip_on_ci()
  hash <- names(list_azure_tokens())[1]

  ## Use the var env
  withr::with_envvar(c("SHAREPOINT_AZURE_HASH" = hash), {
    messages <- capture_messages(get_token())
    expect_false(
      any(grepl(x = messages, pattern = "No SHAREPOINT_AZURE_HASH env found"))
    )
  })

  ## Error if no token
  withr::with_envvar(c("R_AZURE_DATA_DIR" = "~"), {
    quiet_token <- function(...) {
      suppressMessages(get_token(...))
    }

    expect_error(quiet_token())
  })

  ## Manipulate .active_file
  file.rename(from = get_tk_active_file(), to = file.path(AzureAuth::AzureR_dir(), ".old_hash"))
  messages_a <- capture_messages(get_token())

  expect_true(
    any(grepl(x = messages_a, pattern = "No hash provided or found, using the first token found"))
  )

  ## create one without SHAREPOINT
  file.create(file.path(AzureAuth::AzureR_dir(), ".active_hash"))
  messages_s <- capture_messages(get_token())
  expect_true(
    any(grepl(x = messages_s, pattern = "SHAREPOINT key not found in the active hash file"))
  )
  file.remove(file.path(AzureAuth::AzureR_dir(), ".active_hash"))

  ## Restore .active_file
  file.rename(
    from = file.path(AzureAuth::AzureR_dir(), ".old_hash"),
    to = file.path(AzureAuth::AzureR_dir(), ".active_hash")
  )
})

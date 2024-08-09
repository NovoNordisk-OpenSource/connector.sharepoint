test_that("Manipulate options", {
  skip_on_ci()
  expect_equal(options::opt("verbosity_level"), "verbose")


  options::opt_set("verbosity_level", "debug")
  expect_equal(options::opt("verbosity_level"), "debug")

  messages <- capture_messages(connector_sharepoint(my_site))
  expect_true(
    sum(grepl(x = messages, pattern = "Active hash file found, using it to get the hash")) == 1
  )
  options::opt_set("verbosity_level", "verbose")
})

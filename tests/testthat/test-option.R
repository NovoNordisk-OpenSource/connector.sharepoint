test_that("Manipulate options",{
  skip_on_ci()
  expect_equal(options::opt("verbosity_level"), "verbose")


    options::opt_set("verbosity_level", "debug")
    expect_equal(options::opt("verbosity_level"), "debug")

    messages <- capture_messages(connector_sharepoint(my_site))
    expect_true(
      sum(grepl(x = messages, pattern = "Setting up the private variables|Define the path of the folder")) == 2
    )
    options::opt_set("verbosity_level", "verbose")

})

test_that("Testing utils", {
  skip_on_ci()
  checkmate::expect_logical(not_on_ci())
})

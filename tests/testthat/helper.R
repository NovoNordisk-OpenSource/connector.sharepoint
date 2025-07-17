local_create_directory <- function(
  site_url = NULL,
  ...,
  env = parent.frame()
) {
  # Generate test directory name
  test_dir <- test_directory_name()

  test_sharepoint <- suppressMessages(connector_sharepoint(site_url))

  # Create test directory
  test_sharepoint |>
    create_directory_cnt(test_dir) |>
    expect_no_error()

  # Create connection to test directory
  con <- ConnectorSharepoint$new(
    site_url = test_sharepoint$site_url,
    path_of_folder = test_dir,
    ...
  )

  withr::defer(
    {
      test_sharepoint$remove_cnt(test_dir, confirm = FALSE)
      rm(con)
    },
    envir = env
  )

  con
}

local_download_sharepoint_file <- function(
  con = NULL,
  file_name = NULL,
  env = parent.frame()
) {
  con |>
    download_cnt(file_name, file_name, overwrite = TRUE)

  withr::defer(unlink(file_name), envir = env)

  file_name
}

test_directory_name <- function(prefix = "test_", length = 10) {
  random_string <- paste0(
    sample(c(letters, LETTERS, 0:9), length, replace = TRUE),
    collapse = ""
  )
  result <- paste0(prefix, random_string)
  return(result)
}

test_file_name <- function(prefix = "test_", suffix = ".csv", length = 10) {
  random_string <- paste0(
    sample(c(letters, LETTERS, 0:9), length, replace = TRUE),
    collapse = ""
  )
  result <- paste0(prefix, random_string, suffix)
  return(result)
}

# make iris a tbl
tbl_iris <- tibble::as_tibble(iris, rownames = NULL)

## remove factors, read and write not working with factors
tbl_iris$Species <- as.character(tbl_iris$Species)

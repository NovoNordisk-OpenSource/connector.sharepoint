# make iris a tbl
tbl_iris <- tibble::as_tibble(iris, rownames = NULL)
## remove factors, read and write not working with factors
tbl_iris$Species <- as.character(tbl_iris$Species)

# just to have clean messages in tests
quiet_connect <- function(...) {
  suppressMessages(connector_sharepoint(...))
}

if (!on_ci) {
  # Connect
  test_drive <- quiet_connect(site_url = my_site)
}

test_that("Testing General connector_sahrepoint", {
  skip_on_ci()

  ###############
  ### GENERAL
  ##############

  expect_true(inherits(test_drive, "Connector_sharepoint"))

  ## Extra class

  extra_class_ <- quiet_connect(my_site, extra_class = "test")
  expect_true(inherits(extra_class_, "test"))

  ## Errors

  ##### Not a sharepoint URL
  expect_error(quiet_connect("https://www.google.com"))

  #### Expected a http or https URL
  expect_error(quiet_connect("www.google.com"))

  #### Not a expected token
  expect_error(quiet_connect(my_site, token = "a weird token"))
})

test_that("Testing connector_sharepoint methods", {
  skip_on_ci()
  my_drive <- suppressMessages(local_create_sharepoint_directory(site_url = my_site))
  ###############
  ### Methods
  ###############

  # List content
  contents <- my_drive$list_content_cnt() |>
    expect_no_condition()

  # Write a file
  my_drive$write_cnt(tbl_iris, "iris.csv") |>
    expect_equal(my_drive)

  # Read a file
  my_drive$read_cnt("iris.csv", show_col_types = FALSE) |>
    expect_equal(tbl_iris)

  # Remove a file or directory
  my_drive$remove_cnt("iris.csv", confirm = FALSE) |>
    expect_no_condition()

  # Create a directory
  new_directory <- my_drive$create_directory_cnt("new_directory", open = FALSE)

  checkmate::expect_r6(new_directory, "Connector_sharepoint")
  expect_equal(my_drive$folder$get_path(), new_directory$folder$get_path())
  
  new_directory_open <- my_drive$create_directory_cnt("new_directory_open", open = TRUE)
  expect_equal(new_directory_open$folder$get_path(), paste0(my_drive$folder$get_path(), "/new_directory_open"))
  my_drive$remove_directory_cnt(name = "new_directory_open", confirm = FALSE)
  
  my_drive$create_directory_cnt("new_directory") |>
    expect_error()

  contents <- my_drive$list_content_cnt()

  expect_true(nrow(contents) == 1)

  contents_new_dir <- my_drive$list_content_cnt("new_directory")

  expect_true(nrow(contents_new_dir) == 0)

  # Remove a file or directory

  my_drive$remove_cnt("new_directory", confirm = FALSE) |>
    expect_no_condition()
})

test_that("Testing connector_sharepoint methods with a specific folder", {
  skip_on_ci()
  my_drive <- suppressMessages(local_create_sharepoint_directory(site_url = my_site))

  #########################
  ### For a specific folder
  #########################

  dir_name <- test_directory_name()
  test_folder <- my_drive$create_directory_cnt(dir_name)

  contents <- test_folder$list_content_cnt()

  expect_true(nrow(contents) == 0)

  test_folder$write_cnt(tbl_iris, "iris.csv") |>
    expect_equal(test_folder)

  test_folder$read_cnt("iris.csv", show_col_types = FALSE) |>
    expect_equal(tbl_iris)

  # Remove a file or directory
  my_drive$remove_cnt(dir_name, confirm = FALSE) |>
    expect_no_condition()
})

test_that("Testing connector_sharepoint specific outputs for methods", {
  skip_on_ci()
  my_drive <- suppressMessages(local_create_sharepoint_directory(site_url = my_site))
  #########################
  ### Specific to methods
  #########################

  # Create a folder and file
  dir_name <- test_directory_name()
  subfolder <- my_drive$create_directory_cnt(dir_name)
  my_drive$write_cnt(iris, paste0(dir_name,"/iris.csv"))

  ## Check error for read_cnt fo a folder

  my_drive$read_cnt("dir_name", show_col_types = FALSE) |>
    expect_error()

  my_drive$read_cnt(paste0(dir_name, "/iris.csv"), show_col_types = FALSE) |>
    expect_no_error()

  ## Check error for write of non character

  my_drive$write_cnt("iris", paste0(dir_name, "/iris.csv")) |>
    expect_error()

  ### Upload and download

  ### file
  tmp_file <- tempfile(fileext = ".example")
  tmp_file_d <- tempfile(pattern = "downloaded", fileext = ".example")
  write.csv(iris, tmp_file, row.names = FALSE)

  my_drive$upload_cnt(src = tmp_file, paste0(dir_name, "/iris.example")) |>
    expect_no_error()

  my_drive$download_cnt(name = paste0(dir_name, "/iris.example"), file = tmp_file_d) |>
    expect_no_error()

  path_ <- my_drive$get_conn()$get_item(paste0(dir_name, "/iris.example"))$get_path()

  expect_equal(path_, paste0(my_drive$folder$get_path(), paste0("/", dir_name, "/iris.example")))

  #### Dirs

  tmp_dir <- tempfile(pattern = "test_dir")
  dir.create(tmp_dir)
  dir_d <- tempfile("dir_d")
  dir.create(dir_d)

  withr::with_dir(tmp_dir, {
    write.csv(iris, "iris.csv", row.names = FALSE)
  })

  # Upload directory
  my_drive$upload_cnt(src = tmp_dir, paste0(dir_name,"/dir")) |>
    expect_no_error()

  subfolder$upload_cnt(tmp_dir, "dir_sub") |>
    expect_no_error()

  ### Error not existing
  my_drive$upload_cnt(src = "notexits", paste0(dir_name, "/dir")) |>
    expect_error() |>
    expect_warning()

  dir_ <- my_drive$get_conn()$get_item(paste0(dir_name,"/dir"))

  expect_true(dir_$is_folder())

  ## Download directory
  my_drive$download_cnt(name = paste0(dir_name, "/dir"), file = dir_d) |>
    expect_no_error()

  list.files(dir_d) |>
    expect_equal("iris.csv")


  #### Read a folder
  my_drive$read_cnt(dir_name) |>
    expect_error()

  ### Using vroom
  my_drive$read_cnt(paste0(dir_name, "/iris.example"), show_col_types = FALSE) |>
    expect_no_error()

  ### Clean up
  my_drive$remove_cnt(dir_name, confirm = FALSE)
})


test_that("test when path to a folder is not a folder", {
  skip_on_ci()
  my_drive <- suppressMessages(local_create_sharepoint_directory(site_url = my_site))

  ## create a file
  dir_name <- test_directory_name()
  my_drive$create_directory_cnt(dir_name)
  my_drive$write_cnt(iris, paste0(dir_name, "/iris.csv"))

  # Path is not a folder
  quiet_connect(
    my_site,
    path_of_folder = paste0(dir_name, "/iris.csv")
  ) |>
    expect_error()

  # clean up
  my_drive$remove_cnt(dir_name, confirm = FALSE)
})

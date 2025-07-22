test_that("Testing General connector_sharepoint", {
  ## Errors
  ##### Not a sharepoint URL
  expect_error(quiet_connect("https://www.google.com"))

  #### Expected a http or https URL
  expect_error(quiet_connect("www.google.com"))

  #### Not a expected token
  expect_error(quiet_connect(my_site, token = "a weird token"))

  skip_on_ci()

  expect_true(inherits(setup_connector, "ConnectorSharepoint"))
  ## Extra class
  extra_class_ <- quiet_connect(my_site, extra_class = "test")
  expect_true(inherits(extra_class_, "test"))

  ## Check active bindings
  expect_error(setup_connector$folder <- "new_folder_name")
  expect_error(setup_connector$token <- "new_token_value")
  expect_error(setup_connector$site_url <- "new_site_url")
  expect_error(setup_connector$path <- "new_path_name")
})

test_that("Testing ConnectorSharepoint methods", {
  skip_on_ci()
  my_drive <- suppressMessages(local_create_directory(site_url = my_site))

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

  checkmate::expect_r6(new_directory, "ConnectorSharepoint")
  expect_equal(my_drive$folder, new_directory$folder)

  new_directory_open <- my_drive$create_directory_cnt(
    "new_directory_open",
    open = TRUE
  )
  expect_equal(
    new_directory_open$folder,
    paste(my_drive$folder, "new_directory_open", sep = "/")
  )

  my_drive$remove_directory_cnt(name = "new_directory_open", confirm = FALSE)

  my_drive$create_directory_cnt("new_directory") |>
    expect_error()

  contents <- my_drive$list_content_cnt()

  expect_true(length(contents) == 1)

  # Remove a file or directory
  my_drive$remove_directory_cnt("new_directory", confirm = FALSE) |>
    expect_no_condition()
})

test_that("Testing ConnectorSharepoint methods with a specific folder", {
  skip_on_ci()
  my_drive <- suppressMessages(local_create_directory(site_url = my_site))

  #########################
  ### For a specific folder
  #########################

  dir_name <- test_directory_name()
  test_folder <- my_drive$create_directory_cnt(dir_name, open = TRUE)

  contents <- test_folder$list_content_cnt()

  expect_true(length(contents) == 0)

  test_folder$write_cnt(tbl_iris, "iris.csv") |>
    expect_equal(test_folder)

  test_folder$read_cnt("iris.csv", show_col_types = FALSE) |>
    expect_equal(tbl_iris)

  # Remove a file or directory
  my_drive$remove_cnt(dir_name, confirm = FALSE) |>
    expect_no_condition()
})

test_that("Testing ConnectorSharepoint specific outputs for methods", {
  skip_on_ci()
  my_drive <- suppressMessages(local_create_directory(site_url = my_site))
  #########################
  ### Specific to methods
  #########################

  # Create a folder and file
  dir_name <- test_directory_name()
  subfolder <- my_drive$create_directory_cnt(dir_name)
  my_drive$write_cnt(iris, paste0(dir_name, "/iris.csv"))

  ## Check error for read_cnt fo a folder
  my_drive$read_cnt(dir_name, show_col_types = FALSE) |>
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

  my_drive$upload_cnt(
    file = tmp_file,
    name = paste0(dir_name, "/iris.example")
  ) |>
    expect_no_error()

  my_drive$download_cnt(
    name = paste0(dir_name, "/iris.example"),
    file = tmp_file_d
  ) |>
    expect_no_error()

  path_ <- my_drive$get_conn()$get_item(
    paste(my_drive$folder, dir_name, "iris.example", sep = "/")
  )$get_path()

  expect_equal(
    path_,
    paste0("/", paste(my_drive$folder, dir_name, "iris.example", sep = "/"))
  )

  #### Dirs
  tmp_dir <- tempfile(pattern = "test_dir")
  dir.create(tmp_dir)

  withr::with_dir(tmp_dir, {
    write.csv(iris, "iris.csv", row.names = FALSE)
  })

  my_drive$upload_directory_cnt(
    dir = tmp_dir,
    name = paste0(dir_name, "/dir")
  ) |>
    expect_no_error()

  ## Download directory
  dir_d <- tempfile("dir_d")
  dir.create(dir_d)
  my_drive$download_directory_cnt(
    name = paste0(dir_name, "/dir"),
    dir = dir_d
  ) |>
    expect_no_error()

  list.files(dir_d) |>
    expect_equal("iris.csv")

  #### Read a folder
  my_drive$read_cnt(dir_name) |>
    expect_error()

  ### Using vroom
  my_drive$read_cnt(
    paste0(dir_name, "/iris.example"),
    show_col_types = FALSE
  ) |>
    expect_no_error()

  ### Clean up
  my_drive$remove_cnt(dir_name, confirm = FALSE)
})

test_that("test when path to a folder is not a folder", {
  skip_on_ci()
  my_drive <- suppressMessages(local_create_directory(site_url = my_site))

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

test_that("test folder upload works", {
  skip_on_ci()
  my_drive <- suppressMessages(local_create_directory(site_url = my_site))
  dir_name <- test_directory_name()

  tmp_dir <- tempfile(pattern = "test_dir")
  dir.create(tmp_dir)

  withr::with_dir(tmp_dir, {
    write.csv(iris, "iris.csv", row.names = FALSE)
  })

  # Upload directory fails when needed
  my_drive$upload_directory_cnt(dir = "bad_folder", name = "dir") |>
    expect_error()
  my_drive$upload_directory_cnt(dir = tmp_dir, name = 2) |>
    expect_error()

  # Upload directory
  my_drive$upload_directory_cnt(
    dir = tmp_dir,
    name = paste0(dir_name, "/dir")
  ) |>
    expect_no_error()

  # Upload directory OPEN
  new_directory_OPEN <- my_drive$upload_directory_cnt(
    dir = tmp_dir,
    name = paste0(dir_name, "/dirOPEN"),
    open = TRUE
  ) |>
    expect_no_error()

  expect_true(
    new_directory_OPEN$folder ==
      paste(my_drive$folder, dir_name, "dirOPEN", sep = "/")
  )

  # Upload directory to a directory
  new_directory <- my_drive$create_directory_cnt(name = "test_dir", open = TRUE)
  new_directory$upload_directory_cnt(
    dir = tmp_dir,
    name = paste0(dir_name, "/dir")
  ) |>
    expect_no_error()

  ### Error not existing
  my_drive$upload_cnt(src = "not_exist", paste0(dir_name, "/dir")) |>
    expect_error()

  dir_ <- my_drive$get_conn()$get_item(paste(
    my_drive$folder,
    dir_name,
    "/dir",
    sep = "/"
  ))

  expect_true(dir_$is_folder())
})

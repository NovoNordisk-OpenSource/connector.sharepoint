# make iris a tbl
tbl_iris <- tibble::as_tibble(iris, rownames = NULL)
## remove factors, read and write not working with factors
tbl_iris$Species <- as.character(tbl_iris$Species)

# just to have clean messages in tests
quiet_connect <- function(...){
  suppressMessages(connector_sharepoint(...))
}

if(!on_ci){
  # Connect
  my_drive <- quiet_connect(my_site)
}



test_that("Testing General connector_sahrepoint", {

  skip_on_ci()

  ###############
  ### GENERAL
  ##############


  expect_true(inherits(my_drive, "Connector_sharepoint"))

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

   ###############
  ### Methods
  ###############

  # List content
  contents <- my_drive$list_content()

  expect_true(nrow(contents) == 0)

  # Write a file
  my_drive$write(tbl_iris, "iris.csv") %>%
    expect_true()

  # Read a file
  my_drive$read("iris.csv", show_col_types = FALSE) %>%
    expect_equal(tbl_iris)

  # Remove a file or directory
  my_drive$remove("iris.csv", confirm = FALSE) %>%
    expect_no_condition()

  # Create a directory
  my_drive$create_directory("new_directory") %>%
    expect_no_condition()

  my_drive$create_directory("new_directory") %>%
    expect_error()

  contents <- my_drive$list_content()

  expect_true(nrow(contents) == 1)


  # Remove a file or directory

  my_drive$remove("new_directory", confirm = FALSE) %>%
    expect_no_condition()
})

test_that("Testing connector_sharepoint methods with a specific folder", {
  skip_on_ci()

  #########################
  ### For a specific folder
  #########################

  my_drive$create_directory("Test_453frg6g")

  test_folder <- quiet_connect(
    my_site,
    path_of_folder = "Test_453frg6g"
  )

  contents <- test_folder$list_content()

  expect_true(nrow(contents) == 0)

  test_folder$write(tbl_iris, "iris.csv") %>%
    expect_true()

  test_folder$read("iris.csv", show_col_types = FALSE)  %>%
    expect_equal(tbl_iris)

  # Remove a file or directory
  my_drive$remove("Test_453frg6g", confirm = FALSE) %>%
    expect_no_condition()
})

test_that("Testing connector_sharepoint specific outputs for methods", {
  skip_on_ci()
  #########################
  ### Specific to methods
  #########################

  # Create a folder and file
  my_drive$create_directory("Test_453frg6g")
  my_drive$write(iris, "Test_453frg6g/iris.csv")

  ## Check error for read fo a folder

  my_drive$read("Test_453frg6g", show_col_types = FALSE) %>%
    expect_error()

  my_drive$get_conn() %>%
    read_microsoft_file("Test_453frg6g/iris.csv", show_col_types = FALSE) %>%
    expect_no_error()

  ## Check error for write of non character

  my_drive$write("iris", "Test_453frg6g/iris.csv") %>%
    expect_error()

  ### Upload and download

  ### file
  tmp_file <- tempfile(fileext = ".example")
  tmp_file_d <- tempfile(pattern = "downloaded", fileext = ".example")
  write.csv(iris, tmp_file, row.names = FALSE)

  my_drive %>%
    cnt_upload_content(src = tmp_file, "Test_453frg6g/iris.example") %>%
    expect_no_error()

  my_drive %>%
    cnt_download_content("Test_453frg6g/iris.example", dest = tmp_file_d) %>%
    expect_no_error()

  path_ <- my_drive$
    get_conn()$
    get_item("Test_453frg6g/iris.example")$
    get_path()

  expect_equal(path_, "/Test_453frg6g/iris.example")

  #### Dirs

  tmp_dir <- tempfile(pattern = "test_dir")
  dir.create(tmp_dir)
  dir_d <- tempfile("dir_d")
  dir.create(dir_d)

  withr::with_dir(tmp_dir, {
    write.csv(iris, "iris.csv", row.names = FALSE)
  })

  # Upload directory
  my_drive %>%
    cnt_upload_content(src = tmp_dir, "Test_453frg6g/dir") %>%
    expect_no_error()

  my_drive$upload(tmp_dir, "Test_453frg6g/dir") %>%
    expect_no_error()

  ### The same with path of folder
  subfolder <- quiet_connect(
    my_site,
    path_of_folder = "Test_453frg6g"
  )

  subfolder$upload(tmp_dir, "dir_sub") %>%
    expect_no_error()

  ### Error not existing
  my_drive %>%
    cnt_upload_content(src = "notexits", "Test_453frg6g/dir") %>%
    expect_error() %>%
    expect_warning()

  dir_ <- my_drive$
    get_conn()$
    get_item("Test_453frg6g/dir")

  expect_true(dir_$is_folder())

  ## Download directory

  my_drive %>%
    cnt_download_content("Test_453frg6g/dir", dest = dir_d) %>%
    expect_no_error()

  ## same from the method

  my_drive$download("Test_453frg6g/dir", dir_d, overwrite = TRUE) %>%
    expect_no_error()


  list.files(dir_d) %>%
    expect_equal("iris.csv")


  #### A not implemented ext in connector read_ext fct
  my_drive$read("Test_453frg6g") %>%
    expect_error()

  my_drive$read("Test_453frg6g/iris.example") %>%
    expect_error()

  ### Clean up

  my_drive$remove("Test_453frg6g", confirm = FALSE)

})


test_that("test when path to a folder is not a folder", {
  skip_on_ci()

  ## create a file
  my_drive$create_directory("Test_453frg6g")
  my_drive$write(iris, "Test_453frg6g/iris.csv")

  # Path is not a folder
  quiet_connect(
    my_site,
    path_of_folder = "Test_453frg6g/iris.csv"
  ) %>%
    expect_error()

  # clean up
  my_drive$remove("Test_453frg6g", confirm = FALSE)
})


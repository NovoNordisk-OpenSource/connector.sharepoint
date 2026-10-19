# Each test opens its own empty folder through local_test_connector(), seeds
# remote state with put_remote_*() and inspects it with get_remote_lines() /
# list_remote(), so only the method under test goes through the connector.

describe("read_cnt", {
  it("should return the contents of a remote csv as a data frame", {
    # Arrange
    con <- local_test_connector()
    put_remote_csv(con, "iris.csv", tbl_iris)

    # Act
    result <- con$read_cnt("iris.csv", show_col_types = FALSE)

    # Assert
    expect_equal(result, tbl_iris)
  })

  it("should error when the name is a folder", {
    # Arrange
    con <- local_test_connector()
    put_remote_folder(con, "sub")

    # Act, Assert
    expect_error(con$read_cnt("sub"), "is a folder")
  })

  it("should error when the file does not exist", {
    # Arrange
    con <- local_test_connector()

    # Act, Assert
    expect_error(con$read_cnt("missing.csv"), "404")
  })
})

describe("tbl_cnt", {
  it("should return the contents of a remote csv as a data frame", {
    # Arrange
    con <- local_test_connector()
    put_remote_csv(con, "iris.csv", tbl_iris)

    # Act
    result <- con$tbl_cnt("iris.csv", show_col_types = FALSE)

    # Assert
    expect_equal(result, tbl_iris)
  })
})

describe("write_cnt", {
  it("should upload a data frame as a csv file", {
    # Arrange
    con <- local_test_connector()
    x <- data.frame(id = 1:2, value = c("a", "b"))

    # Act
    con$write_cnt(x, "x.csv")

    # Assert
    expect_equal(
      get_remote_lines(con, "x.csv"),
      c("id,value", "1,a", "2,b")
    )
  })

  it("should write into a subfolder given in the name", {
    # Arrange
    con <- local_test_connector()
    put_remote_folder(con, "sub")

    # Act
    con$write_cnt(data.frame(id = 1), "sub/x.csv")

    # Assert
    expect_equal(list_remote(con, "sub"), "x.csv")
  })

  it("should return the connector so calls can be chained", {
    # Arrange
    con <- local_test_connector()

    # Act
    result <- con$write_cnt(data.frame(id = 1), "x.csv")

    # Assert
    expect_identical(result, con)
  })

  it("should error when x is a character", {
    # Arrange
    con <- local_test_connector()

    # Act, Assert
    expect_error(con$write_cnt("iris", "x.csv"), "is a character")
  })

  it("should error when the file exists and overwrite is FALSE", {
    testthat::skip(paste(
      "Open question: `overwrite` is accepted but never used, and Graph",
      "replaces existing files. Should overwrite = FALSE error on an existing",
      "file?"
    ))
  })
})

describe("list_content_cnt", {
  it("should return no names for an empty folder", {
    # Arrange
    con <- local_test_connector()

    # Act
    result <- con$list_content_cnt()

    # Assert
    expect_equal(result, character(0))
  })

  it("should return the names of files and folders directly in the folder", {
    # Arrange
    con <- local_test_connector()
    put_remote_csv(con, "a.csv", iris)
    put_remote_folder(con, "sub")
    put_remote_csv(con, "sub/nested.csv", iris)

    # Act
    result <- con$list_content_cnt()

    # Assert
    expect_setequal(result, c("a.csv", "sub"))
  })
})

describe("remove_cnt", {
  it("should delete only the named file", {
    # Arrange
    con <- local_test_connector()
    put_remote_csv(con, "drop.csv", iris)
    put_remote_csv(con, "keep.csv", iris)

    # Act
    con$remove_cnt("drop.csv", confirm = FALSE)

    # Assert
    expect_equal(list_remote(con), "keep.csv")
  })
})

describe("download_cnt", {
  it("should copy a remote file to the local destination", {
    # Arrange
    con <- local_test_connector()
    put_remote_csv(con, "x.csv", data.frame(id = 1:2))
    dest <- withr::local_tempfile(fileext = ".csv")

    # Act
    con$download_cnt("x.csv", dest)

    # Assert
    expect_equal(readLines(dest), c("\"id\"", "1", "2"))
  })

  it("should error when the destination exists and overwrite is not set", {
    # Arrange
    con <- local_test_connector()
    put_remote_csv(con, "x.csv", data.frame(id = 1))
    dest <- withr::local_tempfile(lines = "local")

    # Act, Assert
    expect_error(con$download_cnt("x.csv", dest), "overwrite is FALSE")
  })

  it("should replace the destination when overwrite is TRUE", {
    # Arrange
    con <- local_test_connector()
    put_remote_csv(con, "x.csv", data.frame(id = 1))
    dest <- withr::local_tempfile(lines = "to be replaced")

    # Act
    con$download_cnt("x.csv", dest, overwrite = TRUE)

    # Assert
    expect_equal(readLines(dest), c("\"id\"", "1"))
  })
})

describe("upload_cnt", {
  it("should copy a local file to the remote destination", {
    # Arrange
    con <- local_test_connector()
    src <- withr::local_tempfile(lines = c("line 1", "line 2"))

    # Act
    con$upload_cnt(src, "notes.txt")

    # Assert
    expect_equal(get_remote_lines(con, "notes.txt"), c("line 1", "line 2"))
  })

  it("should error when the local file does not exist", {
    # Arrange
    con <- local_test_connector()

    # Act, Assert
    expect_error(con$upload_cnt("no/such/file.txt"), "does not exist")
  })
})

describe("create_directory_cnt", {
  it("should return a connector opened on the new folder when open is TRUE", {
    # Arrange
    con <- local_test_connector()

    # Act
    result <- con$create_directory_cnt("sub", open = TRUE)

    # Assert
    expect_equal(result$folder, drive_path(con, "sub"))
  })

  it("should create the folder and return the same connector if not open", {
    # Arrange
    con <- local_test_connector()

    # Act
    result <- con$create_directory_cnt("sub", open = FALSE)

    # Assert
    expect_identical(result, con)
    expect_equal(list_remote(con), "sub")
  })

  it("should open the folder when it already exists", {
    # Arrange
    con <- local_test_connector()
    put_remote_csv(con, "sub/x.csv", iris)

    # Act
    result <- con$create_directory_cnt("sub", open = TRUE)

    # Assert
    expect_equal(result$folder, drive_path(con, "sub"))
    expect_equal(result$list_content_cnt(), "x.csv")
  })

  it("should error when a file with that name exists", {
    # Arrange
    con <- local_test_connector()
    put_remote_csv(con, "sub", iris)

    # Act, Assert
    expect_error(
      con$create_directory_cnt("sub", open = FALSE),
      "already exists and is a file"
    )
  })

  it("should reuse the connector's token when open is TRUE", {
    # Arrange
    con <- local_test_connector()
    testthat::local_mocked_bindings(
      get_token = function(...) stop("get_token() should not be called")
    )

    # Act
    result <- con$create_directory_cnt("sub", open = TRUE)

    # Assert
    expect_identical(result$token, con$token)
  })
})

describe("remove_directory_cnt", {
  it("should delete a folder together with its contents", {
    # Arrange
    con <- local_test_connector()
    put_remote_folder(con, "sub")
    put_remote_csv(con, "sub/x.csv", iris)

    # Act
    con$remove_directory_cnt("sub", confirm = FALSE)

    # Assert
    expect_equal(list_remote(con), character(0))
  })
})

describe("upload_directory_cnt", {
  # a.txt at the top level and b.txt in a nested/ subfolder
  local_nested_dir <- function(env = parent.frame()) {
    src <- withr::local_tempdir(.local_envir = env)
    writeLines("a", file.path(src, "a.txt"))
    dir.create(file.path(src, "nested"))
    writeLines("b", file.path(src, "nested", "b.txt"))
    src
  }

  it("should upload nested files when recursive is TRUE", {
    # Arrange
    con <- local_test_connector()
    src <- local_nested_dir()

    # Act
    con$upload_directory_cnt(src, "up", recursive = TRUE)

    # Assert
    expect_equal(get_remote_lines(con, "up/nested/b.txt"), "b")
  })

  it("should skip subfolders when recursive is FALSE", {
    # Arrange
    con <- local_test_connector()
    src <- local_nested_dir()

    # Act
    con$upload_directory_cnt(src, "up", recursive = FALSE)

    # Assert
    expect_equal(list_remote(con, "up"), "a.txt")
  })

  it("should return a connector opened on the destination when open is TRUE", {
    # Arrange
    con <- local_test_connector()
    src <- withr::local_tempdir()
    writeLines("a", file.path(src, "a.txt"))

    # Act
    result <- con$upload_directory_cnt(src, "up", open = TRUE)

    # Assert
    expect_equal(result$folder, drive_path(con, "up"))
  })

  it("should error when the local directory does not exist", {
    # Arrange
    con <- local_test_connector()

    # Act, Assert
    expect_error(con$upload_directory_cnt("no/such/dir"), "does not exist")
  })

  it("should keep extra_class on the connector returned when open is TRUE", {
    testthat::skip(paste(
      "Known bug: extra_class is computed but never passed to",
      "connector_sharepoint(), so the reopened connector drops it."
    ))
  })
})

describe("download_directory_cnt", {
  it("should download nested files when recursive is TRUE", {
    # Arrange
    con <- local_test_connector()
    put_remote_folder(con, "remote")
    put_remote_folder(con, "remote/nested")
    put_remote_csv(con, "remote/nested/x.csv", data.frame(id = 1))
    dest <- file.path(withr::local_tempdir(), "local")

    # Act
    con$download_directory_cnt("remote", dest, recursive = TRUE)

    # Assert
    expect_equal(
      readLines(file.path(dest, "nested", "x.csv")),
      c("\"id\"", "1")
    )
  })

  it("should skip subfolders when recursive is FALSE", {
    # Arrange
    con <- local_test_connector()
    put_remote_folder(con, "remote")
    put_remote_csv(con, "remote/top.csv", data.frame(id = 1))
    put_remote_folder(con, "remote/nested")
    dest <- file.path(withr::local_tempdir(), "local")

    # Act
    con$download_directory_cnt("remote", dest, recursive = FALSE)

    # Assert
    expect_equal(list.files(dest), "top.csv")
  })
})

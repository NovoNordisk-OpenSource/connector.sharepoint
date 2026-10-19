# just to have clean messages in tests
quiet_connect <- function(...) {
  suppressMessages(connector_sharepoint(...))
}

# make iris a tbl
tbl_iris <- tibble::as_tibble(iris, rownames = NULL)

## remove factors, read and write not working with factors
tbl_iris$Species <- as.character(tbl_iris$Species)

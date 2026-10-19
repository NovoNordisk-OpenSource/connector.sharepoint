# In-memory fake of the Microsoft365R drive objects, backed by a local
# directory. Only the methods and return shapes that ConnectorSharepoint uses
# are implemented; signatures and behaviour follow Microsoft365R's
# ms_drive / ms_drive_item (R/ms_drive.R, R/ms_drive_item.R).

# Same condition classes as httr::stop_for_status(), which AzureGraph uses
fake_http_error <- function(status, reason, message) {
  stop(structure(
    class = c(paste0("http_", status), "http_error", "error", "condition"),
    list(
      message = paste0(
        reason, " (HTTP ", status, "). Failed to complete operation. ",
        "Message:\n", message
      ),
      call = NULL
    )
  ))
}

fake_http_404 <- function(path) {
  fake_http_error(404, "Not Found", paste0(
    "The resource could not be found: ", path
  ))
}

# Same normalisation as ms_drive$get_item(): drop one leading and one
# trailing slash
fake_clean_path <- function(path) {
  gsub("^/|/$", "", if (is.null(path)) "" else path)
}

# Paths given to ms_drive_item methods, and to the ms_drive methods that
# delegate to the root item, are appended to the item ID
# (microsoft365r_use_itemid_in_path = TRUE), which rejects a leading slash
fake_check_relative <- function(path) {
  if (startsWith(path, "/")) {
    stop(
      "Absolute path incompatible with path starting from item ID",
      call. = FALSE
    )
  }
  invisible(path)
}

# The package only reads $name; the columns match info = "partial"
fake_list_items <- function(dir) {
  names <- list.files(dir, all.files = TRUE, no.. = TRUE)
  full <- file.path(dir, names)
  isdir <- dir.exists(full)
  data.frame(
    name = names,
    size = ifelse(isdir, 0, file.size(full)),
    isdir = isdir,
    id = names
  )
}

FakeMicrosoft365RItem <- R6::R6Class(
  "FakeMicrosoft365RItem",
  public = list(
    properties = NULL,
    initialize = function(root, path) {
      private$root <- root
      private$path <- fake_clean_path(path)
      if (!file.exists(private$local())) {
        fake_http_404(private$path)
      }
      self$properties <- list(
        name = if (private$path == "") "root" else basename(private$path),
        id = private$path
      )
    },
    is_folder = function() {
      dir.exists(private$local())
    },
    list_items = function(path = "", ...) {
      if (path == "/") {
        path <- ""
      }
      fake_check_relative(path)
      # Graph is called on "<path>:/children", so "<dir>/:/children" is a 404
      if (endsWith(path, "/")) {
        fake_http_404(path)
      }
      fake_list_items(private$local(path))
    },
    get_item = function(path) {
      fake_check_relative(path)
      FakeMicrosoft365RItem$new(private$root, file.path(private$path, path))
    },
    download = function(
      dest = self$properties$name,
      overwrite = FALSE,
      recursive = FALSE,
      parallel = FALSE
    ) {
      if (!self$is_folder()) {
        # Same check and message as httr::write_disk()
        if (file.exists(dest) && !overwrite) {
          stop("Path exists and overwrite is FALSE", call. = FALSE)
        }
        file.copy(private$local(), dest, overwrite = TRUE)
        return(invisible(NULL))
      }
      dir.create(dest, showWarnings = FALSE)
      children <- self$list_items()
      if (!recursive) {
        children <- children[!children$isdir, , drop = FALSE]
      }
      for (f in children$name) {
        self$get_item(f)$download(
          file.path(dest, f),
          overwrite = overwrite,
          recursive = recursive
        )
      }
      invisible(NULL)
    },
    delete = function(confirm = TRUE, by_item = FALSE) {
      # real delete prompts only when interactive(); tests never are
      unlink(private$local(), recursive = TRUE)
      invisible(NULL)
    }
  ),
  private = list(
    root = NULL,
    path = NULL,
    local = function(child = "") {
      child <- fake_clean_path(child)
      parts <- c(private$root, private$path, child)
      do.call(file.path, as.list(parts[parts != ""]))
    }
  )
)

FakeMicrosoft365RDrive <- R6::R6Class(
  "FakeMicrosoft365RDrive",
  public = list(
    root = NULL,
    properties = list(
      driveType = "documentLibrary",
      id = "fake-drive-id",
      description = "Fake SharePoint document library"
    ),
    initialize = function(root) {
      self$root <- root
    },
    get_item = function(path = NULL, itemid = NULL) {
      FakeMicrosoft365RItem$new(self$root, if (is.null(path)) itemid else path)
    },
    list_items = function(path = "/", ...) {
      self$get_item("/")$list_items(path, ...)
    },
    upload_file = function(src, dest, blocksize = 32768000) {
      fake_check_relative(dest)
      # Graph PUT replaces existing files and creates missing parent folders
      target <- file.path(self$root, fake_clean_path(dest))
      dir.create(dirname(target), recursive = TRUE, showWarnings = FALSE)
      file.copy(src, target, overwrite = TRUE)
      invisible(self$get_item(dest))
    },
    upload_folder = function(
      src,
      dest,
      blocksize = 32768000,
      recursive = FALSE,
      parallel = FALSE
    ) {
      fake_check_relative(dest)
      files <- dir(src, all.files = TRUE, no.. = TRUE, recursive = recursive)
      if (!recursive) {
        subdirs <- list.dirs(src, recursive = FALSE, full.names = FALSE)
        files <- setdiff(files, subdirs)
      }
      for (f in files) {
        self$upload_file(file.path(src, f), file.path(dest, f))
      }
      invisible(self$get_item(dest))
    },
    create_folder = function(path) {
      fake_check_relative(path)
      # Microsoft365R sends conflictBehavior = "fail"
      target <- file.path(self$root, fake_clean_path(path))
      if (file.exists(target)) {
        fake_http_error(
          409,
          "Conflict",
          "An item with the same name already exists under the parent"
        )
      }
      dir.create(target, recursive = TRUE)
      invisible(self$get_item(path))
    },
    download_folder = function(
      src = NULL,
      srcid = NULL,
      dest = basename(src),
      overwrite = FALSE,
      recursive = FALSE,
      parallel = FALSE
    ) {
      self$get_item(src, srcid)$download(
        dest,
        overwrite = overwrite,
        recursive = recursive,
        parallel = parallel
      )
    }
  )
)

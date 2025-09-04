# Utility function to check if the name is valid and add folder name to it
# @noRd
check_convert_name <- function(folder, name) {
  checkmate::assert_string(name)
  name <- paste(folder, name, sep = "/")
}

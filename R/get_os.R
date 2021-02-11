#' Get operating system
#'
#' @return the operating system of the current system
#' @export
#' 
get_os <- function() {
  # TODO: need to modify for Apple silicon
  if (.Platform$OS.type == "windows") {
    "win"
  } else if (Sys.info()["sysname"] == "Darwin") {
    "mac"
  } else if (.Platform$OS.type == "unix") {
    "unix"
  } else {
    stop("Unknown OS")
  }
}

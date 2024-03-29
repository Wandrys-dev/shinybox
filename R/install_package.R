#' Install from isolated lib
#'
#' @return na
#' @export
#'

install_package <- function() {
  passthr <-  Sys.getenv("ESHINE_PASSTHRUPATH")
  remotes_code <-  Sys.getenv("ESHINE_remotes_code")
  return_file_path <-  Sys.getenv("ESHINE_package_return")
  
  if (!nchar(passthr) > 0 ) {
    stop("Empty path") 
  }  
  passthr <- normalizePath(passthr, winslash = "/")
  
  load(passthr)
  
  # TODO this is where the issue with incompatible packages happens on macos
  remotes_code <- getFromNamespace(remotes_code, ns = "remotes")
  
  z <- do.call(remotes_code, passthr)
  # the remotes package returns the name of the installed package
  # but when called from system2, at least on mac,
  # this results in a lot of kerfuffle so here we return
  # a string that will we can regex for
  writeLines(z, con = return_file_path)
}

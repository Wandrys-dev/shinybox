
#' Write to a file
#'
#' @param path path where file should be written to
#' @param text text to write
#' @param filename name of file to write to
#'
#' @return message saying whether file was created or not
#' @export
#'
write_text <- function(text,
                       filename,
                       path){
  
  path <- file.path(path,
                          filename)
  
  path <- normalizePath(path, 
                        winslash = "/", 
                        mustWork = FALSE)
  
  writeLines(text,
                   path)
  
  if (file.exists(path)) {
    message(glue::glue("Successfully created {path}"))
  } else {
    warning(glue::glue("Did not create {path}"))
  }
  
}


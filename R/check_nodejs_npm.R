#' Check if Nodejs and npm works
#' 
#' @param os os
#' @param node_top_dir directory containing nodejs app/exe
#'
#' @return path of nodejs executable if found and functional, otherwise: FALSE

check_nodejs_npm <- function(
  os,
  node_top_dir) {
  
  node_dir <- normalizePath(node_top_dir, "/", mustWork = FALSE)
  
  if (os == "win")  node_path <- file.path(node_dir, "node.exe")
  if (os == "mac")  node_path <- file.path(node_dir, "node")
    
  if (! file.exists(node_path))  stop("nodejs executable not found.")
  
  # Check that the node version is the same as what we expect and nodejs is functional
  command <- glue::glue("{shQuote(node_path)} -v")
  
  nodejs_response <- tryCatch(system(command, intern = TRUE),
                              error = function(e) FALSE, 
                              warning = function(e) FALSE)
  
  if (isFALSE(nodejs_response))  stop(glue::glue("nodejs at {node_path} seems NOT to be functional."))
  
  
  npm_dir <- normalizePath(node_top_dir, "/",  mustWork = FALSE)
  npm_path <- file.path(npm_dir, "npm")
  npm_exists <- file.exists(npm_path)
  
  if (!npm_exists)  stop("npm seems not be installed.")
  
  # Check that the npm version is the same as what we expect
  quoted_npm_path <- shQuote(npm_path)
  command <- paste0(quoted_npm_path, " -v")
  
  npm_response <- tryCatch(system(command, intern = TRUE),
                     error = function(e) FALSE, 
                     warning = function(e) FALSE)
  
  if(isFALSE(npm_response)) { 
    
    stop(glue::glue("npm executable was found but seems not to be functional."))
    npm_path <- FALSE
    return(npm_path)
    
  } else  {
    message(glue::glue("Found npm at: {npm_path}"))
    return(npm_path)
  } 
}

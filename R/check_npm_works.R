#' Check if npm works
#'
#' @param node_top_dir directory containing npmjs app/exe
#'
#' @return path of npm executable if found and functional, otherwise: FALSE
check_npm_works <- function(node_top_dir) {
  
  npm_path <- normalizePath(node_top_dir,
                            "/", 
                            mustWork = FALSE)
  
  npm_path <- file.path(npm_path, "npm")  
  
  npm_exists <- file.exists(npm_path)
  
  if (!npm_exists)  stop("npm seems not be installed.")
  
  
  # Check that the npm version is the same as what we expect
  
  quoted_npm_path <- shQuote(npm_path)
  
  command <- paste0(quoted_npm_path, 
                    " -v")
  
  result <- tryCatch(system(command, intern = TRUE),
                     error = function(e) FALSE, 
                     warning = function(e) FALSE)
  
  if(isFALSE(result)) { 
    
    stop(glue::glue("npm executable was found but seems not to be functional."))
    npm_path <- FALSE
    return(npm_path)
    
  } else  {
    message(glue::glue("Found npm at: {npm_path}"))
    return(npm_path)
  } 
}


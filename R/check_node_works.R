#' Check if Node works
#'
#' @param node_top_dir directory containing nodejs app/exe
#'
#' @return path of nodejs executable if found and functional, otherwise: FALSE
check_node_works <- function(node_top_dir) {
  
  message("Checking if the provided nodejs path already contains nodejs...")
  node_path <- normalizePath(node_top_dir,
                             "/",
                             mustWork = FALSE)
  
  if (os == "win") {
    
    node_path <- file.path(node_path,
                           "node.exe")
    
  } else {
    
    node_path <- file.path(node_path,
                           "node")    
  }
  
  node_exists <- file.exists(node_path)
  if (!node_exists)  stop("nodejs executable not found.")
  
  # Check that the node version is the same as what we expect and nodejs is functional
  
  quoted_node_path <- shQuote(node_path)
  command <- glue::glue("{quoted_node_path} -v")
  
  nodejs_response <- tryCatch(system(command, intern = TRUE),
                              error = function(e) FALSE, 
                              warning = function(e) FALSE)
  
  if (nodejs_response == FALSE)  stop(glue::glue("nodejs at {node_path} seems NOT to be functional."))
}

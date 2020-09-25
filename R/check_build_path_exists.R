#' Check whether build path exists
#'
#' @param build_path build_path
#'
#' @return stops 
check_build_path_exists <- function(build_path){
  
  if (is.null(build_path)) {
    base::stop("'build_path' not provided")
  }
  
  if (!is.character(build_path)) {
    base::stop("'build_path' should be character type.")
  }
  
  if (!dir.exists(build_path)) {
    base::stop("'build_path' provided, but path wasn't found.")
  }
}
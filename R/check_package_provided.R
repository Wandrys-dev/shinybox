#' Check package paths
#'
#'    Doesn't check whether it works, only for conflicts in arguments
#'
#' @param git_host git_host 
#' @param git_repo git_repo 
#' @param local_package_path local_package_path 
#'
#' @return stops 
check_package_provided <- function(git_host,
                                    git_repo,
                                    local_package_path){
  
  # Either 'git_repo' or 'local_package_path' must be set
  if (is.null(c(git_repo, local_package_path))) {
    base::stop("shinybox requires you to specify either a 'git_repo' or 'local_package_path' argument specifying
         the shiny app/package to be turned into an Electron app") 
  }
  
  # Ensure that 'git_repo' and 'local_package_path' aren't set at the same time.
  if (!is.null(git_repo) && !is.null(local_package_path)) {
    stop("Values provided for both 'git_repo' and 'local_package_path'; shinybox requires that only one of these is not NULL.") 
  }
  
  # Ensure that 'git_host' and 'local_package_path' aren't set at the same time.
  if (!is.null(git_host) && !is.null(local_package_path)) {
    stop("Values provided for both 'git_host' and 'local_package_path'; shinybox requires that only one of these is not NULL.") 
  }
  
  if (sum(is.null(git_host), is.null(git_repo)) == 1) {
    stop("Must provide both 'git_host' and 'git_repo', or just 'local_package_path'.") 
  }
  
}




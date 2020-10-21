#' Perform several checks and fail early
#' 
#' @param build_path build_path
#' @param cran_like_url cran_like_url
#' @param mran_date mran_date
#' @param git_host git_host 
#' @param git_repo git_repo 
#' @param local_package_path local_package_path 
#' 


check_first <- function(
  build_path = build_path,
  cran_like_url = NULL, 
  mran_date = NULL,
  git_host,
  git_repo,
  local_package_path) {
  
  message("Check architecture")
  arch <- version$arch[[1]]
  if (arch != "x86_64") {
    stop("Unfortunately 32 bit operating system builds are unsupported, if you would like to contribute to support this, that would be cool")
  }
  
  # Check that a repo for packages/R was set
  # Either 'cran_like_url' or 'local_package_path_path' must be set
  if (is.null(c(cran_like_url, mran_date))) {
    base::stop("shinybox requires you to specify either a 'cran_like_url' or 'mran_date' argument specifying
         the shiny app/package to be turned into an Electron app. The url for CRAN is: 'https://cran.r-project.org'") 
  }
  
  # Ensure that 'cran_like_url' and 'mran_date' aren't set at the same time.
  if (!is.null(cran_like_url) && !is.null(mran_date)) {
    stop("Values provided for both 'cran_like_url' and 'mran_date'; shinybox requires that only one of these is not NULL.") 
  }
  
  # Check whether build path exists
  if (is.null(build_path)) {
    base::stop("'build_path' not provided")
  }
  
  if (!is.character(build_path)) {
    base::stop("'build_path' should be character type.")
  }
  
  if (!dir.exists(build_path)) {
    base::stop("'build_path' provided, but path wasn't found.")
  }
  
  # Check package paths
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
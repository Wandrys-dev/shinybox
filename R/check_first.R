#' Perform several checks and fail early
#' 
#' @param app_name app_name
#' @param semantic_version semantic_version
#' @param function_name function_name
#' @param nodejs_path nodejs_path
#' @param package_install_opts package_install_opts
#' @param build_path build_path
#' @param cran_like_url cran_like_url
#' @param mran_date mran_date
#' @param git_host git_host 
#' @param git_repo git_repo 
#' @param local_package_path local_package_path 
#' 


check_first <- function(
  app_name,
  semantic_version,
  function_name,
  nodejs_path,
  package_install_opts,
  build_path,
  cran_like_url, 
  mran_date,
  git_host,
  git_repo,
  local_package_path) {
  
  message("Check architecture.")
  if (version$arch[[1]] != "x86_64")stop("32-bit operating systems builds are not supported.")
  
  if (is.null(app_name))  stop('Argument "app_name" is missing, with no default')
  
  if (is.null(semantic_version))  stop('Argument "semantic_version" is missing, with no default')
  
  if (is.null(function_name))  stop('Argument "function_name" is missing, with no default')
  
  if (is.null(nodejs_path))  stop('Argument "nodejs_path" is missing, with no default')
  
  if (!is.null(package_install_opts)) { 
    if (!is.list(package_install_opts)) {
      stop("package_install_opts in shinybox() must be a list of arguments.")
    }
  }
  
  
  # Check that a repo for packages/R was set
  # Either 'cran_like_url' or 'local_package_path_path' must be set
  if (is.null(c(cran_like_url, mran_date))) {
    stop("shinybox requires you to specify either a 'cran_like_url' or 'mran_date' argument specifying
         the shiny app/package to be turned into an Electron app. The url for CRAN is: 'https://cran.r-project.org'") 
  }
  
  # Ensure that 'cran_like_url' and 'mran_date' aren't set at the same time.
  if (!is.null(cran_like_url) && !is.null(mran_date)) {
    stop("Values provided for both 'cran_like_url' and 'mran_date'; shinybox requires that only one of these is not NULL.") 
  }
  
  # Check whether build path exists
  if (is.null(build_path)) {
    stop("'build_path' not provided")
  }
  
  if (!is.character(build_path)) {
    stop("'build_path' should be character type.")
  }
  
  if (!dir.exists(build_path)) {
    stop("'build_path' provided, but path wasn't found.")
  }
  
  # Check package paths
  # Either 'git_repo' or 'local_package_path' must be set
  if (is.null(c(git_repo, local_package_path))) {
    stop("shinybox requires you to specify either a 'git_repo' or 'local_package_path' argument specifying
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
  
  message("Check of arguments passed!")
}
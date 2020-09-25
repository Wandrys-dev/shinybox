#' Check that a repo for packages/R was set
#'
#' @param cran_like_url cran_like_url
#' @param mran_date mran_date
#'
check_repo_set <- function(cran_like_url = NULL, 
                            mran_date = NULL) {
  
  # Either 'cran_like_url' or 'local_package_path_path' must be set
  if (is.null(c(cran_like_url, mran_date))) {
    base::stop("shinybox requires you to specify either a 'cran_like_url' or 'mran_date' argument specifying
         the shiny app/package to be turned into an Electron app. The url for CRAN is: 'https://cran.r-project.org'") 
  }
  
  # Ensure that 'cran_like_url' and 'mran_date' aren't set at the same time.
  if (!is.null(cran_like_url) && !is.null(mran_date)) {
    stop("Values provided for both 'cran_like_url' and 'mran_date'; shinybox requires that only one of these is not NULL.") 
  }
  
}
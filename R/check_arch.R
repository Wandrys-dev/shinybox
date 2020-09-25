#' Check if compatible architecture
#'
#' @param arch only used for unit testing
#'
#' @return Stops if unsupported architecture
check_arch <- function(arch = base::version$arch[[1]]){
  
  if (arch != "x86_64") {
    base::stop("Unfortunately 32 bit operating system builds are unsupported, if you would like to contribute to support this, that would be cool")
  }
  
}
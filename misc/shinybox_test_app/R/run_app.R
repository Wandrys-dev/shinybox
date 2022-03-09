#' Launch the testapp 
#' 
#' This function is used to generate the standalone version
#' @param options Named options that should be passed to the run_app call.
#' @return
#' Open browser
#' 
#' @export
#'
#' @import ggplot2 shiny
#' 

run_app <- function(options = list()) {
  app_directory <- system.file("testapp", package = "shinyboxtestapp")
  shiny::shinyAppDir(app_directory, options = options)
}
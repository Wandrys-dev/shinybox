
#' Create an output folder
#'
#' @param app_root_path path where output folder gonna be
#'
#' @return if folder name already exists, show error and do nothing;
#' @export
#'
create_folder <- function(app_root_path){
  
  name <- base::basename(app_root_path)
  
  if (file.exists(app_root_path)) {
    stop(glue::glue("shinybox::create_folder(app_root_path, name) already exists, choose a path that doesn't already contain a directory named '{name}'"))
  } else {
    dir.create(app_root_path)
  }
  
}


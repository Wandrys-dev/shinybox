#' Install shiny app package and dependencies
#'
#' @param library_path path to the new Electron app's R's library folder
#' @param repo_location {remotes} package function, one of c("github", "gitlab", "bitbucket", "local")
#' @param repo e.g. if repo_location is github: "chasemc/demoApp" ; if repo_location is local: "C:/Users/chase/demoApp"
#' @param repos cran like repository package dependencies will be retrieved from  
#' @param package_install_opts further arguments to remotes::install_github, install_gitlab, install_bitbucket, or install_local
#' @param rtools_path_win path to RTools (Windows)
#' @param pandoc_path_mac pandoc path (macOS)
#'
#' @return App name

#' @export
#'

install_user_app <- function(library_path = NULL,
                             repo_location = "github",
                             repo = "chasemc/IDBacApp",
                             repos = cran_like_url,
                             package_install_opts = NULL,
                             rtools_path_win = NULL,
                             pandoc_path_mac = NULL){
  
  accepted_sites <- c("github", "gitlab", "bitbucket", "local")
  
  
  if (is.null(library_path)) {
    stop("install_user_app() requires library_path to be set.")
  }
  
  if (!dir.exists(library_path)) {
    stop("install_user_app() library_path wasn't found.")
  }
  
  if (length(repo_location) != 1L) {
    stop(glue::glue("install_user_app(repo_location) must be character vector of length 1"))
  }
  
  if (!repo_location %in% accepted_sites) {
    stop(glue::glue("install_user_app(repo_location) must be one of: {accepted_sites}"))
  }
  
  if (!nchar(repo) > 0) {
    # TODO: Maybe make this a regex?
    stop("install_user_app(repo) must be character with > 0 characters")
  }
  
  if (!is.null(package_install_opts)) { 
    if (!is.list(package_install_opts)) {
      stop("package_install_opts  must be a list of arguments.")
    }
  }
  
  remotes_code <- as.character(glue::glue("install_{repo_location}"))
  
  
  
  repo <- as.list(repo)
  
  passthr <- c(repo, repos = repos,
               c(package_install_opts, 
                 list(force = TRUE,
                      lib = library_path)
               )
  )
  
  os <- shinybox::get_os()  
  
  if (identical(os, "win")) {
    rscript_path <- file.path(dirname(library_path),
                              "bin",
                              "Rscript.exe")
  }
  
  if (identical(os, "mac")) {
    rscript_path <- file.path(dirname(library_path),
                              "bin",
                              "R")
  }
  
  if (identical(os, "unix")) {
    stop("shinybox is still under development for linux systems")
    
  }
  
  

  tmp_file <- tempfile()
  save(list = c("remotes_code",
                "passthr"),
       file = tmp_file)
  
  
  
  remotes_library <- copy_remotes_package()
  
  copy_shinybox_package()
  
  
  old_R_LIBS <- Sys.getenv("R_LIBS")
  old_R_LIBS_USER <- Sys.getenv("R_LIBS_USER")
  old_R_LIBS_SITE <- Sys.getenv("R_LIBS_SITE")
  
  Sys.setenv(R_LIBS=library_path)
  Sys.setenv(R_LIBS_USER=remotes_library)
  Sys.setenv(R_LIBS_SITE=remotes_library)
  Sys.setenv(ESHINE_PASSTHRUPATH=tmp_file)
  Sys.setenv(ESHINE_remotes_code=remotes_code)
  
  
  # https://stackoverflow.com/questions/47539125/how-to-add-rtools-bin-to-the-system-path-in-r
  if (identical(os, "win") & !is.null(rtools_path_win)) {
    message("Add RTools to R system path.")
    Sys.setenv(PATH = paste(rtools_path_win, Sys.getenv("PATH"), sep = ";"))
  }


  # Add pandoc to R System Path on macOS.
  # if (identical(os, "mac") & !is.null(pandoc_path_mac)) {
  #   message("Add pandoc to R system path.")
  #   Sys.setenv(PATH = paste(pandoc_path_mac, Sys.getenv("PATH"), sep = ";"))
  # }


  tmp_file2 <- tempfile()
  file.create(tmp_file2)
  Sys.setenv(ESHINE_package_return=tmp_file2)
  
  message("Installing your Shiny package into shinybox framework.")
  
  system_install_pkgs(rscript_path)
  
  on.exit({
  Sys.setenv(R_LIBS=old_R_LIBS)
  Sys.setenv(R_LIBS_USER=old_R_LIBS_USER)
  Sys.setenv(R_LIBS_SITE=old_R_LIBS_SITE)
  Sys.setenv(ESHINE_PASSTHRUPATH="")
  Sys.setenv(ESHINE_remotes_code="")
})
  message("Finshed: Installing your Shiny package into shinybox framework")
  
  # TODO: break into unit-testable function
  user_pkg <- readLines(tmp_file2)
  
  return(user_pkg)
}




#' Copy {remotes} package to an isolated folder.
#'    This is necessary to avoid dependency-install issues
#'
#' @return path of new {remotes}-only library
copy_remotes_package <- function(){
  remotes_path <- system.file(package = "remotes")
  
  new_path <- file.path(tempdir(), 
                        "shinybox")
  dir.create(new_path)
  
  new_path <- file.path(tempdir(), 
                        "shinybox",
                        "templib")
  dir.create(new_path)
  
  file.copy(remotes_path,
            new_path, 
            recursive = TRUE,
            copy.mode = F)
  
  test <- file.path(new_path, 
                    "remotes")
  if (!file.exists(test)) {
    stop("Wasn't able to copy remotes package.")
  }
  normalizePath(new_path,
                winslash = "/")
}



#' Copy {shinybox} package to an isolated folder.
#'    This is necessary to avoid dependency-install issues
#'
#' @return path of new {shinybox}-only library
copy_shinybox_package <- function(){
  remotes_path <- system.file(package = "shinybox")
  
  new_path <- file.path(tempdir(), 
                        "shinybox")
  dir.create(new_path)
  
  new_path <- file.path(tempdir(), 
                        "shinybox",
                        "templib")
  dir.create(new_path)
  
  file.copy(remotes_path,
            new_path, 
            recursive = TRUE,
            copy.mode = F)
  
  test <- file.path(new_path, 
                    "shinybox")
  if (!file.exists(test)) {
    stop("Wasn't able to copy shinybox package.")
  }
  invisible(normalizePath(new_path,
                          winslash = "/"))
}



#' Run package installation using the newly-installed R
#'
#' @param rscript_path path to newly-installed R's executable
#'
#' @return nothing
#'
system_install_pkgs <- function(rscript_path){
  
  os <- shinybox::get_os()  
  
  if (identical(os, "win")) {
    system2(rscript_path,
            paste0("-e ",
                   "shinybox::install_package()"),
            wait = TRUE,
            stdout = "")
  }
  
  if (identical(os, "mac")) {
    system2(rscript_path,
            paste0("-e ",
                   "'",
                   "shinybox::install_package()",
                   "'"),
            wait = TRUE,
            stdout = "")
  }
  
}
#' Install R from MRAN date into shinybox folder
#'
#' @param cran_like_url CRAN-like url e.g. https://cran.r-project.org/bin/windows/base
#' @param build_path path to current shinybox app build
#' @param mac_file file path to mac OS tar.gz
#' @param mac_r_url mac R installer url
#' @param permission_to_install have permission to install R?
#'
#' @export
#'
install_r <- function(cran_like_url = NULL,
                      build_path,
                      mac_file = NULL,
                      mac_r_url = NULL,
                      permission_to_install  = FALSE) {
  
  
  
  if (permission_to_install == FALSE) {
    
    permission_to_install <- .prompt_install_r(build_path)
    
  }
  
  if (permission_to_install == FALSE) {
    message("R is bundled into the shinybox app. shinybox() requires this to be accepted, 
            otherwise steps to build the app must be run individually.")
  } else {
    
    
    
    os <- shinybox::get_os()
    
    build_path <- normalizePath(build_path,
                                   winslash = "/",
                                   mustWork = FALSE)
    # Make NULL here so can check if not null later
    rlang_path <- NULL
    
    if (identical(os, "mac")) {
      rlang_path <- .install_mac_r(build_path = build_path,
                                   mac_file = mac_file,
                                   mac_r_url = mac_r_url)
    }
    
    if (identical(os, "win")) {
      
      win_url <- .find_win_exe_url(cran_like_url = cran_like_url)
      
      win_installer_path <- .download_r(d_url = win_url)
      
      rlang_path <- .install_win_r(win_installer_path,
                                   build_path)
      
      rlang_path <- file.path(rlang_path,
                                    "bin",
                                    fsep = "/")
    }
    
    # Check that Rscript is present (ie R at least probably installed)
    # TODO: Mod this check to a system call that checks if R is functional (see testthat tests for install_r())
    if (length(list.files(rlang_path,
                          pattern = "Rscript")) != 1L) {
      stop("R install didn't work as expected.")
    } 
    
    return(rlang_path)
    
  }
}


#' Find Windows R installer URL from MRAN snapshot
#'
#' @param cran_like_url  url to cran-like repository
#'
#' @return url for Windows R installer  
#'
.find_win_exe_url <- function(cran_like_url = NULL){
  
  
  baseUrl <-  file.path(cran_like_url,
                        "bin",
                        "windows",
                        "base")
  
  # Read snapshot html
  readCran <- readLines(baseUrl,
                              warn = FALSE)
  
  # Find the name of the windows exe
  filename <- regexpr("R-[0-9.]+.+-win\\.exe", readCran)
  filename <- regmatches(readCran, filename)
  
  if (regexpr("R-[0-9.]+.+-win\\.exe", filename)[[1]] != 1L) {
    stop("Was unable to resolve url of R.exe installer for Windows.") 
  }
  
  # Construct the url of the download
  win_exe_url <- file.path(baseUrl, 
                                 filename,
                                 fsep = "/")
  
  return(win_exe_url)
}



#' Download R installer given its url
#'
#' @param d_url download file from url
#'
#' @return Path to R.exe installer
.download_r <- function(d_url) {
  
  installer_filename <- basename(d_url)
  download_path <- file.path(tempdir(), 
                                   installer_filename,
                                   fsep = "/")
  utils::download.file(url = d_url, 
                       destfile = download_path, 
                       mode = "wb")
  return(download_path)
}




#' Install R for Windows at given path
#'
#' @param win_installer_path path of Windows R installer 
#' @param build_path top level of new shinybox app build
#'
#' @return NA, installs R to path

.install_win_r <- function(win_installer_path,
                           build_path){
  
  # create the path R installer will install to
  install_r_to_path <- file.path(build_path, 
                                       "app",
                                       fsep = "/")
  dir.create(install_r_to_path)
  
  install_r_to_path <- file.path(build_path, 
                                       "app",
                                       "r_lang",
                                       fsep = "/")
  
  dir.create(install_r_to_path)
  
  # Quote path in case user's path has spaces, etc
  quoted_install_r_to_path <- shQuote(install_r_to_path)
  quoted_win_installer_path <- shQuote(win_installer_path)
  
  # install R
  system(glue::glue("{quoted_win_installer_path} /SILENT /DIR={quoted_install_r_to_path}"))
  
  return(install_r_to_path)
}



#' Download and untar mac R into app folder
#'
#' @param build_path top level of new shinybox app build
#' @param mac_r_url url for mac R language download
#'
#' @return NA
.install_mac_r <- function(build_path,
                           mac_file,
                           mac_r_url){
  
  if(!is.null(mac_file)) {
    installer_path <- mac_file
  }
  
  if(is.null(mac_file)) {
    installer_path <- .download_r(mac_r_url)
  }
  # path R installer will install to
  install_r_to_path <- file.path(build_path, "app", "r_lang", fsep = "/")
  
  # untar files to the app folder
  utils::untar(tarfile = installer_path, exdir = install_r_to_path)
  
  r_executable_path <- file.path(build_path, 
                                 "app/r_lang/Library/Frameworks/R.framework/Versions")
  r_executable_path <- list.dirs(r_executable_path, 
                                 recursive = FALSE)[[1]]
  r_executable_path <- file.path(r_executable_path,
                                 "Resources/bin/R", 
                                 fsep = "/")
  shinybox::modify_mac_r(r_executable_path)
  
  return(dirname(r_executable_path))
  
}





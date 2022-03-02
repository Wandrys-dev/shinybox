#' Install R into shinybox folder
#'
#' @param os os
#' @param cran_like_url CRAN-like url e.g. https://cran.r-project.org/bin/windows/base
#' @param build_path path to current shinybox app build
#' @param mac_file file path to mac OS tar.gz
#' @param mac_r_url mac R installer url
#'
#' @export
#'
install_r <- function(os,
                      cran_like_url = NULL,
                      build_path,
                      mac_file = NULL,
                      mac_r_url = NULL) {
  
  
  
  build_path <- normalizePath(build_path,
                              winslash = "/",
                              mustWork = FALSE)
  # Make NULL here so can check if not null later
  rlang_path <- NULL
  
  if (identical(os, "mac")) {

    if(!is.null(mac_file)) {
      installer_path <- mac_file
    }
    
    browser()
    
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
    shinybox::make_r_portable_mac(r_executable_path)
    
    rlang_path <- dirname(r_executable_path)
    
  }
  
  if (identical(os, "win")) {
    baseUrl <-  file.path(cran_like_url, "bin", "windows", "base")
    
    # Read snapshot html
    readCran <- readLines(baseUrl, warn = FALSE)
    
    # Find the name of the windows exe
    filename <- regexpr("R-[0-9.]+.+-win\\.exe", readCran)
    filename <- regmatches(readCran, filename)
    
    if (regexpr("R-[0-9.]+.+-win\\.exe", filename)[[1]] != 1L) {
      stop("Was unable to resolve url of R.exe installer for Windows.") 
    }
    
    # Construct the url of the download
    win_url <- file.path(baseUrl, 
                         filename,
                         fsep = "/")
    
    win_installer_path <- .download_r(d_url = win_url)
    
    rlang_path <- .install_win_r(win_installer_path,
                                 build_path)
    
    # Create the path R installer will install to.
    install_r_to_path <- file.path(build_path, "app", "r_lang", fsep = "/")
    dir.create(install_r_to_path, recursive = TRUE)
    
    # Quote path in case user's path has spaces, etc
    quoted_install_r_to_path <- shQuote(install_r_to_path)
    quoted_win_installer_path <- shQuote(win_installer_path)
    
    # install R
    system(glue::glue("{quoted_win_installer_path} /SILENT /DIR={quoted_install_r_to_path}"))
    
    rlang_path <- file.path(install_r_to_path, "bin", fsep = "/")
  }
  
  # Check that Rscript is present (ie R at least probably installed)
  # TODO: Mod this check to a system call that checks if R is functional (see testthat tests for install_r())
  if (length(list.files(rlang_path,
                        pattern = "Rscript")) != 1L) {
    stop("R install didn't work as expected.")
  } 
  
  return(rlang_path)
}




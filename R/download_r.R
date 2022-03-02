#' Download R installer given its url
#'
#' @param d_url download file from url
#'
#' @return Path to R.exe installer
download_r <- function(d_url) {
  
  installer_filename <- basename(d_url)
  download_path <- file.path(tempdir(), 
                             installer_filename,
                             fsep = "/")
  download.file(url = d_url, destfile = download_path, mode = "wb")
  return(download_path)
}
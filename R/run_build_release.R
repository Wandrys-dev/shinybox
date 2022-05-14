#' Create an electron-builder release
#'
#' @param os os
#' @param nodejs_path folder containing node.exe
#' @param build_path path to new electron app top directory
#'
#' @return nothing, used for side-effects
#' @export
#'
run_build_release <- function(os,
                              nodejs_path,
                              build_path){
  
  npm_dir <- normalizePath(nodejs_path, "/",  mustWork = FALSE)
  npm_path <- file.path(npm_dir, "npm")
  
  quoted_build_path <- shQuote(build_path)
  quoted_npm_path <- shQuote(npm_path)
  
  # electron-packager <sourcedir> <appname> --platform=<platform> --arch=<arch> [optional flags...]
  # npm start --prefix path/to/your/app
  message("Installing npm dependencies specified in 'package.json'")
  
  if (identical(os, "win")) {
    message(system("cmd.exe",
                   glue::glue('cd {quoted_build_path} && {quoted_npm_path} install --scripts-prepend-node-path'),
                   invisible = FALSE,
                   minimized = FALSE,
                   wait = TRUE,
                   intern = FALSE,
                   ignore.stdout = FALSE,
                   ignore.stderr = FALSE))
    
    message("Building your Electron app.")
    
    message(system("cmd.exe",
                   glue::glue('cd {quoted_build_path} && {quoted_npm_path} run release --scripts-prepend-node-path'),
                   invisible = FALSE,
                   minimized = FALSE,
                   wait = TRUE,
                   intern = FALSE,
                   ignore.stdout = FALSE,
                   ignore.stderr = FALSE))
    
  }
  
  if (identical(os, "mac")) {
    message(system(glue::glue('cd {quoted_build_path} && {quoted_npm_path} install --scripts-prepend-node-path'),
                   wait = TRUE,
                   intern = FALSE,
                   ignore.stdout = FALSE,
                   ignore.stderr = FALSE))
    
    message("Building your Electron app.")
    
    message(system(glue::glue('cd {quoted_build_path} && {quoted_npm_path} run release --scripts-prepend-node-path'),
                   wait = TRUE,
                   intern = FALSE,
                   ignore.stdout = FALSE,
                   ignore.stderr = FALSE))
  }
  message("If all went well, you can find your Electron app in the 'dist' folder")
}


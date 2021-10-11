#' Create an electron-builder release
#'
#' @param nodejs_path parent folder of node.exe (~nodejs_path/node.exe)
#' @param build_path path to new electron app top directory
#'
#' @return nothing, used for side-effects
#' @export
#'
run_build_release <- function(nodejs_path = file.path(system.file(package = "shinybox"), "nodejs"),
                              build_path){
  
  
  os <- shinybox::get_os()
  
  npm_path <- .check_npm_works(node_top_dir = nodejs_path)
  
  if (isFALSE(npm_path))  stop("First run install_nodejs() or point nodejs_path to a functional version of nodejs.")
  
  quoted_build_path <- shQuote(build_path)
  quoted_npm_path <- shQuote(npm_path)
  
  
  # electron-packager <sourcedir> <appname> --platform=<platform> --arch=<arch> [optional flags...]
  # npm start --prefix path/to/your/app
  message("Installing npm dependencies specified in 'package.json'")
  
  if (identical(os, "win")) {
    message(system("cmd.exe",
                   glue::glue('cd {quoted_build_path} && {quoted_npm_path} install --scripts-prepend-node-path'),
                   invisible = FALSE,
                   minimized = F,
                   wait = T,
                   intern=F,
                   ignore.stdout=F,
                   ignore.stderr=F))
    
    message("Building your Electron app.")
    
    message(system("cmd.exe",
                   glue::glue('cd {quoted_build_path} && {quoted_npm_path} run release --scripts-prepend-node-path'),
                   invisible = FALSE,
                   minimized = F,
                   wait = T,
                   intern = F,
                   ignore.stdout = F,
                   ignore.stderr = F))
    
  }
  
  if (identical(os, "mac")) {
    # Place to investigare
    print(glue::glue('cd {quoted_build_path} && {quoted_npm_path} install --scripts-prepend-node-path'))
    
    message(system(glue::glue('cd {quoted_build_path} && {quoted_npm_path} install --scripts-prepend-node-path'),
                   wait = T,
                   intern = F,
                   ignore.stdout = F,
                   ignore.stderr = F))
    
    message("Building your Electron app.")
    
    message(system(glue::glue('cd {quoted_build_path} && {quoted_npm_path} run release --scripts-prepend-node-path'),
                   wait = T,
                   intern = F,
                   ignore.stdout = F,
                   ignore.stderr = F))
  }
  
  message("You should now have both a transferable and distributable installer Electron app.")
}


#' shinybox
#'
#' @param app_name Must be lowercase and one word, and may contain hyphens and underscores.
#' @param author Author of the app.
#' @param description Short app description.
#' @param semantic_version Must be in the form x.x.x and follow the semantic versioning guidelines - https://docs.npmjs.com/about-semantic-versioning.
#' @param cran_like_url url to cran-like repository. Default value is https://cran.r-project.org. 
#'     To use MRAN, set to "https://cran.microsoft.com/snapshot/2021-01-10" with desired date. (TODO: what about RStudio package repository?)
#' @param mac_file file path to mac OS tar.gz. Might need to use option 1 of https://www.technipages.com/macos-disable-appname-cant-be-opened-because-it-is-from-an-unidentified-developer
#' @param mac_r_url url to mac OS tar.gz 
#' @param git_host one of c("github", "gitlab", "bitbucket")
#' @param git_repo GitHub/Bitbucket/GitLab username/repo of the shiny-app package (e.g. 'ocelhay/shinyboxtestapp'). 
#' @param function_name the function name in your package that starts the shiny app
#' @param local_package_path path to local shiny-app package, if 'git_package' isn't used 
#' @param package_install_opts optional arguments passed to remotes::install_github, install_gitlab, install_bitbucket, or install_local
#' @param build_path Path where the build files will be created, preferably points to an empty directory.
#' @param rtools_path_win path to RTools (Windows only)
#' @param nodejs_path path to nodejs
#' @param nodejs_version nodejs version to install
#' @param run_build logical, whether to start the build process, helpful if you want to modify anthying before building
#'
#' @export
#'
shinybox <- function(app_name = "hal-9000",
                     author = "Stanley K.",
                     description = "Heuristically Programmed ALgorithmic Computer",
                     semantic_version = "v9000.0.0",
                     cran_like_url = "https://cran.r-project.org",
                     mac_file = NULL,
                     mac_r_url = "https://mac.r-project.org/high-sierra/R-4.0-branch/x86_64/R-4.0-branch.tar.gz",
                     git_host = "github",
                     git_repo = "ocelhay/shinyboxtestapp",
                     local_package_path = NULL,
                     function_name = "run_app",
                     package_install_opts = NULL,
                     build_path = NULL,
                     rtools_path_win = NULL,
                     nodejs_path = file.path(system.file(package = "shinybox"), "nodejs"),
                     nodejs_version = "v12.16.2",
                     run_build = TRUE) {
  
  # Check and fail early ---------------------------------------------------
  check_first(app_name,
              semantic_version,
              function_name,
              nodejs_path,
              package_install_opts,
              build_path,
              cran_like_url, 
              git_host,
              git_repo,
              local_package_path)
  
  
  # Determine Operating System ----------------------------------------------
  os <- get_os()
  
  # Copy Electron boilerplate into build_path -----
  dirs <- system.file("template", package = "shinybox")
  dirs <- list.dirs(dirs)[-1]
  file.copy(dirs, build_path, recursive = TRUE)
  
  # Install R --------------------------------------------------
  message("Install R")
  install_r(cran_like_url = cran_like_url,
            build_path = build_path,
            mac_file = mac_file,
            mac_r_url = mac_r_url,
            permission_to_install = TRUE)
  
  
  # Find Electron app's R's library folder ----------------------------------
  if (identical(os, "win")) {
    library_path <- file.path(build_path, "app", "r_lang", "library")
  }
  
  if (identical(os, "mac")) {
    
    library_path <- file.path(build_path, 
                              "app/r_lang/Library/Frameworks/R.framework/Versions")
    
    library_path <-  list.dirs(library_path, 
                               recursive = FALSE)
    
    library_path <- library_path[grep("\\d+\\.(?:\\d+|x)(?:\\.\\d+|x){0,1}",
                                      library_path)][[1]]
    
    library_path <- file.path(library_path,
                              "Resources/library")
  }  
  
  # Install shiny app/package and dependencies ------------------------------
  message("Install shiny app/package and dependencies")
  if (!is.null(git_host)) {
    my_package_name <-  install_user_app(library_path = library_path,
                                         repo_location = git_host,
                                         repo = git_repo,
                                         repos = cran_like_url,
                                         package_install_opts = package_install_opts,
                                         rtools_path_win = rtools_path_win)
  }
  
  
  if (!is.null(local_package_path)) {
    my_package_name <- install_user_app(library_path = library_path ,
                                        repo_location = "local",
                                        repo = local_package_path,
                                        repos = cran_like_url,
                                        package_install_opts = package_install_opts,
                                        rtools_path_win = rtools_path_win)
  }
  
  message("Trim R's size.")
  trim_r(build_path = build_path)
  
  message("Transfer and overwrite existing icons if present (icons folder at the root of inst)")
  electron_build_resources <- system.file("icons", 
                                          package = my_package_name, 
                                          lib.loc = library_path)
  
  if (nchar(electron_build_resources) > 0) {
    electron_build_resources <- list.files(electron_build_resources, full.names = TRUE)
    resources <- file.path(build_path, "resources")
    file.copy(from = electron_build_resources, to = resources, overwrite = TRUE)
  }
  
  
  # Edit package.json -----------------------------------------------------
  message("Copy, edit and write 'package.json'")
  package_json <- rjson::fromJSON(file = system.file("template/package.json", package = "shinybox"))
  
  package_json$name <- app_name
  package_json$description <- description
  package_json$version <- semantic_version
  package_json$author <- author
  package_json$build$appId <- glue::glue("com.{app_name}")

  package_json <- rjson::toJSON(package_json, indent = 2)
  write(package_json, glue::glue("{build_path}/package.json"))
  
  
  # Add function that runs the shiny app to description.js ------------------
  modify_background_js(background_js_path = file.path(build_path, "src", "background.js"),
                       my_package_name = my_package_name,
                       function_name = function_name,
                       r_path = dirname(library_path))
  
  
  # Download and unzip nodejs -----------------------------------------------
  nodejs_path <- install_nodejs(node_url = "https://nodejs.org/dist",
                                nodejs_path = nodejs_path,
                                nodejs_version = nodejs_version,
                                permission_to_install = TRUE)
  
  # Build the electron app --------------------------------------------------
  ifelse(run_build, 
         run_build_release(nodejs_path = nodejs_path,
                           build_path = build_path,
                           nodejs_version = nodejs_version),
         message("Build step was skipped. When you are ready to build the distributable run 'runBuild(...)'")
  )
}

#' shinybox
#'
#' @param build_path Path where the build files will be created, preferably points to an empty directory.
#'     Must not contain a folder with the name as what you put for shinybox(app_name).
#' @param app_name This will be the name of the executable. It's a uniform type identifier (UTI)
#'    that contains only alphanumeric (A-Z,a-z,0-9), hyphen (-), and period (.) characters.
#'    see https://www.electron.build/configuration/configuration 
#'    and https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html#//apple_ref/doc/uid/20001431-102070
#' @param product_name String - allows you to specify a product name for your executable which
#'    contains spaces and other special characters not allowed in the name property.
#'    https://www.electron.build/configuration/configuration
#' @param semantic_version semantic version of your app, as character (not numeric!);
#'     See https://semver.org/ for more info on semantic versioning.
#' @param mran_date MRAN snapshot date, formatted as 'YYYY-MM-DD'
#' @param git_host one of c("github", "gitlab", "bitbucket")
#' @param git_repo GitHub/Bitbucket/GitLab username/repo of your the shiny-app package (e.g. 'chasemc/demoAPP'). 
#'     Can also use notation for commits/branch (i.e. "chasemc/demoapp@@d81fff0).
#' @param local_package_path path to local shiny-app package, if 'git_package' isn't used 
#' @param package_install_opts optional arguments passed to remotes::install_github, install_gitlab, install_bitbucket, or install_local
#' @param rtools_path_win path to RTools (Windows)
#' @param function_name the function name in your package that starts the shiny app
#' @param run_build logical, whether to start the build process, helpful if you want to modify anthying before building
#' @param short_description short app description
#' @param cran_like_url url to cran-like repository 
#' @param nodejs_path path to nodejs
#' @param nodejs_version nodejs version to install
#' @param permission automatically grant permission to install nodejs and R 
#' @param mac_url url to mac OS tar.gz 
#'
#' @export
#'
shinybox <- function(app_name = NULL,
                      product_name = "product_name",
                      short_description = NULL,
                      semantic_version = NULL,
                      build_path = NULL,
                      mran_date = NULL,
                      cran_like_url = NULL,
                      function_name = NULL,
                      git_host = NULL,
                      git_repo = NULL,
                      local_package_path = NULL,
                      package_install_opts = NULL,
                      rtools_path_win = NULL,
                      run_build = TRUE,
                      nodejs_path = file.path(system.file(package = "shinybox"), "nodejs"),
                      nodejs_version = "v12.16.2",
                      permission = FALSE,
                      mac_url = NULL){
  
  
  # Testing ---
  if(FALSE) {
    short_description = "CoMo Consortium | COVID-19 App"
    mran_date = "2020-09-01"
    cran_like_url = NULL
    function_name = "run_app_standalone"
    git_host = "github"
    git_repo = "ocelhay/como@dev"
    local_package_path = NULL
    package_install_opts = list(type = "binary")
    rtools_path_win = NULL
    run_build = FALSE
    nodejs_path = file.path(system.file(package = "shinybox"), "nodejs")
    mac_url = "https://mac.r-project.org/high-sierra/R-4.0-branch/x86_64/R-4.0-branch.tar.gz"
    permission = TRUE
    
    source("/Users/olivier/Documents/Ressources Pro/shinybox/R/fail_fast.R")
  }
  
  
  # Check and fail early ---------------------------------------------------
  check_first(build_path,
              cran_like_url, 
              mran_date,
              git_host,
              git_repo,
              local_package_path)
  
  
  if (is.null(app_name))  stop('Argument "app_name" is missing, with no default')
  
  if (is.null(semantic_version))  stop('Argument "semantic_version" is missing, with no default')
  
  if (is.null(function_name))  stop('Argument "function_name" is missing, with no default')
  
  if (is.null(nodejs_path))  stop('Argument "nodejs_path" is missing, with no default')
  
  if (!is.null(package_install_opts)) { 
    if (!is.list(package_install_opts)) {
      stop("package_install_opts in shinybox() must be a list of arguments.")
    }
  }
  
  app_root_path <- file.path(build_path, app_name)
  
  if (!isTRUE(permission)) {
    
    permission_to_install_r <- .prompt_install_r(app_root_path)
    permission_to_install_nodejs <- .prompt_install_nodejs(nodejs_path)
    
  } else {
    permission_to_install_r <- TRUE
    permission_to_install_nodejs <- TRUE
    
  }
  
  # Determine Operating System ----------------------------------------------
  os <- get_os()
  
  # Set cran_like_url -------------------------------------------------------
  # If MRAN date provided, construct MRAN url. Else, pass through cran_like_url.
  if (!is.null(mran_date)) cran_like_url <- glue("https://cran.microsoft.com/snapshot/{mran_date}")
  
  # Create top-level build folder for app  ----------------------------------
  create_folder(app_root_path)
  
  # Download and Install R --------------------------------------------------
  message("Download and Install R")
  install_r(cran_like_url = cran_like_url,
            app_root_path = app_root_path,
            mac_url = mac_url,
            permission_to_install = permission_to_install_r)
  
  
  # Find Electron app's R's library folder ----------------------------------
  if (identical(os, "win")) {
    
    library_path <- file.path(app_root_path,
                              "app",
                              "r_lang",
                              "library")
  }
  
  if (identical(os, "mac")) {
    
    library_path <- file.path(app_root_path, 
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
  
  # Trim R's size -----------------------------------------------------------
  message("Trim R's size by removing docs.")
  trim_r(app_root_path = app_root_path)
  
  
  
  # Transfer and overwrite existing icons if present -----------------------------------------------
  message("Transfer and overwrite existing icons if present")
  electron_build_resources <- system.file("icons", 
                                          package = my_package_name, 
                                          lib.loc = library_path)
  
  if (nchar(electron_build_resources) > 0) {
    electron_build_resources <- list.files(electron_build_resources, full.names = TRUE)
    resources <- file.path(app_root_path, "resources")
    file.copy(from = electron_build_resources, to = resources, overwrite = TRUE)
  }
  
  
  # Create package.json -----------------------------------------------------
  create_package_json(app_name = app_name,
                      semantic_version = semantic_version,
                      app_root_path = app_root_path,
                      description = "")
  
  # Edit package.json file ----
  # package_json <-  rjson::fromJSON(file = glue("{dir_build_time}/{app_name}/package.json"))
  # 
  # package_json$description <- "Hey Jude!"
  # package_json$author$email <- "olivier@celhay.net"
  # 
  # package_json <- rjson::toJSON(package_json, indent = 2)
  # write(package_json, glue("{dir_build_time}/{app_name}/package.json"))
  
  
  
  
  # Add function that runs the shiny app to description.js ------------------
  modify_background_js(background_js_path = file.path(app_root_path,
                                                      "src", 
                                                      "background.js"),
                       my_package_name = my_package_name,
                       function_name = function_name,
                       r_path = dirname(library_path))
  
  
  # Download and unzip nodejs -----------------------------------------------
  nodejs_path <- install_nodejs(node_url = "https://nodejs.org/dist",
                                nodejs_path = nodejs_path,
                                force_install = FALSE,
                                nodejs_version = nodejs_version,
                                permission_to_install = permission_to_install_nodejs)
  
  
  # Build the electron app --------------------------------------------------
  if (run_build == TRUE) {
    
    run_build_release(nodejs_path = nodejs_path,
                      app_path = app_root_path,
                      nodejs_version = nodejs_version)
    
    message("You should now have both a transferable and distributable installer Electron app.")
    
  } else {
    
    message("Build step was skipped. When you are ready to build the distributable run 'runBuild(...)'")
    
  }
  
}

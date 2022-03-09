# Install and load the latest version of shinybox
remove.packages("shinybox")
detach("package:shinybox", unload = TRUE)
remotes::install_github("ocelhay/shinybox", ref = "master", upgrade = "never")
library(shinybox)

# shinyboxtestapp, macOS
build_path <- glue::glue("/Users/olivier/Desktop/shinybox_{format(Sys.time(), '%Y-%m-%d_%H%M')}")
dir.create(build_path)

shinybox(
  app_name = "HAL",
  author = "Stanley K.",
  description = "Heuristically Programmed ALgorithmic Computer",
  semantic_version = "v1.0.0",
  cran_like_url = "https://cran.r-project.org",
  # mac_file = "/Users/olivier/Documents/Ressources Pro/R/macOS targz/R-4.1-branch.tar.gz",
  mac_r_url = "https://mac.r-project.org/high-sierra/R-4.1-branch/x86_64/R-4.1-branch.tar.gz", # only used if mac_file is NULL
  git_host = "github",
  git_repo = "ocelhay/shinybox/misc/shinyboxtestapp",
  function_name = "run_app", 
  package_install_opts = list(type = "binary"),
  build_path = build_path,
  rtools_path_win = NULL,
  nodejs_path = "/usr/local/bin/",
  run_build = TRUE)


# shinyboxtestapp, Windows
time <- format(Sys.time(), "%Y-%m-%d_T%H%M%S")
build_path <- paste0("C:/Users/olivi/Desktop/", time)
dir.create(build_path)

shinybox(
  app_name = "HAL",
  author = "Stanley K.",
  description = "Heuristically Programmed ALgorithmic Computer",
  semantic_version = "v1.0.0",
  cran_like_url = "https://cran.r-project.org",
  git_host = "github",
  git_repo = "ocelhay/shinybox/misc/shinyboxtestapp",
  function_name = "run_app", 
  package_install_opts = list(type = "binary"),
  build_path = build_path,
  rtools_path_win = "C:\\rtools40\\usr\\bin",
  nodejs_path = "C:/Program Files/nodejs/",
  run_build = TRUE)

# Install the latest version of shinybox
remove.packages("shinybox")
remotes::install_github("ocelhay/shinybox", ref = "master", upgrade = "never")
library(shinybox)

# Test shinyboxtestapp ----
# remove.packages("shinyboxtestapp")
# library(shinyboxtestapp)
# shinyboxtestapp::run_app()

# shinyboxtestapp, macOS
build_path <- glue::glue("/Users/olivier/Desktop/shinybox_{format(Sys.time(), '%Y-%m-%d_%H%M')}")
dir.create(build_path)

shinybox(
  app_name = "HAL",
  author = "Stanley K.",
  description = "Heuristically Programmed ALgorithmic Computer",
  semantic_version = "v1.0.0",
  cran_like_url = "https://cran.r-project.org",  # "https://cran.microsoft.com/snapshot/2021-01-10",
  # mac_file = "/Users/olivier/Documents/Projets/Standalone R Shiny/R/macOS/2020-10-13/R-4.0-branch.tar.gz",
  mac_r_url = "https://mac.r-project.org/high-sierra/R-4.1-branch/x86_64/R-4.1-branch.tar.gz", # only used if mac_file is NULL
  git_host = "github",
  git_repo = "ocelhay/shinyboxtestapp",
  function_name = "run_app", 
  local_package_path = NULL,
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
  # cran_like_url = "https://cran.microsoft.com/snapshot/2021-01-10",
  git_host = "github",
  git_repo = "ocelhay/shinyboxtestapp",
  function_name = "run_app", 
  local_package_path = NULL,
  package_install_opts = list(type = "binary"),
  build_path = build_path,
  rtools_path_win = "C:\\rtools40\\usr\\bin",
  nodejs_path = "C:/Program Files/nodejs/",
  run_build = TRUE)

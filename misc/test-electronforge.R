# Ressources:
# https://www.electronforge.io
# Prerequesites
# Yarn - https://classic.yarnpkg.com/en/docs/install/
# https://stackoverflow.com/questions/40275877/modify-json-file-using-some-condition-and-create-new-json-file-in-r

if(FALSE)   system("npm install -g yarn")

library(glue)
library(rjson)

dir_build <- "/Users/olivier/Desktop"
(dir_build_time <- paste0(dir_build, "/", format(Sys.time(), "%Y-%m-%d_%H-%M-%S")))
dir.create(dir_build_time)

# app_name should have no space
app_name <- "TestApp"

# Initialize a new project ----
message("\n\n\tInitialize a new project with Electron Forge.
        https://www.electronforge.io/templates/webpack-template")
system(
  glue("
  cd {dir_build_time}
  yarn create electron-app {app_name}
  ")
)

# Add packages
system(
  glue("
  cd {dir_build_time}
  yarn add spectron
  "))

# Edit package.json file ----
package_json <-  rjson::fromJSON(file = glue("{dir_build_time}/{app_name}/package.json"))

package_json$description <- "Hey Jude!"
package_json$author$email <- "olivier@celhay.net"

package_json <- rjson::toJSON(package_json, indent = 2)
write(package_json, glue("{dir_build_time}/{app_name}/package.json"))

# Add shiny app ----
message("\n\n\tAdd the shiny app.\n\t(1) Download and install R.\n\t(2) Install shiny app/package and dependencies.\n\n")

message("\n\n\tDownload R into a temporary directory.")
download_url <- "https://mac.r-project.org/high-sierra/R-4.0-branch/x86_64/R-4.0-branch.tar.gz"
temp_dir <- tempdir()
installer_filename <- basename(download_url)
download_path <- file.path(temp_dir, installer_filename, fsep = "/")
download.file(url = download_url, destfile = download_path, mode = "wb")
untar(tarfile = download_path, exdir = glue("{dir_build_time}/{app_name}/app/r_lang"))

message("\n\n\tChange fixed paths to make R portable on macOS")
r_executable_path <- file.path(glue("{dir_build_time}/{app_name}"), 
                               "app/r_lang/Library/Frameworks/R.framework/Versions")
r_executable_path <- list.dirs(r_executable_path, recursive = FALSE)[[1]]
r_executable_path <- file.path(r_executable_path, "Resources/bin/R", fsep = "/")
con <- file(r_executable_path, "rt")
executable_contents <- readLines(con, n = -1, warn = FALSE)
close(con)

grepped <- grepl("usage=", executable_contents)
grepped <- which(grepped)

modifications <- 
  '
#!/bin/sh
# Shell wrapper for R executable.

echo "*** Change fixed paths to make R portable on macOS ***"
export R_HOME_DIR="$(dirname $(dirname $0))"
export R_HOME="${R_HOME_DIR}"

echo "*** R_HOME_DIR ***"
echo ${R_HOME_DIR}

#R_SHARE_DIR=/Library/Frameworks/R.framework/Resources/share
export R_SHARE_DIR
#R_INCLUDE_DIR=/Library/Frameworks/R.framework/Resources/include

export R_INCLUDE_DIR
#R_DOC_DIR=/Library/Frameworks/R.framework/Resources/doc
R_DOC_DIR=${R_HOME_DIR}/doc
export R_DOC_DIR

# Since this script can be called recursively, we allow R_ARCH to
# be overridden from the environment.
# This script is shared by parallel installs, so nothing in it should
# depend on the sub-architecture except the default here.
: ${R_ARCH=""}
'

combined <- c(modifications, executable_contents[grepped:length(executable_contents)])
writeLines(combined, r_executable_path)


# install shiny app and dependencies
message("\n\n\tInstall shiny app and dependencies.")
library_path <- glue("{dir_build_time}/{app_name}/app/r_lang/Library/Frameworks/R.framework/Versions")
library_path <-  list.dirs(library_path, recursive = FALSE)
library_path <- library_path[grep("\\d+\\.(?:\\d+|x)(?:\\.\\d+|x){0,1}", library_path)][[1]]
library_path <- file.path(library_path, "Resources/library")


# Start-up the app ----
# system(
#   glue("
#   cd {dir_build_time}/{app_name}
#   yarn start
#   "))


# Build distributable ----
system(
  glue("
  cd {dir_build_time}/{app_name}
  yarn make
  "))

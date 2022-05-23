[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)

<!-- badges: start -->
[![R-CMD-check](https://github.com/ocelhay/shinybox/workflows/R-CMD-check/badge.svg)](https://github.com/ocelhay/shinybox/actions)
<!-- badges: end -->

Create Standalone R-Shiny Apps using the Electron framework.

# Requirements

## Node.js and npm

Node.js is an open-source, cross-platform, back-end JavaScript runtime environment that runs on the V8 engine and executes JavaScript code outside a web browser. [Wikipedia](https://en.wikipedia.org/wiki/Node.js). npm is a package manager for the JavaScript language. npm is the default package manager for the JavaScript runtime environment Node.js.

Perform (once per machine) an installation of nodejs and npm (https://nodejs.org/en/). We recommend that you use the latest LTS version available.

You can check in your shell:

```sh
node -v
npm -v
```

You might need to (tested on Windows 11):

- update `core-js` with the following command: `npm install --save core-js@^3`
- install CLI for webpack with `npm install -D webpack-cli`
- install fs-jetpack with `npm install fs-jetpack`
- install webpack-node-externals with `npm install webpack-node-externals`

## R and shinybox

- R 4.2.0 or latest
- this package `shinybox` that can be installed with:

```
remotes::install_github("ocelhay/shinybox", ref = "master", upgrade = "never")
```

- (optional) install Rtools42 for Windows if you use R 4.2.x


## shiny app that you want to build

The shiny app should be organised as an R package. See https://mastering-shiny.org/scaling-packaging.html. Optionaly, a folder named "icons" located in the "inst" folder containing images to be used as shortcut image of the app: icons.icns for macOS and icons.pgn for Windows.

An example app is provided: https://github.com/ocelhay/shinybox/tree/master/misc/shinyboxtestapp


# Building steps

The main `shinybox` function will attenpt at create an Electron app. It undertakes the following steps:

- check function arguments and fail early if something is wrong.
- check Node.js and npm.
- copy Electron app template into the build path.
- edit package.json (Electron app template).
- install R in the build path. **You could be prompted for authorisation to install.** (Do you want to allow this app to make changes to your device?)
- install the shiny app and all package dependencies.
- trim R.
- modify background.js (Electron app template)
- build the Electron app

## Build test app on Windows

```
library(shinybox)

build_path <- "C:/Users/olivi/Desktop/"

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
  nodejs_path = "C:/Program Files/nodejs/",
  run_build = TRUE)
 ```


## Build test app on macOS

```
library(shinybox)

# shinyboxtestapp, macOS
build_path <- "/Users/olivier/Desktop"
dir.create(build_path)

shinybox(
  app_name = "HAL",
  author = "Stanley K.",
  description = "Heuristically Programmed ALgorithmic Computer",
  semantic_version = "v1.0.0",
  cran_like_url = "https://cran.r-project.org",
  mac_r_url = "https://mac.r-project.org/high-sierra/R-4.1-branch/x86_64/R-4.1-branch.tar.gz",
  git_host = "github",
  git_repo = "ocelhay/shinybox/misc/shinyboxtestapp",
  function_name = "run_app", 
  package_install_opts = list(type = "binary"),
  build_path = build_path,
  rtools_path_win = NULL,
  nodejs_path = "/usr/local/bin/",
  run_build = TRUE)
 ```

[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)

# shinybox

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

## shiny app

The shiny app should be organised as an R package. See https://mastering-shiny.org/scaling-packaging.html

Optionaly, a folder named "icons" located in the "inst" folder containing images to be used as shortcut image of the app: icons.icns for macOS and icons.pgn for Windows.

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
- build the standalone R-shiny app.



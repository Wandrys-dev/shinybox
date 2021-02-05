[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)

# shinybox
Create Standalone R-Shiny Apps.


# Requirements

Perform (once per machine) an installation of nodejs (https://nodejs.org/en/).

`external_links.js`
// Convenient way for opening links in external browser, not in the app.
// Useful especially if you have a lot of links to deal with.
//
// Usage:
//
// Every link with class ".js-external-link" will be opened in external browser.
// <a class="js-external-link" href="http://google.com">google</a>
//
// The same behaviour for many links can be achieved by adding
// this class to any parent tag of an anchor tag.
// <p class="js-external-link">
//    <a href="http://google.com">google</a>
//    <a href="http://bing.com">bing</a>
// </p>
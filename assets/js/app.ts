// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import "copy-button"
import {Socket} from "phoenix"
import {start as nProgressStart, done as nProgressDone} from "nprogress"
import {LiveSocket} from "phoenix_live_view"

// LiveReact
// @ts-ignore
import {initLiveReact} from "phoenix_live_react"
import {Components} from "./components"
// @ts-ignore
window.Components = Components
document.addEventListener("DOMContentLoaded", () => initLiveReact())

import {hooks} from "./hooks"
let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}, hooks})

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", () => nProgressStart())
window.addEventListener("phx:page-loading-stop", () => nProgressDone())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
// window.liveSocket = liveSocket

goog.provide 'server.App'

goog.require 'goog.labs.userAgent.util'

bodyParser = require 'body-parser'
compression = (`/** @type {Function} */`) require 'compression'
favicon = (`/** @type {Function} */`) require 'static-favicon'
methodOverride = (`/** @type {Function} */`) require 'method-override'

class server.App

  ###*
    @param {Function} express
    @param {app.Routes} routes
    @param {boolean} isDev
    @param {number} port
    @param {server.Api} api
    @param {server.FrontPage} frontPage
    @param {server.Storage} storage
    @constructor
  ###
  constructor: (express, routes, isDev, port, api, frontPage, storage) ->

    app = express()

    # Middleware must be first.
    app.use compression()
    app.use favicon 'app/client/img/favicon.ico'
    app.use bodyParser.urlencoded extended: false
    app.use bodyParser.json()
    app.use methodOverride()

    # Static assets.
    if isDev
      app.use '/bower_components', express.static 'bower_components'
      app.use '/app', express.static 'app'
      app.use '/tmp', express.static 'tmp'
    else
      # Compiled script has per deploy specific url so set maxAge to one year.
      # TODO: Use CDN.
      app.use '/app', express.static 'app', 'maxAge': 31557600000

    onError = (route, reason) ->
      console.log 'Error: ' + '500'
      console.log 'Route path: ' + route.path
      console.log 'Reason:'
      if reason.stack
        # The stack property contains the message as well as the stack.
        console.log reason.stack
      else
        console.log reason

    # API.
    api.addToExpress app, (route, req, res, promise) ->
      promise
        .then (json) -> res.json json
        .thenCatch (reason) =>
          onError route, reason
          res.status(500).json {}

    # FrontPage rendering.
    routes.addToExpress app, (route, req, res) ->
      params = req['params']

      storage.load route, params
        .then -> routes.setActive route, params
        .thenCatch (reason) -> routes.trySetErrorRoute reason
        .then ->
          goog.labs.userAgent.util.setUserAgent req['headers']['user-agent']
          frontPage.render()
        .then (html) ->
          status = if routes.active == routes.notFound then 404 else 200
          res.status(status).send html
        .thenCatch (reason) ->
          onError route, reason
          # TODO: Show something more beautiful, with static content only.
          res.status(500).send 'Server error.'

    app.listen port, ->
      console.log 'Express server listening on port ' + port

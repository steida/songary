goog.provide 'server.Router'

goog.require 'goog.labs.userAgent.util'

class server.Router

  ###*
    @param {server.FrontPage} frontPage
    @param {app.Routes} routes
    @constructor
  ###
  constructor: (@frontPage, @routes) ->

  use: (app) ->
    @routes.addToExpress app, (req, res) =>
      # PATTERN(steida): Isomorphic user agent detection.
      # Set userAgent on server for critical rendering path optimization.
      # Remember, critical path for isomorphic apps is HTML + CSS only.
      # https://developers.google.com/web/fundamentals/performance/critical-rendering-path
      goog.labs.userAgent.util.setUserAgent req.headers['user-agent']
      res['send'] @frontPage.renderToString()

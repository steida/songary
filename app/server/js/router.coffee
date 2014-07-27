goog.provide 'server.Router'

goog.require 'goog.labs.userAgent.util'

class server.Router

  ###*
    @param {server.FrontPage} frontPage
    @param {app.Routes} routes
    @param {server.Storage} storage
    @constructor
  ###
  constructor: (@frontPage, @routes, @storage) ->

  use: (app) ->
    @routes.addToExpress app, (req, res) =>
      userAgent = req.headers['user-agent']
      @storage.load @routes.active, @routes
        .then =>
          # PATTERN(steida): Set userAgent from client request, so we can detect
          # userAgent on the server side. This is true isomorphic device detection.
          # Check server.react.App to see how it can be used.
          # We can also arbitrary decide to not render something in React component via
          # goog.labs.userAgent.device.isMobile() to save traffic. Of course
          # such React component will work the same both on client and server side.
          # This is great for the best critical rendering path.
          # https://developers.google.com/web/fundamentals/performance/critical-rendering-path/)
          goog.labs.userAgent.util.setUserAgent userAgent
          res['send'] @frontPage.renderToString()
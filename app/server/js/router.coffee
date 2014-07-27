goog.provide 'server.Router'

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
      @storage.load @routes.active, @routes
        .then =>
          html = @frontPage.render()
          res['send'] html
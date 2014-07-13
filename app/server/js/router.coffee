goog.provide 'server.Router'

class server.Router

  ###*
    @param {server.FrontPage} frontPage
    @param {app.react.App} todoApp
    @param {app.Routes} routes
    @param {app.Title} appTitle
    @param {server.Storage} storage
    @constructor
  ###
  constructor: (@frontPage, @todoApp, @routes, @appTitle, @storage) ->

  use: (app) ->
    @routes.addToExpress app, (req, res) =>
      @storage.load @routes.active, @routes
        .then =>
          html = @frontPage.render @appTitle.get(), @todoApp.create
          res['send'] html
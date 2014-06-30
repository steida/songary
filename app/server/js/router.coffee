goog.provide 'server.Router'

class server.Router

  ###*
    @param {server.FrontPage} frontPage
    @param {app.react.App} todoApp
    @param {app.Routes} routes
    @param {app.Title} appTitle
    @constructor
  ###
  constructor: (@frontPage, @todoApp, @routes, @appTitle) ->

  use: (app) ->
    @routes.addToExpress app, (req, res) =>
      html = @frontPage.render @appTitle.get(), @todoApp.create
      res['send'] html
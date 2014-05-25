goog.provide 'server.Router'

class server.Router

  ###*
    @param {server.FrontPage} frontPage
    @param {app.react.App} todoApp
    @param {app.Routes} routes
    @constructor
  ###
  constructor: (@frontPage, @todoApp, @routes) ->

  use: (app) ->
    # TODO: Refactor.
    for route in [@routes.home, @routes.newSong]
      do (route) =>
        expressRoute = app['route'] route.path
        expressRoute.get (req, res) =>
          @routes.setActive route
          html = @frontPage.render 'Songary', @todoApp.create
          res['send'] html
    return
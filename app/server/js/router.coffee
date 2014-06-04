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
    @routeToExpress app, [
      @routes.home
      @routes.newSong
    ]

  routeToExpress: (app, routes) ->
    for route in routes
      app['route'] route.path
        .get @onRequest.bind @, route
    return

  onRequest: (route, req, res) ->
    @routes.setActive route
    html = @frontPage.render 'Songary', @todoApp.create
    res['send'] html
goog.provide 'App'

class App

  ###*
    @param {este.Router} router
    @param {app.Routes} routes
    @param {app.react.App} reactApp
    @param {Element} element
    @constructor
  ###
  constructor: (router, routes, reactApp, element) ->
    @setRoutes router, routes
    router.start()
    React.renderComponent reactApp.create(), element

  setRoutes: (router, routes) ->
    for route in [routes.home, routes.newSong]
      do (route) ->
        router.add route, (params) -> routes.setActive route
    return
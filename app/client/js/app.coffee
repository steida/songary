goog.provide 'App'

class App

  ###*
    @param {Element} element
    @param {app.Routes} routes
    @param {app.Storage} storage
    @param {app.react.App} reactApp
    @param {este.Router} router
    @constructor
  ###
  constructor: (element, routes, storage, reactApp, router) ->

    routes.addToEste router, (route, params) ->
      storage.load route, params
        # Set active route if everything is fine.
        .then -> routes.setActive route, params
        # Try set error route for known errors. Only 404 for now.
        .thenCatch (reason) -> routes.trySetErrorRoute reason
        # Everything is ok, rerender view.
        .then -> React.renderComponent reactApp.component(), element

    router.start()

goog.provide 'App'

goog.require 'goog.async.throwException'

class App

  ###*
    @param {app.Routes} routes
    @param {este.Router} router
    @param {app.Storage} storage
    @param {app.react.App} reactApp
    @param {Element} element
    @constructor
  ###
  constructor: (routes, router, storage, reactApp, element) ->

    routes.addToEste router, (route, params) ->
      storage.load route, params
        # Successful load, set we can set active route.
        .then -> routes.setActive route, params
        # Load failed for 404, 500, or whatever reason. Try set error route.
        .thenCatch (reason) -> routes.trySetErrorRoute reason
        # Update UI.
        .then -> React.renderComponent reactApp.component(), element
        # Handle severe error.
        .thenCatch (reason) ->
          # TODO: Report error to server.
          # TODO: Show something more beautiful.
          alert 'App error, sorry for that. Please reload browser.'
          # Propagate error to dev console.
          goog.async.throwException reason if goog.DEBUG
          # Rethrow to prevent este.Router url change.
          throw reason

    router.start()

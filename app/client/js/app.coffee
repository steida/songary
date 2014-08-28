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
        .then -> routes.setActive route, params
        .thenCatch (reason) -> routes.trySetErrorRoute reason
        .then -> React.renderComponent reactApp.component(), element
        .thenCatch (reason) ->
          # TODO: Show something more beautiful.
          alert 'App error, sorry for that. Please reload browser.'
          # TODO: Report error to server.
          # Ensure error is shown in console.
          goog.async.throwException reason if goog.DEBUG
          # Prevent este.Router url change.
          throw reason

    router.start()

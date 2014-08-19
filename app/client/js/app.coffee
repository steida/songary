goog.provide 'App'

goog.require 'goog.async.throwException'

class App

  ###*
    @param {app.Routes} routes
    @param {este.Router} router
    @param {app.Storage} storage
    @param {app.Title} appTitle
    @param {app.react.App} reactApp
    @param {Element} element
    @constructor
  ###
  constructor: (routes, router, storage, appTitle, reactApp, element) ->

    syncUI = ->
      if routes.active
        document.title = appTitle.get()
        React.renderComponent reactApp.component(), element

    routes.addToEste router, (route, params) ->
      storage.load route, params, routes
        .then ->
          routes.setActive route, params
        .thenCatch (reason) ->
          routes.trySetErrorRoute reason
        .then ->
          syncUI()
        .thenCatch (reason) ->
          # TODO: Report error to server.
          # TODO: Show something more beautiful.
          alert 'Something is wrong, please reload browser.'
          # Ensure error is shown correctly in dev console.
          goog.async.throwException reason if goog.DEBUG
          # Rethrow to ensure este.Router will not change url.
          throw reason

    router.start()
    storage.listen 'change', syncUI

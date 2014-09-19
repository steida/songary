goog.provide 'App'

class App

  ###*
    @param {Element} element
    @param {app.Error} error
    @param {app.Routes} routes
    @param {app.Storage} storage
    @param {app.react.App} reactApp
    @param {este.Router} router
    @constructor
  ###
  constructor: (element, error, routes, storage, reactApp, router) ->

    routes.addToEste router, (route, params) ->
      storage.load route, params
        .then -> routes.setActive route, params
        .thenCatch (reason) -> routes.trySetErrorRoute reason
        .then -> React.renderComponent reactApp.component(), element
        .thenCatch error.handle

    router.start()

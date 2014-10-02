goog.provide 'App'

class App

  ###*
    @param {Element} element
    @param {app.Error} error
    @param {app.Routes} routes
    @param {app.Storage} storage
    @param {app.react.App} reactApp
    @param {este.Router} router
    @param {app.Dispatcher} dispatcher
    @constructor
  ###
  constructor: (element, error, routes, storage, reactApp, router, dispatcher) ->

    routes.addToEste router, (route, params) ->
      dispatcher.dispatch 'router-load', route: route, params: params

    dispatcher.register (action, payload) ->
      if action == 'router-load'
        storage.load payload.route, payload.params
          .then -> routes.setActive payload.route, payload.params
          .thenCatch (reason) -> routes.trySetErrorRoute reason
          .then -> React.renderComponent reactApp.component(), element

    router.start()

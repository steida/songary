goog.provide 'App'

class App

  ###*
    @param {Element} element
    @param {app.Dispatcher} dispatcher
    @param {app.Routes} routes
    @param {app.Storage} storage
    @param {app.react.App} reactApp
    @param {este.Router} router
    @constructor
  ###
  constructor: (element, dispatcher, routes, storage, reactApp, router) ->

    routes.addToEste router, (route, params) ->
      dispatcher.dispatch 'route-load', route: route, params: params

    dispatcher.register (action, payload) ->
      if action == 'route-load'
        storage.load payload.route, payload.params
          .then -> routes.setActive payload.route, payload.params
          .thenCatch (reason) -> routes.trySetErrorRoute reason
          .then -> React.renderComponent reactApp.component(), element

    router.start()
